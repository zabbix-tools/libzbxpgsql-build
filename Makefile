PACKAGE_NAME = libzbxpgsql
PACKAGE_VERSION = 1.1.0

ZABBIX_VERSION = 3.0.2

# args common to all 'docker run' commands
DOCKER_RUNARGS = -it --rm \
		-e "WORKDIR=/root/$(PACKAGE_NAME)" \
		-e "PACKAGE_NAME=$(PACKAGE_NAME)" \
		-e "PACKAGE_VERSION=$(PACKAGE_VERSION)" \
		-e "ZABBIX_VERSION=$(ZABBIX_VERSION)" \
		-v $(shell pwd):/root/$(PACKAGE_NAME)

DOCKER_RUN = docker run $(DOCKER_RUNARGS)

# default package to build
TARGET_MANAGER = "yum"
TARGET_OS = "rhel"
TARGET_OS_MAJOR = "7"
TARGET_ARCH = $(uname -m)

all: libzbxpgsql.so

docker-images:
	cd docker && make docker-images

# build module
libzbxpgsql.so:
	$(DOCKER_RUN) $(PACKAGE_NAME)/build build

# create source tarball
dist:
	$(DOCKER_RUN) $(PACKAGE_NAME)/build dist

# create a release package
package:
	$(DOCKER_RUN) \
		-e "TARGET_MANAGER=$(TARGET_MANAGER)" \
		-e "TARGET_OS=$(TARGET_OS)" \
		-e "TARGET_OS_MAJOR=$(TARGET_OS_MAJOR)" \
		-e "TARGET_ARCH=$(TARGET_ARCH)" \
		$(PACKAGE_NAME)/build package

package-tests:
	$(DOCKER_RUN) $(PACKAGE_NAME)/centos-6-zabbix-2 test_package
	$(DOCKER_RUN) $(PACKAGE_NAME)/centos-6-zabbix-3 test_package
	$(DOCKER_RUN) $(PACKAGE_NAME)/centos-7-zabbix-2 test_package
	$(DOCKER_RUN) $(PACKAGE_NAME)/centos-7-zabbix-3 test_package
	$(DOCKER_RUN) $(PACKAGE_NAME)/debian-wheezy-zabbix-2 test_package
	$(DOCKER_RUN) $(PACKAGE_NAME)/debian-wheezy-zabbix-3 test_package
	$(DOCKER_RUN) $(PACKAGE_NAME)/debian-jessie-zabbix-2 test_package
	$(DOCKER_RUN) $(PACKAGE_NAME)/debian-jessie-zabbix-3 test_package
	$(DOCKER_RUN) $(PACKAGE_NAME)/ubuntu-precise-zabbix-2 test_package
	$(DOCKER_RUN) $(PACKAGE_NAME)/ubuntu-trusty-zabbix-2 test_package
	$(DOCKER_RUN) $(PACKAGE_NAME)/ubuntu-trusty-zabbix-3 test_package

clean:
	rm -rvf release
	cd $(PACKAGE_NAME) && make clean && make distclean

# run key compatability tests (requires testenv)
key-tests:
	docker exec -it libzbxpgsql_agent_1 /entrypoint.sh test

# start a test environment including each postgresql version and a zabbix agent
testenv:
	docker-compose down || :
	WORKDIR=/root/$(PACKAGE_NAME) \
		PACKAGE_NAME=$(PACKAGE_NAME) \
		PACKAGE_VERSION=$(PACKAGE_VERSION) \
		ZABBIX_VERSION=$(ZABBIX_VERSION) \
		docker-compose up

release-sync:
	aws s3 sync ./release/ s3://s3.cavaliercoder.com/libzbxpgsql/

# run an agent with the compiled module
agent:
	$(DOCKER_RUN) -p 10050:10050 $(PACKAGE_NAME)/build agent

# start an interactice session in a build container
shell:
	$(DOCKER_RUN) $(PACKAGE_NAME)/build /bin/bash
