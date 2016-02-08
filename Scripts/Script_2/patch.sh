user=$(whoami)
if [ "$user" == "root" ]; then
    echo "Do not patch with root priviledge";
    exit;
fi

if [ $# -ne "3" ];then
echo Usages: checkout_path checkout_branch_name home_path;
exit;
fi

checkout_path=$1;
checkout_branch_name=$2;
home_path=$3;
echo "#patching the tj100_mc_diff";
cd $home_path/$checkout_path/$checkout_branch_name/tj100_mc
patch -p1 -i /home/parmil/Downloads/tj100_mc_diff

echo "#patching the module_ce_diff";
cd $home_path/$checkout_path/$checkout_branch_name/modules/ce/
patch -p1 -i /home/parmil/Downloads/module_ce_diff

echo "#patching the sdk_diff";
cd $home_path/$checkout_path/$checkout_branch_name/packages/broadcom/bcmsdk-6.0/
patch -p1 -i /home/parmil/Downloads/sdk_diff

echo "#patching the mib_diff";
cd $home_path/$checkout_path/$checkout_branch_name/mib/
patch -p1 -i /home/parmil/Downloads/mib_diff


echo "All patching done of dscp to cosq files now will create mirror of it";
$home_path/cm-utils/mirror $home_path/$checkout_path/$checkout_branch_name/ $home_path/$checkout_path/MIRROR_xcc360g


