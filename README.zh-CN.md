[English](README.md) | [Español](README.es.md) | [Français](README.fr.md) | [Nederlands](README.nl.md) | [Português](README.pt.md) | [Русский](README.ru.md) | [简体中文](README.zh-CN.md) | [日本語](README.ja.md) | [한국어](README.ko.md) | [Bahasa Indonesia](README.id.md) | [Bahasa Melayu](README.ms.md)

<p align="center"><img src="assets/bibliofuse-logo.png" alt="BiblioFuse 标志" width="180"></p>

# BiblioFuse NAS

适用于 Docker 和 Synology NAS 的私有自托管电子书与漫画书库。访问 [BiblioFuse 网站](https://bibliofuse.com)。

## 可免费托管并在浏览器阅读

BiblioFuse NAS 可免费在 Docker 或 Synology Container Manager 中托管；网页书库和阅读器也免费。此公开发行仓库仅含安装文件和文档，不含服务器源代码。

## 产品状态

| 主机或客户端 | 可用性 | 阅读和连接支持 |
| --- | --- | --- |
| Docker / Synology Container Manager | 公开测试版 `0.1.6` | 免费服务器、浏览器 UI 和本地 Wi-Fi 原生串流 |
| BiblioFuse 网页阅读器 | 已包含 | CBZ、ZIP、CBR、RAR、EPUB、TXT、TEXT 和 Markdown |
| 已发布、可连接 Docker 的 iOS / visionOS App | 本地 Wi-Fi 支持 | Bonjour 发现和固定 HTTPS 串流；Premium 由原生 App 管理 |
| Synology Package Center App（`.spk`） | 公开 x86-64 发行版 | 非 root 套件，可引导读取现有 DSM 共享文件夹 |
| Synology App 的 iOS / visionOS 原生串流 | 本地 Wi-Fi 支持 | Bonjour 发现和固定 HTTPS 串流；Premium 由原生 App 管理 |
| BiblioFuse Mac / PC 主机 | 独立产品 | 需要最流畅原生串流性能时建议使用 |

Docker 与浏览器阅读器保持免费；同一局域网内的原生串流是 iOS/visionOS App 的 Premium 功能。

## 浏览器语言

网页 App 可跟随系统语言，或在“设置”中选择英语、西班牙语、法语、荷兰语、葡萄牙语、俄语、简体中文、日语、韩语、印尼语或马来语。该设置只保存在浏览器中，不会更改服务器配置、书库元数据或原生客户端。

## 性能预期

常开 NAS 私密、省电且方便，但准备漫画或压缩包页面通常不如现代 Mac/PC 快。Mac/PC 最适合流畅原生阅读；NAS 适合随时可用的个人书库。CPU 会影响索引、解压、缩略图和下一页准备；SSD/NVMe 可改善冷读和重复读取，但不能让低功耗 NAS CPU 等同当前桌面处理器。连续漫画模式会逐页加载，准备未缓存的下一页时短暂停顿属正常。服务器会缓存已准备页面并预读后续页面。

## 开始前

需要 64 位 Intel/AMD 或 ARM64 Docker Compose 主机，或支持 Container Manager 的 Synology；一个持久配置文件夹、一个可丢弃缓存文件夹、书库文件夹和可用的 TCP `7343`。Synology 的文件夹示例：

```text
/volume1/docker/bibliofuse/config
/volume1/docker/bibliofuse/cache
/volume1/books
```

路径可不同；BiblioFuse 永远不需要书库文件夹的写权限。

## 使用 Docker Compose 安装

1. 下载本仓库的 `docker/compose.yaml` 和 `docker/.env.example`，将后者复制为 `.env`。
2. 设置 `CONFIG_PATH`、`CACHE_PATH`、`LIBRARY_PATH`、`PUID`、`PGID` 和 `BF_TIME_ZONE`。`LIBRARY_PATH` 是您自己的主机文件夹。
3. 启动：

```sh
docker compose up -d
```

4. 打开 `http://<server-ip>:7343`，创建第一个管理员；在设置中选择 **Attach library**、显示的 **Library** 位置或子文件夹，然后选择 **Refresh**。

Compose 仅将指定的 `LIBRARY_PATH` 提供为 **Library**；新安装不会自动附加文件夹。详见 [Docker 安装指南](docs/docker-install.zh-CN.md)。

## 使用 Synology Container Manager 安装

将 `synology/compose.yaml` 用作 Container Manager 项目，设为绝对 Synology 路径，然后打开：

```text
http://<nas-ip>:7343
```

该项目以只读方式挂载 DSM `/volume1`，只列出所选 `PUID`/`PGID` 实际可读的共享文件夹；管理员在设置中选择前不会附加任何文件夹。配置和缓存必须可写。可在设置中更改、禁用或移除书库；移除会清除该根的目录、元数据和阅读进度，但不会删除书籍。完整步骤见 [Synology 教程](docs/synology-container-manager.md)。同一 NAS 不要同时运行 Docker 项目和原生套件：两者均使用 `7342` 与 `7343`。

## 原生 Synology 套件

通用 x86-64 套件使用受限 `BiblioFuseNAS` DSM 帐户，不创建、移动或假定书库。设置会说明如何向该帐户授予现有共享文件夹只读权限；选择器仅显示真正可读的共享。见[原生 Synology 套件指南](docs/synology-package.zh-CN.md)。

## 刷新、格式与安全

**Refresh** 检查完整目录树的新增、移除和重命名，只重新索引新增或变更的书籍。自动刷新默认关闭，可选每日或每周；时间使用容器的 `BF_TIME_ZONE`。网页阅读器支持 CBZ/ZIP/CBR/RAR、EPUB、TXT/TEXT/Markdown；PDF 尚未包含。首个管理员密码至少 12 个字符。`7343` 是浏览器 UI，应留在可信 LAN 或可信 HTTPS 反向代理后；不要做路由器端口转发。`7342` 是固定原生客户端 HTTPS API；`7341` 保留且绝不可发布。

## 备份、更新与下载

备份整个持久 config 文件夹；缓存可丢弃，书库仍在自己的 NAS/主机文件夹中。更新前用设置下载 BiblioFuse 备份并保留 config 副本：

```sh
docker compose pull
docker compose up -d
```

同一 config 文件夹保持挂载时，重建容器不会删除帐户或目录；移除书库则会清除该根的目录、批注和进度。

- **Docker 镜像：** `ghcr.io/mlt-solutions/bibliofuse-nas:0.1.6`
- **Docker/Container Manager 模板：** 本仓库
- **版本说明和下载资产：** GitHub Releases
- **Synology `.spk`：** GitHub Releases（`x86-64` DSM 7）
- **产品概览和原生 App：** [bibliofuse.com](https://bibliofuse.com)

Docker 镜像是公开测试版。两种主机方式均支持本地 Wi-Fi Bonjour 原生发现；Docker 没有 Tailscale/手动原生路由。

## 帮助

请先阅读 [Docker 安装与运维](docs/docker-install.zh-CN.md)、[Synology Container Manager 教程](docs/synology-container-manager.md)、[原生 Synology 套件](docs/synology-package.zh-CN.md)、[性能指南](docs/performance.md) 和 [发行渠道与原生 App](docs/releases-and-native-apps.md)。请求支持时请提供 NAS/主机型号、CPU 架构、Docker 版本、书籍格式和近期容器日志；切勿发布密码、私钥、敏感文件名或 config 内容。
