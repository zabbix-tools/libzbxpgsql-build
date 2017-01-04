PACKAGE_NAME = libzbxpgsql
PACKAGE_VERSION = 1.1.0

ZABBIX_VERSION = 3.2.3

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

clean:
	rm -rvf release
	cd $(PACKAGE_NAME) && make clean && make distclean

docker-images:
	cd docker && make docker-images

docker-clean-all:
	cd docker && make docker-clean-all

# build module
libzbxpgsql.so:
	$(DOCKER_RUN) $(PACKAGE_NAME)/build-debian-jessie build

# create source tarball
dist:
	$(DOCKER_RUN) $(PACKAGE_NAME)/build-debian-jessie dist

# create a release package
package:
	$(DOCKER_RUN) \
		-e "TARGET_MANAGER=$(TARGET_MANAGER)" \
		-e "TARGET_OS=$(TARGET_OS)" \
		-e "TARGET_OS_MAJOR=$(TARGET_OS_MAJOR)" \
		-e "TARGET_ARCH=$(TARGET_ARCH)" \
		$(PACKAGE_NAME)/build-$(TARGET_OS)-$(TARGET_OS_MAJOR) package;

package-tests:
	$(DOCKER_RUN) $(PACKAGE_NAME)/zabbix-2.2-centos-6 test_package
	$(DOCKER_RUN) $(PACKAGE_NAME)/zabbix-2.2-centos-7 test_package
	$(DOCKER_RUN) $(PACKAGE_NAME)/zabbix-2.2-debian-wheezy test_package
	$(DOCKER_RUN) $(PACKAGE_NAME)/zabbix-2.2-ubuntu-precise test_package
	$(DOCKER_RUN) $(PACKAGE_NAME)/zabbix-2.2-ubuntu-trusty test_package
	$(DOCKER_RUN) $(PACKAGE_NAME)/zabbix-3.0-centos-6 test_package
	$(DOCKER_RUN) $(PACKAGE_NAME)/zabbix-3.0-centos-7 test_package
	$(DOCKER_RUN) $(PACKAGE_NAME)/zabbix-3.0-debian-wheezy test_package
	$(DOCKER_RUN) $(PACKAGE_NAME)/zabbix-3.0-debian-jessie test_package
	$(DOCKER_RUN) $(PACKAGE_NAME)/zabbix-3.0-ubuntu-trusty test_package
	$(DOCKER_RUN) $(PACKAGE_NAME)/zabbix-3.0-ubuntu-xenial test_package
	$(DOCKER_RUN) $(PACKAGE_NAME)/zabbix-3.2-centos-6 test_package
	$(DOCKER_RUN) $(PACKAGE_NAME)/zabbix-3.2-centos-7 test_package
	$(DOCKER_RUN) $(PACKAGE_NAME)/zabbix-3.2-debian-wheezy test_package
	$(DOCKER_RUN) $(PACKAGE_NAME)/zabbix-3.2-debian-jessie test_package
	$(DOCKER_RUN) $(PACKAGE_NAME)/zabbix-3.2-ubuntu-trusty test_package
	$(DOCKER_RUN) $(PACKAGE_NAME)/zabbix-3.2-ubuntu-xenial test_package

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
	$(DOCKER_RUN) -p 10050:10050 $(PACKAGE_NAME)/zabbix-3.2-debian-jessie agent

# start an interactice session in a build container
shell-wheezy:
	$(DOCKER_RUN) $(PACKAGE_NAME)/build-debian-wheezy /bin/bash

shell-jessie:
	$(DOCKER_RUN) $(PACKAGE_NAME)/build-debian-jessie /bin/bash

shell-precise:
	$(DOCKER_RUN) $(PACKAGE_NAME)/build-ubuntu-precise /bin/bash

shell-trusty:
	$(DOCKER_RUN) $(PACKAGE_NAME)/build-ubuntu-trusty /bin/bash

shell-centos-6:
	$(DOCKER_RUN) $(PACKAGE_NAME)/build-centos-6 /bin/bash

shell-centos-7:
	$(DOCKER_RUN) $(PACKAGE_NAME)/build-centos-7 /bin/bash

