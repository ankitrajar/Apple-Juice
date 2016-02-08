#!/bin/bash

#***************************************************************#
# SCRIPT NAME : CRASH ANALYSIS                                  #
# AUTHOR      : ANKIT RAJ                                       #
# VERSION     : 1.0                                             #
# USAGE       : TO TRACE THE STACK DUMP UPON CRASH OF THE NODE  #
#               AND RETURN THE ERROR IN THE CODE BLOCK          #
#***************************************************************#

USER=$(whoami)

if [ "$USER" = "root" ]
then
echo "YOU ARE ROOT!"
echo "BECOME A NON-ROOT USER AND THEN RUN THE SCRIPT"
exit;
fi

if [ $# -ne "6" ]
then
echo " "
echo "ENTER REQUIRED FIELDS : "
echo " "
echo "============================================================================================================================="
echo " ANY PATH | MIRROR PATH | NODE IP : 192.168.143.243 | MAP IMG PATH | LOGFILE NAME : nmdlog001 | LOGERROR NAME : UNKNOWN / NM "
echo "============================================================================================================================="
echo " "
echo "   NOTE : COPY LOGFILE NAME FROM NODE WHICH HAS STACK DUMP"
echo "          IF RELEASE BUILD, THEN DOWNLOAD maps.tgz OF XCC TO LOCAL FOLDER & GIVE LOCAL PATH OF REL maps.tgz"
echo " "
exit;
fi

base_dir=$1         # ANY PATH
mirror_dir=$2       # MIRROR PATH
node_ip=$3          # NODE_IP
map_dir=$4          # MAP DIRECTORY
log=$5              # LOG FILE TO COPY
log_n=$6            # LOGFILE NAME

#GOTO BASE DIR
cd $base_dir

# CHECK TO SEE IF THE DIRECTORY ALREADY EXISTS OR NOT
if [ ! -d "crash_analysis" ]
then
echo " "
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "MAKING DIRECTORY crash_analysis IN DIRECTORY : $base_dir"
echo "++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo " "
mkdir crash_analysis
cd crash_analysis/
else
echo " " 
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo "DIRECTORY : crash_analysis ALREADY EXISTS SO GOING INSIDE DIRECTORY"
echo "+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
echo " "
cd crash_analysis/
# COPY STACKTRACE FILE
cp $mirror_dir/tj100_mc/scripts/StackTrace .

# COPY NM.MAPS FROM THE NODE
echo "+++++++++++++++++++++++++++++++"
echo "COPYING NM.MAPS FROM THE NODE :"
echo "+++++++++++++++++++++++++++++++"
echo " "
ncftpget -uguest -piltwat $node_ip . /etc/tejas/log/nm.maps
echo " "

# COPY LOGFILE WHICH HAS STACK DUMP
echo "++++++++++++++++++++++++++++++++++++++++++++++"
echo "COPYING THE LOGFILE WHICH HAS THE STACK DUMP :"
echo "++++++++++++++++++++++++++++++++++++++++++++++"
echo " "
ncftpget -uguest -piltwat $node_ip . /etc/tejas/log/$log
echo " "
fi

# CHECK TO SEE IF THE DIRECTORY ALREADY EXISTS OR NOT
if [ ! -d "maps" ]
then
mkdir maps
cd maps/
cp $map_dir .
tar -xvzf $map_dir
cd ../
else
echo "+++++++++++++++++++++++++++++++"
echo "DIRECTORY : maps ALREADY EXISTS"
echo "+++++++++++++++++++++++++++++++"
echo " "
fi

echo " "
echo "+++++++++++++++++++++++++++++++++"
echo "STARTING STACK TRACE FOR : $log_n"
echo "+++++++++++++++++++++++++++++++++"
echo " "

# SCRIPT TO STACK TRACE WITH LOGFILE AND LOGERROR NAME
./StackTrace TARGET $log $log_n 

echo " "
echo "+++++++++++++++++++++"
echo "MODIFYING READABILITY"
echo "+++++++++++++++++++++"
echo " "

# CMD TO MODIFYING READABILITY 
c++filt < crash_analysis

# END OF SCRIPT
