#!/bin/bash
user=$(whoami)
if [ "$user" != "root" ]; then
    echo "Can not run with non-root priviledge";
    exit;
fi

if [ $# -ne "2" ];then
echo Usages: checkout_path checkout_branch_name;
exit;
fi

echo "THIS SCRIPT WILL CREATE OTHER SCRIPTS";
checkout_path=$1;
checkout_branch_name=$2;
user="parmil"; ####user="$your_pc_username";
su_user="root";
home_path="/home/parmil"; ####home_path="$parent_path_of_checkout_path";
cm_utils_path="/home/parmil"; ####cm_utils_path="$your_cm_utils_path";

declare -a tj100_mc_diffs=\
(
#modify#tj100_mc#array#start
"BR_10_0_2"
"NEOS10_CEF5_DEV"
"BR_8_0_1"
#modify#tj100_mc#array#end
)

echo "Embedded tj100_mc_diffs are following";
for i in "${tj100_mc_diffs[@]}"
do
echo "$i"
done

tj100mc_diff_file_path="$home_path/$checkout_path/tj100mc_diffs_and_extra_files"; #edit only when automatic patching fails
tj100_mc_diff_file_name=""; #edit only when automatic patching fails and u want to give manual diff_path
if [ "$tj100_mc_diff_file_name" == "" ]; then
echo "tj100_mc_diff_file_name is null in script so trying to get it automatically";
case "$checkout_branch_name" in
#modify#tj100_mc#case#start

#modify#tj100_mc#case#BR_10_0_2#start 
  *BR_10_0_2*)
    tj100_mc_diff_file_name="tj100_mc_BR_10_0_2.diff";
    ;;
#modify#tj100_mc#case#BR_10_0_2#end

#modify#tj100_mc#case#NEOS10_CEF5_DEV#start
  *NEOS10_CEF5_DEV*)
    tj100_mc_diff_file_name="tj100_mc_NEOS10_CEF5_DEV.diff";
    ;;
#modify#tj100_mc#case#NEOS10_CEF5_DEV#end

#modify#tj100_mc#case#BR_8_0_1#start
  *BR_8_0_1*)
    tj100_mc_diff_file_name="tj100_mc_BR_8_0_1.diff";
    ;;
#modify#tj100_mc#case#BR_8_0_1#end

#modify#tj100_mc#case#end
   *)
    echo "We don't have $checkout_branch_name tj100mc diff.So please get tj100mc diff for $checkout_branch_name specify in ${0}";
    echo "Don't forget that there are two variables tj100mc_diff_file_path & tj100_mc_diff_file_name in ${0} give values accordingly.";
    exit 1;
esac
fi
echo "tj100_mc_diff_file_name is $tj100_mc_diff_file_name";
mirror_name="MIRROR_xcc360g";
scripts_path="$home_path/$checkout_path/simulator_scripts_for_$checkout_branch_name";
#here home path need not to be like /home/user kind of home path defined above is the base path where you want to make the folder 
#in which you are going to create checkout_path 
#structure is something like this. 
# $home_path/$checkout_path/$checkout_branch_name
# $home_path/$checkout_path/$mirror_name   (of above branch)
# this base_path is given so that if you don't have space in your /home/$USER then you can mention paths like 
# home_path=/drive1   now simulator will be created in the /drive1/CHECKOUTPATH/BRANCHNAME


rm /bin/sh
ln -s /bin/bash /bin/sh
lookup_path="$home_path/$checkout_path"
if [ -d $lookup_path ];then
   echo "$home_path/$checkout_path already exists. Please delete it or give a different checkout name(path)"
exit;
fi
su $user -c "mkdir -p $scripts_path";
su $user -c "mkdir -p $tj100mc_diff_file_path";

