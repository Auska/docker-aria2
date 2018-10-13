FROM lsiobase/alpine:3.8

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="blog.auska.win version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="Auska"

ENV TZ=Asia/Shanghai

RUN \
	echo "**** install packages ****" && \
	apk add --no-cache darkhttpd unzip 

# copy local files
COPY root/ /

# ports and volumes
EXPOSE 6800 80
VOLUME /mnt /config
