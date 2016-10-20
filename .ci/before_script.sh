#!/usr/bin/env bash

set -e
set -o pipefail

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
