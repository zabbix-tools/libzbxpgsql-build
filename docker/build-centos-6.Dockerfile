FROM centos:6

# install dev tools
RUN yum -y groupinstall development \
  && yum -y install \
  git \
  rpmdevtools \
  make \
  gcc \
  autoconf \
  automake \
  m4 \
  libtool \
  libpqxx-devel \
  libconfig-devel \
  vim-enhanced \
  && yum clean all

# install zabbix_agent_bench
RUN curl -LO https://sourceforge.net/projects/zabbixagentbench/files/linux/zabbix_agent_bench-0.4.0.x86_64.tar.gz \
  && tar -xzvf zabbix_agent_bench-0.4.0.x86_64.tar.gz \
  && cp -vf zabbix_agent_bench-0.4.0.x86_64/zabbix_agent_bench /usr/bin/zabbix_agent_bench \
  && rm -rvf zabbix_agent_bench-0.4.0.x86_64*

# install zabbix agent
RUN \
  curl -LO http://repo.zabbix.com/zabbix/3.0/rhel/6/x86_64/zabbix-release-3.0-1.el6.noarch.rpm \
  && rpm -iv zabbix-release-3.0-1.el6.noarch.rpm \
  && yum -y install zabbix-agent zabbix-get \
  && mkdir -p /usr/lib64/zabbix/modules \
  && echo "AllowRoot=1" >> /etc/zabbix/zabbix_agentd.conf \
  && echo "LogType=console" >> /etc/zabbix/zabbix_agentd.conf \
  && echo "LoadModulePath=/root/libzbxpgsql/libzbxpgsql/src/.libs" >> /etc/zabbix/zabbix_agentd.conf \
  && echo "LoadModule=libzbxpgsql.so" >> /etc/zabbix/zabbix_agentd.conf \
  && rm -rf zabbix-release-3.0-1.el6.noarch.rpm \
  && yum clean all

EXPOSE 10050

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
