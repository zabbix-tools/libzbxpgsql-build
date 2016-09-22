FROM ubuntu:xenial

ENV DEBIAN_FRONTEND noninteractive

RUN \
  apt-get -q update \
  && apt-get -y install wget libpq5 libconfig9 \
  && wget -nv http://repo.zabbix.com/zabbix/3.2/ubuntu/pool/main/z/zabbix-release/zabbix-release_3.2-1+xenial_all.deb \
  && dpkg -i zabbix-release_3.2-1+xenial_all.deb \
  && apt-get -q update \
  && apt-get -y install zabbix-agent zabbix-get

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
