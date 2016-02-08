#!/bin/sh
creation_path=/etc/tejas/config/pm
sleep_interval=4s
COUNTER=40;
PREV_COUNTER=40;
while [ 1 ]
do 
PREV_COUNTER=$COUNTER
let COUNTER=PREV_COUNTER+520
   while [ $PREV_COUNTER -le $COUNTER ]
         do
                     for i in {1..10};
                     do
                                for j in {1..10};
                                do
                                    mv $creation_path/pmdb-1-$i-$j-$PREV_COUNTER  $creation_path/pmdb-1-$i-$j-$COUNTER
                                    mv $creation_path/pmdb-1-$i-$j-$PREV_COUNTER.gz  $creation_path/pmdb-1-$i-$j-$COUNTER.gz
                                done
                     done
                     let PREV_COUNTER=PREV_COUNTER+1
         	     let COUNTER=COUNTER+1
                     sleep $sleep_interval
         done
done
 