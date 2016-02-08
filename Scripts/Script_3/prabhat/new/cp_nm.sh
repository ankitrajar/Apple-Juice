user=$(whoami)
    if [ "$user" != "root" ]; then
    echo "Can not run with non-root privilage";
    exit;
    fi

export HIGHTEMP_THRESHOLD=60
export SANITY_TIMEOUT=10000
export TJ_LICENSE_FILE=/etc/tejas/tj1700_license.dat 
export LD_LIBRARY_PATH=/home/prabhath/work/270614/HOST/xccmirror/tj100_mc/src/sharedobj/
export WEB_SERVER_PORT=20080
export SNMP_LOG_LEVEL=0
export BP_EEPROM_ENABLE=YES
export ENABLE_HW_WATCHDOG=YES
export SIMULATOR=YES
export SIGD_TIMEOUT=180000
cd /home/prabhath/work/270614/HOST/xccmirror/packages/treeview/
cp -rf ftiens4.js ua.js /usr/sbin/tejas/ems/js/treeview/
cp -rf /home/prabhath/work/270614/HOST/xccmirror/tj100_mc/src/app/common/nm/ems/js/treeview/NodeToc.js /usr/sbin/tejas/ems/js/treeview/
cp -rf /home/prabhath/work/270614/HOST/xccmirror/tj100_mc/src/app/common/nm/ems/js/* /usr/sbin/tejas/ems/js/
cp -rf /home/prabhath/work/270614/HOST/xccmirror/modules/ce/src/app/common/nm/ems/js/* /usr/sbin/tejas/ems/js/tj2k/
cp -rf //home/prabhath/work/270614/HOST/xccmirror/tj100_mc/scripts/TZData.conf /usr/sbin/tejas/
cp -rf /home/prabhath/work/270614/HOST/xccmirror/tj100_mc/src/licenses/vendor/tj2k_vendor.dat /etc/tejas/config/
cd /home/prabhath/work/270614/HOST/xccmirror/tj100_mc/src/app/tj1700/nm/
gdb nm.d
