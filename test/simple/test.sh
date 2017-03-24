#!/bin/bash
set -euo pipefail

cd "$(dirname $0)/app"
declare -r output='simple_0.1.0_all'

finish() {
  rm -rf "$output" *.deb
}

trap 'finish' EXIT

../../../node-deb --verbose \
                  --no-delete-temp \
                  -- app.js lib/

if ! grep -q 'Package: simple' "$output/DEBIAN/control"; then
  echo 'Package name was wrong'
  exit 1
fi

if ! grep -q 'Version: 0.1.0' "$output/DEBIAN/control"; then
  echo 'Package version was wrong'
  exit 1
fi

dpkg -i "$output.deb"
apt-get purge -y simple
