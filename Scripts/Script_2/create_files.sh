#!/bin/sh
#creation_path=/etc/tejas/config/pm
creation_path=/home/parmil/myscripts/perl/exp
sleep_interval=2s
COUNTER=40;
   while [ 1 ]
   do
	 for i in {1..10};
         do
                          for j in {1..10};
		          do
                 	     touch $creation_path/pmdb-1-$i-$j-$COUNTER
			     touch $creation_path/pmdb-1-$i-$j-$COUNTER.gz
			     echo "1">$creation_path/pmdb-1-$i-$j-$COUNTER
                             echo "2">$creation_path/pmdb-1-$i-$j-$COUNTER.gz
        		  done

		 
         done  
         let COUNTER=COUNTER+1
         sleep $sleep_interval
   done
   exit;
#like pmdb-1-10-1-15-1              pmdb-1-11-39-10-1             pmdb-1-2-12-3-1               pmdb-1-3-18-5-1               pmdb-1-9-4-15-1
