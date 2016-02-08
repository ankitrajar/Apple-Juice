#! /bin/bash
export LD_LIBRARY_PATH=/usr/sbin/tejas/sharedobj

SLOT=`echo "0 0 q" | /usr/sbin/tejas/test /dev/slot0/id/slotidentifier0 | grep "offset" | awk '{print hex $9}'`
SLOT=`printf "%d" $SLOT`
echo "slot number: $SLOT"

echo "-------------------------------------------------------"
echo "                       Port 1                          "
echo "-------------------------------------------------------"
VAL=`echo "1 d0014 q" | /usr/sbin/tejas/miiMgmtIfTest -q $SLOT 1 23 | grep "Read" | awk '{print $3}'`
VAL=`echo "$VAL" | awk '{print substr ($0, 2, length($0) )}'`
echo "XFI status Readister(d0014) val: $VAL (towards Port)"
echo "-------------------------------------------------------"
VAL=`echo "0x$VAL"`
VAL=`printf "%d" $VAL`
mask=1
let "mask<<=12"
va=$(($VAL & $mask ? 1 : 0))
if [ "$va" -eq 1 ]; then
    echo " Rx Lane-A Signal Detected "
else echo " Rx Lane-A Signal Not Detected "
fi

mask=1
let "mask<<=14"
va=$(($VAL & $mask ? 1 : 0))
if [ "$va" -eq 1 ]; then
    echo " Rx Loss of Signal Present "
else echo " Rx Loss of Signal not Present "
fi

VAL=`echo "1 c000c q" | /usr/sbin/tejas/miiMgmtIfTest -q $SLOT 1 23 | grep "Read" | awk '{print $3}'`
VAL=`echo "$VAL" | awk '{print substr ($0, 2, length($0) )}'`
echo ""
echo "UPI status Register(c000c) val: $VAL (towards Petra)"
echo "-------------------------------------------------------"
VAL=`echo "0x$VAL"`
VAL=`printf "%d" $VAL`

mask=1
let "mask<<=20"
va=$(($VAL & $mask ? 1 : 0))
if [ "$va" -eq 1 ]; then
    echo " Rx Loss of Signal Present"
else echo " Rx Loss of Signal not Present"
fi

echo ""
echo ""

echo "-------------------------------------------------------"
echo "                       Port 2                          "
echo "-------------------------------------------------------"
VAL=`echo "1 90014 q" | /usr/sbin/tejas/miiMgmtIfTest -q $SLOT 2 23 | grep "Read" | awk '{print $3}'`
VAL=`echo "$VAL" | awk '{print substr ($0, 2, length($0) )}'`
echo "XFI status Register(90014) val: $VAL (towards Port)"
echo "-------------------------------------------------------"
VAL=`echo "0x$VAL"`
VAL=`printf "%d" $VAL`
mask=1
let "mask<<=12"
va=$(($VAL & $mask ? 1 : 0))
if [ "$va" -eq 1 ]; then
    echo " Rx Lane-A Signal Detected "
else echo " Rx Lane-A Signal Not Detected "
fi

mask=1
let "mask<<=14"
va=$(($VAL & $mask ? 1 : 0))
if [ "$va" -eq 1 ]; then
    echo " Rx Loss of Signal Present "
else echo " Rx Loss of Signal not Present "
fi

VAL=`echo "1 8000c q" | /usr/sbin/tejas/miiMgmtIfTest -q $SLOT 2 23 | grep "Read" | awk '{print $3}'`
VAL=`echo "$VAL" | awk '{print substr ($0, 2, length($0) )}'`
echo ""
echo "UPI status Register(8000c) val: $VAL (towards Petra)"
echo "-------------------------------------------------------"
VAL=`echo "0x$VAL"`
VAL=`printf "%d" $VAL`

mask=1
let "mask<<=20"
va=$(($VAL & $mask ? 1 : 0))
if [ "$va" -eq 1 ]; then
    echo " Rx Loss of Signal Present"
else echo " Rx Loss of Signal Not Present "
fi

echo ""
echo ""
echo "-------------------------------------------------------"
echo "                       Port 3                          "
echo "-------------------------------------------------------"
VAL=`echo "1 d0014 q" | /usr/sbin/tejas/miiMgmtIfTest -q $SLOT 3 23 | grep "Read" | awk '{print $3}'`
VAL=`echo "$VAL" | awk '{print substr ($0, 2, length($0) )}'`
echo "XFI status Register(d0014) val: $VAL (towards Port)"
echo "-------------------------------------------------------"
VAL=`echo "0x$VAL"`
VAL=`printf "%d" $VAL`
mask=1
let "mask<<=12"
va=$(($VAL & $mask ? 1 : 0))
if [ "$va" -eq 1 ]; then
    echo " Rx Lane-A Signal Detected "
else echo " Rx Lane-A Signal Not Detected "
fi

