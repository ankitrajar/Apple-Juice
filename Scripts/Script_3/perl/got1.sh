#!/bin/bash

user=$(whoami)
if [ "$user" != "root" ]; then
    echo "Can not run with non-root priviledge";
    exit;
fi

echo "THIS SCRIPT WILL CREATE THE FINAL NM.D USING OTHER SCRIPTS";
checkout_path=$1;
checkout_branch_name=$2;
option=$3;
user="parmil";
su_user="root";
home_path="/home/parmil";
cm_utils_path="/home/parmil";
tj100mc_diff_file_path="/home/parmil";
tj100_mc_diff_file_name="nm_simulator_tj100_mc.diff";
mirror_name="MIRROR_xcc360g";
scripts_path="$home_path/$checkout_path/myscripts";

echo $option
if [ $# -ne "3" ];then
echo Usages: checkout_path checkout_branch_name option;
echo Optoins: 
echo 1=all steps. 
echo 2=skip checkout and patching. start from compilation 
echo 3=similar to option 2 but sidepanelnotworking.sh script will not be run 
echo 4=just run the nm.d
exit;
fi

if [ $option == "1" ];then

rm /bin/sh
ln -s /bin/bash /bin/sh
lookup_path="$home_path/$checkout_path"
if [ -d $lookup_path ];then
   echo "$home_path/$checkout_path already exists. Please delete it or give a different checkout name(path)"
exit;
fi

su $user -c "mkdir -p $scripts_path";

echo Using checkoutnm_simulator.sh checkingout after that patching also;
su $user -c "source $scripts_path/checkoutnm_simulator.sh $checkout_path $checkout_branch_name $home_path $cm_utils_path $tj100mc_diff_file_path $tj100_mc_diff_file_name";

echo Using /home/parmil/myscripts/patch_dscp_cosq_files.sh after patch creating mirror also;

su $user -c "source $scripts_path/patch_dscp_cosq_files.sh $checkout_path $checkout_branch_name $home_path $cm_utils_path $mirror_name";

fi

if [ $option \< "4" ];then

echo Using /home/parmil/myscripts/compile_xcc360g.sh compiling till now without root

su $user -c "source $scripts_path/compile_xcc360g.sh $checkout_path $home_path $mirror_name";

echo Now onwards all scripts will be running in root level

echo Using onetime.sh for onetime setup

source $scripts_path/onetime.sh $checkout_path $home_path $mirror_name

fi

if [ $option \< "3" ];then

echo Using sidepanelnotworking.sh so that sidepanel issue can be fixed

source $scripts_path/sidepanelnotworking.sh $home_path

fi

echo Using run_nm_xcc360g.sh to run nm

source $scripts_path/run_nm_xcc360g.sh $checkout_path $home_path $mirror_name

