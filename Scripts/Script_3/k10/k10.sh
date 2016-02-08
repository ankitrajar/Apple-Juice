#! /bin/bash
this_script_name=$0 #storing the string name.
if [ $# -ne "1" ];then # if passed argument is not 1 then
echo "USAGE: 	$this_script_name <slot number>"
exit;
fi
#######################################################DEF SECTION################################################
PATH=$PATH:/bin:/sbin;
SLOTNO=$1
device=outputcntl
instance1=70
instance2=80
device_path="/dev/ctrl/$device"
instance1_path="/dev/slot$SLOTNO/${device}$instance1"
instance2_path="/dev/slot$SLOTNO/${device}$instance2"
test_file_dir="/usr/sbin/tejas"
#######################################################FUNCTIONS USED#############################################
function get_minor_no_of () {
instance_no=$1
minor_no_of_instance=$(cat /proc/$device | grep ${device}$instance_no | awk '{print $2}')
echo $minor_no_of_instance
}

function get_major_no_of () {
major_no_of_device=$(cat /proc/devices |grep $device | awk '/^ *[[:digit:]]/ {print $1}')
echo $major_no_of_device
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
	echo "6 0x80000088 $SLOTNO $instance1 0 0 0 0 2 2 2 1 0 0 q" | ./test /dev/ctrl/$device >/dev/null
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
	echo "6 0x8000008c $SLOTNO $instance2 0 0 0 0 2 2 2 1 0 0 q" | ./test /dev/ctrl/$device >/dev/null
	minor_of_instance2=$(get_minor_no_of "$instance2") 
fi
echo "$device minor_of_instance2: $minor_of_instance2"
if [ ! -e $instance1_path ];then
   mknod -m 666 $instance2_path c $device_major $minor_of_instance2
fi 
echo "use /dev/slotno/${device}$instance2 to access $instance2 address register of k10" 
#############################################################DONE########################################################