#!/bin/bash

#---------------------Running NM.d------------------------#

build=$1

user=${whoami}

if [ $# -ne 1 ]
then
echo "Usage : Enter The Base Directory "
fi

cd $build/tj100mc/src/sharedobj/

echo "Linking All Required Library"
echo "****************************"
echo " "
ln -s libnetsnmpagent.so libnetsnmpagent.so.30
ln -s libnetsnmpmibs.so libnetsnmpmibs.so.30
ln -s libnetsnmp.so libnetsnmp.so.30

echo "Copying All WEB-UI Files"
echo "************************"

echo "iltwat" | sudo -S su 

if [ "$user" == "root" ]
then
mkdir /usr/sbin/tejas/ems/js/treeview

cd $build/packages/treeview/

cp ftiens4.js ua.js /usr/sbin/tejas/ems/js/treeview/

cp $build/tj100_mc/src/app/common/nm/ems/js/treeview/NodeToc.js /usr/sbin/tejas/ems/js/treeview/

cp -r $build/tj100_mc/src/app/common/nm/ems/js/* /usr/sbin/tejas/ems/js/

cp $build/modules/ce/src/app/common/nm/ems/js/* /usr/sbin/tejas/ems/js/tj2k/

cp $build/tj100_mc/scripts/TZData.conf /usr/sbin/tejas/

cp $build/tj100_mc/src/licenses/vendor/tj2k_vendor.dat /etc/tejas/config/

cd $build/tj100_mc/src/app/cef4C/nm/

fi

#----------------------------------Kill SNMP & NM.d--------------------------#

echo "Killing snmp process"
echo "********************"
echo " "

echo "iltwat" | sudo -S pkill snmp

echo "Killing nm.d if running"
echo "***********************"
echo " "

echo "iltwat" | sudo -S pkill nm.d

#----------------------------------------------------------------------------#









