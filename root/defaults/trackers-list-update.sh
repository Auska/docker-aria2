#!/bin/bash

list=`wget -qO- https://raw.githubusercontent.com/ngosang/trackerslist/master/trackers_all.txt|awk NF|sed ":a;N;s/\n/,/g;ta"`
if [ -z "`grep "bt-tracker" /config/aria2.conf`" ]; then
    sed -i '$a bt-tracker='${list} /config/aria2.conf
    echo add trackers-list
else
    sed -i "s@bt-tracker.*@bt-tracker=$list@g" /config/aria2.conf
    echo update trackers-list
fi