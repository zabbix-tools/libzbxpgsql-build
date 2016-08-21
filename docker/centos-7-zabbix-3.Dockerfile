FROM centos:7

RUN \
  rpm -iv http://repo.zabbix.com/zabbix/3.0/rhel/7/x86_64/zabbix-release-3.0-1.el7.noarch.rpm \
  && yum install -y zabbix-agent zabbix-get postgresql-libs libconfig \
  && yum clean all

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
