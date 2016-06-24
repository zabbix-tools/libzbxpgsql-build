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

make dist

# build for each zabbix version
for ZABBIX_VERSION in "2.4.8" "3.0.2"; do
  TARGET_MANAGER="apt"

  TARGET_OS="debian"
  for TARGET_OS_MAJOR in "wheezy" "jessie"; do
    for TARGET_ARCH in "amd64"; do
      make_package "${ZABBIX_VERSION}" "${TARGET_MANAGER}" "${TARGET_OS}" "${TARGET_OS_MAJOR}" "${TARGET_ARCH}"
    done
  done

  TARGET_OS="ubuntu"
  for TARGET_OS_MAJOR in "trusty" "precise"; do
    for TARGET_ARCH in "amd64"; do
      make_package "${ZABBIX_VERSION}" "${TARGET_MANAGER}" "${TARGET_OS}" "${TARGET_OS_MAJOR}" "${TARGET_ARCH}"
    done
  done

  TARGET_MANAGER="yum"
  
  TARGET_OS="rhel"
  for TARGET_OS_MAJOR in "6" "7"; do
    for TARGET_ARCH in "x86_64"; do
      make_package "${ZABBIX_VERSION}" "${TARGET_MANAGER}" "${TARGET_OS}" "${TARGET_OS_MAJOR}" "${TARGET_ARCH}"
    done
  done
done
