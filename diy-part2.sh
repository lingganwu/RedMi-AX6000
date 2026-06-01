#!/bin/bash
# diy-part2.sh: OpenWrt DIY script part 2 (After Update feeds)

# 修改默认 IP、主机名、主题
sed -i 's/192.168.1.1/192.168.8.1/g' package/base-files/files/bin/config_generate
sed -i 's/OpenWrt/Redmi-AX6000/g' package/base-files/files/bin/config_generate
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile

# ==================== 注入你的私人定制配置 ====================
mkdir -p package/base-files/files/etc/uci-defaults

cat << "EOF" > package/base-files/files/etc/uci-defaults/99-custom-settings
#!/bin/sh

# 1. 设置后台登录密码 (851129)
echo -e "851129\n851129" | passwd root

# 2. 设置 WAN 口为 PPPoE 拨号
uci set network.wan.proto='pppoe'
uci set network.wan.username='637143646974'
uci set network.wan.password='888888'
uci commit network

# 3. 设置 WiFi 名称、密码并开启 (2.4G / 5G 分离)
uci set wireless.radio0.disabled='0'
uci set wireless.radio1.disabled='0'

# 2.4G 配置
uci set wireless.default_radio0.ssid='OpenWrt_2.4G'
uci set wireless.default_radio0.encryption='psk2+ccmp'
uci set wireless.default_radio0.key='19851129z'

# 5G 配置
uci set wireless.default_radio1.ssid='OpenWrt_5G'
uci set wireless.default_radio1.encryption='psk2+ccmp'
uci set wireless.default_radio1.key='19851129z'

uci commit wireless

# 4. 强制设置中文界面 + 上海时区
uci set luci.main.lang='zh_cn'
uci set system.@system[0].timezone='CST-8'
uci set system.@system[0].zonename='Asia/Shanghai'
uci commit luci
uci commit system

# 5. 放行 Tailscale 通信端口 (41641)
uci add firewall rule
uci set firewall.@rule[-1].name='Allow-Tailscale-Port'
uci set firewall.@rule[-1].src='*'
uci set firewall.@rule[-1].dest_port='41641'
uci set firewall.@rule[-1].proto='udp'
uci set firewall.@rule[-1].target='ACCEPT'
uci commit firewall

# 6. 【新增】自动配置 Tailscale 社区版软件源与公钥 (针对 ImmortalWrt 24.10)
# 这样固件刷完后，opkg 源里就自带社区仓库，方便以后在线更新
wget -qO /tmp/key-build.pub https://Tokisaki-Galaxy.github.io/luci-app-tailscale-community/all/key-build.pub
[ -s /tmp/key-build.pub ] && opkg-key add /tmp/key-build.pub
if ! grep -q "tailscale_community" /etc/opkg/customfeeds.conf; then
    echo "src/gz tailscale_community https://Tokisaki-Galaxy.github.io/luci-app-tailscale-community/all" >> /etc/opkg/customfeeds.conf
fi

# 7. 重新加载服务使配置生效
/etc/init.d/network restart
wifi reload

echo "99-custom-settings 执行完成：拨号、WiFi分离、中文界面、Tailscale社区源已就绪"
exit 0
EOF

# 给生成的脚本赋予执行权限
chmod +x package/base-files/files/etc/uci-defaults/99-custom-settings

echo "diy-part2.sh 执行完成：已成功注入最终定制逻辑！"
