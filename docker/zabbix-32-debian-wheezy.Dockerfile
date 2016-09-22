FROM debian:wheezy

ENV DEBIAN_FRONTEND noninteractive

RUN \
  apt-get update -y \
  && apt-get -y install wget libpq5 libconfig9 \
  && wget -nv http://repo.zabbix.com/zabbix/3.2/debian/pool/main/z/zabbix-release/zabbix-release_3.2-1+wheezy_all.deb \
  && dpkg -i zabbix-release_3.2-1+wheezy_all.deb \
  && apt-get -q update \
  && apt-get -y install zabbix-agent zabbix-get \
  && rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
