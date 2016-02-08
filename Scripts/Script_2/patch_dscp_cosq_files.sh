user=$(whoami)
if [ "$user" == "root" ]; then
    echo "Do not patch with root priviledge";
    exit;
fi

if [ $# -ne "5" ];then
echo Usages: checkout_path checkout_branch_name home_path;
exit;
fi

checkout_path=$1;
checkout_branch_name=$2;
home_path=$3;
cm_utils_path=$4;
mirror_name=$5;
#YOUR PATCHING HAPPENS HERE

#echo "#patching the tj100_mc_diff";
#cd $home_path/$checkout_path/$checkout_branch_name/tj100_mc
#patch -p1 -i /home/parmil/Downloads/tj100_mc_diff

echo "All patching done of dscp to cosq files now will create mirror of it";
$cm_utils_path/cm-utils/mirror $home_path/$checkout_path/$checkout_branch_name/ $home_path/$checkout_path/$mirror_name


