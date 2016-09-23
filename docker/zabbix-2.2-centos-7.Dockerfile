FROM centos:7

RUN \
  rpm -iv http://repo.zabbix.com/zabbix/2.4/rhel/7/x86_64/zabbix-release-2.4-1.el7.noarch.rpm \
  && yum install -y zabbix-agent zabbix-get postgresql-libs libconfig \
  && yum clean all

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
