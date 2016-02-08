#!/bin/sh
creation_path=/etc/tejas/config/pm
sleep_interval=1s
COUNTER=40;
MAX_VALUE=290;
MIN_VALUE=40;
while [ 1 ]
do
   while [ $COUNTER -lt $MAX_VALUE ]
   do
        for i in {1..10};
        do
            for j in {1..10};
            do
		echo -n "1" >$creation_path/pmdb-1-$i-$j-$COUNTER
		echo -n "2">$creation_path/pmdb-1-$i-$j-$COUNTER.gz
            done
        done
        let COUNTER=COUNTER+1
        sleep $sleep_interval
   done
sleep 5s
   while [ $COUNTER -gt $MIN_VALUE ]
   do
        for i in {1..10};
        do
            for j in {1..10};
            do
                rm $creation_path/pmdb-1-$i-$j-$COUNTER
                rm $creation_path/pmdb-1-$i-$j-$COUNTER.gz
            done
        done
        let COUNTER=COUNTER-1
        sleep $sleep_interval
   done
done
