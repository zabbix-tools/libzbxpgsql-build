DOCKER_BUILD = docker build \
	--build-arg "HTTP_PROXY=$(HTTP_PROXY)" \
	--build-arg "HTTPS_PROXY=$(HTTPS_PROXY)" \
	--build-arg "FTP_PROXY=$(FTP_PROXY)" \
	--build-arg "NO_PROXY=$(NO_PROXY)" \
	--build-arg "http_proxy=$(http_proxy)" \
	--build-arg "https_proxy=$(https_proxy)" \
	--build-arg "ftp_proxy=$(ftp_proxy)" \
	--build-arg "no_proxy=$(no_proxy)"

DOCKER_RUN = docker run \
	-it --rm \
	-v $(shell pwd):/home/docker

all: docker-images

docker-images: \
	build-centos-6 \
	build-centos-7 \
	build-debian-wheezy \
	build-debian-jessie \
	build-ubuntu-precise \
	build-ubuntu-trusty \
	build-ubuntu-xenial \
	zabbix-2.2-centos-6 \
	zabbix-2.2-centos-7 \
	zabbix-2.2-debian-wheezy \
	zabbix-2.2-ubuntu-precise \
	zabbix-2.2-ubuntu-trusty \
	zabbix-3.0-centos-6 \
	zabbix-3.0-centos-7 \
	zabbix-3.0-debian-jessie \
	zabbix-3.0-debian-wheezy \
	zabbix-3.0-ubuntu-trusty \
	zabbix-3.0-ubuntu-xenial \
	zabbix-3.2-centos-6 \
	zabbix-3.2-centos-7 \
	zabbix-3.2-debian-jessie \
	zabbix-3.2-debian-wheezy \
	zabbix-3.2-ubuntu-trusty \
	zabbix-3.2-ubuntu-xenial

docker-clean-all:
	docker ps -aq | xargs docker rm
	docker images -q | xargs docker rmi

docker-images-update:
	docker pull centos:6
	docker pull centos:7
	docker pull debian:wheezy
	docker pull debian:jessie
	docker pull ubuntu:trusty
	docker pull ubuntu:precise
	docker pull ubuntu:xenial
	make docker-images

# run build container
run-wheezy:
	docker run \
		-it \
		--rm \
		libzbxpgsql/build-debian-wheezy \
		/bin/bash

run-jessie:
	docker run \
		-it \
		--rm \
		libzbxpgsql/build-debian-jessie \
		/bin/bash

run-precise:
	docker run \
		-it \
		--rm \
		libzbxpgsql/build-ubuntu-precise \
		/bin/bash

run-trusty:
	docker run \
		-it \
		--rm \
		libzbxpgsql/build-ubuntu-trusty \
		/bin/bash

run-centos-6:
	docker run \
		-it \
		--rm \
		libzbxpgsql/build-centos-6 \
		/bin/bash

run-centos-7:
	docker run \
		-it \
		--rm \
		libzbxpgsql/build-centos-7 \
		/bin/bash

build-centos-6:
	$(DOCKER_BUILD) \
		-f build-centos-6.Dockerfile \
		-t libzbxpgsql/build-centos-6 \
		.

build-centos-7:
	$(DOCKER_BUILD) \
		-f build-centos-7.Dockerfile \
		-t libzbxpgsql/build-centos-7 \
		.

build-debian-wheezy:
	$(DOCKER_BUILD) \
		-f build-debian-wheezy.Dockerfile \
		-t libzbxpgsql/build-debian-wheezy \
		.

build-debian-jessie:
	$(DOCKER_BUILD) \
		-f build-debian-jessie.Dockerfile \
		-t libzbxpgsql/build-debian-jessie \
		.

build-ubuntu-precise:
	$(DOCKER_BUILD) \
		-f build-ubuntu-precise.Dockerfile \
		-t libzbxpgsql/build-ubuntu-precise \
		.

build-ubuntu-trusty:
	$(DOCKER_BUILD) \
		-f build-ubuntu-trusty.Dockerfile \
		-t libzbxpgsql/build-ubuntu-trusty \
		.

