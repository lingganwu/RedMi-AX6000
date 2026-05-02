#!/bin/bash
# diy-part2.sh: OpenWrt DIY script part 2 (After Update feeds)

# 修改默认 IP 为 192.168.8.1
sed -i 's/192.168.1.1/192.168.8.1/g' package/base-files/files/bin/config_generate

# 修改主机名为 Redmi-AX6000
sed -i 's/OpenWrt/Redmi-AX6000/g' package/base-files/files/bin/config_generate

# 修改默认主题为 Argon
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile

echo "diy-part2.sh 执行完成！"
