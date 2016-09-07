FROM debian:jessie

ENV DEBIAN_FRONTEND noninteractive

# install dev tools
RUN apt-get update && apt-get -y install \
  git \
  devscripts \
  debhelper \
  dh-make \
  rpm \
  make \
  gcc \
  autoconf \
  automake \
  m4 \
  libtool \
  libpq-dev \
  libconfig-dev \
  vim \
  && rm -rf /var/lib/apt/lists/*

# install zabbix_agent_bench
RUN curl -LO https://sourceforge.net/projects/zabbixagentbench/files/linux/zabbix_agent_bench-0.4.0.x86_64.tar.gz \
  && tar -xzvf zabbix_agent_bench-0.4.0.x86_64.tar.gz \
  && cp -vf zabbix_agent_bench-0.4.0.x86_64/zabbix_agent_bench /usr/bin/zabbix_agent_bench \
  && rm -rvf zabbix_agent_bench-0.4.0.x86_64*

# install zabbix agent
RUN \
  curl -LO http://repo.zabbix.com/zabbix/3.0/debian/pool/main/z/zabbix-release/zabbix-release_3.0-1+jessie_all.deb \
  && dpkg -i zabbix-release_3.0-1+jessie_all.deb \
  && apt-get update \
  && apt-get -y install zabbix-agent zabbix-get \
  && mkdir -p /usr/lib/zabbix/modules \
  && mkdir -p /var/run/zabbix && chown zabbix.zabbix /var/run/zabbix \
  && echo "AllowRoot=1" >> /etc/zabbix/zabbix_agentd.conf \
  && echo "LogType=console" >> /etc/zabbix/zabbix_agentd.conf \
  && rm -rf zabbix-release_3.0-1+jessie_all.deb /var/lib/apt/lists/*

EXPOSE 10050

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
