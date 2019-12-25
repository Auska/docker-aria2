FROM lsiobase/alpine:3.11

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="blog.auska.win version:1.35.0"
LABEL maintainer="Auska"

ENV TZ=Asia/Shanghai SECRET=admin

RUN \
	echo "**** install packages ****" \
	&& apk add --no-cache aria2 curl

# copy local files
COPY root/ /

# ports and volumes
EXPOSE 6800
VOLUME /mnt /config
