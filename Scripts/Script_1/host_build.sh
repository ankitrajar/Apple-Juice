#*********************************************************************************************#
# script to run Host_build Automaticaly for branch BR_6_2_9                                  # 
# Author: Ankit Raj                                                                           #
#*********************************************************************************************#

#!/bin/bash

#******Check For Root*********#

user=$(whoami)
    
if [ "$user" == "root" ]; then
echo "Do not patch with root priviledge";
exit;
fi
#******Check if User has done any input or not**********#
if [ $# -ne 2 ]
then 
echo "Usage : Enter your Base directory & Patch Directory"
echo "Base Dir :Example: /home/ankit/checkout/629/BR_6_2_9"
echo "Patch Dir :Example: /home/ankit/checkout/629/patch"
exit
fi

function up()
{ 
DEEP=$1; [ -z "${DEEP}" ] && { DEEP=1; }; for i in $(seq 1 ${DEEP}); do cd ../; done; 
}

scripts_path=/home/ankit/myscripts

function sms () 
{
mobile_no=$1
all_arg=$@
message=${all_arg#${mobile_no} }
python $scripts_path/python/sms_working.py "$mobile_no" "$message"
}

#function logkill () 
#{
#    regex='.*Error 1.*'
#        tail errorlog -n0 -F | while read line; do 
#        if [[ $line =~ $regex ]]; then 
#        pkill -9 -P $$ tail 
#        fi 
#        done
#        sms 7411199851 Build Break Due To Error
#}

basedir=$1  #Example /home/ankit/checkout/801/BR_8_0_1_a66_1
patchdir=$2 
mce=$basedir/modules/ce/

#----------------------Patching Automation In main Branch--------------------------#
cd $mce
echo " "
echo "Patching Module ce"
echo "******************"
patch -p1 -i $patchdir/ce.diff
echo " 0"
up 1

cd ethCommon/
echo "Patching ethCommon"
echo "******************"
patch -p1 -i $patchdir/ethCommon.diff
echo " "
up 1

cd ethTransport/
echo "Patching ethTransport"
echo "*********************"
patch -p1 -i $patchdir/ethTransport.diff
echo " "
up 2

cd tj100_mc/
echo "Patching tj100mc"
echo "****************"
patch -p1 -i $patchdir/tj100mc.diff
echo " "
echo "--------------------------------"
echo "All Patches Applied Successfully"
echo "--------------------------------"
echo " "
up 2

if [ -d "cef4c" ] 
then 
echo "Mirroring Not required "
else 
#----------------------Making Mirror----------------------------------------------#
echo "Making Mirror"
echo "*************"
echo " "
cd cm-utils
[ -d cef4c ] || ./mirror $PWD/../BR_6_2_9 $PWD/../cef4c
echo "Mirror Done"
echo " "
up 1
fi
#---------------------Removing sstream & string from tj100mc/src------------------#

echo "Entering Mirror"
echo "***************"
echo " "
cd cef4c/
cd tj100_mc/src/
echo "Removing sstream string"
echo "***********************"
echo " "
rm -f sstream string 
echo "-------------------"
echo "Operation Completed"
echo "-------------------"
echo " "
#--------------------Trigerring Host Build---------------------------------------#

up 2

cd tj100_mc/scripts/

echo "Sourcing Makeenv"
echo "****************"
echo " "
source makeenv
echo "Making Environment"
echo "******************"
echo " "
makeenv cef4C host LINUX26 $PWD/../src NO NO YES
echo " "
echo "Build Started"
echo "*************"
echo " "
tail -f errorlog; make -C $PWD/../src/app/cef4C/nm/ -j2 &>errorlog &  
sleep 2

#--------------------------------------Inform User---------------------------------#


