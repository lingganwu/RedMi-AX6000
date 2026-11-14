# patches/

## 001-firewall4-add-support-for-fullcone-nat.patch

FullCone NAT 补丁，按上游 firewall4 新版重做过的版本。

- 来源：ImmortalWrt 自带的同名补丁（`package/network/config/firewall4/patches/001-firewall4-add-support-for-fullcone-nat.patch`），只改了第一块，其余内容与上游 master 版一字不差。
- 为什么要重做：25.12（master）用的 firewall4 已升级到 2026-11-08（`3722eadc`），上游删掉了 `root/etc/config/firewall` 里的 `# option disable_ipv6 1` 那几行，旧补丁第一块打不上，编译在 `firewall4/.prepared` 阶段失败（25.12 #94，`Patch failed!`，`make Error 2`）。新补丁把 4 个选项（`flow_offloading`、`flow_offloading_hw`、`fullcone`、`fullcone6`）改成插在 `option forward REJECT` 后面，其余不变。
- 只对新版生效：`diy-part2.sh` 里先查 `package/network/config/firewall4/Makefile` 的 `PKG_SOURCE_DATE`，只有 `2026-11-08` 才用这个文件替换树里的旧补丁；24.10（firewall4 2024-12-18）保持上游原补丁不动，因为新补丁的第一块在旧版上反而打不上。

本地验证（2026-11-14）：原补丁在 firewall4 `3722eadc` 上 `Hunk #1 FAILED`；新补丁 `patch -p1` 全部通过，`root/etc/config/firewall` 正确多出上述 4 个选项，`fw4.uc`/`ruleset.uc`/`zone-fullcone.uc` 均正常。
