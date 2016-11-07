#!/usr/bin/env bash

set -e
set -o pipefail

sed -i 's/\(\[pygobject_required_version\]\,\s\[3\.\)18\(\.0\]\)/\112\2/' configure.ac
sed -i 's/\(\[glib_required_version\]\,\s\[2\.\)46\(\.0\]\)/\140\2/' configure.ac
sed -i 's/\(\[peas_required_version\]\,\s\[1\.\)16\(\.0\]\)/\18\2/' configure.ac
sed -i 's/\(\[json_required_version\]\,\s\[\)1\.0\(\.0\]\)/\10.16\2/' configure.ac

./autogen.sh \
    --disable-ui \
    --disable-webkit \
    --disable-vala-plugin \
    --disable-python-plugin
make