mask=1
let "mask<<=14"
va=$(($VAL & $mask ? 1 : 0))
if [ "$va" -eq 1 ]; then
    echo " Rx Loss of Signal Present "
else echo " Rx Loss of Signal not Present "
fi

VAL=`echo "1 c000c q" | /usr/sbin/tejas/miiMgmtIfTest -q $SLOT 3 23 | grep "Read" | awk '{print $3}'`
VAL=`echo "$VAL" | awk '{print substr ($0, 2, length($0) )}'`
echo ""
echo "UPI status Register(c000c) val: $VAL (towards Petra)"
echo "-------------------------------------------------------"
VAL=`echo "0x$VAL"`
VAL=`printf "%d" $VAL`

mask=1
let "mask<<=20"
va=$(($VAL & $mask ? 1 : 0))
if [ "$va" -eq 1 ]; then
    echo " Rx Loss of Signal Present"
else echo " Rx Loss of Signal Not Present "
fi

echo ""
echo ""

echo "-------------------------------------------------------"
echo "                       Port 4                          "
echo "-------------------------------------------------------"
VAL=`echo "1 90014 q" | /usr/sbin/tejas/miiMgmtIfTest -q $SLOT 4 23 | grep "Read" | awk '{print $3}'`
VAL=`echo "$VAL" | awk '{print substr ($0, 2, length($0) )}'`
echo "XFI status Register(90014) val: $VAL (towards Port)"
echo "-------------------------------------------------------"
VAL=`echo "0x$VAL"`
VAL=`printf "%d" $VAL`
mask=1
let "mask<<=12"
va=$(($VAL & $mask ? 1 : 0))
if [ "$va" -eq 1 ]; then
    echo " Rx Lane-A Signal Detected "
else echo " Rx Lane-A Signal Not Detected "
fi

mask=1
let "mask<<=14"
va=$(($VAL & $mask ? 1 : 0))
if [ "$va" -eq 1 ]; then
    echo " Rx Loss of Signal Present "
else echo " Rx Loss of Signal not Present "
fi

VAL=`echo "1 8000c q" | /usr/sbin/tejas/miiMgmtIfTest -q $SLOT 4 23 | grep "Read" | awk '{print $3}'`
VAL=`echo "$VAL" | awk '{print substr ($0, 2, length($0) )}'`
echo ""
echo "UPI status Register(8000c) val: $VAL (towards Petra)"
echo "-------------------------------------------------------"
VAL=`echo "0x$VAL"`
VAL=`printf "%d" $VAL`

mask=1
let "mask<<=20"
va=$(($VAL & $mask ? 1 : 0))
if [ "$va" -eq 1 ]; then
    echo " Rx Loss of Signal Present"
else echo " Rx Loss of Signal Not Present "
fi
echo ""
echo ""
echo "-------------------------------------------------------"
echo "                       Port 13                          "
echo "-------------------------------------------------------"
VAL=`echo "1 90014 q" | /usr/sbin/tejas/miiMgmtIfTest -q $SLOT 13 23 | grep "Read" | awk '{print $3}'`
VAL=`echo "$VAL" | awk '{print substr ($0, 2, length($0) )}'`
echo "XFI status Register(90014) val: $VAL (towards Port)"
echo "-------------------------------------------------------"
VAL=`echo "0x$VAL"`
VAL=`printf "%d" $VAL`
mask=1
let "mask<<=12"
va=$(($VAL & $mask ? 1 : 0))
if [ "$va" -eq 1 ]; then
    echo " Rx Lane-A Signal Detected "
else echo " Rx Lane-A Signal Not Detected "
fi

mask=1
let "mask<<=14"
va=$(($VAL & $mask ? 1 : 0))
if [ "$va" -eq 1 ]; then
    echo " Rx Loss of Signal Present "
else echo " Rx Loss of Signal not Present "
fi

VAL=`echo "1 8000c q" | /usr/sbin/tejas/miiMgmtIfTest -q $SLOT 13 23 | grep "Read" | awk '{print $3}'`
VAL=`echo "$VAL" | awk '{print substr ($0, 2, length($0) )}'`
echo ""
echo "UPI status Register(8000c) val: $VAL (towards Petra)"
echo "-------------------------------------------------------"
VAL=`echo "0x$VAL"`
VAL=`printf "%d" $VAL`

mask=1
let "mask<<=20"
va=$(($VAL & $mask ? 1 : 0))
if [ "$va" -eq 1 ]; then
    echo " Rx Loss of Signal Present"
else echo " Rx Loss of Signal Not Present "
fi

echo ""
echo ""
echo "-------------------------------------------------------"
echo "                       Port 14                          "
echo "-------------------------------------------------------"
VAL=`echo "1 d0014 q" | /usr/sbin/tejas/miiMgmtIfTest -q $SLOT 14 23 | grep "Read" | awk '{print $3}'`
VAL=`echo "$VAL" | awk '{print substr ($0, 2, length($0) )}'`
echo "XFI status Register(d0014) val: $VAL (towards Port)"
echo "-------------------------------------------------------"
VAL=`echo "0x$VAL"`
VAL=`printf "%d" $VAL`
mask=1
let "mask<<=12"
va=$(($VAL & $mask ? 1 : 0))
if [ "$va" -eq 1 ]; then
    echo " Rx Lane-A Signal Detected "
