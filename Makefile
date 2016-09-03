PACKAGE_NAME = libzbxpgsql
PACKAGE_VERSION = 1.1.0

ZABBIX_VERSION = 3.0.4

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

docker-clean-all:
	cd docker && make docker-clean-all

# build module
libzbxpgsql.so:
	$(DOCKER_RUN) $(PACKAGE_NAME)/build-jessie build

# create source tarball
dist:
	$(DOCKER_RUN) $(PACKAGE_NAME)/build-jessie dist

# create a release package
package:
	if test '$(TARGET_OS)' != 'rhel'; then \
		if test '$(TARGET_OS_MAJOR)' != 'precise'; then \
			$(DOCKER_RUN) \
				-e "TARGET_MANAGER=$(TARGET_MANAGER)" \
				-e "TARGET_OS=$(TARGET_OS)" \
				-e "TARGET_OS_MAJOR=$(TARGET_OS_MAJOR)" \
				-e "TARGET_ARCH=$(TARGET_ARCH)" \
				$(PACKAGE_NAME)/build-jessie package; \
		else \
			$(DOCKER_RUN) \
				-e "TARGET_MANAGER=$(TARGET_MANAGER)" \
				-e "TARGET_OS=$(TARGET_OS)" \
				-e "TARGET_OS_MAJOR=$(TARGET_OS_MAJOR)" \
				-e "TARGET_ARCH=$(TARGET_ARCH)" \
				$(PACKAGE_NAME)/build-precise package; \
		fi \
	else \
		if test '$(TARGET_OS_MAJOR)' = '6'; then \
			$(DOCKER_RUN) \
				-e "TARGET_MANAGER=$(TARGET_MANAGER)" \
				-e "TARGET_OS=$(TARGET_OS)" \
				-e "TARGET_OS_MAJOR=$(TARGET_OS_MAJOR)" \
				-e "TARGET_ARCH=$(TARGET_ARCH)" \
				$(PACKAGE_NAME)/build-centos-6 package; \
		else \
			$(DOCKER_RUN) \
				-e "TARGET_MANAGER=$(TARGET_MANAGER)" \
				-e "TARGET_OS=$(TARGET_OS)" \
				-e "TARGET_OS_MAJOR=$(TARGET_OS_MAJOR)" \
				-e "TARGET_ARCH=$(TARGET_ARCH)" \
				$(PACKAGE_NAME)/build-centos-7 package; \
		fi \
	fi

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
	$(DOCKER_RUN) -p 10050:10050 $(PACKAGE_NAME)/build-jessie agent

# start an interactice session in a build container
shell-wheezy:
	$(DOCKER_RUN) $(PACKAGE_NAME)/build-wheezy /bin/bash

shell-jessie:
	$(DOCKER_RUN) $(PACKAGE_NAME)/build-jessie /bin/bash

shell-centos-6:
	$(DOCKER_RUN) $(PACKAGE_NAME)/build-centos-6 /bin/bash

shell-centos-7:
	$(DOCKER_RUN) $(PACKAGE_NAME)/build-centos-7 /bin/bash

