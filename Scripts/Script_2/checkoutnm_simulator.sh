user=$(whoami)
if [ "$user" == "root" ]; then
    echo "Do not checkout with root priviledge";
    exit;
fi

if [ $# -ne "6" ];then
echo Usages: checkout_path checkout_branch_name home_path;
exit;
fi

checkout_path=$1;
checkout_branch_name=$2;
home_path=$3;
cm_utils_path=$4;
tj100mc_diff_file_path=$5;
tj100_mc_diff_file_name=$6;
mkdir $home_path/$checkout_path
cd $home_path/$checkout_path
$cm_utils_path/cm-utils/checkout --dir=$home_path/$checkout_path/$checkout_branch_name $checkout_branch_name

echo "Checkout is completed now will start patching nm simulator files with corresponding tj100mcdiff file";

#    patch attached diff by :
cd $home_path/$checkout_path/$checkout_branch_name/tj100_mc
patch -p1 -i $tj100mc_diff_file_path/$tj100_mc_diff_file_name
OUT=$?
if [ $OUT -eq 0 ];then
  echo "Patching done successfully. No problem. :-) "
else
   REP='n';
   echo "Patching failed. Please patch manually using other shell. After patching manually enter C or c to continue."
   while [[ ! $REP =~ ^[Cc] ]]; do
   echo "If manually patched. Enter c or C to continue ";
   read REP
   done
fi
echo "Continuing";

