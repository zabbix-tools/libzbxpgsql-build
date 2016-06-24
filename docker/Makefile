docker-images: \
	build \
	centos-6-zabbix-2 \
	centos-6-zabbix-3 \
	centos-7-zabbix-2 \
	centos-7-zabbix-3 \
	debian-wheezy-zabbix-2 \
	debian-wheezy-zabbix-3 \
	debian-jessie-zabbix-2 \
	debian-jessie-zabbix-3 \
	ubuntu-precise-zabbix-2 \
	ubuntu-trusty-zabbix-2 \
	ubuntu-trusty-zabbix-3

# run build container
run:
	docker run \
		-it \
		--rm \
		libzbxpgsql/build \
		/bin/bash

build:
	docker build \
		-f build.Dockerfile \
		-t libzbxpgsql/build \
		.

centos-6-zabbix-2:
	docker build \
		-f centos-6-zabbix-2.Dockerfile \
		-t libzbxpgsql/centos-6-zabbix-2 \
		.

centos-6-zabbix-3:
	docker build \
		-f centos-6-zabbix-3.Dockerfile \
		-t libzbxpgsql/centos-6-zabbix-3 \
		.

centos-7-zabbix-2:
	docker build \
		-f centos-7-zabbix-2.Dockerfile \
		-t libzbxpgsql/centos-7-zabbix-2 \
		.

centos-7-zabbix-3:
	docker build \
		-f centos-7-zabbix-3.Dockerfile \
		-t libzbxpgsql/centos-7-zabbix-3 \
		.

debian-wheezy-zabbix-2:
	docker build \
		-f debian-wheezy-zabbix-2.Dockerfile \
		-t libzbxpgsql/debian-wheezy-zabbix-2 \
		.
debian-wheezy-zabbix-3:
	docker build \
		-f debian-wheezy-zabbix-3.Dockerfile \
		-t libzbxpgsql/debian-wheezy-zabbix-3 \
		.

debian-jessie-zabbix-2:
	docker build \
		-f debian-jessie-zabbix-2.Dockerfile \
		-t libzbxpgsql/debian-jessie-zabbix-2 \
		.
debian-jessie-zabbix-3:
	docker build \
		-f debian-jessie-zabbix-3.Dockerfile \
		-t libzbxpgsql/debian-jessie-zabbix-3 \
		.

ubuntu-precise-zabbix-2:
	docker build \
		-f ubuntu-precise-zabbix-2.Dockerfile \
		-t libzbxpgsql/ubuntu-precise-zabbix-2 \
		.

ubuntu-trusty-zabbix-2:
	docker build \
		-f ubuntu-trusty-zabbix-2.Dockerfile \
		-t libzbxpgsql/ubuntu-trusty-zabbix-2 \
		.

ubuntu-trusty-zabbix-3:
	docker build \
		-f ubuntu-trusty-zabbix-3.Dockerfile \
		-t libzbxpgsql/ubuntu-trusty-zabbix-3 \
		.
