FROM ghcr.io/linuxserver/baseimage-alpine:edge

# set version label
ARG BUILD_DATE="2025-08-17"
ARG VERSION="1.37.0-1"
LABEL build_version="version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="Auska"

ENV TZ=Asia/Shanghai
ENV WEB=80
ENV RPC=6800
ENV PORT=16881 
ENV TRACKERSAUTO=Yes
ENV MODE=BT

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
VOLUME /downloads /config
