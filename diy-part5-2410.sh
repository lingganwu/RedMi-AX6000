#!/bin/bash
#
# DIY Part 5 for 2410 branch - After feeds install
#

# 修改默认 IP（可选）
# sed -i 's/192.168.1.1/192.168.8.1/g' package/base-files/files/bin/config_generate

# 修改主机名（可选）
# sed -i 's/OpenWrt/AX6000-2410/g' package/base-files/files/bin/config_generate

# 确保 Lucky 和 HomeProxy 被正确安装
if [ -d "package/luci-app-lucky" ]; then
    echo "Lucky 已添加"
fi
if [ -d "package/homeproxy" ]; then
    echo "HomeProxy 已添加"
fi

echo "diy-part5-2410.sh 执行完成"
