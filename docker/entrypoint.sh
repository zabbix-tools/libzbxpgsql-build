#!/bin/bash

BULLET="==>"
ARCH=$(uname -m)
ZABBIX_VERSION_MAJOR=${ZABBIX_VERSION:0:1}

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
  [[ -f configure ]] || ./autogen.sh || exit 1
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
  mkdir -p ${WORKDIR}/release
  mv -vf \
    ${PACKAGE_NAME}-${PACKAGE_VERSION}.tar.gz \
    ${WORKDIR}/release/${PACKAGE_NAME}-${PACKAGE_VERSION}.tar.gz
}

# make package for given target OS.
# requires `make dist` to have been run
function make_package() {
  check_env

  [[ -z "${TARGET_OS}" ]] && die "TARGET_OS not set"
  [[ -z "${TARGET_OS_MAJOR}" ]] && die "TARGET_OS_MAJOR not set"
  [[ -z "${TARGET_ARCH}" ]] && die "TARGET_ARCH not set"
  [[ -z "${TARGET_MANAGER}" ]] && die "TARGET_MANAGER not set"

  # create release destination path
  RELEASE_PATH=${WORKDIR}/release/${TARGET_MANAGER}/zabbix${ZABBIX_VERSION_MAJOR}/${TARGET_OS}/${TARGET_OS_MAJOR}/${TARGET_ARCH}
  mkdir -vp ${RELEASE_PATH} || die "error creating release path"

  # build an rpm
  case "${TARGET_MANAGER}" in
    "yum")
      RPMBASE=/root/rpmbuild
      PACKAGE_RELEASE=$(grep '^Release.*' ${WORKDIR}/rpmbuild/${PACKAGE_NAME}.spec | grep -o '[0-9]\+$')
      [[ "${TARGET_OS}" == "rhel" ]] && TARGET_DIST="el${TARGET_OS_MAJOR}."

      # prepare working area
      mkdir -vp ${RPMBASE}/{BUILD,RPMS,SOURCES,SPECS,SRPMS} || :

      # copy spec file
      cp -vf \
        ${WORKDIR}/rpmbuild/${PACKAGE_NAME}.spec \
        ${RPMBASE}/SPECS/${PACKAGE_NAME}.spec \
        || exit 1

      # copy dist package
      cp -vf \
        ${WORKDIR}/release/${PACKAGE_NAME}-${PACKAGE_VERSION}.tar.gz \
        ${RPMBASE}/SOURCES/${PACKAGE_NAME}-${PACKAGE_VERSION}.tar.gz \
        || exit 1
      
      # build rpm
      rpmbuild \
        -ba \
        --define "_zabbix_version ${ZABBIX_VERSION_MAJOR}" \
        ${RPMBASE}/SPECS/${PACKAGE_NAME}.spec \
        || exit 1

      # copy out of container
      cp -vf \
        ${RPMBASE}/RPMS/${TARGET_ARCH}/${PACKAGE_NAME}-${PACKAGE_VERSION}-${PACKAGE_RELEASE}.${TARGET_ARCH}.rpm \
        ${RELEASE_PATH}/${PACKAGE_NAME}-${PACKAGE_VERSION}-${PACKAGE_RELEASE}.${TARGET_DIST}${TARGET_ARCH}.rpm \
        || exit 1
      ;;

    "apt")
      # TODO
      PACKAGE_RELEASE=1

      # copy dist to tmp build area
      cd /tmp
      cp -v \
        ${WORKDIR}/release/${PACKAGE_NAME}-${PACKAGE_VERSION}.tar.gz \
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

      # fixes for zabbix v2
      if [[ "${ZABBIX_VERSION_MAJOR}" == "2" ]]; then
        sed -i \
          -e 's/\/zabbix\/modules/\/modules/g' \
          /tmp/${PACKAGE_NAME}-${PACKAGE_VERSION}/debian/rules

        sed  -i \
          -e 's/, zabbix-agent \(.*\)/, zabbix-agent (>= 2.2)/' \
          /tmp/${PACKAGE_NAME}-${PACKAGE_VERSION}/debian/control
      fi

      # build
      cd ${PACKAGE_NAME}-${PACKAGE_VERSION}
      debuild -us -uc || exit 1

      # copy package out of container
      cp -vf \
        ../${PACKAGE_NAME}_${PACKAGE_VERSION}-1_${TARGET_ARCH}.deb \
        ${RELEASE_PATH}/${PACKAGE_NAME}_${PACKAGE_VERSION}-${PACKAGE_RELEASE}+${TARGET_OS_MAJOR}_${TARGET_ARCH}.deb \
        || exit 1
      ;;

    *)
      die "Unsupported package manager: ${TARGET_MANAGER}"
      ;;
  esac
}

