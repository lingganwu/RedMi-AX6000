# RedMi-AX6000

![GitHub Actions Workflow Status](https://github.com/lingganwu/RedMi-AX6000/actions/workflows/immortalwrt-24.10-builder.yml/badge.svg)
![GitHub Actions Workflow Status](https://github.com/lingganwu/RedMi-AX6000/actions/workflows/immortalwrt-25.12-builder.yml/badge.svg)
![GitHub Actions Workflow Status](https://github.com/lingganwu/RedMi-AX6000/actions/workflows/immortalwrt-25.12-closed-builder.yml/badge.svg)
![GitHub Actions Workflow Status](https://github.com/lingganwu/RedMi-AX6000/actions/workflows/immortalwrt-25.12-closed-110m-builder.yml/badge.svg)

> 红米 AX6000 专属定制 ImmortalWrt 固件，开箱即用。基于 ImmortalWrt 源码深度定制，内置 HomeProxy、Lucky、Tailscale 等常用功能，刷入即可使用。

## 📖 简介

本项目是为小米 Redmi AX6000（MT7986A）路由器定制的 ImmortalWrt 固件，由 GitHub Actions 全自动编译构建，支持 24.10、25.12 两个开源版本，以及两个 MTK 闭源驱动版（25.12-closed 原厂分区版、25.12-closed-110m 大分区版）。开源版与闭源原厂分区版适配 `xiaomi_redmi-router-ax6000-stock` 机型；110m 大分区版适配 `xiaomi_redmi-router-ax6000-110m` 机型。

| 构建 | 上游源码 | 内核 | 主题 | 更新方式 |
| --- | --- | --- | --- | --- |
| 24.10 | ImmortalWrt 24.10 | 6.6 | Vantage | 每 18 小时自动检查更新 |
| 25.12 | ImmortalWrt 25.12 | 6.18 | Vantage | 每 18 小时自动检查更新 |
| 25.12-closed | chasey-dev rebase 25.12 | 6.12 | Vantage | 手动触发（不自动更新） |
| 25.12-closed-110m | chasey-dev rebase 25.12 | 6.12 | Vantage | 手动触发（不自动更新） |

## ✨ 核心特性

- **科学上网**：集成 HomeProxy（mihomo 内核），支持订阅转换与规则分流，开箱即用。
- **FullCone NAT**：支持 FullCone NAT，游戏与 P2P 体验更顺畅。
- **穿透与组网**：内置 Lucky 反向代理与 Tailscale 零信任异地组网。
- **定制外观**：默认采用 `Vantage` 主题（`Bootstrap` 兜底），后台支持原生中文。
- **深度精简**：剔除了 Docker、虚拟机、NAS 存储类应用（Samba、qbittorrent）以及冗余的 VPN 和代理工具。
- **定时检查更新**：内置 Update Checker 定时任务，每 18 小时自动比对官方源码，检测到更新后自动触发流水线编译（闭源驱动版除外，需手动触发）。
- **闭源驱动版（25.12-closed）**：基于 [chasey-dev/immortalwrt-mt798x-rebase](https://github.com/chasey-dev/immortalwrt-mt798x-rebase)（ImmortalWrt 25.12，内核 6.12），用 MTK 官方 `mtwifi` 闭源驱动 + `hnat`/`warp` 硬件加速，集成 Turbo ACC（MTK）；插件（HomeProxy / Lucky / Tailscale）与主题（Vantage）与开源版一致。WiFi 不走标准 `uci wireless`，刷完后在 LuCI → MTK WiFi 里配置。构建代码在独立分支 `closed-driver-25.12`（配置 `ax6000-closed.config`、脚本 `diy-part2-closed.sh`），与开源版完全分开，互不干扰。
- **闭源驱动 110m 大分区版（25.12-closed-110m）**：与 25.12-closed 完全相同，唯一差别是分区布局：单个 110MB ubi 分区（原厂分区版是内核 30MB + 系统 80MB 分开），系统可用空间多约 30MB，对应 [hanwckf 不死 uboot](https://github.com/hanwckf/bl-mt798x) 的 `immortalwrt-110m` 布局。刷之前须先在 hanwckf uboot web 界面里把布局切到 110m，再在 uboot 里刷入编出的 `*-110m-squashfs-sysupgrade.bin`，不能在跑着的原厂分区系统里刷；布局不同不能互刷。

## 📦 获取固件

### 方式一：从 Releases 下载（推荐）

1. 进入本仓库的 [Releases](https://github.com/lingganwu/RedMi-AX6000/releases) 页面。
2. 选择最新发布的版本（标题带 `-closed-110m` 的是闭源 110m 大分区版，带 `-closed` 的是闭源原厂分区版，不带的是开源版）。
3. 下载 `*-stock-squashfs-sysupgrade.bin`（110m 大分区版下载 `*-110m-squashfs-sysupgrade.bin`）文件（不要下 factory / initramfs 版本）。
4. 已在 ImmortalWrt 上时，直接在 LuCI → 系统 → 备份/升级里刷入；从原厂或其他固件刷入时，先用 `*-stock-squashfs-factory.bin`。110m 大分区版例外：必须先在 hanwckf uboot web 界面里把布局切到 110m，再在 uboot 里刷入，不能在跑着的原厂分区系统里刷。

### 方式二：从 Actions 下载编译产物

1. 进入本仓库的 [Actions](https://github.com/lingganwu/RedMi-AX6000/actions) 页面。
2. 选择需要的构建（`immortalwrt-24.10-builder`、`immortalwrt-25.12-builder`、闭源驱动版 `immortalwrt-25.12-closed-builder` 或 110m 大分区版 `immortalwrt-25.12-closed-110m-builder`），点进最新一次成功的运行。
3. 在页面底部 Artifacts 区域下载 `OpenWrt_firmware` 压缩包，解压后同样用其中的 `*-stock-squashfs-sysupgrade.bin`（110m 版是 `*-110m-squashfs-sysupgrade.bin`）刷机。

### 刷入不死 uboot（还没有不死 uboot 时）

本仓库的闭源版与 110m 版建议在 hanwckf 不死 uboot 下刷机。还没有刷过不死 uboot 的，按以下步骤操作（参考恩山教程帖）：

1. 先用救砖工具回到官方系统，再进 telnet 解锁 SSH。
2. SSH 里运行 `cat /proc/mtd`，确认 FIP 所在的分区号（官方固件一般在分区 5，有的第三方固件在分区 4），一定要看好自己的。
3. 从 [hanwckf/bl-mt798x Releases](https://github.com/hanwckf/bl-mt798x/releases) 下载不死 uboot 的 `.bin`，用 WinSCP 传到路由器的 `/tmp` 目录。
4. 替换前建议先备份官方引导 FIP 分区：`dd if=/dev/mtd5 of=/tmp/FIP.bin`（分区号按第 2 步的实际结果改）。
5. SSH 里写入 uboot：`mtd write /tmp/xxuboot.bin /dev/mtd5`（文件名与分区号按实际修改）。
6. 写入后 SSH 无报错提示，等 5 秒直接拔电；电脑网卡 IPv4 固定为 `192.168.31.X`（X 为 2–254 任意数字）。
7. 断电状态下顶住 reset 孔再插电，约 15 秒后松手（第一版不死 BOOT 无 LED 灯提示）。
8. 用非 IE 的浏览器打开 `192.168.31.1`，即可进入 uboot 的 WebUI 界面，在里面选分区布局并刷入固件（具体刷机方法见上文）。

> ⚠️ 闭源驱动版首次开机 WiFi 名为 `ImmortalWrt-2.4G` / `ImmortalWrt-5G`，无密码，请刷完后尽快在 LuCI → MTK WiFi 里改名并设置密码；换版本刷机时建议不要勾选“保留配置”，干净刷入。

### 🔐 默认登录信息

刷机完成后，在浏览器打开 `http://192.168.8.1`，用户名 `root`，密码 `password`，即可进入后台。首次登录后请尽快修改密码。

> 注意：新密码自本次修改之后的新构建起生效；此前发布的版本仍为旧密码，刷入后请自行修改。

## 🛠️ 自定义配置

本项目支持一定程度的自定义，Fork 后可根据需要修改。

### 修改默认配置

请编辑仓库根目录下的 `diy-part2.sh` 文件（闭源驱动版改 `diy-part2-closed.sh`，110m 大分区版改 `diy-part2-closed-110m.sh`）。该文件中包含一段自动注入的 `99-custom-settings` 脚本，你可以在这里修改 `config_generate` 设定的后台默认 IP、WiFi 名称等默认配置。编译出的固件在首次刷入开机时会自动应用这些配置。注意：闭源驱动版不走标准 `uci wireless`，WiFi 请刷完后在 LuCI 的 MTK WiFi 界面里改。

### 添加或删除软件包

请编辑仓库根目录下的 `ax6000.config` 文件（闭源驱动版改 `ax6000-closed.config`，110m 大分区版改 `ax6000-closed-110m.config`）。这里包含了所有的编译参数，你可以通过取消注释（去掉 `#`）来恢复被屏蔽的组件，或者直接添加你需要的 `CONFIG_PACKAGE_` 规则。

## 🚀 手动触发编译

如果你想立即编译最新版本，而不想等待自动触发，可以手动启动编译流程：

1. 进入本仓库的 [Actions](https://github.com/lingganwu/RedMi-AX6000/actions) 页面。
2. 在左侧菜单中选择需要的编译分支，例如 `immortalwrt-24.10-builder`、`immortalwrt-25.12-builder`、闭源驱动版 `immortalwrt-25.12-closed-builder` 或 110m 大分区版 `immortalwrt-25.12-closed-110m-builder`。
3. 点击右上角的 `Run workflow` 按钮（闭源驱动版与 110m 版需在 Branch 里选 `closed-driver-25.12`）。
4. 等待约 1.5 - 2.5 小时左右，编译完成后即可在构建记录中下载。

## 🙏 鸣谢

- [ImmortalWrt](https://github.com/immortalwrt/immortalwrt) - 提供优秀的路由器固件源码
- [P3TERX](https://github.com/P3TERX/Actions-OpenWrt) - 提供 Actions 云编译模板
- [chasey-dev/immortalwrt-mt798x-rebase](https://github.com/chasey-dev/immortalwrt-mt798x-rebase) - 闭源驱动版的上游源码（MTK mtwifi 驱动）
- [hanwckf/immortalwrt-mt798x](https://github.com/hanwckf/immortalwrt-mt798x) - 闭源驱动版的上游源码之一
- [hanwckf/bl-mt798x](https://github.com/hanwckf/bl-mt798x) - 不死 uboot，支持多分区布局
- [luci-theme-vantage](https://github.com/anothaDev/luci-theme-vantage) - 默认主题 Vantage

## 📄 开源协议

本项目基于 [MIT License](LICENSE) 开源。
