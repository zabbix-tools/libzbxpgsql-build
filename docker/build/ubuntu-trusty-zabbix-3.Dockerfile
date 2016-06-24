FROM ubuntu:trusty

ENV DEBIAN_FRONTEND noninteractive

RUN \
  apt-get -q update \
  && apt-get -y install wget libpq5 \
  && wget -nv http://repo.zabbix.com/zabbix/3.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_3.0-1+trusty_all.deb \
  && dpkg -i zabbix-release_3.0-1+trusty_all.deb \
  && apt-get -q update \
  && apt-get -y install zabbix-agent zabbix-get
  
COPY entrypoint.sh /entrypoint.sh

CMD [ "/entrypoint.sh" ]
