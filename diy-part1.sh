#!/bin/bash
# diy-part1.sh: OpenWrt DIY script part 1 (Before Update feeds)

# 仅添加 Lucky 源码（HomeProxy官方源自带，切勿在此重复添加）
git clone https://github.com/gdy666/luci-app-lucky.git package/luci-app-lucky

# 给权限
chmod -R 755 ./package/luci-app-lucky/*

echo "diy-part1.sh 执行完成：已添加 Lucky。"
