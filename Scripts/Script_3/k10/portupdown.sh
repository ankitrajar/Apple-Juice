#! /bin/bash
export LD_LIBRARY_PATH=/usr/sbin/tejas/sharedobj/
PATH=$PATH:/bin:/sbin;
timeint=10s
while [ 1 ]
do
echo For slot 4 port 1 Making it UP.
echo "13 0x10080 9 3 0 0 81 13 6 f0 2 97 q" | /usr/sbin/tejas/testPPFpga -q 4
echo "Reading Status"
echo "12 0x10080 9 q" | /usr/sbin/tejas/testPPFpga -q 4
echo "Sleeping for $timeint"
sleep $timeint
echo For slot 4 port 1 Making it Down.
echo "13 0x10080 9 3 0 0 81 13 6 0 2 97 q" | /usr/sbin/tejas/testPPFpga -q 4
echo "Reading Status"
echo "12 0x10080 9 q" | /usr/sbin/tejas/testPPFpga -q 4
done
##########################################################END OF SCRIPT##################################################
   
