FROM ghcr.io/linuxserver/baseimage-alpine:edge

# set version label
ARG BUILD_DATE="2022-03-16"
ARG VERSION="1.36.0"
LABEL build_version="version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="Auska"

ENV TZ=Asia/Shanghai SECRET=admin RPC=6800 PORT=16881 TRACKERSAUTO=Yes MODE=BT

# copy local files
COPY  root /
COPY aria2c  /usr/bin/aria2c

RUN \
	echo "**** install packages ****" \
	&& apk add --no-cache curl

# ports and volumes
EXPOSE 6800 16881
VOLUME /mnt /config
