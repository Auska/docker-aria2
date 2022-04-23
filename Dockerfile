FROM ghcr.io/linuxserver/baseimage-alpine:edge

# set version label
ARG BUILD_DATE="2022-03-16"
ARG VERSION="1.36.0"
LABEL build_version="version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="Auska"

ENV TZ=Asia/Shanghai SECRET=admin WEB=80 RPC=6800 PORT=16881 TRACKERSAUTO=Yes MODE=BT NO_Digest=true

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
