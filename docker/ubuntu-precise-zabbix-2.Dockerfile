FROM ubuntu:precise

ENV DEBIAN_FRONTEND noninteractive

RUN \
  apt-get update -y \
  && apt-get -y install wget libpq5 \
  && wget -nv http://repo.zabbix.com/zabbix/2.2/ubuntu/pool/main/z/zabbix-release/zabbix-release_2.2-1+precise_all.deb \
  && dpkg -i zabbix-release_2.2-1+precise_all.deb \
  && apt-get -q update \
  && apt-get -y install zabbix-agent zabbix-get \
  && rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
