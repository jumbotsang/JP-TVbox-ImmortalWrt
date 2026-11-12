#!/bin/bash
set -euo pipefail
# Preserve the existing LAN address used by the JP-TVbox firmware.
sed -i 's/192\.168\.1\.1/192.168.50.2/g' package/base-files/files/bin/config_generate
# Add the required LuCI applications and theme as source packages.
git clone --depth=1 https://github.com/ophub/luci-app-amlogic.git package/luci-app-amlogic
git clone --depth=1 https://github.com/jerrykuku/luci-theme-argon.git package/luci-theme-argon
# Nikki is a multi-package feed; install it through OpenWrt's feed manager.
grep -q '^src-git nikki ' feeds.conf.default || \
    echo 'src-git nikki https://github.com/nikkinikki-org/OpenWrt-nikki.git;main' >> feeds.conf.default
./scripts/feeds update nikki
./scripts/feeds install -a -p nikki
# BusyBox tar in OpenWrt does not necessarily auto-detect gzip archives.
# Make the kernel updater explicitly decompress gzip before extracting tar.
KERNEL_UPDATE_SCRIPT="package/luci-app-amlogic/root/usr/share/amlogic/amlogic_check_kernel.sh"
if [[ -f "$KERNEL_UPDATE_SCRIPT" ]]; then
    sed -i 's/tar -xf /tar -xzf /g' "$KERNEL_UPDATE_SCRIPT"
    grep -Fq 'tar -xzf ${KERNEL_DOWNLOAD_PATH}/${kernel_file_name}.tar.gz' "$KERNEL_UPDATE_SCRIPT"
else
    echo "晶晨宝盒内核更新脚本不存在：$KERNEL_UPDATE_SCRIPT" >&2
    exit 1
fi
