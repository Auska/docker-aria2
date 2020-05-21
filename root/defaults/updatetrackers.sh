#! /bin/sh

if [ "$TRACKERSAUTO" == "YES" ];then

# get url_list
tracker_url='https://trackerslist.com/best.txt'
aria2_url=http://localhost:6800/jsonrpc

list=$(curl -s $tracker_url)
url_list=$(echo $list | sed 's/[ ][ ]*/,/g')

# pack json
#uuid=$(cat /proc/sys/kernel/random/uuid)
uuid=$(od -x /dev/urandom | head -1 | awk '{OFS="-"; print $2$3,$4,$5,$6,$7$8$9}')
token=$SECRET
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
curl -H "Accept: application/json" \
    -H "Content-type: application/json" \
    -X POST \
    -d "$json" \
    -s "$aria2_url"

else

echo "Update Tracker Exit ..."

fi