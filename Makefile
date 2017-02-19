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

# build module
libzbxpgsql.so:
	$(DOCKER_RUN) $(PACKAGE_NAME)/build-debian-jessie build

# build docker images for compiling, testing and packaging the module
docker-images:
	cd docker && make docker-images

# create source tarball
dist:
	$(DOCKER_RUN) $(PACKAGE_NAME)/build-debian-jessie dist

clean:
	rm -rvf release
	cd $(PACKAGE_NAME) && make clean && make distclean

# create a release package
package:
	$(DOCKER_RUN) \
		-e "TARGET_MANAGER=$(TARGET_MANAGER)" \
		-e "TARGET_OS=$(TARGET_OS)" \
		-e "TARGET_OS_MAJOR=$(TARGET_OS_MAJOR)" \
		-e "TARGET_ARCH=$(TARGET_ARCH)" \
		$(PACKAGE_NAME)/build-$(TARGET_OS)-$(TARGET_OS_MAJOR) package;

test-packages:
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

# run key compatibility tests (requires `make run-postgres`)
test-keys:
	docker exec -it libzbxpgsql_agent /entrypoint.sh test

# run an agent with the compiled module
# requires run-postgres to be running
run-agent: libzbxpgsql.so
	$(DOCKER_RUN) \
		-p 10050:10050 \
		--network libzbxpgsql_default \
		--link pg84:libzbxpgsql_pg84_1 \
		--link pg90:libzbxpgsql_pg90_1 \
		--link pg91:libzbxpgsql_pg91_1 \
		--link pg92:libzbxpgsql_pg92_1 \
		--link pg93:libzbxpgsql_pg93_1 \
		--link pg94:libzbxpgsql_pg94_1 \
		--link pg95:libzbxpgsql_pg95_1 \
		--link pg96:libzbxpgsql_pg96_1 \
		--name libzbxpgsql_agent \
		$(PACKAGE_NAME)/zabbix-3.2-debian-jessie agent

# start a test environment including each postgresql version and a zabbix agent
run-postgres:
	docker-compose down || :
	WORKDIR=/root/$(PACKAGE_NAME) \
		PACKAGE_NAME=$(PACKAGE_NAME) \
		PACKAGE_VERSION=$(PACKAGE_VERSION) \
		ZABBIX_VERSION=$(ZABBIX_VERSION) \
		docker-compose up

release-sync:
	aws s3 sync ./release/ s3://s3.cavaliercoder.com/libzbxpgsql/

