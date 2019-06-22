FROM ubuntu:xenial

ENV HOSTNAME=ks-builder
ENV PS1="\h:\w\$ "

RUN echo "deb mirror://mirrors.ubuntu.com/mirrors.txt xenial main restricted universe multiverse" > /etc/apt/sources.list && \
    echo "deb mirror://mirrors.ubuntu.com/mirrors.txt xenial-updates main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb mirror://mirrors.ubuntu.com/mirrors.txt xenial-security main restricted universe multiverse" >> /etc/apt/sources.list && \
    DEBIAN_FRONTEND=noninteractive apt-get update && \
    apt-get install -y \
    apt-transport-https \
    tar \
    xz-utils \
    curl \
    sudo \
    automake \
    autopoint \
    gcc-aarch64-linux-gnu \
    binutils-aarch64-linux-gnu \
    libtool \
    ca-certificates \
    git \
    cpio \
    gettext \
    pkg-config \
    bison \
    && rm -rf /var/lib/apt/lists/* \
    && echo 'export PS1="ks-dev \W $ "' > /bashrc \
    && mkdir -p /sdk \
    && mkdir -p /target/{dev,proc,sys,tmp}
