#! /bin/bash
this_script_name=$0 #storing the string name.
if [ $# -lt "1" ];then # if passed argument is not 1 then
echo "USAGE:$this_script_name <slot> <fresh_start(Optional)> <time_interval(Opt)> <times_to_run(Opt)> <inst1(Opt)> <inst2(Opt)>"
echo "fresh_start:(1)-overwrite temp file.(0)-keep previous temp data & times_to_run get reduced by lines present in file.Default: 1"
echo "time_interval: how frequently read temp.Input format - 1s 1m 1h etc similar to bash sleep command. Default: 5m"
echo "times_to_run: (-1)-run infinitally but use 2 temp files in alternative way of max lines allowed as 2500. Default:5000"
echo "inst 1 & 2 : instances of outputcntl device.Default: 70 & 80.Incase of conflict with other instances give these values."
exit;
fi
#######################################################DEF SECTION######################################################
export LD_LIBRARY_PATH=/usr/sbin/tejas/sharedobj/
PATH=$PATH:/bin:/sbin;
COUNTER=1
SLOTNO=$1
FRESH_START=$2
TIME_INTERVAL=$3
COUNTER_MAX_VALUE=$4
instance1=$5
instance2=$6
if [ "$FRESH_START" == "" ];then
	FRESH_START=1
fi

if [ "$COUNTER_MAX_VALUE" == "" ];then
	COUNTER_MAX_VALUE=5000
fi

if [ "$TIME_INTERVAL" == "" ];then
	TIME_INTERVAL=5m
fi

if [ "$instance1" == "" ];then
	instance1=70
fi

if [ "$instance2" == "" ];then
	instance2=80
fi
TEMPERATURE_FILE_MAX_LINES=2500
device=outputcntl
device_path="/dev/ctrl/$device"
instance1_path="/dev/slot$SLOTNO/${device}$instance1"
instance2_path="/dev/slot$SLOTNO/${device}$instance2"
test_file="/usr/sbin/tejas/test"
k10_temperature_file="/tmp/k10slot${SLOTNO}Temperature_EPOCH_SECOND_PHY1DIE0_PHY1DIE1_PHY2DIE0_PHY2DIE1_PETRA.txt"
k10_temperature_file2="/tmp/k10slot${SLOTNO}Temperature_EPOCH_SECOND_PHY1DIE0_PHY1DIE1_PHY2DIE0_PHY2DIE1_PETRA_file2.txt"
discarder_device="/dev/null" # it discards everything written to it.
#########################################################FUNCTIONS#######################################################
				    						  ###DEVICE INSTANTIATION###
function get_minor_no_of () {
instance_no=$1
minor_no_of_instance=$(cat /proc/$device | grep ${device}$instance_no | awk '{print $2}')
echo $minor_no_of_instance
}

function get_major_no_of () {
major_no_of_device=$(cat /proc/devices |grep $device | awk '/^ *[[:digit:]]/ {print $1}')
echo $major_no_of_device
}
				    						  ###TEMPRATURE READING###
function write_via_instance1 () {
test_file_operations_write_sequence=$@
#removing extra echo.
echo "$test_file_operations_write_sequence" | $test_file $instance1_path > $discarder_device
}

function read_via_instance2 () {
test_file_operations_read_sequence=$@
#don't add any extra echo here otherwise it will mess with output.
echo $(echo "$test_file_operations_read_sequence" | $test_file $instance2_path |grep -i "read value" | cut -f2 -d = | cut -f2 -d ' ')
}

######################################################PROCEED TO CREATE DEVICE INSTANCES##################################
cd $test_file_dir
pwd
###########################################################DEVICE#########################################################
device_major=$(get_major_no_of "$device")
if [ "$device_major" == "" ]; then
	echo "It seems that $device_path needs to be created."
	mknod -m 666 $device_path c $device_major 255
	device_major=$(get_major_no_of)
fi
echo "device_major: $device_major"
###########################################################DEVICE INSTANCE 1##############################################
minor_of_instance1=$(get_minor_no_of "$instance1")
if [ "$minor_of_instance1" == "" ]; then
	echo "It seems that ${device}$instance1 needs to be instantiated using test"
	echo "6 0x80000088 $SLOTNO $instance1 0 0 0 0 2 2 2 1 0 0 q" | $test_file $device_path >$discarder_device
	minor_of_instance1=$(get_minor_no_of "$instance1") 
fi
echo "$device minor_of_instance1: $minor_of_instance1"
if [ ! -e $instance1_path ];then
   mknod -m 666 $instance1_path c $device_major $minor_of_instance1
fi 
echo "use /dev/slotno/${device}$instance1 to access $instance1 address register of k10"                        
############################################################DEVICE INSTANCE 2#############################################
minor_of_instance2=$(get_minor_no_of "$instance2") 
if [ "$minor_of_instance2" == "" ]; then
	echo "It seems that ${device}$instance2 needs to be instantiated using test"
	echo "6 0x8000008c $SLOTNO $instance2 0 0 0 0 2 2 2 1 0 0 q" | $test_file $device_path >$discarder_device
	minor_of_instance2=$(get_minor_no_of "$instance2") 
fi
echo "$device minor_of_instance2: $minor_of_instance2"
if [ ! -e $instance2_path ];then
   mknod -m 666 $instance2_path c $device_major $minor_of_instance2
fi 
echo "use /dev/slotno/${device}$instance2 to access $instance2 address register of k10" 
######################################################TEMPERATURE RECORD##################################################
if [ ! -e $k10_temperature_file ];then  # If file doesn't exist than create it.
	touch $k10_temperature_file #not writing the formate that is mentioned in the file name itself.
else
	if [ "$FRESH_START" == 1 ];then
		echo -n > $k10_temperature_file
	else
		COUNTER=$(wc -l < $k10_temperature_file)
	fi
fi
#########################################################PROCEED TO READ TEMP#############################################
while [ "$COUNTER" -le "$COUNTER_MAX_VALUE" ] || [ "$COUNTER_MAX_VALUE" -eq "-1" ]
do
#echo "PHY 1 Die 0"
write_via_instance1 "10 0 8154 q"
phy1die0=$(($(read_via_instance2 "8 0 q")/100))

#echo "PHY 1 Die 1"
write_via_instance1 "10 0 815c q"
phy1die1=$(($(read_via_instance2 "8 0 q")/100))

#echo "PHY 2 Die 0"
write_via_instance1 "10 0 8158 q"
phy2die0=$(($(read_via_instance2 "8 0 q")/100))

#echo "PHY 2 Die 1"
write_via_instance1 "10 0 8160 q"
phy2die1=$(($(read_via_instance2 "8 0 q")/100))

#echo "Petra"
write_via_instance1 "10 0 8164 q"
petra=$(($(read_via_instance2 "8 0 q")/100))

epoch_second=$(date +%s)

if [ "$COUNTER_MAX_VALUE" -eq "-1" ] && [ "$COUNTER" -eq "$TEMPERATURE_FILE_MAX_LINES" ];then
	cp $k10_temperature_file $k10_temperature_file2
	echo -n > $k10_temperature_file
	let COUNTER=1
	echo "$epoch_second $phy1die0 $phy1die1 $phy2die0 $phy2die1 $petra" >> $k10_temperature_file
else
	echo "$epoch_second $phy1die0 $phy1die1 $phy2die0 $phy2die1 $petra" >> $k10_temperature_file
fi

let COUNTER=COUNTER+1
sleep $TIME_INTERVAL
done
##########################################################END OF SCRIPT##################################################
   