build-ubuntu-xenial:
	$(DOCKER_BUILD) \
		-f build-ubuntu-xenial.Dockerfile \
		-t libzbxpgsql/build-ubuntu-xenial \
		.

zabbix-2.2-centos-6:
	$(DOCKER_BUILD) \
		-f zabbix-2.2-centos-6.Dockerfile \
		-t libzbxpgsql/zabbix-2.2-centos-6 \
		.

zabbix-2.2-centos-7:
	$(DOCKER_BUILD) \
		-f zabbix-2.2-centos-7.Dockerfile \
		-t libzbxpgsql/zabbix-2.2-centos-7 \
		.

zabbix-2.2-debian-wheezy:
	$(DOCKER_BUILD) \
		-f zabbix-2.2-debian-wheezy.Dockerfile \
		-t libzbxpgsql/zabbix-2.2-debian-wheezy \
		.

zabbix-2.2-ubuntu-precise:
	$(DOCKER_BUILD) \
		-f zabbix-2.2-ubuntu-precise.Dockerfile \
		-t libzbxpgsql/zabbix-2.2-ubuntu-precise \
		.

zabbix-2.2-ubuntu-trusty:
	$(DOCKER_BUILD) \
		-f zabbix-2.2-ubuntu-trusty.Dockerfile \
		-t libzbxpgsql/zabbix-2.2-ubuntu-trusty \
		.

zabbix-3.0-centos-6:
	$(DOCKER_BUILD) \
		-f zabbix-3.0-centos-6.Dockerfile \
		-t libzbxpgsql/zabbix-3.0-centos-6 \
		.

zabbix-3.0-centos-7:
	$(DOCKER_BUILD) \
		-f zabbix-3.0-centos-7.Dockerfile \
		-t libzbxpgsql/zabbix-3.0-centos-7 \
		.

zabbix-3.0-debian-wheezy:
	$(DOCKER_BUILD) \
		-f zabbix-3.0-debian-wheezy.Dockerfile \
		-t libzbxpgsql/zabbix-3.0-debian-wheezy \
		.
		
zabbix-3.0-debian-jessie:
	$(DOCKER_BUILD) \
		-f zabbix-3.0-debian-jessie.Dockerfile \
		-t libzbxpgsql/zabbix-3.0-debian-jessie \
		.

zabbix-3.0-ubuntu-trusty:
	$(DOCKER_BUILD) \
		-f zabbix-3.0-ubuntu-trusty.Dockerfile \
		-t libzbxpgsql/zabbix-3.0-ubuntu-trusty \
		.

zabbix-3.0-ubuntu-xenial:
	$(DOCKER_BUILD) \
		-f zabbix-3.0-ubuntu-xenial.Dockerfile \
		-t libzbxpgsql/zabbix-3.0-ubuntu-xenial \
		.

zabbix-3.2-centos-6:
	$(DOCKER_BUILD) \
		-f zabbix-3.2-centos-6.Dockerfile \
		-t libzbxpgsql/zabbix-3.2-centos-6 \
		.

zabbix-3.2-centos-7:
	$(DOCKER_BUILD) \
		-f zabbix-3.2-centos-7.Dockerfile \
		-t libzbxpgsql/zabbix-3.2-centos-7 \
		.

zabbix-3.2-debian-wheezy:
	$(DOCKER_BUILD) \
		-f zabbix-3.2-debian-wheezy.Dockerfile \
		-t libzbxpgsql/zabbix-3.2-debian-wheezy \
		.
		
zabbix-3.2-debian-jessie:
	$(DOCKER_BUILD) \
		-f zabbix-3.2-debian-jessie.Dockerfile \
		-t libzbxpgsql/zabbix-3.2-debian-jessie \
		.

zabbix-3.2-ubuntu-trusty:
	$(DOCKER_BUILD) \
		-f zabbix-3.2-ubuntu-trusty.Dockerfile \
		-t libzbxpgsql/zabbix-3.2-ubuntu-trusty \
		.

zabbix-3.2-ubuntu-xenial:
	$(DOCKER_BUILD) \
		-f zabbix-3.2-ubuntu-xenial.Dockerfile \
		-t libzbxpgsql/zabbix-3.2-ubuntu-xenial \
		.
