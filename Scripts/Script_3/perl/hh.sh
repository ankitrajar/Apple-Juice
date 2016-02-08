#!/bin/bash
user=$(whoami)
if [ "$user" != "root" ]; then
    echo "Can not run with non-root priviledge";
    exit;
fi

checkout_path="";
checkout_branch_name="";
option="";
user="";
su_user="";
home_path="";
cm_utils_path="";
tj100mc_diff_file_path="";
tj100_mc_diff_file_name="";
mirror_name="";
scripts_path="";

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

echo "THIS SCRIPT WILL CREATE THE FINAL NM.D USING OTHER SCRIPTS";

if [ $option == "1" ];then

rm /bin/sh
ln -s /bin/bash /bin/sh
lookup_path="$home_path/$checkout_path"
if [ -d $lookup_path ];then
   echo "$home_path/$checkout_path already exists. Please delete it or give a different checkout name(path)"
exit;
fi
echo Using checkoutnm_simulator.sh checkingout after that patching also;
su $user -c "source $scripts_path/checkoutnm_simulator.sh $checkout_path $checkout_branch_name $home_path $cm_utils_path $tj100mc_diff_file_path $tj100_mc_diff_file_name";

echo Using $scripts_path/patch_and_mirror.sh after patch creating mirror also;

su $user -c "source $scripts_path/patch_and_mirror.sh $checkout_path $checkout_branch_name $home_path $cm_utils_path $mirror_name";

fi

if [ $option \< "4" ];then

echo Using $scripts_path/compile_simulator.sh compiling till now without root

su $user -c "source $scripts_path/compile_simulator.sh $checkout_path $home_path $mirror_name";

echo Now onwards all scripts will be running in root level

echo Using $scripts_path/onetime.sh for onetime setup

source $scripts_path/onetime.sh $checkout_path $home_path $mirror_name

fi

if [ $option \< "3" ];then

echo Using $scripts_path/sidepanelnotworking.sh so that sidepanel issue can be fixed

source $scripts_path/sidepanelnotworking.sh $home_path

fi

echo Using $scripts_path/run_nm_simulator.sh to run nm

source $scripts_path/run_nm_simulator.sh $checkout_path $home_path $mirror_name



