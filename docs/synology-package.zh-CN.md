[English](synology-package.md) | [Español](synology-package.es.md) | [Français](synology-package.fr.md) | [Nederlands](synology-package.nl.md) | [Português](synology-package.pt.md) | [Русский](synology-package.ru.md) | [简体中文](synology-package.zh-CN.md) | [日本語](synology-package.ja.md) | [한국어](synology-package.ko.md) | [Bahasa Indonesia](synology-package.id.md) | [Bahasa Melayu](synology-package.ms.md)

# 原生 Synology 套件

## 当前状态

`0.1.0-0018` x86-64 套件是 DSM 7 发行版，提供非 root、易用的访问流程：不会把共享文件夹名称、NAS 地址或书库路径写入套件；书籍仍在现有 DSM 共享文件夹；BiblioFuse 无法自行授权或修改 DSM 权限；设置会说明如何向受限套件帐户授予只读权限；附加和移除只控制索引，绝不删除书库文件。该套件不是容器；Package Center 管理生命周期、主菜单图标和受限的系统内部帐户。

## 浏览器语言

在设置中选择 **Language**，可跟随系统语言，或选英语、西班牙语、法语、荷兰语、葡萄牙语、俄语、简体中文、日语、韩语、印尼语或马来语。选择只存于该浏览器，并会在套件升级后保留。

## 安装并授予访问权

1. 通过 Package Center → Manual Install 安装 x86-64 `.spk`。
2. 打开 BiblioFuse NAS，使用至少 12 个字符创建管理员。
3. 打开设置 → **Show the 6 steps**，或按以下步骤：
   1. 打开 DSM **Control Panel** → **Shared Folder**。
   2. 选择含书籍的现有共享文件夹并选择 **Edit**。
   3. 打开 **Permissions**。
   4. 将下拉菜单改为 **System internal user**。
   5. 找到 `BiblioFuseNAS`，授予 **Read only** 并保存。
   6. 回到 BiblioFuse → **Attach library** → **Refresh access**，选择共享或书籍子文件夹。
4. 选择 **Refresh books**。

无需输入 `/volume1/...` 或 `/var/packages/...` 路径；授权后也无需重启套件。

## 数据生命周期

- **Disable：** 保留目录，之后可再次启用。
- **Detach：** 清除该附加项的 BiblioFuse 目录、元数据和阅读进度。
- **Upgrade package：** 保留帐户、证书身份、设置、目录和缓存。
- **Uninstall package：** 清除所有 BiblioFuse 自有的帐户、密码、身份、设置、目录、日志和缓存数据。
- **Library：** 始终在 BiblioFuse 套件数据之外，绝不会删除。

从私有 v8 测试套件升级会迁移其套件共享别名到标准 DSM volume 路径，同时保留根身份。

## 网络与当前支持边界

- `7343/tcp`：可信 LAN 上免费的浏览器书库和阅读器。
- `7342/tcp`：固定 HTTPS 原生客户端监听器。
- `7341/tcp`：保留，永不使用。

启动时，套件从 DSM 推导活动私有 LAN 地址，并直接从 NAS 主机广播 Bonjour。若 DSM Tailscale 已启用，`tailscale0` 地址会作为可选手动连接提示。大型原生 JSON 响应含 `Content-Length`，以兼容已发布 Apple 固定传输。已发布 iOS/visionOS App 支持经 Bonjour 的本地 Wi-Fi 配对和固定 HTTPS；原生串流仍受原生 App Premium 边界限制。

## 架构

初始套件支持 Synology x86-64；ARM64 尚未构建或测试。下载发行版前请确认 NAS CPU 架构。
