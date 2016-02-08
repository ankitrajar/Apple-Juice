#!/bin/bash
# track_day_of_year: 302
# this script is selfmodifying in nature
self_path=${0};
user=$(whoami)
if [ "$user" != "root" ]; then
    echo "Can not run with non-root priviledge";
    exit;
fi
echo "THIS SCRIPT WILL START UNDERSTAND BY CLEARING MEMORY AND DELETING CONFIG AFTER 15 DAYS. IF YOU PASS 1 AS ARGUMENT IT WILL DELETE CONFIG.";
#understand will require too much memory so clearing up cache and swap.
#if [ 1 ] ; then
sync
echo 1 > /proc/sys/vm/drop_caches
echo 2 > /proc/sys/vm/drop_caches
echo 3 > /proc/sys/vm/drop_caches
#swapoff -a
#swapon -a
#fi

my_pc_user=parmil
understand_binary_path="/home/parmil/und/scitools/bin/linux32";
understand_binary_file_name="understand";
understand_config_files_path="/home/parmil/.config/SciTools";
day_of_year_command=`date +%j | sed 's/^[0]*//'`;
expiry_time_period="15";
safe_side_days_time_period="14";
force_delete_config=$1;
force_delete_flag="1";
today_s_day=$day_of_year_command;
last_entry_in_file=$(cat "$self_path" | grep "track_day_of_year" | head -1 | cut -d: -f2)
echo "Last entery in file is $last_entry_in_file"
days_difference=$(( $today_s_day - $last_entry_in_file )) ; 
echo "Running from here : $understand_binary_path/$understand_binary_file_name"
echo "Config is stored here : $understand_config_files_path"
ls $understand_config_files_path
if [[ $days_difference -gt $safe_side_days_time_period ]] || [[ $force_delete_config -eq $force_delete_flag ]];then
   echo "Renewing the config for next 15 days.";
   sed -i -e "2s/track_day_of_year:.*$/track_day_of_year: $today_s_day/" "$self_path"
   su $my_pc_user -c "rm -rf $understand_config_files_path";
   ls $understand_config_files_path
else
	days_left=$(( $expiry_time_period - $days_difference )) ;
	echo "Days left to renew the config is/are $days_left";
fi

su $my_pc_user -c "$understand_binary_path/$understand_binary_file_name";
