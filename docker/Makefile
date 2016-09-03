docker-images: \
	build-wheezy \
	build-jessie \
	build-precise \
	build-centos-6 \
	build-centos-7 \
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
run-jessie:
	docker run \
		-it \
		--rm \
		libzbxpgsql/build-jessie \
		/bin/bash

run-wheezy:
	docker run \
		-it \
		--rm \
		libzbxpgsql/build-wheezy \
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

build-jessie:
	docker build \
		-f build-jessie.Dockerfile \
		-t libzbxpgsql/build-jessie \
		.

build-wheezy:
	docker build \
		-f build-wheezy.Dockerfile \
		-t libzbxpgsql/build-wheezy \
		.

build-precise:
	docker build \
		-f build-precise.Dockerfile \
		-t libzbxpgsql/build-precise \
		.

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

