# libzbxpgsql-build

Build and test scripts for [libzbxpgsql](https://github.com/cavaliercoder/libzbxpgsql).

## Setup

1. Clone this repo
2. Clone `libzbxpgsql` sources into `./libzbxpgsql`
3. Ensure `PACKAGE_VERSION` in `Makefile` matches the `AC_INIT` version in
   `./libzbxpgsql/configure.ac`
4. Build the Docker images with `make docker-images`

## Docker images

This repo uses Docker to create immutable build and test environments so that:

* Build and tests run in a known state
* Developer workstation is left alone
* Multiple operating systems can be tested quickly

All Dockerfiles are stored and built in `./docker`.

The `libzbxpgsql/build` image is a Debian Jessie environment that contains
everything you need to compile, package and test `libzbxpgsql`.

## Build targets

* `make libzbxpgsql.so`:

  Compiles the main module in place (`./libzbxpgsql/src/libs/libzbxpgsql.so`)
  
* `make docker-images`:
  
  Builds all Docker images required to build, package and test `libzbxpgsql`

* `make dist`:
  
  Builds a source distribution archive, used as input for packaging systems

* `make package [OPTION=VALUE, ...]`:
  
  Builds a package for the desired target. Supports the following options:

  * `ZABBIX_VERSION=n.n.n`
  * `TARGET_MANAGER=apt|yum`
  * `TARGET_OS=rhel|debian|ubuntu`
  * `TARGET_OS_MAJOR=6|7|wheezy|jessie|precise|trusty`
  * `TARGET_ARCH=amd64|x86_64`

* `make package-tests`:
  
  Test the installation and configuration of built packages on all supported
  operating systems

* `make clean`:
  
  Destroy all build and package output, including the `./release` directory

* `make key-tests`:

  Run tests using a live agent against all supported versions of PostgreSQL.
  This requires `make testenv` to be running

* `make testenv`:
  
  Use `docker-compose` to run all supported versions of PostgreSQL and a Zabbix
  agent loaded with `libzbxpgsql`

* `make agent`:
  
  Start the Zabbix v3 agent on the build container

* `make shell`:
  
  Run an interactive shell in a new instances of the `libzbxpgsql/build`
  container
