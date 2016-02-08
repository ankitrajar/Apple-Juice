user=$(whoami)
if [ "$user" != "root" ]; then
    echo "Can not run with non-root priviledge";
    exit;
fi

if [ $# -ne "3" ];then
echo Usages: checkout_path home_path;
exit;
fi

checkout_path=$1;
home_path=$2;
mirror_name=$3;
echo "One time setup script started";

mkdir /etc/tejas
mkdir /etc/tejas/log
mkdir /etc/tejas/config
mkdir /etc/tejas/config/db
mkdir /etc/tejas/config/backup
mkdir /usr/sbin/tejas
mkdir /usr/sbin/tejas/ems
mkdir /usr/sbin/tejas/ems/js
mkdir /usr/sbin/tejas/ems/js/treeview
cd $home_path/$checkout_path/$mirror_name/packages/treeview/ 

#// Please note that if you are modifying .js files then this is not one time work, you will have to copy them using commands below:
: << 'commentout'
#moving these lines to run_nm_xcc360.sh
cp -rf ftiens4.js ua.js /usr/sbin/tejas/ems/js/treeview/
cp -rf $home_path/$checkout_path/$mirror_name/tj100_mc/src/app/common/nm/ems/js/treeview/NodeToc.js  /usr/sbin/tejas/ems/js/treeview/
cp -rf $home_path/$checkout_path/$mirror_name/tj100_mc/src/app/common/nm/ems/js/* /usr/sbin/tejas/ems/js/
cp -rf $home_path/$checkout_path/$mirror_name/modules/ce/src/app/common/nm/ems/js/* /usr/sbin/tejas/ems/js/tj2k/
cp -rf $home_path/$checkout_path/$mirror_name/tj100_mc/scripts/TZData.conf /usr/sbin/tejas/
cp -rf $home_path/$checkout_path/$mirror_name/tj100_mc/src/licenses/vendor/tj2k_vendor.dat /etc/tejas/config/
commentout


ncftpget -uguest -piltwat 192.168.50.162 /etc/tejas /etc/tejas/license.dat
cd $home_path/$checkout_path/$mirror_name/tj100_mc/src/app/tj1700/nm/
echo "One time setup completed";
