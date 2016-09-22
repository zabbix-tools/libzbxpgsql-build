all: docker-images

docker-images: \
	build-centos-6 \
	build-centos-7 \
	build-debian-wheezy \
	build-debian-jessie \
	build-ubuntu-precise \
	build-ubuntu-trusty \
	build-ubuntu-xenial \
	zabbix-22-centos-6 \
	zabbix-22-centos-7 \
	zabbix-22-debian-wheezy \
	zabbix-22-debian-jessie \
	zabbix-22-ubuntu-precise \
	zabbix-22-ubuntu-trusty \
	zabbix-30-centos-6 \
	zabbix-30-centos-7 \
	zabbix-30-debian-jessie \
	zabbix-30-debian-wheezy \
	zabbix-30-ubuntu-trusty \
	zabbix-30-ubuntu-xenial \
	zabbix-32-centos-6 \
	zabbix-32-centos-7 \
	zabbix-32-debian-jessie \
	zabbix-32-debian-wheezy \
	zabbix-32-ubuntu-trusty \
	zabbix-32-ubuntu-xenial

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
	docker build \
		-f build-centos-6.Dockerfile \
		-t libzbxpgsql/build-centos-6 \
		.

build-centos-7:
	docker build \
		-f build-centos-7.Dockerfile \
		-t libzbxpgsql/build-centos-7 \
		.

build-debian-wheezy:
	docker build \
		-f build-debian-wheezy.Dockerfile \
		-t libzbxpgsql/build-debian-wheezy \
		.

build-debian-jessie:
	docker build \
		-f build-debian-jessie.Dockerfile \
		-t libzbxpgsql/build-debian-jessie \
		.

build-ubuntu-precise:
	docker build \
		-f build-ubuntu-precise.Dockerfile \
		-t libzbxpgsql/build-ubuntu-precise \
		.

build-ubuntu-trusty:
	docker build \
		-f build-ubuntu-trusty.Dockerfile \
		-t libzbxpgsql/build-ubuntu-trusty \
		.

build-ubuntu-xenial:
	docker build \
		-f build-ubuntu-xenial.Dockerfile \
		-t libzbxpgsql/build-ubuntu-xenial \
		.

zabbix-22-centos-6:
	docker build \
		-f zabbix-22-centos-6.Dockerfile \
		-t libzbxpgsql/zabbix-22-centos-6 \
		.

zabbix-22-centos-7:
	docker build \
		-f zabbix-22-centos-7.Dockerfile \
		-t libzbxpgsql/zabbix-22-centos-7 \
		.

zabbix-22-debian-wheezy:
	docker build \
		-f zabbix-22-debian-wheezy.Dockerfile \
		-t libzbxpgsql/zabbix-22-debian-wheezy \
		.

zabbix-22-debian-jessie:
	docker build \
		-f zabbix-22-debian-jessie.Dockerfile \
		-t libzbxpgsql/zabbix-22-debian-jessie \
		.

zabbix-22-ubuntu-precise:
	docker build \
		-f zabbix-22-ubuntu-precise.Dockerfile \
		-t libzbxpgsql/zabbix-22-ubuntu-precise \
		.

zabbix-22-ubuntu-trusty:
	docker build \
		-f zabbix-22-ubuntu-trusty.Dockerfile \
		-t libzbxpgsql/zabbix-22-ubuntu-trusty \
		.

zabbix-30-centos-6:
	docker build \
		-f zabbix-30-centos-6.Dockerfile \
		-t libzbxpgsql/zabbix-30-centos-6 \
		.

zabbix-30-centos-7:
	docker build \
		-f zabbix-30-centos-7.Dockerfile \
		-t libzbxpgsql/zabbix-30-centos-7 \
		.

zabbix-30-debian-wheezy:
	docker build \
		-f zabbix-30-debian-wheezy.Dockerfile \
		-t libzbxpgsql/zabbix-30-debian-wheezy \
		.
		
zabbix-30-debian-jessie:
	docker build \
		-f zabbix-30-debian-jessie.Dockerfile \
		-t libzbxpgsql/zabbix-30-debian-jessie \
		.

zabbix-30-ubuntu-trusty:
	docker build \
		-f zabbix-30-ubuntu-trusty.Dockerfile \
		-t libzbxpgsql/zabbix-30-ubuntu-trusty \
		.

zabbix-30-ubuntu-xenial:
	docker build \
		-f zabbix-30-ubuntu-xenial.Dockerfile \
		-t libzbxpgsql/zabbix-30-ubuntu-xenial \
		.

zabbix-32-centos-6:
	docker build \
		-f zabbix-32-centos-6.Dockerfile \
		-t libzbxpgsql/zabbix-32-centos-6 \
		.

zabbix-32-centos-7:
	docker build \
		-f zabbix-32-centos-7.Dockerfile \
		-t libzbxpgsql/zabbix-32-centos-7 \
		.

zabbix-32-debian-wheezy:
	docker build \
		-f zabbix-32-debian-wheezy.Dockerfile \
		-t libzbxpgsql/zabbix-32-debian-wheezy \
		.
		
zabbix-32-debian-jessie:
	docker build \
		-f zabbix-32-debian-jessie.Dockerfile \
		-t libzbxpgsql/zabbix-32-debian-jessie \
		.

zabbix-32-ubuntu-trusty:
	docker build \
		-f zabbix-32-ubuntu-trusty.Dockerfile \
		-t libzbxpgsql/zabbix-32-ubuntu-trusty \
		.

zabbix-32-ubuntu-xenial:
	docker build \
		-f zabbix-32-ubuntu-xenial.Dockerfile \
		-t libzbxpgsql/zabbix-32-ubuntu-xenial \
		.
