if [ $# -ne "5" ];then
echo Usages: IP_of_node User Password Tempdir_on_xcc Local_dir_for_logs;
exit;
fi
ip=$1;
user=$2;
user_pass=$3;
tempdir=$4;
local_dir=$5;
cd /home/parmil/
rm -rf /home/parmil/$local_dir
mkdir $local_dir
cd /home/parmil/$local_dir
pwd
echo $tempdir
ls -l
echo ncftpget -R -u$user -p$user_pass $ip /home/$USER/$local_dir /tmp/$tempdir
ncftpget -R -u$user -p$user_pass $ip /home/$USER/$local_dir /tmp/$tempdir/
ls -lR
pwd
