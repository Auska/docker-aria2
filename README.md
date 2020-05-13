# 我的博客
http://blog.auska.win

## 创建镜像

```
docker create --name=aria2 \
-v <path to downloads>:/mnt \
-v <path to config>:/config \
-e PGID=<gid> -e PUID=<uid> \
-e TZ=<timezone> -e SECRET=<admin> \
-e RPC=<6800> PORT=<16881> \
-p 6800:6800 -p 16881:16881 \
auska/docker-aria2
```

## 参数解释

* `-p 6800` PRC端口
* `-p 16881` - BT软件通讯端口
* `-v /config` - 配置文件目录
* `-v /mnt` - 下载文件目录
* `-e PGID` 用户的GroupID，留空为root
* `-e PUID` 用户的UserID，留空为root
* `-e SECRET` 登录密钥
* `-e TZ` 时区 默认 Asia/Shanghai

## 版本介绍

latest ： 自带WEB。
no-web ： 不包括WEB_UI。