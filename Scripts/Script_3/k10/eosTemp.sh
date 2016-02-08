#! /bin/bash
this_script_name=$0 #storing the string name.
if [ $# -lt "1" ];then # if passed argument is not 1 then
echo "USAGE: $this_script_name <slot number> <fresh_start(Optional)> <time_interval(Opt)> <times_to_run(Opt)>"
echo "fresh_start:(1)-overwrite temp file.(0)-keep previous temp data & times_to_run get reduced by lines present in file.Default: 1"
echo "time_interval: how frequently read temp.input format - 1s 1m 1h etc similar to bash sleep command. Default: 5m"
echo "times_to_run: (-1)-run infinitally but use 2 temp files in alternative way of max lines allowed as 2500. Default:5000"
exit;
fi
#######################################################DEF SECTION################################################
COUNTER=1
SLOTNO=$1
FRESH_START=$2
TIME_INTERVAL=$3
COUNTER_MAX_VALUE=$4
TEMPERATURE_FILE_MAX_LINES=2500

if [ "$FRESH_START" == "" ];then
	FRESH_START=1
fi

if [ "$COUNTER_MAX_VALUE" == "" ];then
	COUNTER_MAX_VALUE=5000
fi

if [ "$TIME_INTERVAL" == "" ];then
	TIME_INTERVAL=5m
fi

eosFpga_path="/dev/slot$SLOTNO/perPortEosFpga0"
test_file="/usr/sbin/tejas/test"
eosfpga_temperature_file="/tmp/eosFpgaSlot${SLOTNO}_temperature_file_EPOCH_SECOND_AVG_MAX_MIN.txt"
eosfpga_temperature_file2="/tmp/eosFpgaSlot${SLOTNO}_temperature_file_EPOCH_SECOND_AVG_MAX_MIN_file2.txt"

if [ ! -e $eosfpga_temperature_file ];then
	touch $eosfpga_temperature_file #not wirting the format that is mentioned in the file name itself.
else
	if [ "$FRESH_START" == 1 ];then
		echo -n > $eosfpga_temperature_file
	else
		COUNTER=$(wc -l < $eosfpga_temperature_file)
	fi
fi
#########################################################FUNCTIONS################################################
function read_temp () {
temp_read_sequence=$@
echo $(echo "$temp_read_sequence" | $test_file $eosFpga_path |grep -i "read value" | cut -f2 -d = | cut -f2 -d ' ')
}
#########################################################PROCEED TO READ TEMP#####################################

while [ $COUNTER -le $COUNTER_MAX_VALUE ] || [ "$COUNTER_MAX_VALUE" -eq "-1" ]
do
avg_temp_hex=$(read_temp "10 31 0000   10 31 8000   8 32 q")
max_temp_hex=$(read_temp "10 31 0020   10 31 8020   8 32 q")
min_temp_hex=$(read_temp "10 31 0024   10 31 8024   8 32 q")
avg_temp=$(($avg_temp_hex/130-273))
max_temp=$(($max_temp_hex/130-273))
min_temp=$(($min_temp_hex/130-273))
epoch_second=$(date +%s)

if [ "$COUNTER_MAX_VALUE" -eq "-1" ] && [ "$COUNTER" -eq "$TEMPERATURE_FILE_MAX_LINES" ];then
	cp $eosfpga_temperature_file $eosfpga_temperature_file2
	echo -n > $eosfpga_temperature_file
	let COUNTER=1
	echo "$epoch_second $avg_temp $max_temp $min_temp" >> $eosfpga_temperature_file
else
	echo "$epoch_second $avg_temp $max_temp $min_temp" >> $eosfpga_temperature_file
fi

let COUNTER=COUNTER+1
sleep $TIME_INTERVAL
done
##########################################################END OF SCRIPT############################################