function test_package() {
  check_env

  echo "${BULLET} Zabbix agent info:"
  zabbix_agentd --version

  # target installed agent version
  ZABBIX_VERSION_MAJOR=$(zabbix_agentd --version | grep -o '[0-9]\+' | grep -o '[0-9]\+' | head -n 1)
  [[ -z "${ZABBIX_VERSION_MAJOR}" ]] && die "Error printing Zabbix agent version"

  # install on redhat family
  if [[ -f /etc/redhat-release ]]; then
    OS=$(head -n 1 /etc/redhat-release)
    OSVER=$(grep -o '[0-9]\+' /etc/redhat-release | head -n 1)
    ARCH=$(uname -m)
    PACKAGE_PATH=release/yum/zabbix${ZABBIX_VERSION_MAJOR}/rhel/${OSVER}/${ARCH}/${PACKAGE_NAME}-${PACKAGE_VERSION}-1.el${OSVER}.${ARCH}.rpm

    echo "${BULLET} Package info:"
    rpm -qpi ${WORKDIR}/${PACKAGE_PATH}
    rpm -qpl ${WORKDIR}/${PACKAGE_PATH}
    rpm -qpR ${WORKDIR}/${PACKAGE_PATH}

    echo "${BULLET} Installing ${PACKAGE_PATH} on ${OS}"
    rpm -iv ${WORKDIR}/${PACKAGE_PATH} || die "Error installing package"

  # install on debian family
  elif [[ -f /etc/os-release ]]; then
    source /etc/os-release
    OS="${ID}"
    case "${ID}" in
      "debian")
        case "${VERSION_ID}" in
          "7") OSVER="wheezy" ;;
          "8") OSVER="jessie" ;;
        esac
      ;;

      "ubuntu")
        case "${VERSION_ID}" in
          "12.04") OSVER="precise" ;;
          "14.04") OSVER="trusty" ;;
        esac
      ;;

      *)
        die "Unsupported operating system: ${PRETTY_NAME}"
        ;;
    esac

    case "$(uname -m)" in
      "x86_64") ARCH="amd64" ;;
      *) die "Unsupported architecture: $(uname -m)" ;;
    esac

    PACKAGE_PATH=release/apt/zabbix${ZABBIX_VERSION_MAJOR}/${OS}/${OSVER}/${ARCH}/${PACKAGE_NAME}_${PACKAGE_VERSION}-1+${OSVER}_${ARCH}.deb


    echo "${BULLET} Package info:"
    dpkg-deb -I ${WORKDIR}/${PACKAGE_PATH}
    dpkg-deb -c ${WORKDIR}/${PACKAGE_PATH}

    echo "${BULLET} Installing ${PACKAGE_PATH} on ${PRETTY_NAME}"
    dpkg -i ${WORKDIR}/${PACKAGE_PATH} || die "Error installing package"
  fi

  echo "${BULLET} Testing module configuration"
  zabbix_agentd -t pg.modver \
    | grep --color "libzbxpgsql ${PACKAGE_VERSION}" \
    || die "Error getting loaded ${PACKAGE_NAME} version"
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

  "agent")
    PACKAGE_PATH=${WORKDIR}/${PACKAGE_NAME}/src/.libs/${PACKAGE_NAME}.so
    CONF_PATH=${WORKDIR}/${PACKAGE_NAME}/query.conf

    # load module if present
    if [[ -f $PACKAGE_PATH ]]; then
      ln -vs \
        $PACKAGE_PATH \
        /usr/lib/zabbix/modules/${PACKAGE_NAME}.so

      if [[ ! -f /etc/zabbix/zabbix_agent.d/${PACKAGE_NAME}.conf ]]; then
        echo "LoadModule=${PACKAGE_NAME}.so" > \
          /etc/zabbix/zabbix_agentd.d/${PACKAGE_NAME}.conf
      fi
    fi

    # add config file if needed
    if [[ -f $CONF_PATH && ! -f /etc/${PACKAGE_NAME}.d/query.conf ]]; then
      mkdir /etc/${PACKAGE_NAME}.d
      cp -v $CONF_PATH /etc/${PACKAGE_NAME}.d
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

  "package")
    make_package
    ;;

  "test_package")
    test_package
    ;;

  *)
    exec $@
    ;;
esac
