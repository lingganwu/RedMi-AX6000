# patches/

## 001-firewall4-add-support-for-fullcone-nat.patch

FullCone NAT 补丁兜底文件。

- 平时用不上：rebase 自带的 firewall4 是 2025-03-17 旧版，树里自带的同名补丁本来就能打上。
- 只是兜底：`diy-part2-closed.sh` 里只有 `PKG_SOURCE_DATE` 变成 `2026-11-08` 时才会用这个文件替换树里的旧补丁；万一上游 rebase 哪天升级了 firewall4，没有这个文件替换步骤会直接报错、构建失败。
- 来源：以 master 的同名补丁为底，第一块按新版 firewall4 重做（同主题分支的修复手法），但把 flow_offloading / flow_offloading_hw 强制写成 0——闭源版靠 hnat/warp 硬件 NAT，不开软件流卸载。本地验证（2026-11-14）：在 firewall4 `3722eadc`（2026-11-08）上 `patch -p1` 全部通过。
