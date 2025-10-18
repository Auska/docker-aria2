# Aria2 Docker 镜像

一个基于 Alpine Linux 的轻量级 Aria2 Docker 镜像。

## 功能特性

- 基于 Alpine Linux，镜像体积小
- 可配置的用户权限（UID/GID）
- 支持 WebUI（latest 版本）
- 自动保存下载会话
- 可自定义 RPC 密钥和端口

## 镜像版本

- `latest`：包含 WebUI
- `noweb`：不包含 WebUI

## 快速开始

### 创建容器

```bash
docker create --name=aria2 \
  -v <path to downloads>:/downloads \
  -v <path to config>:/config \
  -e PGID=<gid> -e PUID=<uid> \
  -e TZ=<timezone> -e SECRET=<rpc_secret> \
  -e RPC=<rpc_port> -e PORT=<bt_port> \
  -p <rpc_port>:<rpc_port> -p <bt_port>:<bt_port> \
  auska/docker-aria2
```

### 启动容器

```bash
docker start aria2
```

### 使用 Docker Compose

```yaml
version: '3'
services:
  aria2:
    image: auska/docker-aria2
    container_name: aria2
    volumes:
      - <path to downloads>:/downloads
      - <path to config>:/config
    environment:
      - PGID=<gid>
      - PUID=<uid>
      - TZ=<timezone>
      - SECRET=<rpc_secret>
      - RPC=<rpc_port>
      - PORT=<bt_port>
    ports:
      - <rpc_port>:<rpc_port>
      - <bt_port>:<bt_port>
    restart: unless-stopped
```

## 环境变量

| 变量名 | 默认值 | 描述 |
|--------|--------|------|
| `UID` | `1000` | 用户 ID |
| `GID` | `1000` | 用户组 ID |
| `SECRET` | `admin` | RPC 密钥 |
| `RPC` | `6800` | RPC 端口 |
| `PORT` | `16881` | BT 监听端口 |
| `WEB` | `80` | WebUI 端口 |
| `DOWNLOAD` | `/downloads` | 下载目录 |
| `TZ` | `Asia/Shanghai` | 时区 |
| `BTINCLUDE` | `-,A2` | BT Peer ID 白名单 |
| `BTEXCLUDE` | `-SD,-XF,-QD,-BN,-DL,-XL` | BT Peer ID 黑名单 |

## 端口说明

- `80`：WebUI 端口（默认）
- `6800`：RPC 端口（默认）
- `16881`：BT 监听端口（默认）

## 卷映射

- `/downloads`：下载文件存储目录
- `/config`：配置文件目录

## 配置文件

首次运行时会自动创建以下配置文件：

- `aria2.conf`：Aria2 配置文件
- `aria2.session`：下载会话文件
- `dht.dat`：DHT 节点数据文件
- `dht6.dat`：IPv6 DHT 节点数据文件

## 链接

[我的博客](http://blog.auska.win)
