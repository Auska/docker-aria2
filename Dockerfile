FROM ghcr.io/linuxserver/baseimage-alpine:edge

# set version label
ARG BUILD_DATE="2023-12-10"
ARG VERSION="1.37.0"
LABEL build_version="version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="Auska"

ENV TZ=Asia/Shanghai SECRET=admin WEB=80 RPC=6800 PORT=16881 TRACKERSAUTO=Yes MODE=BT

# copy local files
COPY  root /
COPY aria2c  /usr/bin/aria2c
COPY webui /webui

RUN \
	echo "**** install packages ****" \
	&& sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories \
	&& apk add --no-cache curl darkhttpd

# ports and volumes
EXPOSE 6800 16881 80
VOLUME /mnt /config
