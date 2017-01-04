FROM debian:jessie

ENV DEBIAN_FRONTEND noninteractive

RUN \
  apt-get update -y \
  && apt-get -y install wget libpq5 libconfig9 \
  && wget -nv http://repo.zabbix.com/zabbix/3.2/debian/pool/main/z/zabbix-release/zabbix-release_3.2-1+jessie_all.deb \
  && dpkg -i zabbix-release_3.2-1+jessie_all.deb \
  && apt-get -q update \
  && apt-get -y install zabbix-agent zabbix-get \
  && rm -rf /var/lib/apt/lists/*

# we'll use this container also for running zabbix_agent_bench
RUN \
    wget https://sourceforge.net/projects/zabbixagentbench/files/linux/zabbix_agent_bench-0.4.0.x86_64.tar.gz \
    && tar -xzvf zabbix_agent_bench-0.4.0.x86_64.tar.gz \
    && cp -vf zabbix_agent_bench-0.4.0.x86_64/zabbix_agent_bench /usr/bin/zabbix_agent_bench \
    && rm -rvf zabbix_agent_bench-0.4.0.x86_64/ zabbix_agent_bench-0.4.0.x86_64.tar.gz

# we'll also use it for testing the module in a running agent
RUN \
	install -d -o zabbix -g zabbix -m 0750 /usr/lib/zabbix/modules \
	&& install -d -o zabbix -g zabbix -m 755 /var/run/zabbix \
  && install -d -o zabbix -g zabbix -m  0750 /etc/libzbxpgsql.d \
  && echo "AllowRoot=1" >> /etc/zabbix/zabbix_agentd.conf \
  && echo "LogType=console" >> /etc/zabbix/zabbix_agentd.conf

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
