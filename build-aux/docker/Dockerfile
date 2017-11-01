FROM debian:latest

MAINTAINER Geoff Johnson <geoff.jay@gmail.com>

RUN apt-get update
RUN apt-get install -y \
    libcomedi-dev \
    libgee-0.8-dev \
    libgirepository1.0-dev \
    libglib2.0-dev \
    libgsl0-dev \
    libjson-glib-dev \
    libmatheval-dev \
    libmodbus-dev \
    libpeas-dev \
    libreadline-dev \
    libsoup2.4-dev \
    libsqlite3-dev \
    libxml2-dev \
    libzmq3-dev \
    bison \
    flex \
    gettext \
    git \
    python-gobject-dev \
    python3-pip \
    unzip \
    valac
RUN rm -rf /var/lib/apt/lists/*

# Meson
RUN pip3 install meson

# Ninja
ADD https://github.com/ninja-build/ninja/releases/download/v1.6.0/ninja-linux.zip /tmp
RUN unzip /tmp/ninja-linux.zip -d /usr/local/bin

# TODO add build for cld, template-glib (?), valum (?)
