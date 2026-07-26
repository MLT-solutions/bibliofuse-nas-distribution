# Synology Container Manager 教程

[English](synology-container-manager.md) | [Español](synology-container-manager.es.md) | [Français](synology-container-manager.fr.md) | [Nederlands](synology-container-manager.nl.md) | [Português](synology-container-manager.pt.md) | [Русский](synology-container-manager.ru.md) | [简体中文](synology-container-manager.zh-CN.md) | [日本語](synology-container-manager.ja.md) | [한국어](synology-container-manager.ko.md) | [Bahasa Indonesia](synology-container-manager.id.md) | [Bahasa Melayu](synology-container-manager.ms.md)

本指南通过 Container Manager 安装免费的 Docker 服务器和网页界面。如需安装经过单独测试的原生 DSM 套件，请参阅 [Synology 套件指南](synology-package.zh-CN.md)。

## 要求

- 配备 Container Manager 的 DSM 7
- 受已发布镜像支持的 Intel/AMD 64 位或 ARM64 机型
- 有权创建共享文件夹和 Container Manager 项目

## 1. 创建文件夹

在 File Station 中创建：

```text
docker/bibliofuse/config
docker/bibliofuse/cache
```

该项目以只读方式挂载 DSM `/volume1`。设置会列出所配置 DSM 帐户实际可以读取的共享文件夹；不会自动附加其中任何一个。

## 2. 选择容器用户

容器必须能够写入配置/缓存并读取书库。请使用拥有这些权限的专用 DSM 帐户的数字 UID 和 GID。通过 SSH 运行：

```sh
id <username>
```

默认值 `1026:100` 仅作示例，可能不适用于您的 NAS。

## 3. 创建项目

1. 下载 `synology/compose.yaml`。
2. 打开 Container Manager → Project → Create。
3. 选择项目名称，例如 `bibliofuse`。
4. 上传或粘贴 Compose 文件。
5. 设置：
   - `CONFIG_PATH`，例如 `/volume1/docker/bibliofuse/config`
   - `CACHE_PATH`，例如 `/volume1/docker/bibliofuse/cache`
   - `PUID` 和 `PGID`
   - `BF_TIME_ZONE`，例如 `Asia/Kuala_Lumpur`
6. 构建/启动项目。

## 4. 首次设置

打开：

```text
http://<nas-ip>:7343
```

创建至少 12 个字符的管理员密码。在设置中选择 **Attach library**，选择显示的 DSM 共享文件夹或图书子文件夹，然后选择 Refresh。无需输入 DSM 或容器路径。选择器会根据所选容器 UID/GID 过滤掉不可读的共享文件夹。

可更改、禁用或移除根目录。禁用会保留目录数据。移除会清除该根目录的 BiblioFuse 目录、元数据和阅读进度，但不会删除文件或文件夹；移除最后一个根目录后，仍会保留有效的空书库。

## 5. 阅读与刷新

刷新会检查整个挂载树，并索引新增、已更改、已重命名或已移除的图书。自动刷新默认关闭；可在设置中安排每日或每周刷新。

连续漫画模式会逐步加载页面。在 DS923+ 或类似 NAS 上，未缓存的归档页面仍可能出现短暂加载延迟。Mac 或 PC 主机通常可提供更流畅的原生串流体验，因为其 CPU 能更快地解压并准备页面。

## 6. 备份与升级

- 在 Hyper Backup 中包含配置文件夹。
- 可以排除缓存。
- 升级前，请在设置中下载 BiblioFuse 备份。
- 保留之前的配置备份，因为数据库迁移可能只能向前进行。
- 拉取新镜像并重新创建项目，不要更改文件夹映射。

切勿选择会删除已映射配置或书库文件夹的卸载选项。

如要将 Container Manager 恢复出厂设置，请停止项目，备份并重命名已配置的配置和缓存文件夹，以原名称和权限创建新的空文件夹，然后重新启动。切勿在此清理中包含书库文件夹。

## 7. 网络边界

- `7343`：受信任局域网上的免费浏览器界面
- `7342`：固定的原生客户端 HTTPS API，通过 Bonjour 在本地 Wi-Fi 上发现
- `7341`：请勿发布

Container Manager 和原生 `.spk` 均可通过 Bonjour 在本地 Wi-Fi 上与已发布的 iOS/visionOS App 配对。原生串流仍受原生 App Premium 功能边界限制；Docker 不提供手动/Tailscale 原生路由。

不要在同一 NAS 上将这个 Container Manager 项目与原生 BiblioFuse Synology 套件同时运行。两个服务都会绑定 `7342` 和 `7343`；请选择一种安装方式。
