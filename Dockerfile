FROM alpine:latest

ENV GOSU_VERSION=1.16
ENV TZ=Asia/Shanghai
ENV DOWNLOAD=/downloads
ENV MODE=BT
ENV RPC=6800
ENV PORT=16881
ENV UID=1000
ENV GID=1000
ENV BTINCLUDE="-,A2"
ENV BTEXCLUDE="-SD,-XF,-QD,-BN,-DL,-XL"

# copy local files
COPY app /app
COPY aria2c /usr/bin/aria2c

RUN \
	sed -i 's/dl-cdn.alpinelinux.org/mirrors.tuna.tsinghua.edu.cn/g' /etc/apk/repositories && \
    apk add --no-cache curl && \
    chmod +x /app/entrypoint.sh && \
    chmod +x /usr/bin/aria2c

RUN curl -L "https://gh-proxy.net/https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-amd64" -o /usr/bin/gosu && \
    chmod +x /usr/bin/gosu

# ports and volumes
EXPOSE 6800 16881
VOLUME /downloads /config

ENTRYPOINT ["/app/entrypoint.sh"]
