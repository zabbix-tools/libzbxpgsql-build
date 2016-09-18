FROM centos:7

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
  vim-enhanced

# install zabbix_agent_bench
RUN curl -LO https://sourceforge.net/projects/zabbixagentbench/files/linux/zabbix_agent_bench-0.4.0.x86_64.tar.gz \
  && tar -xzvf zabbix_agent_bench-0.4.0.x86_64.tar.gz \
  && cp -vf zabbix_agent_bench-0.4.0.x86_64/zabbix_agent_bench /usr/bin/zabbix_agent_bench \
  && rm -rvf zabbix_agent_bench-0.4.0.x86_64*

# install zabbix agent
RUN \
  curl -LO http://repo.zabbix.com/zabbix/3.0/rhel/7/x86_64/zabbix-release-3.0-1.el7.noarch.rpm \
  && rpm -iv zabbix-release-3.0-1.el7.noarch.rpm \
  && yum -y install zabbix-agent zabbix-get \
  && mkdir -p /usr/lib64/zabbix/modules \
  && echo "AllowRoot=1" >> /etc/zabbix/zabbix_agentd.conf \
  && echo "LogType=console" >> /etc/zabbix/zabbix_agentd.conf \
  && rm -rf zabbix-release-3.0-1.el7.noarch.rpm

# install postgresql libs
RUN \
  curl -LO https://download.postgresql.org/pub/repos/yum/9.5/redhat/rhel-7-x86_64/pgdg-centos95-9.5-2.noarch.rpm \
  && rpm -iv pgdg-centos95-9.5-2.noarch.rpm \
  && yum -y install postgresql95 postgresql95-server postgresql95-devel \
  && ln -s /usr/pgsql-9.5/bin/pg_config /usr/local/bin \
  && rm -rf pgdg-centos95-9.5-2.noarch.rpm \
  && yum clean all

EXPOSE 10050

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
