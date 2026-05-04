#!/bin/bash
# diy-part2.sh: OpenWrt DIY script part 2 (After Update feeds)

# 修改默认 IP 为 192.168.8.1
sed -i 's/192.168.1.1/192.168.8.1/g' package/base-files/files/bin/config_generate

# 修改主机名为 Redmi-AX6000
sed -i 's/OpenWrt/Redmi-AX6000/g' package/base-files/files/bin/config_generate

# 修改默认主题为 Argon
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile

# ==================== 注入你的私人定制配置 ====================
# 原理：我们通过创建 99-custom-settings 脚本，让路由器在刷机后第一次开机时自动执行这些配置。
mkdir -p package/base-files/files/etc/uci-defaults
cat << "EOF" > package/base-files/files/etc/uci-defaults/99-custom-settings
#!/bin/sh

# 1. 设置后台登录密码 (851129)
echo -e "851129\n851129" | passwd root

# 2. 设置 WAN 口为 PPPoE 拨号并填入账号密码
uci set network.wan.proto='pppoe'
uci set network.wan.username='637143646974'
uci set network.wan.password='888888'
uci commit network

# 3. 设置 WiFi 名称、密码并默认开启 (OpenWrt默认是关闭WiFi的)
# 遍历寻找所有的无线网络接口
for iface in $(uci show wireless | grep '=wifi-iface' | cut -d'.' -f2 | cut -d'=' -f1); do
    device=$(uci get wireless.$iface.device)
    band=$(uci get wireless.$device.band)
    
    # 智能判断频段：如果是 2.4G 频段，则命名为 2.4G，否则命名为 5G
    if echo "$band" | grep -qiE "2g|2.4g|b|g"; then
        uci set wireless.$iface.ssid='OpenWrt_2.4G'
    else
        uci set wireless.$iface.ssid='OpenWrt_5G'
    fi
    
    # 设置加密方式和 WiFi 密码
    uci set wireless.$iface.encryption='psk2+ccmp'
    uci set wireless.$iface.key='19851129z'
    
    # 启用对应的物理无线网卡
    uci set wireless.$device.disabled='0'
done
uci commit wireless

# 4. 放行 Tailscale 通信端口 (41641)
uci add firewall rule
uci set firewall.@rule[-1].name='Allow-Tailscale-Port'
uci set firewall.@rule[-1].src='*'
uci set firewall.@rule[-1].dest_port='41641'
uci set firewall.@rule[-1].proto='udp'
uci set firewall.@rule[-1].target='ACCEPT'
uci commit firewall

# 5. 重新加载网络和无线使配置立即生效
/etc/init.d/network restart
wifi reload

# 退出代码必须为 0，这样系统执行完后会自动删除此脚本，以后重启不再重复执行
exit 0
EOF

# 给生成的脚本赋予可执行权限
chmod +x package/base-files/files/etc/uci-defaults/99-custom-settings

echo "diy-part2.sh 执行完成：已成功注入后台密码、宽带拨号、WiFi 定制以及 Tailscale 防火墙规则！"
