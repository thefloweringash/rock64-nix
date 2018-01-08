#!/bin/sh

old_version="$1"
new_version="$2"

prefix=ayufan-rock64/linux-build
short_version=${old_version}...${new_version}
long_version=${prefix}/${old_version}...${prefix}/${new_version}

cat <<EOF

linux-build:
  https://github.com/ayufan-rock64/linux-build/compare/${short_version}

Manifest
  https://github.com/ayufan-rock64/linux-manifests

EOF

for repo in linux-kernel linux-u-boot arm-trusted-firmware; do
  cat <<EOF
${repo}:
  https://github.com/ayufan-rock64/${repo}/compare/${long_version}

EOF
done
