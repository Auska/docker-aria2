FROM lsiobase/alpine:3.8

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="blog.auska.win version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="Auska"

ENV TZ=Asia/Shanghai ARIA2_VERSION=1.34.0

RUN \
	echo "**** install packages ****" \
	$$ sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories \
	&& apk add --no-cache darkhttpd \
	&& apk add --no-cache --virtual .build-deps build-base curl \
	&& apk add --no-cache --virtual .persistent-deps ca-certificates zlib-dev openssl-dev expat-dev sqlite-dev c-ares-dev libssh2-dev \
	&& cd /tmp \
	&& curl -fSL https://github.com/aria2/aria2/releases/download/release-${ARIA2_VERSION}/aria2-${ARIA2_VERSION}.tar.xz -o aria2.tar.xz \
	&& tar xJf aria2.tar.xz \
	&& cd aria2-${ARIA2_VERSION} \
	&& sed -i 's|"1", 1, 16,|"8", 1, -1,|g' src/OptionHandlerFactory.cc \
	&& ./configure \
	&& make -j$(getconf _NPROCESSORS_ONLN) \
	&& make install \
	&& apk del .build-deps \
	&& rm -rf /tmp

# copy local files
COPY root/ /

# ports and volumes
EXPOSE 6800 80
VOLUME /mnt /config
