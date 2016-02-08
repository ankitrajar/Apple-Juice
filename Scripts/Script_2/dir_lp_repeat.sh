#!/bin/sh
sleep_interval=0s
COUNTER=1;
MAX_VALUE=2000;
while [ $COUNTER -lt $MAX_VALUE ]
do
	 echo "inserting module"
	 cat /proc/meminfo | grep -i "slab"
	 cat /proc/meminfo | grep -i "claim"
	ls /fsdf/sdfsdlfjsdfsd/fsd/fsd/fsd/f/sd/fsd/fsd/fsdfe/rwersdfgsd/f/sd/f/sd/fsd/f.txt 2>/dev/null
     #/sbin/modprobe --force --set-version 2.6 ram_stresser
     let COUNTER=COUNTER+1
     sleep $sleep_interval
	 #/sbin/modprobe --force --set-version 2.6 -r ram_stresser
	 echo "removing module"
	 cat /proc/meminfo | grep -i "slab"
	 cat /proc/meminfo | grep -i "claim"
	 sleep $sleep_interval
done

