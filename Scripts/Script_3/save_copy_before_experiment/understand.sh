#!/bin/bash

user=$(whoami)
if [ "$user" != "root" ]; then
    echo "Can not run with non-root priviledge";
    exit;
fi
echo "THIS SCRIPT WILL START UNDERSTAND BY CLEARING MEMORY AND DELETING CONFIG AFTER 15 DAYS. IF YOU PASS 1 AS ARGUMENT IT WILL DELETE CONFIG.";
#understand will require too much memory so clearing up cache and swap.

sync
echo 1 > /proc/sys/vm/drop_caches
echo 2 > /proc/sys/vm/drop_caches
echo 3 > /proc/sys/vm/drop_caches
swapoff -a
swapon -a

track_day_of_year="/home/parmil/.track_day_of_year_file";
my_pc_user=parmil
understand_binary_path="/home/parmil/und/scitools/bin/linux32";
understand_binary_file_name="understand";
understand_config_files_path="/home/parmil/.config/SciTools";
day_of_year_command=`date +%j`;
expiry_time_period="15";
safe_side_days_period="14";
force_delete_config=$1;

if [ -f $track_day_of_year ];then
   echo "$track_day_of_year already exists. Will read days form this and decide wheather to delete the config or not.";
   last_entry_in_file=`cat $track_day_of_year`;
   today_s_day=$day_of_year_command;
else
   echo "$track_day_of_year doesn't exists so will create it.";
   echo -n $day_of_year_command > $track_day_of_year;
   today_s_day=$day_of_year_command;
   last_entry_in_file=`cat $track_day_of_year`;
fi

days_difference=$(( $today_s_day - $last_entry_in_file )) ;

if [ $days_difference -gt $safe_side_days_period ] || [ $force_delete_config -eq "1" ];then
   echo "Renewing the config for next 15 days.";
   echo -n $day_of_year_command > $track_day_of_year;
   su $my_pc_user -c "rm -rf $understand_config_files_path";
   ls $understand_config_files_path
else
	days_left=$(( $expiry_time_period - $days_difference )) ;
	echo "Days left to renew the config is/are $days_left";
fi

su $my_pc_user -c "$understand_binary_path/$understand_binary_file_name";
