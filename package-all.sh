#!/bin/bash
function die() {
  echo "$@" >&2
  exit 1
}

function make_package() {
  make package \
    ZABBIX_VERSION="$1" \
    TARGET_MANAGER="$2" \
    TARGET_OS="$3" \
    TARGET_OS_MAJOR="$4" \
    TARGET_ARCH="$5" \
    || die "Package build failed"
}

# only build package given from command line
if [[ $# -gt 0 ]]; then
  make dist
  make_package $@
  exit 0
fi

# build all packages
make docker-images || die
make dist || die

make_package 2.2.14 yum centos 6 x86_64
make_package 2.2.14 yum centos 7 x86_64
make_package 2.2.14 apt debian wheezy amd64
make_package 2.2.14 apt debian jessie amd64
make_package 2.2.14 apt ubuntu precise amd64
make_package 2.2.14 apt ubuntu trusty amd64

make_package 3.0.4 yum centos 6 x86_64
make_package 3.0.4 yum centos 7 x86_64
make_package 3.0.4 apt debian wheezy amd64
make_package 3.0.4 apt debian jessie amd64
make_package 3.0.4 apt ubuntu trusty amd64
make_package 3.0.4 apt ubuntu xenial amd64

make_package 3.2.0 yum centos 6 x86_64
make_package 3.2.0 yum centos 7 x86_64
make_package 3.2.0 apt debian wheezy amd64
make_package 3.2.0 apt debian jessie amd64
make_package 3.2.0 apt ubuntu trusty amd64
make_package 3.2.0 apt ubuntu xenial amd64
