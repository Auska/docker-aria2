#!/bin/sh

set -e

UID=${UID:-1000}
GID=${GID:-1000}
USER_NAME=${USER_NAME:-abc}
MODE=${MODE:-BT}
SECRET=${SECRET:-admin}

if ! getent group $GID > /dev/null 2>&1; then
    addgroup -g $GID $USER_NAME
fi

if ! getent passwd $UID > /dev/null 2>&1; then
    adduser -u $UID -G $USER_NAME -s /bin/sh -D $USER_NAME
fi

chown -R "$USER_NAME:$USER_NAME" /app || true

[[ ! -f /config/aria2.conf ]] && cp /app/defaults/aria2.conf /config/aria2.conf
[[ ! -f /config/aria2.session ]] && touch /config/aria2.session
[[ ! -f /config/dht.dat ]] && touch /config/dht.dat
[[ ! -f /config/dht6.dat ]] && touch /config/dht6.dat

if [ $MODE == "PT" ]; then
    sed -i "s@max-overall-upload-limit=.*@max-overall-upload-limit=0@g" /config/aria2.conf
    sed -i "s@enable-dht=.*@enable-dht=false@g" /config/aria2.conf
    sed -i "s@enable-dht6=.*@enable-dht6=false@g" /config/aria2.conf
    sed -i "s@bt-enable-lpd=.*@bt-enable-lpd=false@g" /config/aria2.conf
    sed -i "s@enable-peer-exchange=.*@enable-peer-exchange=false@g" /config/aria2.conf
    sed -i "s@seed-ratio=.*@seed-ratio=0@g" /config/aria2.conf
    sed -i "s@force-save=.*@force-save=true@g" /config/aria2.conf
    sed -i "s@bt-detach-seed-only=.*@bt-detach-seed-only=true@g" /config/aria2.conf
else
    sed -i "s@max-overall-upload-limit=.*@max-overall-upload-limit=200K@g" /config/aria2.conf
    sed -i "s@enable-dht=.*@enable-dht=true@g" /config/aria2.conf
    sed -i "s@enable-dht6=.*@enable-dht6=true@g" /config/aria2.conf
    sed -i "s@bt-enable-lpd=.*@bt-enable-lpd=true@g" /config/aria2.conf
    sed -i "s@enable-peer-exchange=.*@enable-peer-exchange=true@g" /config/aria2.conf
    sed -i "s@seed-ratio=.*@seed-ratio=1@g" /config/aria2.conf
    sed -i "s@force-save=.*@force-save=false@g" /config/aria2.conf
    sed -i "s@bt-detach-seed-only=.*@bt-detach-seed-only=false@g" /config/aria2.conf
fi

chown -R "$USER_NAME:$USER_NAME" /config || true
chown -R "$USER_NAME:$USER_NAME" /www || true

/usr/bin/gosu "$USER_NAME" /usr/bin/althttpd --root /www --port $WEB &

exec /usr/bin/gosu "$USER_NAME" /usr/bin/aria2c --conf-path=/config/aria2.conf --rpc-listen-port=$RPC --listen-port=$PORT --dht-listen-port=$PORT --rpc-secret=$SECRET --bt-include-client-ids=$BTINCLUDE --bt-exclude-client-ids=$BTEXCLUDE --dir=$DOWNLOAD
