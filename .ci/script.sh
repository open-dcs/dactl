#!/usr/bin/env bash

set -e
set -o pipefail

./autogen.sh \
    --disable-ui \
    --disable-webkit \
    --disable-vala-plugin \
    --disable-python-plugin
make
