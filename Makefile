ARCH = $(shell uname -m)

PACKAGE_NAME = libzbxpgsql
PACKAGE_VERSION = 0.2.1

ZABBIX_VERSION = 3.0.2

# args common to all 'docker run' commands
DOCKER_RUNARGS = -it --rm \
		-e "WORKDIR=/root/$(PACKAGE_NAME)" \
		-e "PACKAGE_NAME=$(PACKAGE_NAME)" \
		-e "PACKAGE_VERSION=$(PACKAGE_VERSION)" \
		-e "ZABBIX_VERSION=$(ZABBIX_VERSION)" \
		-v $(shell pwd):/root/$(PACKAGE_NAME)

DOCKER_RUN = docker run $(DOCKER_RUNARGS)

# build module
libzbxpgsql.so:
	$(DOCKER_RUN) $(PACKAGE_NAME)/build build

all: libzbxpgsql.so dist deb rpm

# create source tarball
dist:
	$(DOCKER_RUN) $(PACKAGE_NAME)/build dist

# build debian package
deb:
	$(DOCKER_RUN) $(PACKAGE_NAME)/build deb

# build rpm package
rpm:
	$(DOCKER_RUN) $(PACKAGE_NAME)/build rpm

agent:
	$(DOCKER_RUN) -p 10050:10050 $(PACKAGE_NAME)/build agent

# start an interactice session in a build container
shell:
	$(DOCKER_RUN) $(PACKAGE_NAME)/build /bin/bash

clean:
	rm -vf \
		$(PACKAGE_NAME)-$(PACKAGE_VERSION)*.tar.gz \
		$(PACKAGE_NAME)_$(PACKAGE_VERSION)*.deb \
		$(PACKAGE_NAME)-$(PACKAGE_VERSION)*.rpm
	cd $(PACKAGE_NAME) && make clean && make distclean

# start a test environment including each postgresql version and a zabbix agent
testenv:
	docker-compose down || :
	WORKDIR=/root/$(PACKAGE_NAME) \
		PACKAGE_NAME=$(PACKAGE_NAME) \
		PACKAGE_VERSION=$(PACKAGE_VERSION) \
		ZABBIX_VERSION=$(ZABBIX_VERSION) \
		docker-compose up

test:
	docker exec -it libzbxpgsql_agent_1 /entrypoint.sh test
