#!/bin/bash
user=$(whoami)
if [ "$user" == "root" ]; then
    echo "Can not run with root priviledge";
    exit;
fi
number_of_parameters=$#

if [ $number_of_parameters -eq "1" ]; then

	if ! [ -e './taginfo' ]; then
		echo "Usage:checkout path new_branch_name"
		exit;
	else
		checkout_path=$(readlink -e ./)
		new_branch_name=$1
	fi
	echo "Usage:checkout path new_branch_name"
	exit
elif [ $number_of_parameters -eq "2" ]; then
	checkout_path=$(readlink -e $1)
	tagfile=$checkout_path/taginfo
	new_branch_name=$2
    if ! [ -e $tagfile ]; then
		echo "Usage: $tagfile not found."
		exit;
	else
		pushd $checkout_path
	fi
else
	echo "Usage:checkout path new_branch_name"
	exit
fi

tagfile=$checkout_path/taginfo
versionfile=$checkout_path/versioninfo
current_branch_name=$(cat $versionfile | grep module_name | cut -f2 -d ' ')
current_branch_tag=$(cat $versionfile | grep tag | cut -f2 -d ' ')
error_log=~/branchout_error_log.txt
frist_space="%2s"
second_space='%5s'
module_conf_append=~/${new_branch_name}_module_conf_append.txt
echo -n > $error_log
echo -n > $module_conf_append
echo "error log is $error_log"
echo "module.conf append file is $module_conf_append"

echo "Full & Final check. Please don't make any mistake its going to effect remote git repo. Verify these."
echo "Your current_branch_name is : $current_branch_name"
echo "Your current_branch_tag is : $current_branch_tag"
echo "Script will create branch named : $new_branch_name"
if [ "$current_branch_tag" == "" ]; then
	echo "Your checkout doesn't seem to be tagged checkout. Please take a tagged checkout"
	exit;
fi

REP='n';

echo "Do you want to proceed further? Enter Y or y only if you are sure."
read REP
if [[  $REP =~ ^[Yy] ]];then
	echo "All the best. Lets hope you haven't made any mistake. Otherwise will create mess.";
	echo "Use ctrl + C if change your mind."
	for tick in 5 4 3 2 1
	do
		echo $tick
		sleep 1s
	done
	echo "Lets Do This!!!"
else
	echo "You took right decision. Please rectify the mistake & try again."
	exit
fi
#creating module.conf append 
echo "module=$new_branch_name" >> $module_conf_append
#checkout_command_path=$(locate -w cm-utils/checkout) # if doesn't work commentout below one and edit if necessary.
checkout_command_path="$USER/cm-utils/checkout"

results=${#checkout_command_path[@]}
if [ $results -ne 1 ];then
    echo "Multiple Entries are coming while locating cm-utils. Please Specify the path in script."
    exit
elif [ $results -lt 1 ];then
    echo "No location found for cm-utils. Please Specify in script."
    exit
else
	echo "checkout_command_path is $checkout_command_path"
fi

declare -a all_modules=$(cat $tagfile | awk '{OFS="\t"; print $2}' | grep -v -- "----\|Component\|LINUX")
for module in ${all_modules[@]}
	do
		pushd ${checkout_path}/$module* 2>/dev/null > /dev/null #have added * so that it will go to min. matching module.
		module_push_status=$?
		if [ $module_push_status -eq 0 ]; then

			echo "Module $module"
			pwdmodule=$(pwd)
			pwdmodule=${pwdmodule#$(echo "$checkout_path")/}
			printf "%2s" " $pwdmodule"  >> $module_conf_append		
			printf "%5s\n" "     $new_branch_name" >> $module_conf_append
			git checkout -b $new_branch_name
	        git push -u origin $new_branch_name

			popd > /dev/null
		else
			echo "Not able to go to module : ${checkout_path}/$module";
			echo "${checkout_path}/$module" >> $error_log
		fi
done

echo "server=cvs" >> $module_conf_append
printf "%2s\n" ' LINUX/linux-2.6.26' >> $module_conf_append
printf "%2s\n" ' LINUX/linux-2.6.32' >> $module_conf_append
echo "endmodule" >> $module_conf_append
cat $module_conf_append | column -t > ${module_conf_append}.tmp
cp ${module_conf_append}.tmp $module_conf_append
rm ${module_conf_append}.tmp

	#popd > /dev/null

