#! /bin/bash
this_script_name=$0 #storing the string name.
if [ $# -ne "1" ];then # if passed argument is not 1 then
echo "USAGE: 	$this_script_name <slot number>"
exit;
fi
#######################################################DEF SECTION################################################
export LD_LIBRARY_PATH=/usr/sbin/tejas/sharedobj/
SLOTNO=$1
device=outputcntl
instance1=70
instance2=80
device_path="/dev/ctrl/$device"
instance1_path="/dev/slot$SLOTNO/${device}$instance1"
instance2_path="/dev/slot$SLOTNO/${device}$instance2"
test_file="/usr/sbin/tejas/test"
discarder_device="/dev/null" # it discards everything written to it.
#########################################################FUNCTIONS################################################
function write_via_instance1 () {
test_file_operations_write_sequence=$@
echo "writing via instance1 using sequence $test_file_operations_write_sequence"
echo "$test_file_operations_write_sequence" | $test_file $instance1_path > $discarder_device
}

function read_via_instance2 () {
test_file_operations_read_sequence=$@
echo "reading via instance2 using sequence $test_file_operations_read_sequence"
echo "$test_file_operations_read_sequence" | $test_file $instance2_path | grep "offset"
}
#########################################################PROCEED TO READ TEMP#####################################
echo "PHY 1 Die 0"
write_via_instance1 "10 0 8154 q"
read_via_instance2 "8 0 q"

echo "PHY 1 Die 1"
write_via_instance1 "10 0 815c q"
read_via_instance2 "8 0 q"

echo "PHY 2 Die 0"
write_via_instance1 "10 0 8158 q"
read_via_instance2 "8 0 q"

echo "PHY 2 Die 1"
write_via_instance1 "10 0 8160 q"
read_via_instance2 "8 0 q"

echo "Petra"
write_via_instance1 "10 0 8164 q"
read_via_instance2 "8 0 q"