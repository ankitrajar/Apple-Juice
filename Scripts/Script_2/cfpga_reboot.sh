#! /bin/bash
this_script_name=$0 #storing the string name.
if [ $# -lt "0" ];then # if passed argument is not 1 then
echo "USAGE: $this_script_name <slot number> <fresh_start(Optional)> <time_interval(Opt)> <times_to_run(Opt)>"
echo "fresh_start:(1)-overwrite output file.(0)-keep previous output data & times_to_run get reduced by lines present in file.Default: 1"
echo "time_interval: how frequently read output.input format - 1s 1m 1h etc similar to bash sleep command. Default: 5m"
echo "times_to_run: (-1)-run infinitally but use 2 output files in alternative way of max lines allowed as 2500. Default:5000"
exit;
fi
#######################################################DEF SECTION################################################
sleep 10m


COUNTER=1
SLOTNO=$1
FRESH_START=$2
TIME_INTERVAL=$3
COUNTER_MAX_VALUE=$4
OUTPUT_FILE_MAX_LINES=2500
CORRECT_VALUE="0x23"
COLD_REBOOT_SCRIPT="/usr/sbin/tejas/PPColdStart.sh"

if [ "$FRESH_START" == "" ];then
	FRESH_START=0
fi

if [ "$SLOTNO" == "" ];then
	SLOTNO=8
fi

if [ "$COUNTER_MAX_VALUE" == "" ];then
	COUNTER_MAX_VALUE=-1
fi

if [ "$TIME_INTERVAL" == "" ];then
	TIME_INTERVAL=5m
fi

use_this_device_with_test_path="/dev/slot$SLOTNO/cardidentifier1" 
test_file="/usr/sbin/tejas/test"
output_data_storage_file="/etc/tejas/Slot${SLOTNO}_data.txt"
output_data_storage_file2="/etc/tejas/Slot${SLOTNO}_data_file2.txt"

if [ ! -e $output_data_storage_file ];then
	touch $output_data_storage_file #not wirting the format that is mentioned in the file name itself.
else
	if [ "$FRESH_START" == 1 ];then
		echo -n > $output_data_storage_file
	else
		COUNTER=$(wc -l < $output_data_storage_file)
	fi
fi
#########################################################FUNCTIONS################################################
function read_data_using_seq () {
read_sequence=$@
echo $(echo "$read_sequence" | $test_file $use_this_device_with_test_path |grep -i "read value" | cut -f2 -d = | cut -f2 -d ' ')
}
#########################################################PROCEED TO READ DATA#####################################


output_data=$(read_data_using_seq "0 0 q")
epoch_second=$(date +%s)

if [ "$COUNTER_MAX_VALUE" -eq "-1" ] && [ "$COUNTER" -eq "$OUTPUT_FILE_MAX_LINES" ];then
	cp $output_data_storage_file $output_data_storage_file2
	echo -n > $output_data_storage_file
	let COUNTER=1
	echo "$epoch_second $output_data" >> $output_data_storage_file
else
	echo "$epoch_second $output_data" >> $output_data_storage_file
fi

if [ "$output_data" == "$CORRECT_VALUE" ];then
	echo "Got correct value of cfpga version $output_data"
	echo "Going for cold reboot."
	#reboot
	$COLD_REBOOT_SCRIPT
	reboot
else
	echo "Congrats You have got wrong value of cfpga version. Yahoooooooooo :)"
	echo "Just stoping here."
	exit
fi

##########################################################END OF SCRIPT############################################
