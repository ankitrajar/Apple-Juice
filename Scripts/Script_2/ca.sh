#!/bin/sh
#Crash Analysis Script.
ca_base_dir=$HOME\crash_analysis
if ! [ -e $ca_base_dir ];then
	mkdir -p $ca_base_dir
fi

crash_count=$(echo "." | grep -ni "stackdump" $(find ./ -maxdepth 2 -type f -name "*log*")| awk 'BEGIN { FS = ":" } { printf($1"\n") }' | wc -l)
# echo "." so that grep don't hangup.
if [ $crash_count -ne 0 ]; then
	ca_current_main_dir="$ca_base_dir/crash_analysis$(pwd | sed -e 's/\//_/g')"
	echo "Crash Count is non-zero - $crash_count."
	echo "Creating $ca_current_main_dir"
	mkdir -p $ca_current_main_dir
else
	echo "Crash Count is zero for current dir. Exiting."
	exit
fi

ca_details=$ca_current_main_dir/all_crashes.txt
echo "." | grep -ni "stackdump" $(find ./ -maxdepth 2 -type f -name "*log*")| awk 'BEGIN { FS = ":" } { printf($1" "$2"\n") }' > $ca_details
echo "Wrote all crash details to $ca_details"

