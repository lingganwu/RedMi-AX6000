# RedMi-AX6000

![GitHub Actions Workflow Status](https://github.com/lingganwu/RedMi-AX6000/actions/workflows/immortalwrt-24.10-builder.yml/badge.svg)
![GitHub Actions Workflow Status](https://github.com/lingganwu/RedMi-AX6000/actions/workflows/immortalwrt-25.12-builder.yml/badge.svg)
![GitHub Actions Workflow Status](https://github.com/lingganwu/RedMi-AX6000/actions/workflows/immortalwrt-25.12-closed-builder.yml/badge.svg)

> 红米 AX6000 专属定制 ImmortalWrt 固件，开箱即用。基于 ImmortalWrt 源码深度定制，内置科学上网、广告过滤、网络加速等常用功能，刷入即可使用。

## 📖 简介

本项目是为小米 Redmi AX6000（MT7986A）路由器定制的 ImmortalWrt 固件，由 GitHub Actions 全自动编译构建，支持 24.10、25.12 两个开源版本，以及一个 MTK 闭源驱动版（25.12-closed）。所有版本均只适配 `xiaomi_redmi-router-ax6000-stock` 一个机型。

| 构建 | 上游源码 | 内核 | 主题 | 更新方式 |
| --- | --- | --- | --- | --- |
| 24.10 | ImmortalWrt 24.10 | 6.6 | Vantage | 每 18 小时自动检查更新 |
| 25.12 | ImmortalWrt 25.12 | 6.18 | Vantage | 每 18 小时自动检查更新 |
| 25.12-closed | chasey-dev rebase 25.12 | 6.12 | Vantage | 手动触发（不自动更新） |

## ✨ 核心特性

- **科学上网**：集成 HomeProxy（mihomo 内核），支持订阅转换与规则分流，开箱即用。
- **广告过滤**：内置 AdGuardHome，支持自定义规则（已加入编译配置，自下个构建起内置）。
- **FullCone NAT**：支持 FullCone NAT，游戏与 P2P 体验更顺畅。
- **穿透与组网**：内置 Lucky 反向代理与 Tailscale 零信任异地组网。
- **定制外观**：默认采用 `Vantage` 主题（`Bootstrap` 兜底），后台支持原生中文。
- **深度精简**：剔除了 Docker、虚拟机、NAS 存储类应用（Samba、qbittorrent）以及冗余的 VPN 和代理工具。
- **定时检查更新**：内置 Update Checker 定时任务，每 18 小时自动比对官方源码，检测到更新后自动触发流水线编译（闭源驱动版除外，需手动触发）。
- **闭源驱动版（25.12-closed）**：基于 [chasey-dev/immortalwrt-mt798x-rebase](https://github.com/chasey-dev/immortalwrt-mt798x-rebase)（ImmortalWrt 25.12，内核 6.12），用 MTK 官方 `mtwifi` 闭源驱动 + `hnat`/`warp` 硬件加速，集成 Turbo ACC（MTK）；插件（HomeProxy / Lucky / Tailscale）与主题（Vantage）与开源版一致。WiFi 不走标准 `uci wireless`，刷完后在 LuCI → MTK WiFi 里配置。构建代码在独立分支 `closed-driver-25.12`（配置 `ax6000-closed.config`、脚本 `diy-part2-closed.sh`），与开源版完全分开，互不干扰。

## 📦 获取固件

### 方式一：从 Releases 下载（推荐）

1. 进入本仓库的 [Releases](https://github.com/lingganwu/RedMi-AX6000/releases) 页面。
2. 选择最新发布的版本（标题带 `-closed` 的是闭源驱动版，不带的是开源版）。
3. 下载 `*-stock-squashfs-sysupgrade.bin` 文件（不要下 factory / initramfs 版本）。
4. 已在 ImmortalWrt 上时，直接在 LuCI → 系统 → 备份/升级里刷入；从原厂或其他固件刷入时，先用 `*-stock-squashfs-factory.bin`。

### 方式二：从 Actions 下载编译产物

1. 进入本仓库的 [Actions](https://github.com/lingganwu/RedMi-AX6000/actions) 页面。
2. 选择需要的构建（`immortalwrt-24.10-builder`、`immortalwrt-25.12-builder` 或闭源驱动版 `immortalwrt-25.12-closed-builder`），点进最新一次成功的运行。
3. 在页面底部 Artifacts 区域下载 `OpenWrt_firmware` 压缩包，解压后同样用其中的 `*-stock-squashfs-sysupgrade.bin` 刷机。

> ⚠️ 闭源驱动版首次开机 WiFi 名为 `ImmortalWrt-2.4G` / `ImmortalWrt-5G`，无密码，请刷完后尽快在 LuCI → MTK WiFi 里改名并设置密码；换版本刷机时建议不要勾选“保留配置”，干净刷入。

## 🛠️ 自定义配置

本项目支持一定程度的自定义，Fork 后可根据需要修改。

### 修改默认配置

请编辑仓库根目录下的 `diy-part2.sh` 文件（闭源驱动版改 `diy-part2-closed.sh`）。该文件中包含一段自动注入的 `99-custom-settings` 脚本，你可以在这里修改 `config_generate` 设定的后台默认 IP、WiFi 名称等默认配置。编译出的固件在首次刷入开机时会自动应用这些配置。注意：闭源驱动版不走标准 `uci wireless`，WiFi 请刷完后在 LuCI 的 MTK WiFi 界面里改。

### 添加或删除软件包

请编辑仓库根目录下的 `ax6000.config` 文件（闭源驱动版改 `ax6000-closed.config`）。这里包含了所有的编译参数，你可以通过取消注释（去掉 `#`）来恢复被屏蔽的组件，或者直接添加你需要的 `CONFIG_PACKAGE_` 规则。

## 🚀 手动触发编译

如果你想立即编译最新版本，而不想等待自动触发，可以手动启动编译流程：

1. 进入本仓库的 [Actions](https://github.com/lingganwu/RedMi-AX6000/actions) 页面。
2. 在左侧菜单中选择需要的编译分支，例如 `immortalwrt-24.10-builder`、`immortalwrt-25.12-builder` 或闭源驱动版 `immortalwrt-25.12-closed-builder`。
3. 点击右上角的 `Run workflow` 按钮（闭源驱动版需在 Branch 里选 `closed-driver-25.12`）。
4. 等待约 1.5 - 2.5 小时左右，编译完成后即可在构建记录中下载。

## 🙏 鸣谢

- [ImmortalWrt](https://github.com/immortalwrt/immortalwrt) - 提供优秀的路由器固件源码
- [P3TERX](https://github.com/P3TERX/Actions-OpenWrt) - 提供 Actions 云编译模板
- [chasey-dev/immortalwrt-mt798x-rebase](https://github.com/chasey-dev/immortalwrt-mt798x-rebase) - 闭源驱动版的上游源码（MTK mtwifi 驱动）
- [luci-theme-vantage](https://github.com/anothaDev/luci-theme-vantage) - 默认主题 Vantage

## 📄 开源协议

本项目基于 [MIT License](LICENSE) 开源。
