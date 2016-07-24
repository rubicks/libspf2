# github.com/rubicks/libspf2/Dockerfile

from debian:jessie

maintainer rubicks <naroza@gmail.com>

run \
  apt-get -y update && \
  apt-get -y upgrade && \
  apt-get -y dist-upgrade && \
  apt-get -y install \
    coreutils \
    curl      \
    g++       \
    gcc       \
    git       \
    jq        \
    m4        \
    make      \
    tar       \
    wget      \
  && >/stamp.txt date --iso-8601=ns

run wget -O- https://raw.githubusercontent.com/rubicks/autotoolme/master/autotoolme.sh | sh

workdir /libspf2
add . .
run \
  autoreconf -ivf . && \
  ./configure && \
  make && \
  make install && \
  echo win

cmd /bin/bash
