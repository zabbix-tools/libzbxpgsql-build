FROM centos:7

# install dev tools
RUN yum -y install \
  libtool \
  make \
  rpm-build \
  libconfig-devel \
  postgresql-devel \
  && yum clean all

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
