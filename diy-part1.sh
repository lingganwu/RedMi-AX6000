#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#
# Copyright (c) 2019-2024 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#

# ==================== 添加 Lucky 和 HomeProxy ====================

# Lucky（网络工具/测速等）
git clone https://github.com/gdy666/luci-app-lucky.git package/luci-app-lucky
# HomeProxy（Sing-box 内核代理，支持 Hysteria2 等）
git clone https://github.com/immortalwrt/homeproxy.git package/homeproxy

# 给权限
chmod -R 755 ./package/luci-app-lucky/*
chmod -R 755 ./package/homeproxy/*

# ==================== 移除不需要的 ====================

# （已移除 helloworld、passwall、ADGuardHome）

echo "diy-part1.sh 执行完成：已添加 Lucky + HomeProxy，并移除 helloworld/passwall/ADGuardHome"
