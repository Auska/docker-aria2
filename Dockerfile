FROM lsiobase/alpine:3.8

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="blog.auska.win version:1.34.0"
LABEL maintainer="Auska"

ENV TZ=Asia/Shanghai SECRET=Auska

RUN \
	echo "**** install packages ****" \
	&& apk add --no-cache aria2

# copy local files
COPY root/ /

# ports and volumes
EXPOSE 6800
VOLUME /mnt /config
