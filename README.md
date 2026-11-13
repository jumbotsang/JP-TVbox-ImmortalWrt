# JP-TVbox ImmortalWrt Builder
GitHub Actions project for building an ImmortalWrt ARMv8 root filesystem and packaging it for the Rockchip RK3566 JP-TVbox.
## Build target
- Board: JP-TVbox (RK3566)
- Source: ImmortalWrt v25.12.2 by default
- Kernel: Flippy mainline 6.18.y, automatically selecting the newest published patch release
- Required LuCI packages: Crystal Box (luci-app-amlogic) and Nikki (luci-app-nikki)
- DNS filtering: AdGuardHome (adguardhome) with its LuCI management page (luci-app-adguardhome)
- Theme: Argon (luci-theme-argon)
- Default LAN address: 192.168.50.2
The root filesystem uses the armsr/armv8 Generic EFI target required by the TV-box packaging workflow. The project uses the unifreq/openwrt_packit packaging action and the JP-TVbox custom pack script.
## AdGuardHome
The firmware build selects both adguardhome and luci-app-adguardhome from the ImmortalWrt 25.12 package and LuCI feeds. The package recipe builds the AdGuardHome source and frontend during the firmware build; it is not installed later from the router's runtime package manager. The LuCI package depends on the adguardhome service. After first boot, open the AdGuardHome page in LuCI and complete its initial setup, including the web interface and DNS listening ports. Check that its DNS port does not conflict with dnsmasq before enabling it as the LAN DNS service.
## Start a build
1. Open Actions → Build JP-TVbox ImmortalWrt → Run workflow.
2. The source branch defaults to v25.12.2; you can select another ImmortalWrt branch when running the workflow.
3. When the run completes, download the firmware image and checksum files from the generated Release.
The build is manual-only. It does not write firmware to a device or initiate a router reboot.
## Kernel updater compatibility fix
The build script patches the Crystal Box kernel updater to use tar -xzf for its .tar.gz kernel archive. This avoids relying on BusyBox tar's optional compression auto-detection and preserves the normal SHA256 verification and update flow.
## Configuration
- JP-TVbox/.config: generic ARMv8 root filesystem target and selected packages, including AdGuardHome and its LuCI page.
- JP-TVbox/diy.sh: adds the Crystal Box, Nikki, and Argon source packages and applies the gzip extraction fix. AdGuardHome is sourced from the ImmortalWrt 25.12 feeds installed by the workflow.
- JP-TVbox/mk_rk3566_jp-tvbox.sh: JP-TVbox image customization used by the packer.
- .github/workflows/build.yml: builds ImmortalWrt, packages the root filesystem, and publishes the image.
## Upstream references
- [ophub OpenWrt build guide](https://github.com/ophub/amlogic-s9xxx-openwrt/blob/main/documents/README.cn.md)
- [ophub/amlogic-s9xxx-openwrt](https://github.com/ophub/amlogic-s9xxx-openwrt)
- [unifreq/openwrt_packit](https://github.com/unifreq/openwrt_packit)
- [OpenWrt-nikki](https://github.com/nikkinikki-org/OpenWrt-nikki)
- [ImmortalWrt 25.12 packages: AdGuardHome](https://github.com/immortalwrt/packages/tree/openwrt-25.12/net/adguardhome)
- [ImmortalWrt 25.12 LuCI: AdGuardHome](https://github.com/immortalwrt/luci/tree/openwrt-25.12/applications/luci-app-adguardhome)
- [luci-theme-argon](https://github.com/jerrykuku/luci-theme-argon)