else echo " Rx Lane-A Signal Not Detected "
fi

mask=1
let "mask<<=14"
va=$(($VAL & $mask ? 1 : 0))
if [ "$va" -eq 1 ]; then
    echo " Rx Loss of Signal Present "
else echo " Rx Loss of Signal not Present "
fi

VAL=`echo "1 c000c q" | /usr/sbin/tejas/miiMgmtIfTest -q $SLOT 14 23 | grep "Read" | awk '{print $3}'`
VAL=`echo "$VAL" | awk '{print substr ($0, 2, length($0) )}'`
echo ""
echo "UPI status Register(c000c) val: $VAL (towards Petra)"
echo "-------------------------------------------------------"
VAL=`echo "0x$VAL"`
VAL=`printf "%d" $VAL`

mask=1
let "mask<<=20"
va=$(($VAL & $mask ? 1 : 0))
if [ "$va" -eq 1 ]; then
    echo " Rx Loss of Signal Present"
else echo " Rx Loss of Signal Not Present "
fi

echo ""
echo ""
echo "-------------------------------------------------------"
echo "                       Port 15                          "
echo "-------------------------------------------------------"
VAL=`echo "1 90014 q" | /usr/sbin/tejas/miiMgmtIfTest -q $SLOT 15 23 | grep "Read" | awk '{print $3}'`
VAL=`echo "$VAL" | awk '{print substr ($0, 2, length($0) )}'`
echo "XFI status Register(90014) val: $VAL (towards Port)"
echo "-------------------------------------------------------"
VAL=`echo "0x$VAL"`
VAL=`printf "%d" $VAL`
mask=1
let "mask<<=12"
va=$(($VAL & $mask ? 1 : 0))
if [ "$va" -eq 1 ]; then
    echo " Rx Lane-A Signal Detected "
else echo " Rx Lane-A Signal Not Detected "
fi

mask=1
let "mask<<=14"
va=$(($VAL & $mask ? 1 : 0))
if [ "$va" -eq 1 ]; then
    echo " Rx Loss of Signal Present "
else echo " Rx Loss of Signal not Present "
fi

VAL=`echo "1 8000c q" | /usr/sbin/tejas/miiMgmtIfTest -q $SLOT 15 23 | grep "Read" | awk '{print $3}'`
VAL=`echo "$VAL" | awk '{print substr ($0, 2, length($0) )}'`
echo ""
echo "UPI status Register(8000c) val: $VAL (towards Petra)"
echo "-------------------------------------------------------"
VAL=`echo "0x$VAL"`
VAL=`printf "%d" $VAL`

mask=1
let "mask<<=20"
va=$(($VAL & $mask ? 1 : 0))
if [ "$va" -eq 1 ]; then
    echo " Rx Loss of Signal Present"
else echo " Rx Loss of Signal Not Present "
fi

echo ""
echo ""
echo "-------------------------------------------------------"
echo "                       Port 16                          "
echo "-------------------------------------------------------"
VAL=`echo "1 d0014 q" | /usr/sbin/tejas/miiMgmtIfTest -q $SLOT 16 23 | grep "Read" | awk '{print $3}'`
VAL=`echo "$VAL" | awk '{print substr ($0, 2, length($0) )}'`
echo "XFI status Register(d0014) val: $VAL (towards Port)"
echo "-------------------------------------------------------"
VAL=`echo "0x$VAL"`
VAL=`printf "%d" $VAL`
mask=1
let "mask<<=12"
va=$(($VAL & $mask ? 1 : 0))
if [ "$va" -eq 1 ]; then
    echo " Rx Lane-A Signal Detected "
else echo " Rx Lane-A Signal Not Detected "
fi

mask=1
let "mask<<=14"
va=$(($VAL & $mask ? 1 : 0))
if [ "$va" -eq 1 ]; then
    echo " Rx Loss of Signal Present "
else echo " Rx Loss of Signal not Present "
fi

VAL=`echo "1 c000c q" | /usr/sbin/tejas/miiMgmtIfTest -q $SLOT 16 23 | grep "Read" | awk '{print $3}'`
VAL=`echo "$VAL" | awk '{print substr ($0, 2, length($0) )}'`
echo ""
echo "UPI status Register(c000c) val: $VAL (towards Petra)"
echo "-------------------------------------------------------"
VAL=`echo "0x$VAL"`
VAL=`printf "%d" $VAL`

mask=1
let "mask<<=20"
va=$(($VAL & $mask ? 1 : 0))
if [ "$va" -eq 1 ]; then
    echo " Rx Loss of Signal Present"
else echo " Rx Loss of Signal Not Present "
fi
