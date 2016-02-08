user=$(whoami)
if [ "$user" == "root" ]; then
    echo "Do not patch with root priviledge";
    exit;
fi

if [ $# -ne "4" ];then
echo Usages: checkout_path checkout_branch_name home_path Diff_directory;
exit;
fi

checkout_path=$1;
checkout_branch_name=$2;
home_path=$3;
diff_dir=$4;
echo "#making diff for tj100_mc";
cd $home_path/$checkout_path/$checkout_branch_name/tj100_mc
git diff > $home_path/$diff_dir/tj100mc.diff

echo "#making the module_ce_diff";
cd $home_path/$checkout_path/$checkout_branch_name/modules/ce/
git diff > $home_path/$diff_dir/module_ce.diff

echo "#making the sdk_diff";
cd $home_path/$checkout_path/$checkout_branch_name/packages/broadcom/bcmsdk-6.0/
git diff > $home_path/$diff_dir/sdk.diff

echo "#making the mib_diff";
cd $home_path/$checkout_path/$checkout_branch_name/mib/
git diff > $home_path/$diff_dir/mib.diff

