#!/bin/sh
lookup_path=/etc/tejas/mem_watch_output.txt
sleep_interval=5m
if [ -f $lookup_path ];then
   init_time=$(date);
   echo "$lookup_path already exists. It will resume at new time stamp.$init_time" >> $lookup_path
   echo Memory Changes in every $sleep_interval interval >> $lookup_path
   cat /proc/meminfo |awk '{print $1}'| tr '\n' ' ' >> $lookup_path
   echo >>$lookup_path
   while [ 1 ]
   do
     cat /proc/meminfo |awk '{print $2}'|grep -oiE '([0-9.]{0,9})' | tr '\n' ' ' >> $lookup_path
     echo >>$lookup_path
     sleep $sleep_interval
   done
   exit;
else
   init_time=$(date);
   echo "$lookup_path is not created so creating it. starting at $init_time" > $lookup_path;
   echo Memory Changes in every $sleep_interval interval >> $lookup_path
   cat /proc/meminfo |awk '{print $1}'| tr '\n' ' ' >> $lookup_path
   echo >>$lookup_path
   while [ 1 ]
   do
     cat /proc/meminfo |awk '{print $2}'|grep -oiE '([0-9.]{0,9})' | tr '\n' ' ' >> $lookup_path
     echo >>$lookup_path
     sleep $sleep_interval
   done
fi

