FROM alpine:3.11 as compilingaria2c

#compiling aria2c

ARG  ARIA2_VER=1.35.0

# copy local files
COPY  root /

RUN  apk add --no-cache ca-certificates make g++ gcc wget bash zlib-dev openssl-dev expat-dev sqlite-dev c-ares-dev libssh2-dev \
&&   bash /defaults/build.sh \
&&   cp --parents /usr/local/bin/aria2c /aria2

# docker aria2 

FROM lsiobase/alpine:3.11

# set version label
LABEL maintainer="Auska"

ENV TZ=Asia/Shanghai SECRET=admin RPC=6800 PORT=16881

# copy local files
COPY  root /
COPY --from=compilingaria2c  /aria2  /

RUN \
	echo "**** install packages ****" \
	&& apk add --no-cache curl

# ports and volumes
EXPOSE 6800 16881
VOLUME /mnt /config
