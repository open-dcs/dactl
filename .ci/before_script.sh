#!/usr/bin/env bash

set -e
set -o pipefail

cd ${TRAVIS_BUILD_DIR}
wget https://github.com/GNOME/libsoup/archive/2.48.1.tar.gz
tar zxvf 2.48.1.tar.gz
cd libsoup-2.48.1
./autogen.sh --prefix=/usr --without-gnome --disable-tls-check
make && sudo make install
cd ${TRAVIS_BUILD_DIR}
rm -rf libsoup-2.48.1
# TODO move into a build_deps script within .ci/common/build.sh
git clone https://github.com/geoffjay/libcld.git
cd libcld
git checkout develop
PKG_CONFIG_PATH=./deps ./autogen.sh
make && sudo make install
cd ${TRAVIS_BUILD_DIR}
rm -rf libcld
# XXX don't think this actually works
echo "/usr/local/lib" | sudo tee --append /etc/ld.so.conf
sudo ldconfig
