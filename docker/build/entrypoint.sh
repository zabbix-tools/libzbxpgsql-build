#!/bin/bash

function die() {
  echo "$@"
  exit 1
}

function check_env() {
  [[ -z "${WORKDIR}" ]] && die "WORKDIR not set"
  [[ -z "${PACKAGE_NAME}" ]] && die "PACKAGE_NAME not set"
  [[ -z "${PACKAGE_VERSION}" ]] && die "PACKAGE_VERSION not set"
  [[ -z "${ZABBIX_VERSION}" ]] && die "ZABBIX_VERSION not set"

  # ensure zabbix sources exist
  # version is assumed to be correct as it is in the file path
  [[ -d ${WORKDIR}/zabbix-${ZABBIX_VERSION} ]] || \
    die "Zabbix sources not found"

  # set zabbix major version
  export ZABBIX_VERSION_MAJOR=${ZABBIX_VERSION:0:1}

  # link zabbix sources to default location
  [[ -d /usr/src/zabbix ]] || ln -s \
    ${WORKDIR}/zabbix-${ZABBIX_VERSION} \
    /usr/src/zabbix

  # ensure module source exists
  [[ -f ${WORKDIR}/${PACKAGE_NAME}/configure.ac ]] || \
    die "${PACKAGE_NAME} sources not found"

  # check module source version
  PACKAGE_SOURCE_VERSION=$(grep AC_INIT ${WORKDIR}/${PACKAGE_NAME}/configure.ac | grep -Eo '([0-9]+\.){2}[0-9]+')
  [[ "${PACKAGE_VERSION}" == "${PACKAGE_SOURCE_VERSION}" ]] ||
    die "Requested build of ${PACKAGE_NAME}-${PACKAGE_VERSION} but sources are version ${PACKAGE_SOURCE_VERSION}"
}

function make_build(){
  check_env

  cd ${WORKDIR}/${PACKAGE_NAME}
  [[ -f configure ]] || autogen.sh || exit 1
  [[ -f Makefile ]] || ./configure || exit 1
  make || exit 1
}

# make source distribution package
function make_dist() {
  check_env

  cd ${WORKDIR}/${PACKAGE_NAME}
  [[ -f configure ]] || autogen.sh || exit 1
  [[ -f Makefile ]] || ./configure || exit 1
  make dist || exit 1

  # move to parent
  mv -vf \
    ${PACKAGE_NAME}-${PACKAGE_VERSION}.tar.gz \
    ${WORKDIR}/${PACKAGE_NAME}-${PACKAGE_VERSION}.tar.gz
}

# make debian package
function make_deb() {
  check_env

  # create dist package
  make_dist

  # copy dist to tmp build area
  cd /tmp
  cp -v \
    ${WORKDIR}/${PACKAGE_NAME}-${PACKAGE_VERSION}.tar.gz \
    /tmp/${PACKAGE_NAME}_${PACKAGE_VERSION}.orig.tar.gz \
    || exit 1

  # extract sources
  tar -xC /tmp -f /tmp/${PACKAGE_NAME}_${PACKAGE_VERSION}.orig.tar.gz \
    || exit 1

  mkdir /tmp/${PACKAGE_NAME}-${PACKAGE_VERSION}/debian/

  # copy package config
  cp -vr \
    ${WORKDIR}/debuild/* \
    /tmp/${PACKAGE_NAME}-${PACKAGE_VERSION}/debian/ \
    || exit 1

  # build
  cd ${PACKAGE_NAME}-${PACKAGE_VERSION}
  debuild -us -uc || exit 1

  # copy package out of container
  cp -vf \
    ../${PACKAGE_NAME}_${PACKAGE_VERSION}-1_amd64.deb \
    ${WORKDIR}/${PACKAGE_NAME}_${PACKAGE_VERSION}-1_amd64.deb \
    || exit 1
}

function make_rpm() {
  check_env

  # create dist package
  make_dist

  RPMBASE=/root/rpmbuild
  ARCH=$(uname -m)

  # prepare working area
  mkdir -vp ${RPMBASE}/{BUILD,RPMS,SOURCES,SPECS,SRPMS} || :

  # copy spec file
  cp -vf \
    ${WORKDIR}/rpmbuild/${PACKAGE_NAME}-zabbix-${ZABBIX_VERSION_MAJOR}.spec \
    ${RPMBASE}/SPECS/${PACKAGE_NAME}.spec \
    || exit 1

  # copy dist package
  cp -vf \
    ${WORKDIR}/${PACKAGE_NAME}-${PACKAGE_VERSION}.tar.gz \
    ${RPMBASE}/SOURCES/${PACKAGE_NAME}-${PACKAGE_VERSION}.tar.gz \
    || exit 1
  
  # build rpm
  rpmbuild -ba ${RPMBASE}/SPECS/${PACKAGE_NAME}.spec || exit 1

  # copy out of container
  cp -vf \
    ${RPMBASE}/RPMS/${ARCH}/${PACKAGE_NAME}-${PACKAGE_VERSION}-1.${ARCH}.rpm \
    ${WORKDIR}/${PACKAGE_NAME}-${PACKAGE_VERSION}-1.${ARCH}.rpm \
    || exit 1
}

function test_keys() {
  check_env

  PGHOST=$1
  PGVERSION=$2

  export PGDATABASE=postgres
  PGCONN="host=${PGHOST} user=postgres" \
    zabbix_agent_bench \
      -host localhost \
      -iterations 1 \
      -threads 8 \
      -strict \
      -keys ${WORKDIR}/fixtures/postgresql-${PGVERSION}.keys
}

case $1 in
  "all")
    make_dist
    make_deb
    make_rpm
    ;;

  "build")
    make_build
    ;;
    
  "dist")
    make_dist
    ;;

  "deb")
    make_deb
    ;;

  "rpm")
    make_rpm
    ;;

  "agent")
    PACKAGE_PATH=${WORKDIR}/${PACKAGE_NAME}/src/.libs/${PACKAGE_NAME}.so

    # load module if present
    if [[ -f $PACKAGE_PATH ]]; then
      ln -vs \
        $PACKAGE_PATH \
        /usr/lib/zabbix/modules/${PACKAGE_NAME}.so

      echo "LoadModule=${PACKAGE_NAME}.so" > \
        /etc/zabbix/zabbix_agentd.d/${PACKAGE_NAME}.conf
    fi

    # start agent
    exec /usr/sbin/zabbix_agentd -c /etc/zabbix/zabbix_agentd.conf -f
    ;;

  "test")
    test_keys pg84 8.4 || die "Tests failed for PostgreSQL v8.4"
    test_keys pg90 8.4 || die "Tests failed for PostgreSQL v9.0"
    test_keys pg91 9.1 || die "Tests failed for PostgreSQL v9.1"
    test_keys pg92 9.2 || die "Tests failed for PostgreSQL v9.2"
    test_keys pg93 9.2 || die "Tests failed for PostgreSQL v9.3"
    test_keys pg94 9.4 || die "Tests failed for PostgreSQL v9.4"
    test_keys pg95 9.4 || die "Tests failed for PostgreSQL v9.5"
    ;;

  *)
    exec $@
    ;;
esac
