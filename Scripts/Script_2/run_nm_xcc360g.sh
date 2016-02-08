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
echo Copy command executing
cd $home_path/$checkout_path/$mirror_name/packages/treeview/

cp -rf ftiens4.js ua.js /usr/sbin/tejas/ems/js/treeview/
cp -rf $home_path/$checkout_path/$mirror_name/tj100_mc/src/app/common/nm/ems/js/treeview/NodeToc.js  /usr/sbin/tejas/ems/js/treeview/
cp -rf $home_path/$checkout_path/$mirror_name/tj100_mc/src/app/common/nm/ems/js/* /usr/sbin/tejas/ems/js/
cp -rf $home_path/$checkout_path/$mirror_name/modules/ce/src/app/common/nm/ems/js/* /usr/sbin/tejas/ems/js/tj2k/
cp -rf $home_path/$checkout_path/$mirror_name/tj100_mc/scripts/TZData.conf /usr/sbin/tejas/
cp -rf $home_path/$checkout_path/$mirror_name/tj100_mc/src/licenses/vendor/tj2k_vendor.dat /etc/tejas/config/

cd $home_path/$checkout_path/$mirror_name/tj100_mc/src/app/tj1700/nm/
echo Export commands executing
export HIGHTEMP_THRESHOLD=60
export SANITY_TIMEOUT=10000
export TJ_LICENSE_FILE=/etc/tejas/license.dat 
export LD_LIBRARY_PATH=$home_path/$checkout_path/$mirror_name/tj100_mc/src/sharedobj/
export WEB_SERVER_PORT=20080
export SNMP_LOG_LEVEL=0
export BP_EEPROM_ENABLE=YES
export ENABLE_HW_WATCHDOG=YES
export SIMULATOR=YES
export SIGD_TIMEOUT=180000

snmp_pids=`ps -ef | grep -iw "[s]nmpd" | awk '{print $2}'`
nm_pids=`ps -ef| grep -iw "[n]m\.d" | awk '{print $2}'`

echo Checking and killing snmpd if already running
if [ "$snmp_pids" != "" ]; then
for signal in "-15" "-1" "-9"
do
  pids=`ps -ef | grep -iw "[s]nmpd" | awk '{print $2}'`
  kill $signal $pids 2> /dev/null
  echo Killed pid $pids with signal $signal
done
fi

echo Checking if nm.d is already running and killing it.
if [ "$nm_pids" !=  "" ]; then
for signal in "-15" "-1" "-9"
do
  pids=`ps -ef| grep -iw "[n]m\.d" | awk '{print $2}'`
  kill $signal $pids 2> /dev/null
  echo Killed pid $pids with signal $signal
done
fi
echo No snmp or nm.d is running!!! Ready to launch nm.d

gdb nm.d