echo "GENERATING OTHER SCRIPTS AND TJ100MC DIFF FILES";
echo "Writing $scripts_path/checkoutnm_simulator.sh";
echo "\
user=\$(whoami)
if [ \"\$user\" == \"root\" ]; then
    echo \"Do not checkout with root priviledge\";
    exit;
fi

if [ \$# -ne \"6\" ];then
echo Usages: checkout_path checkout_branch_name home_path;
exit;
fi

checkout_path=\$1;
checkout_branch_name=\$2;
home_path=\$3;
cm_utils_path=\$4;
tj100mc_diff_file_path=\$5;
tj100_mc_diff_file_name=\$6;
mkdir \$home_path/\$checkout_path
cd \$home_path/\$checkout_path
\$cm_utils_path/cm-utils/checkout --dir=\$home_path/\$checkout_path/\$checkout_branch_name \$checkout_branch_name

echo \"Checkout is completed now will start patching nm simulator files with corresponding tj100mcdiff file\";

#    patch attached diff by :
cd \$home_path/\$checkout_path/\$checkout_branch_name/tj100_mc
patch -p1 -i \$tj100mc_diff_file_path/\$tj100_mc_diff_file_name
OUT=\$?
if [ \$OUT -eq 0 ];then
  echo \"Patching done successfully. No problem. :-) \"
else
   REP='n';
   echo \"Patching failed. Please patch manually using other shell. After patching manually enter C or c to continue.\"
   while [[ ! \$REP =~ ^[Cc] ]]; do
   echo \"If manually patched. Enter c or C to continue \";
   read REP
   done
fi
echo \"Continuing\";
echo \"Patch done Manually or automatically\";

" > $scripts_path/checkoutnm_simulator.sh;

echo "Writing $scripts_path/patch_and_mirror.sh";
echo "\
user=\$(whoami)
if [ \"\$user\" == \"root\" ]; then
    echo \"Do not patch with root priviledge\";
    exit;
fi

if [ \$# -ne \"5\" ];then
echo Usages: checkout_path checkout_branch_name home_path;
exit;
fi

checkout_path=\$1;
checkout_branch_name=\$2;
home_path=\$3;
cm_utils_path=\$4;
mirror_name=\$5;
#YOUR PATCHING HAPPENS HERE

#echo \"#patching the tj100_mc_diff\";
#cd \$home_path/\$checkout_path/\$checkout_branch_name/tj100_mc
#patch -p1 -i /home/parmil/Downloads/tj100_mc_diff

echo \"All patching done now will create mirror of it\";
\$cm_utils_path/cm-utils/mirror \$home_path/\$checkout_path/\$checkout_branch_name/ \$home_path/\$checkout_path/\$mirror_name


" > $scripts_path/patch_and_mirror.sh;

echo "Writing $scripts_path/compile_simulator.sh";
echo "\
user=\$(whoami)
if [ \"\$user\" == \"root\" ]; then
    echo \"Can not compile with root priviledge\";
    exit;
fi

if [ \$# -ne \"3\" ];then
echo Usages: checkout_path home_path;
exit;
fi

checkout_path=\$1;
home_path=\$2;
mirror_name=\$3;

init_time=\$(date)
cd \$home_path/\$checkout_path/\$mirror_name/tj100_mc/src
source ../scripts/makeenv
makeenv xcc360g host LINUX26 \$PWD NO YES YES
cd interfaces/
make
cd ..
./version.pl
cd app/tj1700/nm/
make
echo \"compilation started at  : \"\$init_time
echo \"compilation finished at : \"\$(date)

" > $scripts_path/compile_simulator.sh;

echo "Writing $scripts_path/onetime.sh";
echo "\
user=\$(whoami)
if [ \"\$user\" != \"root\" ]; then
    echo \"Can not run with non-root priviledge\";
    exit;
fi

if [ \$# -ne \"3\" ];then
echo Usages: checkout_path home_path;
exit;
fi

checkout_path=\$1;
home_path=\$2;
mirror_name=\$3;
echo \"One time setup script started\";

mkdir /etc/tejas
mkdir /etc/tejas/log
mkdir /etc/tejas/config
mkdir /etc/tejas/config/db
mkdir /etc/tejas/config/backup
mkdir /usr/sbin/tejas
mkdir /usr/sbin/tejas/ems
mkdir /usr/sbin/tejas/ems/js
mkdir /usr/sbin/tejas/ems/js/treeview
cd \$home_path/\$checkout_path/\$mirror_name/packages/treeview/

#// Please note that if you are modifying .js files then this is not one time work, you will have to copy them using commands below:
: << 'commentout'
#moving these lines to run_nm_xcc360.sh
cp -rf ftiens4.js ua.js /usr/sbin/tejas/ems/js/treeview/
cp -rf \$home_path/\$checkout_path/\$mirror_name/tj100_mc/src/app/common/nm/ems/js/treeview/NodeToc.js  /usr/sbin/tejas/ems/js/treeview/
cp -rf \$home_path/\$checkout_path/\$mirror_name/tj100_mc/src/app/common/nm/ems/js/* /usr/sbin/tejas/ems/js/
cp -rf \$home_path/\$checkout_path/\$mirror_name/modules/ce/src/app/common/nm/ems/js/* /usr/sbin/tejas/ems/js/tj2k/
cp -rf \$home_path/\$checkout_path/\$mirror_name/tj100_mc/scripts/TZData.conf /usr/sbin/tejas/
cp -rf \$home_path/\$checkout_path/\$mirror_name/tj100_mc/src/licenses/vendor/tj2k_vendor.dat /etc/tejas/config/
commentout


cp $tj100mc_diff_file_path/license.dat /etc/tejas/
cd \$home_path/\$checkout_path/\$mirror_name/tj100_mc/src/app/tj1700/nm/
echo \"One time setup completed\";

" > $scripts_path/onetime.sh;

echo "Writing $scripts_path/sidepanelnotworking.sh";
echo "\
user=\$(whoami)
if [ \"\$user\" != \"root\" ]; then
    echo \"Can not run with non-root priviledge\";
    exit;
fi

home_path=\$1;

mkdir \$home_path/sidepaneltmp
cd \$home_path/sidepaneltmp
#  //copy  \"tgz image for your control card\" from tn100build to your computer
# // Like for  REL_10_0_0_a15_1, i would do following :
ncftpget -uswtn100 -ptn100sw 192.168.0.14 . /home/swtn100/releases/REL_10_0_0/a_x/a15_1/builds/xcc360g-ppc-REL_10_0_0_a15_1.tgz
tar -xvzf xcc360g-ppc-REL_10_0_0_a15_1.tgz
#//tejas directory will be created.
cd tejas
cp -rf ems /usr/sbin/tejas
cd \$home_path
rm -rf \$home_path/sidepaneltmp

" > $scripts_path/sidepanelnotworking.sh;

echo "Writing $scripts_path/run_nm_simulator.sh";
echo "\
user=\$(whoami)
if [ \"\$user\" != \"root\" ]; then
    echo \"Can not run with non-root priviledge\";
    exit;
fi

if [ \$# -ne \"3\" ];then
echo Usages: checkout_path home_path;
exit;
fi

checkout_path=\$1;
home_path=\$2;
mirror_name=\$3;
echo Copy command executing
cd \$home_path/\$checkout_path/\$mirror_name/packages/treeview/

cp -rf ftiens4.js ua.js /usr/sbin/tejas/ems/js/treeview/
cp -rf \$home_path/\$checkout_path/\$mirror_name/tj100_mc/src/app/common/nm/ems/js/treeview/NodeToc.js  /usr/sbin/tejas/ems/js/treeview/
cp -rf \$home_path/\$checkout_path/\$mirror_name/tj100_mc/src/app/common/nm/ems/js/* /usr/sbin/tejas/ems/js/
cp -rf \$home_path/\$checkout_path/\$mirror_name/modules/ce/src/app/common/nm/ems/js/* /usr/sbin/tejas/ems/js/tj2k/
cp -rf \$home_path/\$checkout_path/\$mirror_name/tj100_mc/scripts/TZData.conf /usr/sbin/tejas/
cp -rf \$home_path/\$checkout_path/\$mirror_name/tj100_mc/src/licenses/vendor/tj2k_vendor.dat /etc/tejas/config/

cd \$home_path/\$checkout_path/\$mirror_name/tj100_mc/src/app/tj1700/nm/
echo Export commands executing
export HIGHTEMP_THRESHOLD=60
export SANITY_TIMEOUT=10000
export TJ_LICENSE_FILE=/etc/tejas/license.dat
export LD_LIBRARY_PATH=\$home_path/\$checkout_path/\$mirror_name/tj100_mc/src/sharedobj/
export WEB_SERVER_PORT=20080
export SNMP_LOG_LEVEL=0
export BP_EEPROM_ENABLE=YES
export ENABLE_HW_WATCHDOG=YES
export SIMULATOR=YES
export SIGD_TIMEOUT=180000

snmp_pids=\`ps -ef | grep -iw \"[s]nmpd\" | awk '{print \$2}'\`
nm_pids=\`ps -ef| grep -iw \"[n]m\.d\" | awk '{print \$2}'\`

echo Checking and killing snmpd if already running
if [ \"\$snmp_pids\" != \"\" ]; then
for signal in \"-15\" \"-1\" \"-9\"
do
  pids=\`ps -ef | grep -iw \"[s]nmpd\" | awk '{print \$2}'\`
  kill \$signal \$pids 2> /dev/null
  echo Killed pid \$pids with signal \$signal
done
fi

echo Checking if nm.d is already running and killing it.
if [ \"\$nm_pids\" !=  \"\" ]; then
for signal in \"-15\" \"-1\" \"-9\"
do
  pids=\`ps -ef| grep -iw \"[n]m\.d\" | awk '{print \$2}'\`
  kill \$signal \$pids 2> /dev/null
  echo Killed pid \$pids with signal \$signal
done
fi
echo No snmp or nm.d is running!!! Ready to launch nm.d

gdb nm.d

" > $scripts_path/run_nm_simulator.sh;

echo "Writing $scripts_path/simulator_master_script.sh";
echo "\
#!/bin/bash
user=\$(whoami)
if [ \"\$user\" != \"root\" ]; then
    echo \"Can not run with non-root priviledge\";
    exit;
fi

checkout_path=\"$1\";
checkout_branch_name=\"$2\";
option=\"\$1\";
user=\"$user\";
su_user=\"$su_user\";
home_path=\"$home_path\";
cm_utils_path=\"$cm_utils_path\";
tj100mc_diff_file_path=\"$tj100mc_diff_file_path\";
tj100_mc_diff_file_name=\"$tj100_mc_diff_file_name\";
mirror_name=\"$mirror_name\";
scripts_path=\"$scripts_path\";
tj100mc_diff_full_path=\$tj100mc_diff_file_path/\$tj100_mc_diff_file_name
if [ -f \$tj100mc_diff_full_path ];then
   echo \"\$tj100mc_diff_full_path exists. OK!!! :-) \"
else
echo \"\$tj100mc_diff_full_path doesn't exist. Please get a proper tj100mc diff for \$checkout_branch_name then try again. Bye Bye :(\"
exit;
fi

echo \$option
if [ \$# -ne \"1\" ];then
echo Usages: option;
echo Optoins: 
echo 1=all steps. 
echo 2=skip checkout and patching. start from compilation 
echo 3=similar to option 2 but sidepanelnotworking.sh script will not be run 
echo 4=just run the nm.d
exit;
fi

echo \"THIS SCRIPT WILL CREATE THE FINAL NM.D USING OTHER SCRIPTS\";

if [ \$option == \"1\" ];then

rm /bin/sh
ln -s /bin/bash /bin/sh
lookup_path=\"\$home_path/\$checkout_path/\$checkout_branch_name\"
if [ -d \$lookup_path ];then
   echo \"\$home_path/\$checkout_path/\$checkout_branch_name already exists. Please delete it or give a different checkout name(path)\"
exit;
fi
echo Using checkoutnm_simulator.sh checkingout after that patching also;
su \$user -c \"source \$scripts_path/checkoutnm_simulator.sh \$checkout_path \$checkout_branch_name \$home_path \$cm_utils_path \$tj100mc_diff_file_path \$tj100_mc_diff_file_name\";

echo Using \$scripts_path/patch_and_mirror.sh after patch creating mirror also;

su \$user -c \"source \$scripts_path/patch_and_mirror.sh \$checkout_path \$checkout_branch_name \$home_path \$cm_utils_path \$mirror_name\";

fi

if [ \$option \\< \"4\" ];then

echo Using \$scripts_path/compile_simulator.sh compiling till now without root

su \$user -c \"source \$scripts_path/compile_simulator.sh \$checkout_path \$home_path \$mirror_name\";

echo Now onwards all scripts will be running in root level

echo Using \$scripts_path/onetime.sh for onetime setup

source \$scripts_path/onetime.sh \$checkout_path \$home_path \$mirror_name

fi

if [ \$option \\< \"3\" ];then

echo Using \$scripts_path/sidepanelnotworking.sh so that sidepanel issue can be fixed

source \$scripts_path/sidepanelnotworking.sh \$home_path

fi

echo Using \$scripts_path/run_nm_simulator.sh to run nm

source \$scripts_path/run_nm_simulator.sh \$checkout_path \$home_path \$mirror_name

" > $scripts_path/simulator_master_script.sh;
echo "Generating tj100mc diffs in $tj100mc_diff_file_path";

#modify#tj100_mc#file#start

#modify#tj100_mc#file#BR_10_0_2#start
echo -n "diff --git a/src/DebugFrameWork/DebugMgr.cpp b/src/DebugFrameWork/DebugMgr.cpp
index c0dbff0..4e6b569 100755
--- a/src/DebugFrameWork/DebugMgr.cpp
+++ b/src/DebugFrameWork/DebugMgr.cpp
@@ -1,5 +1,9 @@
 #include <iomanip>
-#include <vector>
+#ifndef EMULATOR
+    #include <vector.h>
+#else
+    #include <vector>
+#endif
 #include <stdio.h>
 #include <ctype.h>
 #include <strings.h>
@@ -20,7 +24,9 @@
 #include <limits.h>
 #include <errno.h>
 #include <time.h>
-//#include <asm/user.h>
+#ifndef EMULATOR
+    #include <asm/user.h>
+#endif
 #include <sys/wait.h>
 #include <sched.h>
 #include <sys/resource.h>
diff --git a/src/DebugFrameWork/DebugMgr.h b/src/DebugFrameWork/DebugMgr.h
index 0ecd6d6..c35b269 100755
--- a/src/DebugFrameWork/DebugMgr.h
+++ b/src/DebugFrameWork/DebugMgr.h
@@ -13,7 +13,11 @@
 
 
 #include <bits/siginfo.h>
-#include <string>
+#ifndef EMULATOR
+ #include <string>
+#else
+#include <cstring>
+#endif
 #include <map>
 #include <sstream>
 #include \"SocketMgr.h\"
diff --git a/src/DebugFrameWork/SegHndlr.cpp b/src/DebugFrameWork/SegHndlr.cpp
index 9bad984..c30b722 100755
--- a/src/DebugFrameWork/SegHndlr.cpp
+++ b/src/DebugFrameWork/SegHndlr.cpp
@@ -187,12 +187,15 @@ void print_backtrace(int signum, siginfo_t * info, void *ptr)
     }
     while (bp && ip)
     {
+#ifndef EMULATOR
         if (!dladdr(ip, &dlinfo))
         {
          
           fprintf(stderr, \"could n't get symbol info:\\n\");
           break;
         }
+#else
+#endif
 
         const char *symname = dlinfo.dli_sname;
 
diff --git a/src/app/common/blocks/NetD/Netd_ECC_Agent/makefile b/src/app/common/blocks/NetD/Netd_ECC_Agent/makefile
index e28a385..5a0d808 100755
--- a/src/app/common/blocks/NetD/Netd_ECC_Agent/makefile
+++ b/src/app/common/blocks/NetD/Netd_ECC_Agent/makefile
@@ -34,7 +34,7 @@ ADDED_C++_INCLUDES = -I\$(SOFTWARE_ROOT)/hal/common \\
 					 -I\$(ETHCOMMON_ROOT) \\
 					 -I\$(ETHCOMMON_ROOT)/include \\
 					 -I\$(ETHCOMMON_ROOT)/hal/common
-ADDED_C++FLAGS = -DTHREADED -DCOSMO_CAL -Werror
+ADDED_C++FLAGS = -DTHREADED -DCOSMO_CAL 
 
 ################################################################################
 include \$(SOFTWARE_ROOT)/make/rules.tn100
diff --git a/src/app/common/blocks/NetD/Netd_Mgr/makefile b/src/app/common/blocks/NetD/Netd_Mgr/makefile
index ec2dabb..d1ee851 100644
--- a/src/app/common/blocks/NetD/Netd_Mgr/makefile
+++ b/src/app/common/blocks/NetD/Netd_Mgr/makefile
@@ -35,7 +35,7 @@ ADDED_C++_INCLUDES =-I \$(SOFTWARE_ROOT)/hal/common \\
                     -I \$(ETHCOMMON_ROOT) \\
                     -I \$(ETHCOMMON_ROOT)/include 
 
-ADDED_C++FLAGS = -DTHREADED -DCOSMO_CAL -Werror
+ADDED_C++FLAGS = -DTHREADED -DCOSMO_CAL 
 
 ################################################################################
 include \$(SOFTWARE_ROOT)/make/rules.tn100
diff --git a/src/app/common/blocks/dhcp/dhcp.cpp b/src/app/common/blocks/dhcp/dhcp.cpp
index 1957d2a..3696aac 100755
--- a/src/app/common/blocks/dhcp/dhcp.cpp
+++ b/src/app/common/blocks/dhcp/dhcp.cpp
@@ -1,8 +1,10 @@
 #include <string>
-#include <cstring>
 #include <stdio.h>
+#ifndef EMULATOR
+#include <string>
+#else
 #include <cstring>
-
+#endif
 #include \"dhcp.h\"
 static const string dhcp_config_file(\"/etc/tejas/config/dhcpd.conf\");
 static const string dhcp_leases_file(\"/etc/tejas/config/dhcpd.leases\");
diff --git a/src/app/common/nm/nm/webpages/genpages/datalib/makefile b/src/app/common/nm/nm/webpages/genpages/datalib/makefile
index 3630e07..4532861 100755
--- a/src/app/common/nm/nm/webpages/genpages/datalib/makefile
+++ b/src/app/common/nm/nm/webpages/genpages/datalib/makefile
@@ -10,7 +10,7 @@
 ################################################################################
 
 ADDED_C_INCLUDES = -I\$(SOFTWARE_ROOT)/app/common/nm
-ADDED_CFLAGS = #-Werror
+#ADDED_CFLAGS = #-Werror
 ADDED_C++_INCLUDES = \\
 	-I\$(SOFTWARE_ROOT)/app/common \\
 	-I\$(SOFTWARE_ROOT)/app/common/nm \\
@@ -18,7 +18,7 @@ ADDED_C++_INCLUDES = \\
 	-I\$(ETHTRANSPORT_ROOT)/include \\
 	-I\$(ETHCOMMON_ROOT)/include \\
 	-I\$(ETHCOMMON_ROOT)/app/common/nm
-ADDED_C++FLAGS = -Werror
+#ADDED_C++FLAGS = -Werror
 
 
 ################################################################################
diff --git a/src/app/common/nm/snmp/SnmpAgent.cpp b/src/app/common/nm/snmp/SnmpAgent.cpp
index 75241d7..7ed323f 100755
--- a/src/app/common/nm/snmp/SnmpAgent.cpp
+++ b/src/app/common/nm/snmp/SnmpAgent.cpp
@@ -50,6 +50,7 @@ Handle<SnmpAgent> SnmpAgent::getSnmpAgent()
 //------------------------------------------------------------------------
 
 extern string oemName;
+extern bool simulatorMode;
 
 static bool enableSNMPProvision ()
 {
@@ -59,6 +60,7 @@ static bool enableSNMPProvision ()
 extern NESecuritySettings *theNESecuritySettings;
 void SnmpAgent::run()
 {
+    if(simulatorMode) return;
 #ifdef NM_DBGMGR_SUPPORT
     DebugMgr::registerThreadId(\"SnmpAgent\",\"SnmpAgent listening thread\");
 #endif
diff --git a/src/cal/conn/UdpServerOS.h b/src/cal/conn/UdpServerOS.h
index e034fd1..936e1b5 100755
--- a/src/cal/conn/UdpServerOS.h
+++ b/src/cal/conn/UdpServerOS.h
@@ -3,7 +3,11 @@
 
 #include <iostream>
 #include <map>
+#ifndef EMULATOR
 #include <string>
+#else
+#include <cstring>
+#endif
 #include \"serverOS.h\"
 #include <include/tj_types.h>
 using namespace std;
diff --git a/src/hal/common/makefile b/src/hal/common/makefile
index 62989f1..7576ca3 100755
--- a/src/hal/common/makefile
+++ b/src/hal/common/makefile
@@ -44,7 +44,7 @@ ADDED_C++_INCLUDES = -I\$(SOFTWARE_ROOT)/hal/drivers/char \\
 ADDED_C++FLAGS = 
 
 ifneq (\$(MODE), EMULATOR)
-	ADDED_C++FLAGS += -Werror
+	ADDED_C++FLAGS += 
 endif
 
 \$(SOFTWARE_ROOT)/common/cardCharacteristics.o: ADDED_C++FLAGS += -fexceptions 
diff --git a/src/hal/devices/VtTermWrapper.cpp b/src/hal/devices/VtTermWrapper.cpp
index b62023a..4735cfc 100755
--- a/src/hal/devices/VtTermWrapper.cpp
+++ b/src/hal/devices/VtTermWrapper.cpp
@@ -471,7 +471,7 @@ VtTermWrapper::VtTermWrapper(vtTerm *vt_terms[], const UInt32 &num_vt_terms,
 vtTerm(vt_stm_multiplicity), numVtTerms(num_vt_terms)
 {
     vtTerms = new vtTerm *[num_vt_terms];
-    memcpy(vtTerms, vt_terms, (num_vt_terms * sizeof(vtTerm *)));
+    //memcpy(vtTerms, vt_terms, (num_vt_terms * sizeof(vtTerm *)));
     vtStmMultiplicity = vt_stm_multiplicity;
 
     callbackDataArray = new VtEventHandlerWrapper[numVtTerms];
diff --git a/src/lib/threadPool.cpp b/src/lib/threadPool.cpp
index 058d0ac..e4d156b 100755
--- a/src/lib/threadPool.cpp
+++ b/src/lib/threadPool.cpp
@@ -68,7 +68,7 @@ ThreadPool::ThreadPool(int num_threads)
     waitingForThreadResource = 0;
     mNumThreads = num_threads;
     sem_init(&ThreadPool::mSemThread, 0, 1);
-    SEM_WAIT(&ThreadPool::mSemThread) ; // Initial state is 1 (non-blocked)
+    SEM_WAIT(&mSemThread) ; // Initial state is 1 (non-blocked)
 }
 
 
@@ -175,7 +175,7 @@ threadElement* ThreadPool::getThread(char *name, int pri, void(*run)(void *),
                 TRC( \"ThreadPool::getThread: WaitingForThreadResource on Semaphore\");
             }
 
-            SEM_WAIT (&ThreadPool::mSemThread) ;
+            SEM_WAIT (&mSemThread) ;
         }
     }
     return t;
diff --git a/src/sstream b/src/sstream
deleted file mode 100755
index 45e05b1..0000000
--- a/src/sstream
+++ /dev/null
@@ -1,25 +0,0 @@
-#if __GNUC__ < 3
-#ifdef UNIX
-#include <stl/linuxsstream.h>
-#endif
-
-#ifdef VXWORKS 
-#include <stl/stringstream.h>
-#endif
-
-#ifdef WIN32
-#error
-#endif
-#else
-#if (__GNUC__ == 4 && __GNUC_MINOR__ >= 2)
-        #ifdef TCARD_EDC01 
-            #include \"/opt/MIPS/OCTEON-SDK/tools/mips64-octeon-linux-gnu/include/c++/4.3.3/sstream\"
-        #else
-#include \"/opt/ELDK42/ppc_85xx/usr/include/c++/4.2.2/sstream\"
-        #endif
-#else 
-#include \"/opt/ELDK41/ppc_6xx/usr/include/c++/4.0.0/sstream\"
-#endif
-#endif
-
-
diff --git a/src/string b/src/string
deleted file mode 100755
index 895d4a7..0000000
--- a/src/string
+++ /dev/null
@@ -1,20 +0,0 @@
-#if __GNUC__ < 3
-#ifdef WIN32
-#error
-#else
-#include <stl/std_string.h>
-#endif
-#else
-#if (__GNUC__ == 4 && __GNUC_MINOR__ >= 2)
-        #ifdef TCARD_EDC01 
-            #include \"/opt/MIPS/OCTEON-SDK/tools/mips64-octeon-linux-gnu/include/c++/4.3.3/string\"
-        #else
-#include \"/opt/ELDK42/ppc_85xx/usr/include/c++/4.2.2/string\"
-        #endif
-#else 
-#include \"/opt/ELDK41/ppc_6xx/usr/include/c++/4.0.0/string\"
-#endif
-    #include \"string.h\"
-#endif
-
-
" > $tj100mc_diff_file_path/tj100_mc_BR_10_0_2.diff
#modify#tj100_mc#file#BR_10_0_2#end

#modify#tj100_mc#file#NEOS10_CEF5_DEV#start
echo -n "diff --git a/src/DebugFrameWork/DebugMgr.cpp b/src/DebugFrameWork/DebugMgr.cpp
index 2ad571c..fa6d9e6 100755
--- a/src/DebugFrameWork/DebugMgr.cpp
+++ b/src/DebugFrameWork/DebugMgr.cpp
@@ -1,5 +1,9 @@
 #include <iomanip>
-#include <vector>
+#ifndef EMULATOR
+    #include <vector.h>
+#else
+    #include <vector>
+#endif
 #include <stdio.h>
 #include <ctype.h>
 #include <strings.h>
@@ -20,7 +24,9 @@
 #include <limits.h>
 #include <errno.h>
 #include <time.h>
-//#include <asm/user.h>
+#ifndef EMULATOR
+    #include <asm/user.h>
+#endif
 #include <sys/wait.h>
 #include <sched.h>
 #include <sys/resource.h>
diff --git a/src/DebugFrameWork/DebugMgr.h b/src/DebugFrameWork/DebugMgr.h
index 0cbd8b9..e91e540 100755
--- a/src/DebugFrameWork/DebugMgr.h
+++ b/src/DebugFrameWork/DebugMgr.h
@@ -13,7 +13,11 @@
 
 
 #include <bits/siginfo.h>
-#include <string>
+#ifndef EMULATOR
+ #include <string>
+#else
+#include <cstring>
+#endif
 #include <map>
 #include <sstream>
 #include \"SocketMgr.h\"
diff --git a/src/DebugFrameWork/SegHndlr.cpp b/src/DebugFrameWork/SegHndlr.cpp
index 3b83b5f..5a84c8c 100755
--- a/src/DebugFrameWork/SegHndlr.cpp
+++ b/src/DebugFrameWork/SegHndlr.cpp
@@ -187,12 +187,15 @@ void print_backtrace(int signum, siginfo_t * info, void *ptr)
     }
     while (bp && ip)
     {
+#ifndef EMULATOR
         if (!dladdr(ip, &dlinfo))
         {
          
           fprintf(stderr, \"could n't get symbol info:\\n\");
           break;
         }
+#else
+#endif
 
         const char *symname = dlinfo.dli_sname;
 
diff --git a/src/app/common/blocks/NetD/Netd_ECC_Agent/makefile b/src/app/common/blocks/NetD/Netd_ECC_Agent/makefile
index e28a385..5a0d808 100755
--- a/src/app/common/blocks/NetD/Netd_ECC_Agent/makefile
+++ b/src/app/common/blocks/NetD/Netd_ECC_Agent/makefile
@@ -34,7 +34,7 @@ ADDED_C++_INCLUDES = -I\$(SOFTWARE_ROOT)/hal/common \\
 					 -I\$(ETHCOMMON_ROOT) \\
 					 -I\$(ETHCOMMON_ROOT)/include \\
 					 -I\$(ETHCOMMON_ROOT)/hal/common
-ADDED_C++FLAGS = -DTHREADED -DCOSMO_CAL -Werror
+ADDED_C++FLAGS = -DTHREADED -DCOSMO_CAL 
 
 ################################################################################
 include \$(SOFTWARE_ROOT)/make/rules.tn100
diff --git a/src/app/common/blocks/NetD/Netd_Mgr/makefile b/src/app/common/blocks/NetD/Netd_Mgr/makefile
index cc192c2..8b5108b 100644
--- a/src/app/common/blocks/NetD/Netd_Mgr/makefile
+++ b/src/app/common/blocks/NetD/Netd_Mgr/makefile
@@ -35,7 +35,7 @@ ADDED_C++_INCLUDES =-I \$(SOFTWARE_ROOT)/hal/common \\
                     -I \$(ETHCOMMON_ROOT) \\
                     -I \$(ETHCOMMON_ROOT)/include 
 
-ADDED_C++FLAGS = -DTHREADED -DCOSMO_CAL -Werror
+ADDED_C++FLAGS = -DTHREADED -DCOSMO_CAL 
 
 ################################################################################
 include \$(SOFTWARE_ROOT)/make/rules.tn100
diff --git a/src/app/common/blocks/dhcp/dhcp.cpp b/src/app/common/blocks/dhcp/dhcp.cpp
index 1957d2a..3696aac 100755
--- a/src/app/common/blocks/dhcp/dhcp.cpp
+++ b/src/app/common/blocks/dhcp/dhcp.cpp
@@ -1,8 +1,10 @@
 #include <string>
-#include <cstring>
 #include <stdio.h>
+#ifndef EMULATOR
+#include <string>
+#else
 #include <cstring>
-
+#endif
 #include \"dhcp.h\"
 static const string dhcp_config_file(\"/etc/tejas/config/dhcpd.conf\");
 static const string dhcp_leases_file(\"/etc/tejas/config/dhcpd.leases\");
diff --git a/src/app/common/nm/nm/webpages/genpages/datalib/makefile b/src/app/common/nm/nm/webpages/genpages/datalib/makefile
index adc2614..84bebc4 100755
--- a/src/app/common/nm/nm/webpages/genpages/datalib/makefile
+++ b/src/app/common/nm/nm/webpages/genpages/datalib/makefile
@@ -17,7 +17,7 @@ ADDED_C++_INCLUDES = \\
 	-I\$(SWITCHING_ROOT)/app/common/nm \\
 	-I\$(ETHTRANSPORT_ROOT)/include \\
 	-I\$(ETHCOMMON_ROOT)/include
-ADDED_C++FLAGS = -Werror
+ADDED_C++FLAGS = 
 
 
 ################################################################################
diff --git a/src/app/tj1700/nm/impl/tj1700Shelf.cpp b/src/app/tj1700/nm/impl/tj1700Shelf.cpp
index bffb159..289b86f 100755
--- a/src/app/tj1700/nm/impl/tj1700Shelf.cpp
+++ b/src/app/tj1700/nm/impl/tj1700Shelf.cpp
@@ -41,7 +41,7 @@ Handle<Card> TJ1700ShelfImpl::getSelfCard()
 {
 	int slot,self_slot;
     SystemVariantType sysType;
-    mChassisMgr->getSystemType(sysType);
+    //mChassisMgr->getSystemType(sysType);
 
     if ( SYSTEM_TJ16006 == sysType )
         self_slot = TJ16006_PSS1_SLOT_NO;
@@ -72,7 +72,7 @@ bool TJ1700ShelfImpl::CardCreationPreCondition(unsigned slot, unsigned  cardtype
             slot);
 
     SystemVariantType sysType;
-    mChassisMgr->getSystemType(sysType);
+    //mChassisMgr->getSystemType(sysType);
 
     switch (cardtype){
         case Card::card_BackPlane:
diff --git a/src/cal/conn/UdpServerOS.h b/src/cal/conn/UdpServerOS.h
index e034fd1..936e1b5 100755
--- a/src/cal/conn/UdpServerOS.h
+++ b/src/cal/conn/UdpServerOS.h
@@ -3,7 +3,11 @@
 
 #include <iostream>
 #include <map>
+#ifndef EMULATOR
 #include <string>
+#else
+#include <cstring>
+#endif
 #include \"serverOS.h\"
 #include <include/tj_types.h>
 using namespace std;
diff --git a/src/hal/common/makefile b/src/hal/common/makefile
index 8b4e710..5b346dc 100755
--- a/src/hal/common/makefile
+++ b/src/hal/common/makefile
@@ -44,7 +44,7 @@ ADDED_C++_INCLUDES = -I\$(SOFTWARE_ROOT)/hal/drivers/char \\
 ADDED_C++FLAGS = 
 
 ifneq (\$(MODE), EMULATOR)
-	ADDED_C++FLAGS += -Werror
+	ADDED_C++FLAGS += 
 endif
 
 \$(SOFTWARE_ROOT)/common/cardCharacteristics.o: ADDED_C++FLAGS += -fexceptions 
diff --git a/src/hal/devices/VtTermWrapper.cpp b/src/hal/devices/VtTermWrapper.cpp
index b62023a..4735cfc 100755
--- a/src/hal/devices/VtTermWrapper.cpp
+++ b/src/hal/devices/VtTermWrapper.cpp
@@ -471,7 +471,7 @@ VtTermWrapper::VtTermWrapper(vtTerm *vt_terms[], const UInt32 &num_vt_terms,
 vtTerm(vt_stm_multiplicity), numVtTerms(num_vt_terms)
 {
     vtTerms = new vtTerm *[num_vt_terms];
-    memcpy(vtTerms, vt_terms, (num_vt_terms * sizeof(vtTerm *)));
+    //memcpy(vtTerms, vt_terms, (num_vt_terms * sizeof(vtTerm *)));
     vtStmMultiplicity = vt_stm_multiplicity;
 
     callbackDataArray = new VtEventHandlerWrapper[numVtTerms];
diff --git a/src/lib/threadPool.cpp b/src/lib/threadPool.cpp
index 058d0ac..e4d156b 100755
--- a/src/lib/threadPool.cpp
+++ b/src/lib/threadPool.cpp
@@ -68,7 +68,7 @@ ThreadPool::ThreadPool(int num_threads)
     waitingForThreadResource = 0;
     mNumThreads = num_threads;
     sem_init(&ThreadPool::mSemThread, 0, 1);
-    SEM_WAIT(&ThreadPool::mSemThread) ; // Initial state is 1 (non-blocked)
+    SEM_WAIT(&mSemThread) ; // Initial state is 1 (non-blocked)
 }
 
 
@@ -175,7 +175,7 @@ threadElement* ThreadPool::getThread(char *name, int pri, void(*run)(void *),
                 TRC( \"ThreadPool::getThread: WaitingForThreadResource on Semaphore\");
             }
 
-            SEM_WAIT (&ThreadPool::mSemThread) ;
+            SEM_WAIT (&mSemThread) ;
         }
     }
     return t;
diff --git a/src/sstream b/src/sstream
deleted file mode 100755
index 7fbb6ba..0000000
--- a/src/sstream
+++ /dev/null
@@ -1,19 +0,0 @@
-#if __GNUC__ < 3
-#ifdef UNIX
-#include <stl/linuxsstream.h>
-#endif
-
-#ifdef VXWORKS 
-#include <stl/stringstream.h>
-#endif
-
-#ifdef WIN32
-#error
-#endif
-#else
-#if (__GNUC__ == 4 && __GNUC_MINOR__ >= 2)
-#include \"/opt/ELDK42/ppc_85xx/usr/include/c++/4.2.2/sstream\"
-#else 
-#include \"/opt/ELDK41/ppc_6xx/usr/include/c++/4.0.0/sstream\"
-#endif
-#endif
diff --git a/src/string b/src/string
deleted file mode 100755
index 9ac4e0b..0000000
--- a/src/string
+++ /dev/null
@@ -1,14 +0,0 @@
-#if __GNUC__ < 3
-#ifdef WIN32
-#error
-#else
-#include <stl/std_string.h>
-#endif
-#else
-#if (__GNUC__ == 4 && __GNUC_MINOR__ >= 2)
-#include \"/opt/ELDK42/ppc_85xx/usr/include/c++/4.2.2/string\"
-#else 
-#include \"/opt/ELDK41/ppc_6xx/usr/include/c++/4.0.0/string\"
-#endif
-#endif
-
" > $tj100mc_diff_file_path/tj100_mc_NEOS10_CEF5_DEV.diff
#modify#tj100_mc#file#NEOS10_CEF5_DEV#end

#modify#tj100_mc#file#BR_8_0_1#start
echo -n "diff --git a/src/DebugFrameWork/DebugMgr.cpp b/src/DebugFrameWork/DebugMgr.cpp
index 2ad571c..fa6d9e6 100755
--- a/src/DebugFrameWork/DebugMgr.cpp
+++ b/src/DebugFrameWork/DebugMgr.cpp
@@ -1,5 +1,9 @@
 #include <iomanip>
-#include <vector>
+#ifndef EMULATOR
+    #include <vector.h>
+#else
+    #include <vector>
+#endif
 #include <stdio.h>
 #include <ctype.h>
 #include <strings.h>
@@ -20,7 +24,9 @@
 #include <limits.h>
 #include <errno.h>
 #include <time.h>
-//#include <asm/user.h>
+#ifndef EMULATOR
+    #include <asm/user.h>
+#endif
 #include <sys/wait.h>
 #include <sched.h>
 #include <sys/resource.h>
diff --git a/src/DebugFrameWork/DebugMgr.h b/src/DebugFrameWork/DebugMgr.h
index 0cbd8b9..e91e540 100755
--- a/src/DebugFrameWork/DebugMgr.h
+++ b/src/DebugFrameWork/DebugMgr.h
@@ -13,7 +13,11 @@
 
 
 #include <bits/siginfo.h>
-#include <string>
+#ifndef EMULATOR
+ #include <string>
+#else
+#include <cstring>
+#endif
 #include <map>
 #include <sstream>
 #include \"SocketMgr.h\"
diff --git a/src/DebugFrameWork/SegHndlr.cpp b/src/DebugFrameWork/SegHndlr.cpp
index a4d85b9..d36b381 100755
--- a/src/DebugFrameWork/SegHndlr.cpp
+++ b/src/DebugFrameWork/SegHndlr.cpp
@@ -187,12 +187,15 @@ void print_backtrace(int signum, siginfo_t * info, void *ptr)
     }
     while (bp && ip)
     {
+#ifndef EMULATOR
         if (!dladdr(ip, &dlinfo))
         {
          
           fprintf(stderr, \"could n't get symbol info:\\n\");
           break;
         }
+#else
+#endif
 
         const char *symname = dlinfo.dli_sname;
 
diff --git a/src/app/common/blocks/NetD/Netd_ECC_Agent/makefile b/src/app/common/blocks/NetD/Netd_ECC_Agent/makefile
index e28a385..5a0d808 100755
--- a/src/app/common/blocks/NetD/Netd_ECC_Agent/makefile
+++ b/src/app/common/blocks/NetD/Netd_ECC_Agent/makefile
@@ -34,7 +34,7 @@ ADDED_C++_INCLUDES = -I\$(SOFTWARE_ROOT)/hal/common \\
 					 -I\$(ETHCOMMON_ROOT) \\
 					 -I\$(ETHCOMMON_ROOT)/include \\
 					 -I\$(ETHCOMMON_ROOT)/hal/common
-ADDED_C++FLAGS = -DTHREADED -DCOSMO_CAL -Werror
+ADDED_C++FLAGS = -DTHREADED -DCOSMO_CAL 
 
 ################################################################################
 include \$(SOFTWARE_ROOT)/make/rules.tn100
diff --git a/src/app/common/blocks/NetD/Netd_Mgr/makefile b/src/app/common/blocks/NetD/Netd_Mgr/makefile
index cc192c2..8b5108b 100644
--- a/src/app/common/blocks/NetD/Netd_Mgr/makefile
+++ b/src/app/common/blocks/NetD/Netd_Mgr/makefile
@@ -35,7 +35,7 @@ ADDED_C++_INCLUDES =-I \$(SOFTWARE_ROOT)/hal/common \\
                     -I \$(ETHCOMMON_ROOT) \\
                     -I \$(ETHCOMMON_ROOT)/include 
 
-ADDED_C++FLAGS = -DTHREADED -DCOSMO_CAL -Werror
+ADDED_C++FLAGS = -DTHREADED -DCOSMO_CAL 
 
 ################################################################################
 include \$(SOFTWARE_ROOT)/make/rules.tn100
diff --git a/src/app/common/blocks/dhcp/dhcp.cpp b/src/app/common/blocks/dhcp/dhcp.cpp
index 1957d2a..3696aac 100755
--- a/src/app/common/blocks/dhcp/dhcp.cpp
+++ b/src/app/common/blocks/dhcp/dhcp.cpp
@@ -1,8 +1,10 @@
 #include <string>
-#include <cstring>
 #include <stdio.h>
+#ifndef EMULATOR
+#include <string>
+#else
 #include <cstring>
-
+#endif
 #include \"dhcp.h\"
 static const string dhcp_config_file(\"/etc/tejas/config/dhcpd.conf\");
 static const string dhcp_leases_file(\"/etc/tejas/config/dhcpd.leases\");
diff --git a/src/app/common/nm/nm/webpages/genpages/datalib/makefile b/src/app/common/nm/nm/webpages/genpages/datalib/makefile
index adc2614..84bebc4 100755
--- a/src/app/common/nm/nm/webpages/genpages/datalib/makefile
+++ b/src/app/common/nm/nm/webpages/genpages/datalib/makefile
@@ -17,7 +17,7 @@ ADDED_C++_INCLUDES = \\
 	-I\$(SWITCHING_ROOT)/app/common/nm \\
 	-I\$(ETHTRANSPORT_ROOT)/include \\
 	-I\$(ETHCOMMON_ROOT)/include
-ADDED_C++FLAGS = -Werror
+ADDED_C++FLAGS = 
 
 
 ################################################################################
diff --git a/src/app/tj1700/nm/impl/tj1700Shelf.cpp b/src/app/tj1700/nm/impl/tj1700Shelf.cpp
index 57c9fcb..fcb6787 100755
--- a/src/app/tj1700/nm/impl/tj1700Shelf.cpp
+++ b/src/app/tj1700/nm/impl/tj1700Shelf.cpp
@@ -310,61 +310,72 @@ void TJ1700ShelfImpl::createSimulatedCards(const string & /* nodeConfStr */)
         //createMibCard(1, Card::card_AGG21, nullString, true);
         //createMibCard(2, Card::card_TET126, nullString, true);
         //createMibCard(3, Card::card_AGG20, \"\\t-NumOfSTM64s\\t2\", true);
-		Handle<Card_ELAN04> hElan04Card;
+        Handle<Card_ELAN04> hElan04Card;
+        Handle<Card> hCEF5Card;
 
-		{
-		Handle<Card> hCEF5Card;
-        createMibCard(1, Card::card_CEF5, nullString, true);
-        hCEF5Card = getCard(1);
-        hElan04Card = DYNAMIC_CAST<Card, Card_ELAN04>(hCEF5Card);
-        if (hElan04Card)
         {
-            hElan04Card->setValues(\"\\t-NumOfFEPorts\\t16\\t-NumOfGEPorts\\t4\\t-NumOfEthernetPorts\\t20\\t-NumOfVCGPorts\\t10\");
-            hElan04Card->setNumOfVCGPorts(20);
-            hElan04Card->setNumOfSFPports(0);
-            hElan04Card->setNumOfTwistedPairPorts(16);
-            tjAssertMessage(hElan04Card->verify(), __FUNCTION__
-                    << \": verify() failed for setting Elan04Card params in slot 1\");
-            hElan04Card->commit(pluginUser);
+            createMibCard(1, Card::card_CEF5, nullString, true);
+            hCEF5Card = getCard(1);
+            hElan04Card = DYNAMIC_CAST<Card, Card_ELAN04>(hCEF5Card);
+            if (hElan04Card)
+            {
+                hElan04Card->setValues(\"\\t-NumOfFEPorts\\t16\\t-NumOfGEPorts\\t4\\t-NumOfEthernetPorts\\t20\\t-NumOfVCGPorts\\t10\");
+                hElan04Card->setNumOfVCGPorts(0);
+                hElan04Card->setNumOfSFPports(0);
+                hElan04Card->setNumOfTwistedPairPorts(16);
+                tjAssertMessage(hElan04Card->verify(), __FUNCTION__
+                        << \": verify() failed for setting Elan04Card params in slot 1\");
+                hElan04Card->commit(pluginUser);
+            }
         }
-		}
-		{
+        {
+            createMibCard(2, Card::card_CEF5, nullString, true);
+            hCEF5Card = getCard(2);
+            hElan04Card = DYNAMIC_CAST<Card, Card_ELAN04>(hCEF5Card);
+            if (hElan04Card)
+            {
+                hElan04Card->setValues(\"\\t-NumOfFEPorts\\t16\\t-NumOfGEPorts\\t4\\t-NumOfEthernetPorts\\t20\\t-NumOfVCGPorts\\t10\");
+                hElan04Card->setNumOfVCGPorts(0);
+                hElan04Card->setNumOfSFPports(0);
+                hElan04Card->setNumOfTwistedPairPorts(16);
+                tjAssertMessage(hElan04Card->verify(), __FUNCTION__
+                        << \": verify() failed for setting Elan04Card params in slot 2\");
+                hElan04Card->commit(pluginUser);
+            }
 
-			Handle<Card> hCEF5Card;
-        createMibCard(2, Card::card_CEF5, nullString, true);
-        hCEF5Card = getCard(2);
-        hElan04Card = DYNAMIC_CAST<Card, Card_ELAN04>(hCEF5Card);
-        if (hElan04Card)
+        }
         {
-            hElan04Card->setValues(\"\\t-NumOfFEPorts\\t16\\t-NumOfGEPorts\\t4\\t-NumOfEthernetPorts\\t20\\t-NumOfVCGPorts\\t10\");
-            hElan04Card->setNumOfVCGPorts(20);
-            hElan04Card->setNumOfSFPports(0);
-            hElan04Card->setNumOfTwistedPairPorts(16);
-            tjAssertMessage(hElan04Card->verify(), __FUNCTION__
-                    << \": verify() failed for setting Elan04Card params in slot 2\");
-            hElan04Card->commit(pluginUser);
+            createMibCard(3, Card::card_CEF5, nullString, true);
+            hCEF5Card = getCard(3);
+            hElan04Card = DYNAMIC_CAST<Card, Card_ELAN04>(hCEF5Card);
+            if (hElan04Card)
+            {
+                hElan04Card->setValues(\"\\t-NumOfFEPorts\\t16\\t-NumOfGEPorts\\t4\\t-NumOfEthernetPorts\\t20\\t-NumOfVCGPorts\\t10\");
+                hElan04Card->setNumOfVCGPorts(0);
+                hElan04Card->setNumOfSFPports(0);
+                hElan04Card->setNumOfTwistedPairPorts(16);
+                tjAssertMessage(hElan04Card->verify(), __FUNCTION__
+                        << \": verify() failed for setting Elan04Card params in slot 3\");
+                hElan04Card->commit(pluginUser);
+            }
         }
-
-		}
-		{
-		Handle<Card> hCEF5Card;
-        createMibCard(3, Card::card_CEF5, nullString, true);
-        hCEF5Card = getCard(3);
-        hElan04Card = DYNAMIC_CAST<Card, Card_ELAN04>(hCEF5Card);
-        if (hElan04Card)
         {
-            hElan04Card->setValues(\"\\t-NumOfFEPorts\\t16\\t-NumOfGEPorts\\t4\\t-NumOfEthernetPorts\\t20\\t-NumOfVCGPorts\\t10\");
-            hElan04Card->setNumOfVCGPorts(20);
-            hElan04Card->setNumOfSFPports(0);
-            hElan04Card->setNumOfTwistedPairPorts(16);
-            tjAssertMessage(hElan04Card->verify(), __FUNCTION__
-                    << \": verify() failed for setting Elan04Card params in slot 3\");
-            hElan04Card->commit(pluginUser);
+            createMibCard(4, Card::card_CEF5, nullString, true);
+            hCEF5Card = getCard(4);
+            hElan04Card = DYNAMIC_CAST<Card, Card_ELAN04>(hCEF5Card);
+            if (hElan04Card)
+            {
+                hElan04Card->setValues(\"\\t-NumOfFEPorts\\t16\\t-NumOfGEPorts\\t4\\t-NumOfEthernetPorts\\t20\\t-NumOfVCGPorts\\t10\");
+                hElan04Card->setNumOfVCGPorts(0);
+                hElan04Card->setNumOfSFPports(0);
+                hElan04Card->setNumOfTwistedPairPorts(16);
+                tjAssertMessage(hElan04Card->verify(), __FUNCTION__
+                        << \": verify() failed for setting Elan04Card params in slot 3\");
+                hElan04Card->commit(pluginUser);
+            }
         }
-		}
-
-        createMibCard(4, Card::card_AGG20, \"\\t-NumOfSTM64s\\t2\", true);
-        createMibCard(7, Card::card_AGG40, nullString, true);
+        //createMibCard(4, Card::card_AGG20, \"\\t-NumOfSTM64s\\t2\", true);
+        //createMibCard(7, Card::card_AGG40, nullString, true);
         //createMibCard(7, Card::card_AGG20, \"\\t-NumOfSTM64s\\t2\", true);
 #ifdef L2_SWITCHING_SUPPORT
         Handle<Card> hCard;
@@ -399,15 +410,27 @@ void TJ1700ShelfImpl::createSimulatedCards(const string & /* nodeConfStr */)
                     << \": verify() failed for setting Elan04Card params in slot 9\");
             hElan04Card->commit(pluginUser);
         }
-
-        Handle<Card> hCEF5Card;
+       /* 
+        createMibCard(9, Card::card_CEF5, nullString, true);
+        hCEF5Card = getCard(9);
+        hElan04Card = DYNAMIC_CAST<Card, Card_ELAN04>(hCEF5Card);
+        if (hElan04Card) {
+            hElan04Card->setValues(\"\\t-NumOfFEPorts\\t16\\t-NumOfGEPorts\\t4\\t-NumOfEthernetPorts\\t20\");
+            hElan04Card->setNumOfVCGPorts(0);
+            hElan04Card->setNumOfSFPports(0);
+            hElan04Card->setNumOfTwistedPairPorts(16);
+            tjAssertMessage(hElan04Card->verify(), __FUNCTION__
+                    << \": verify() failed for setting Elan04Card params in slot 9\");
+            hElan04Card->commit(pluginUser);
+        }
+*/
         createMibCard(10, Card::card_CEF5, nullString, true);
         hCEF5Card = getCard(10);
         hElan04Card = DYNAMIC_CAST<Card, Card_ELAN04>(hCEF5Card);
         if (hElan04Card)
         {
-            hElan04Card->setValues(\"\\t-NumOfFEPorts\\t16\\t-NumOfGEPorts\\t4\\t-NumOfEthernetPorts\\t20\\t-NumOfVCGPorts\\t10\");
-            hElan04Card->setNumOfVCGPorts(20);
+            hElan04Card->setValues(\"\\t-NumOfFEPorts\\t16\\t-NumOfGEPorts\\t4\\t-NumOfEthernetPorts\\t20\");
+            hElan04Card->setNumOfVCGPorts(0);
             hElan04Card->setNumOfSFPports(0);
             hElan04Card->setNumOfTwistedPairPorts(16);
             tjAssertMessage(hElan04Card->verify(), __FUNCTION__
@@ -416,6 +439,8 @@ void TJ1700ShelfImpl::createSimulatedCards(const string & /* nodeConfStr */)
         }
 
 #else
+		createMibCard(2, Card::card_AGG21, nullString, true);
+		createMibCard(3, Card::card_AGG21, nullString, true);
 		createMibCard(9, Card::card_AGG21, nullString, true);
         createMibCard(10, Card::card_AGG21, nullString, true);
 #endif
diff --git a/src/cal/conn/UdpServerOS.h b/src/cal/conn/UdpServerOS.h
index e034fd1..936e1b5 100755
--- a/src/cal/conn/UdpServerOS.h
+++ b/src/cal/conn/UdpServerOS.h
@@ -3,7 +3,11 @@
 
 #include <iostream>
 #include <map>
+#ifndef EMULATOR
 #include <string>
+#else
+#include <cstring>
+#endif
 #include \"serverOS.h\"
 #include <include/tj_types.h>
 using namespace std;
diff --git a/src/hal/common/makefile b/src/hal/common/makefile
index 8b4e710..5b346dc 100755
--- a/src/hal/common/makefile
+++ b/src/hal/common/makefile
@@ -44,7 +44,7 @@ ADDED_C++_INCLUDES = -I\$(SOFTWARE_ROOT)/hal/drivers/char \\
 ADDED_C++FLAGS = 
 
 ifneq (\$(MODE), EMULATOR)
-	ADDED_C++FLAGS += -Werror
+	ADDED_C++FLAGS += 
 endif
 
 \$(SOFTWARE_ROOT)/common/cardCharacteristics.o: ADDED_C++FLAGS += -fexceptions 
diff --git a/src/hal/devices/VtTermWrapper.cpp b/src/hal/devices/VtTermWrapper.cpp
index b62023a..4735cfc 100755
--- a/src/hal/devices/VtTermWrapper.cpp
+++ b/src/hal/devices/VtTermWrapper.cpp
@@ -471,7 +471,7 @@ VtTermWrapper::VtTermWrapper(vtTerm *vt_terms[], const UInt32 &num_vt_terms,
 vtTerm(vt_stm_multiplicity), numVtTerms(num_vt_terms)
 {
     vtTerms = new vtTerm *[num_vt_terms];
-    memcpy(vtTerms, vt_terms, (num_vt_terms * sizeof(vtTerm *)));
+    //memcpy(vtTerms, vt_terms, (num_vt_terms * sizeof(vtTerm *)));
     vtStmMultiplicity = vt_stm_multiplicity;
 
     callbackDataArray = new VtEventHandlerWrapper[numVtTerms];
diff --git a/src/lib/threadPool.cpp b/src/lib/threadPool.cpp
index 058d0ac..e4d156b 100755
--- a/src/lib/threadPool.cpp
+++ b/src/lib/threadPool.cpp
@@ -68,7 +68,7 @@ ThreadPool::ThreadPool(int num_threads)
     waitingForThreadResource = 0;
     mNumThreads = num_threads;
     sem_init(&ThreadPool::mSemThread, 0, 1);
-    SEM_WAIT(&ThreadPool::mSemThread) ; // Initial state is 1 (non-blocked)
+    SEM_WAIT(&mSemThread) ; // Initial state is 1 (non-blocked)
 }
 
 
@@ -175,7 +175,7 @@ threadElement* ThreadPool::getThread(char *name, int pri, void(*run)(void *),
                 TRC( \"ThreadPool::getThread: WaitingForThreadResource on Semaphore\");
             }
 
-            SEM_WAIT (&ThreadPool::mSemThread) ;
+            SEM_WAIT (&mSemThread) ;
         }
     }
     return t;
diff --git a/src/sstream b/src/sstream
deleted file mode 100755
index 7fbb6ba..0000000
--- a/src/sstream
+++ /dev/null
@@ -1,19 +0,0 @@
-#if __GNUC__ < 3
-#ifdef UNIX
-#include <stl/linuxsstream.h>
-#endif
-
-#ifdef VXWORKS 
-#include <stl/stringstream.h>
-#endif
-
-#ifdef WIN32
-#error
-#endif
-#else
-#if (__GNUC__ == 4 && __GNUC_MINOR__ >= 2)
-#include \"/opt/ELDK42/ppc_85xx/usr/include/c++/4.2.2/sstream\"
-#else 
-#include \"/opt/ELDK41/ppc_6xx/usr/include/c++/4.0.0/sstream\"
-#endif
-#endif
diff --git a/src/string b/src/string
deleted file mode 100755
index 9ac4e0b..0000000
--- a/src/string
+++ /dev/null
@@ -1,14 +0,0 @@
-#if __GNUC__ < 3
-#ifdef WIN32
-#error
-#else
-#include <stl/std_string.h>
-#endif
-#else
-#if (__GNUC__ == 4 && __GNUC_MINOR__ >= 2)
-#include \"/opt/ELDK42/ppc_85xx/usr/include/c++/4.2.2/string\"
-#else 
-#include \"/opt/ELDK41/ppc_6xx/usr/include/c++/4.0.0/string\"
-#endif
-#endif
-
" > $tj100mc_diff_file_path/tj100_mc_BR_8_0_1.diff
#modify#tj100_mc#file#BR_8_0_1#end

#modify#tj100_mc#file#end

echo "Generating licence.dat in $tj100mc_diff_file_path";
echo -n "\
VERSION 2
NodeType TJMC1700
ProductCode TJ1600C
NodeConfiguration ADM64
OSPF YES
SNMP YES
SILVX_MGR YES
EMS_GUI YES
MODE SDH_OR_SONET
AU-MODE AU4_OR_AU3
SSM YES
NES_DOC NO
OVERHEAD_TUNNEL YES
CAPABILITY STM64
DHCP YES
ALLOW_ALL_SFP YES
REDUNDANCYMODE REDUNDANT
OrderWire YES
AUTO_DISCOVERY YES
BLSR YES
BLSR_EXTRA_TRAFFIC_SUPPORTED YES
BLSR_ENUT_SUPPORTED YES
FMECA  YES
TERMSERVER YES
LOGIN_APP YES
RADIUS YES
" > $tj100mc_diff_file_path/license.dat

echo "Generated all files now goto the checkout directory to find all files needed";
echo "changing permissions of $scripts_path & $tj100mc_diff_file_path";
chmod -R 777 $scripts_path $tj100mc_diff_file_path;
echo DONE
##############################################################################################################################################
##############################################################################################################################################
##############################################################################################################################################
#After this you cant call the master_script if you want with apropriate option. 
#I am exiting here only.
exit;
##############################################################################################################################################
##############################################################################################################################################
##############################################################################################################################################
$scripts_path/simulator_master_script.sh 1
#comment the exit statement and master script will start with option 1 that means fresh checkout.



