#!/bin/sh

# get url_list
tracker_url='https://raw.githubusercontent.com/ngosang/trackerslist/master/trackers_best.txt'

if [ $TRACKER_URL"x" != "x" ]
then
    tracker_url=$TRACKER_URL
fi

aria2_url=http://localhost:6800/jsonrpc

if [ $URL"x" != "x" ]
then
    aria2_url=$URL
fi

list=$(curl -s $tracker_url)
url_list=$(echo $list | sed 's/[ ][ ]*/,/g')
echo $url_list


# pack json
#uuid=$(cat /proc/sys/kernel/random/uuid)
uuid=$(od -x /dev/urandom | head -1 | awk '{OFS="-"; print $2$3,$4,$5,$6,$7$8$9}')
token="$SECRET"
json='{
    "jsonrpc": "2.0",
    "method": "aria2.changeGlobalOption",
    "id": "'$uuid'",
    "params": [
        "token:'$token'",
        {
            "bt-tracker": "'$url_list'"
        }
    ]
}'


# post json
echo "$aria2_url"
echo $json
curl -H "Accept: application/json" \
    -H "Content-type: application/json" \
    -X POST \
    -d "$json" \
    -s "$aria2_url"