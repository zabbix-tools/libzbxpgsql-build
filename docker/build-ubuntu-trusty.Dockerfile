FROM ubuntu:trusty

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

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
