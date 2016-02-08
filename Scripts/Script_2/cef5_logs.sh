echo Welcome
if [ $# -ne "3" ];then
echo Usages: IP_of_node Slot_no_of_CEF5_card Icc_ip_second_byte;
echo Inter_card_communication\(icc\):  127.icc_ip_second_byte.1.slot, default icc_ip_second_byte is 1 but in some cards it is 7 or may be different
exit;
fi

     ip=$1;
     slot=$2;
     icc_ip_second_byte=$3;
     user="guest";
     user_pass="iltwat";
     su_user="root";
     su_user_pass="swtn100tj";
     tempdir="temp_cef5logs";
     local_dir="instant_logs";
     scripts_path="/home/parmil/myscripts"; ####scripts_path="$your_scripts_path"; #<#<#$HOME/myscripts#>#>#

echo Copying cef5 logs into xcc\'s /tmp/$tempdir using copy_cef5_to_xcc.sh
$scripts_path/copy_cef5_to_xcc.sh $ip $slot $user $user_pass $su_user $su_user_pass $tempdir $icc_ip_second_byte

echo Copying cef5 logs from xcc\'s /tmp/$tempdir to /home/parmil/$local_dir using get_cef5logs_from_xcc.sh
source $scripts_path/get_cef5logs_from_xcc.sh $ip $user $user_pass $tempdir $local_dir

echo Removing previously created /tmp/$tempdir @$ip using clean_tempdir_from_xcc.sh
$scripts_path/clean_tempdir_from_xcc.sh $ip $user $user_pass $su_user $su_user_pass $tempdir

echo Congrats You have downloaded CEF5 LOGS into /home/parmil/$local_dir
echo Exiting
echo Bye
