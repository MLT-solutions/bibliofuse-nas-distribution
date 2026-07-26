[English](docker-install.md) | [Español](docker-install.es.md) | [Français](docker-install.fr.md) | [Nederlands](docker-install.nl.md) | [Português](docker-install.pt.md) | [Русский](docker-install.ru.md) | [简体中文](docker-install.zh-CN.md) | [日本語](docker-install.ja.md) | [한국어](docker-install.ko.md) | [Bahasa Indonesia](docker-install.id.md) | [Bahasa Melayu](docker-install.ms.md)

# Docker 安装与运维

## 浏览器语言

安装后打开设置并选择 **Language**。浏览器可跟随系统语言，或使用英语、西班牙语、法语、荷兰语、葡萄牙语、俄语、简体中文、日语、韩语、印尼语或马来语。选择只存于此浏览器，不影响容器或书库元数据。

## 1. 选择文件夹

| 用途 | 容器路径 | 所需访问 | 备份 |
| --- | --- | --- | --- |
| 帐户、身份、目录和设置 | `/config` | 读/写 | 是 |
| 已准备页面和缩略图 | `/cache` | 读/写 | 否 |
| 您的书库 | `/library` | 只读 | 单独备份 |

容器路径保持不变；`CONFIG_PATH`、`CACHE_PATH` 与 `LIBRARY_PATH` 选择主机上的实际文件夹。Docker 不会自行定位书库：在首次启动前映射文件夹，然后在设置中选择要附加的文件夹。

## 2. 配置 Compose

下载 `docker/` 中的文件，将 `.env.example` 复制为 `.env` 并编辑。服务器安装请使用绝对路径。Linux 上可用以下命令取得数字用户和组 ID：

```sh
id
```

将 `PUID` 和 `PGID` 设为可写 config/cache、可读书库的身份；BiblioFuse 不以 root 身份运行。

## 3. 启动并验证

```sh
docker compose pull
docker compose up -d
docker compose ps
docker compose logs --tail=100 bibliofuse
```

打开 `http://<server-ip>:7343`，创建管理员后在设置中选择 **Attach library**。选择器显示配置的 **Library** 挂载及子文件夹，但新安装没有附加根，直到选择一个并刷新。不要与原生 Synology 套件在同一 NAS 运行此 host-network 服务：两者绑定原生 HTTPS `7342` 和浏览器 UI `7343`。首次刷新遍历完整书库；之后仍检查目录树但会复用未变压缩包的元数据。

## 4. 添加另一书库文件夹

每个 Library Root 必须是容器内存在的路径。先向 `compose.yaml` 加入只读挂载，例如：

```yaml
volumes:
  - "/srv/books:/library:ro"
  - "/srv/manga:/books/manga:ro"
environment:
  BF_LIBRARY_BROWSE_ROOTS: >-
    [{"name":"Library","path":"/library"},{"name":"Manga","path":"/books/manga"}]
```

重建容器后，在设置 → Attach library 中选择 **Manga**。不要在网页 UI 输入 `/books/manga` 或主机路径 `/srv/manga`。挂载文件夹重命名时用 **Change**，会保留目录身份；**Disable** 保留目录数据；**Detach**（包括最后一个根）会清除该根的目录、元数据和阅读进度，但不会删除书籍或文件夹。

## 5. 计划刷新

设置支持 Disabled、Daily 和 Weekly；每日/每周时间以 30 分钟为间隔。将 `BF_TIME_ZONE` 设为有效 IANA 时区，例如 `Asia/Kuala_Lumpur`。

## 6. 更新

受控部署应使用编号镜像标签。备份 `/config` 后运行：

```sh
docker compose pull
docker compose up -d
docker image prune
```

`docker image prune` 可选，只移除未使用的镜像数据，不会移除书籍。

## 7. 停止或卸载

```sh
docker compose down
```

这会移除容器和网络，不会删除主机的 config、cache 或书库。明确恢复出厂设置时：先运行 `docker compose down`，备份 `CONFIG_PATH` 与 `CACHE_PATH`，将这两个文件夹重命名为保留备份并创建同名、权限正确的空文件夹，然后运行 `docker compose up -d` 并创建管理员。绝不要重命名、清空或删除 `LIBRARY_PATH`；BiblioFuse 以只读方式挂载它。

## 家庭网络外的浏览器访问

不要从路由器直接转发 `7343`。请使用带身份验证和有效证书的可信 HTTPS 反向代理，或经自己的 VPN/Tailscale 网络访问 LAN 地址。Tailscale 浏览器访问使用 NAS/服务器的 Tailscale 地址和 `:7343`；这不会为当前已发布 iOS/visionOS App 增加 Docker 配对。

## 故障排除

### 书库选择器为空

- 确认 `LIBRARY_PATH` 是真实主机文件夹，并在 `docker compose up` 前设置。
- 运行 `docker compose config` 并检查 `/library:ro` 挂载。
- 确认 `PUID:PGID` 可读该主机文件夹。
- 修改挂载后重建容器，再重新打开设置。

### Permission denied

所选数字用户/组无法访问已挂载文件夹。修复主机文件夹权限或选择正确的 `PUID`/`PGID`；不要把容器改成 root 作为首个解决办法。

### 阅读时页面停顿

检查 CPU 与磁盘活动。冷压缩包页面必须解压和准备；服务器会预加载后续页面，但低功耗 NAS CPU 仍可能短暂停顿。重复阅读应受益于持久缓存。

### 容器反复重启

```sh
docker compose ps
docker compose logs --tail=200 bibliofuse
```

检查无效挂载路径、config/cache 写权限、端口冲突及损坏或不完整的 `.env`。

### 管理员密码遗失

没有邮件恢复。仅重建容器不会重置密码，因为验证信息在 `/config` 中；只有在可接受失去既有 BiblioFuse 帐户、身份、目录和设置时，才使用上面的明确恢复出厂步骤；书库本身不受影响。
