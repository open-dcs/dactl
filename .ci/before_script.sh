#!/usr/bin/env bash

set -e
set -o pipefail

wget https://launchpad.net/libsoup/main/2.34.2/+download/libsoup-2.34.2.tar.gz
tar zxvf libsoup-2.34.2.tar.gz
cd libsoup-2.34.2
./configure --prefix=/usr
make && sudo make install
# TODO move into a build_deps script within .ci/common/build.sh
git clone https://github.com/geoffjay/libcld.git
cd libcld
git checkout develop
PKG_CONFIG_PATH=./deps ./autogen.sh
make && sudo make install
cd ..
# XXX don't think this actually works
echo "/usr/local/lib" | sudo tee --append /etc/ld.so.conf
sudo ldconfig
