#!/bin/sh
user=$(whoami)
this_script=$0
	if [ "$user" != "root" ]; then
	    echo "Can not run with non-root priviledge";
		exit;
	fi
if [ $# -ne "1" ];then
echo "Usages: $this_script add|del"
exit;
fi

COUNTER=1;
MAX_VALUE=254;
operation=$1
while [ $COUNTER -le $MAX_VALUE ]
do
	for i in {1..5};
	do
	 	route $operation -net 10.$i.$COUNTER.0 netmask 255.255.255.0 dev eth1
	done
    let COUNTER=COUNTER+1
done










