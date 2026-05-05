# Redmi AX6000 定制版 ImmortalWrt 固件

欢迎来到本仓库，这是专为 Redmi AX6000 打造的 ImmortalWrt 自动化编译项目。本项目通过 GitHub Actions 云端编译，为路由器提供轻量、稳定且功能聚焦的专属固件。

## ✨ 核心特性

- **双分支自动构建**：支持自动追踪 ImmortalWrt `24.10` 稳定分支与 `25.12` (master) 最新分支。
- **定时检查更新**：内置 Update Checker 定时任务，每 18 小时自动比对官方源码，检测到更新后自动触发流水线编译。
- **深度精简**：严格控制编译体积，剔除了多余的 Docker、虚拟机、NAS 存储类应用（Samba、qbittorrent）以及冗余的 VPN 和代理工具，把硬件性能全部留给网络转发与核心服务。
- **核心插件矩阵**：
  - **网络代理**：自带 `HomeProxy`（全面替代 OpenClash/PassWall 等重度依赖）。
  - **网络穿透/反向代理**：自动拉取并集成 `Lucky`。
  - **零信任异地组网**：内置 `Tailscale` 服务端组件。
- **定制外观**：默认采用简洁美观的 `Argon` 主题，后台支持原生中文。

## 🔧 个性化定制说明

如果你 Fork 了本项目并希望生成符合自己网络环境的专属固件，无需每次刷机后手动配置，可以直接在代码库中修改以下文件：

- **修改默认 IP、密码、WiFi及宽带账号**：
  请编辑仓库根目录下的 `diy-part2.sh` 文件。该文件中包含了一段自动注入的 `99-custom-settings` 脚本，你可以在这里修改 `config_generate` 设定的后台默认 IP，或者替换 `uci set` 命令中的默认后台密码、PPPoE 拨号账号/密码以及 WiFi 的 SSID 和加密密钥。编译出的固件在首次刷入开机时会自动应用这些配置。

- **增删内置插件与核心组件**：
  请编辑仓库根目录下的 `ax6000.config` 文件。这里包含了所有的编译参数，你可以通过取消注释（去掉 `#`）来恢复被屏蔽的组件，或者直接添加你需要的 `CONFIG_PACKAGE_` 规则。

- **添加第三方源码与主题**：
  如需在编译前拉取第三方插件源码，请编辑 `diy-part1.sh` 文件并在其中添加 `git clone` 命令（例如本项目中自动拉取 Lucky 源码的操作）。

## 🚀 获取固件

1. 点击本仓库顶部的 **Actions** 标签页。
2. 在左侧菜单中选择需要的编译分支，例如 `immortalwrt-24.10-builder` 或 `immortalwrt-25.12-builder`。
3. 点击最近一次带有绿色对勾 `✅` 的运行记录。
4. 在页面最下方的 **Artifacts** 区域，下载名称类似 `OpenWrt_firmware_xiaomi_redmi-router-ax6000` 的压缩包，解压后即可得到刷机文件。
5. 带有正式标签的固件也可直接在 **Releases** 页面下载。

## 🛠️ 手动触发编译

如果你希望立刻进行一次全新编译，可以按以下步骤操作：

1. 进入 **Actions** 页面。
2. 在左侧选择要编译的 Workflow，如 `immortalwrt-24.10-builder`。
3. 点击右上角的 `Run workflow` 按钮。
4. 等待约 1.5 - 2 小时左右，编译完成后即可在构建记录中下载。

## 📜 鸣谢与声明

本项目基于以下优秀的开源项目构建与定制：
- [ImmortalWrt](https://github.com/immortalwrt/immortalwrt) - 高性能的 OpenWrt 分支
- [P3TERX/Actions-OpenWrt](https://github.com/P3TERX/Actions-OpenWrt) - GitHub Actions 编译模板
- [Lucky](https://github.com/gdy666/luci-app-lucky) - 强大的网络工具

**License**
[MIT](LICENSE) © 灵感屋
