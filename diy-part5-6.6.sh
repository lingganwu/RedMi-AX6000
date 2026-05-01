#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part5-6.6.sh
# Description: OpenWrt DIY script part 5 (After Update feeds)
#
# Copyright (c) 2019-2024 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#

# ==================== 基础优化 ====================

# 修改默认 IP（取消注释即可使用）
sed -i 's/192.168.1.1/192.168.8.1/g' package/base-files/files/bin/config_generate

# 修改主机名（取消注释即可使用）
sed -i 's/OpenWrt/Redmi-AX6000-6.6/g' package/base-files/files/bin/config_generate

# 修改默认主题为 Argon（取消注释即可使用）
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile

# ==================== Lucky 和 HomeProxy 确认 ====================

if [ -d "package/luci-app-lucky" ]; then
    echo "Lucky 插件已加载"
else
    echo "警告：Lucky 插件未找到"
fi

if [ -d "package/homeproxy" ]; then
    echo "HomeProxy 插件已加载"
else
    echo "警告：HomeProxy 插件未找到"
fi

echo "diy-part5-6.6.sh 执行完成！"
