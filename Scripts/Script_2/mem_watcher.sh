#!/bin/sh
echo Memory Changes in every five min. interval > mem_watch_output.txt
cat /proc/meminfo |awk '{print $1}'| tr '\n' ' ' >> mem_watch_output.txt
echo
while [ 1 ]
do
cat /proc/meminfo |awk '{print $2}'|grep -oiE '([0-9.]{0,9})' | tr '\n' ' | ' >> mem_watch_output.txt
echo
sleep 1s
done

