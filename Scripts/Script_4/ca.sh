#!/bin/bash
#Crash Analysis Master Script. Controls all other scripts.
number_of_parameters=$#;
if [ $number_of_parameters -lt "1" ];then
echo "Usages: $0 IP_PART"
exit;
fi
####################################### FUNCTIONS ############################################
function fip143 () { #internal fxn taken  from bashrc
    if [[ $1 = *.*.*.* ]] ; then
        echo $1
    elif [[ $1 = *.*.* ]] ; then
        echo 192.$1
    elif [[ $1 = *.* ]] ; then
        echo 192.168.$1
    elif [[ $1 -lt 255 ]] ; then
        echo 192.168.143.$1
    fi
}

function get_daemon_map () {
input_daemon_name=$1
input_daemon_name=${input_daemon_name%.d.map*}
input_daemon_map="${input_daemon_name}.d.map"
input_daemon_map=${input_daemon_map,,}
match_in_this_dir=$2
if pushd $match_in_this_dir >/dev/null;then
   daemons=($(ls -1 *.d.map))
   use_path=$(pwd)
   popd >/dev/null
fi
for dmn in ${daemons[@]}
do
    temp=${dmn##*\/}
    temp=${temp,,}
    if [[ "$temp" == "$input_daemon_map" ]];then
       echo "$use_path/$dmn"
       return 0
    fi
done
return 1
}
##############################################################################################
############################ ARG HANDLING AND DEF SECTION ####################################
reip='^[0-9\.]+$'
retgz='.*-maps.tgz$'
max_ping_retry=10
control_card_image_path="/etc/bin/tejas/"
intelligent_card_imag_path="/etc/tejas/builds/"
release_server_ip="192.168.0.14"
release_server_username="swtn100"
release_server_password="tn100sw"

if  [[ $1 =~ $reip ]] ; then
    ip_part=$1;
    full_ip=$(fip143 $ip_part)
    results_path=$2
    log_maps_downloader_script_path=$3
    crash_analyzer_perl_script_path=$4
    universal_local_md5_file=$5
    universal_release_md5_file=$6
elif [[ $1 =~  'rel' ]] ; then
    release_branch=$2;
    release_tag=$3;
    crash_logs_path=$4;
    if [ $number_of_parameters -lt "4" ];then
       echo "rel RELEASE_BRANCH BRANCH_TAG CRASH_LOG_PATH all are not passed"
       exit 1
    fi    
    results_path=$5
    log_maps_downloader_script_path=$6
    crash_analyzer_perl_script_path=$7
    universal_local_md5_file=$8
    universal_release_md5_file=$9
elif [[ $1 =~  $retgz ]] ; then
    maps_tgz_file_path=$1;
    crash_logs_path=$2;
    if [ $number_of_parameters -lt "2" ];then
       echo "MAPS_TGZ_FILE_PATH  CRASH_LOG_PATH all are not passed"
       exit 1
    fi
    results_path=$3
    log_maps_downloader_script_path=$4
    crash_analyzer_perl_script_path=$5
    universal_local_md5_file=$6
    universal_release_md5_file=$7
else
    echo "Not able to understand what args you are passing."
    exit 1
fi
########################################################################################################
###################################### ROLL BACK TO THESE IF NULL ######################################
##these extra agrs are being used so that we can have flexiblity from bashrc while calling this script.
##below is the default setting block. if above args are not passed.
if [[ "$results_path" == "" ]];then
	 results_path=~/crash_analysis
fi

if [[ "$log_maps_downloader_script_path" == "" ]];then
	 log_maps_downloader_script_path=~/myscripts/ca_maps_logs_downloader
fi

if [[ "$crash_analyzer_perl_script_path" == "" ]];then
	 crash_analyzer_perl_script_path=~/myscripts/unbound_stacktracer.pl
fi

if [[ "$universal_local_md5_file" == "" ]];then
	 universal_local_md5_file=~/.universal_local_md5_list
fi

if [[ "$universal_release_md5_file" == "" ]];then
	 universal_release_md5_file=~/.universal_release_md5_list
fi
##########################################################################################################
##################################### AVOID DISASTER. CHECK BEFORE TAKEOFF ###############################
if ! [ -e $results_path ];then
      mkdir -p $results_path
fi

if ! [ -e $log_maps_downloader_script_path ];then
   echo "log_maps_downloader_script_path is needed for script to work properly.Please check if you have passed wrongly or edit hardcoded section of script."
   exit 1;
fi

if ! [ -e $crash_analyzer_perl_script_path ];then
   echo "crash_analyzer_perl_script_path is needed for script to work properly.Please check if you have passed wrongly or edit hardcoded section of script."
   exit 1;
fi

if ! [ -e $universal_local_md5_file ];then
   echo "universal_local_md5_file is needed for script to work properly.Please check if you have passed wrongly or edit hardcoded section of script."
   exit 1;
fi

if ! [ -e $universal_release_md5_file ];then
      echo "universal_release_md5_file is needed for script to work properly.Please check if you have passed wrongly or edit hardcoded section of script."
      exit 1;
fi
############################################################################################################
###################################### HELPER SCRIPTS OUTPUT PARAMETERS ####################################
base_path_per_node=$results_path/node_$ip_part
download_maps_logs_here=$base_path_per_node/from_node
img_md5info_file_path=$download_maps_logs_here/img_md5info
download_extract_maps_tgz_here=$base_path_per_node
tgz_maps_path=$download_extract_maps_tgz_here/maps
split_logs_in_this=$base_path_per_node/split/
combined_info=$base_path_per_node/all_info
backup_to_this=$base_path_per_node/backup
analysis_result_ext="analysis"
if [ -e $split_logs_in_this ];then
   mkdir -p $backup_to_this
   echo "Found Existing crash analysis in $split_logs_in_this"
   echo "Backing Up to $backup_to_this"
   all_analysis=($(find $split_logs_in_this -name "*.$analysis_result_ext"))
   if [ ${#all_analysis[@]} -ne 0 ];then
      for analysis_result in ${all_analysis[@]}
      do
         echo "Copying $analysis_result"
         cp $analysis_result $backup_to_this/
      done
      all_analysis=()
   else 
      echo "Seems That last Crash analysis didn't went well because there are no previous .$analysis_result_ext files"
   fi
fi

echo "Creating $split_logs_in_this $download_maps_logs_here"
mkdir -p $download_maps_logs_here $split_logs_in_this $tgz_maps_path
############################################################################################################
############################################# Make Sure Node is UP #########################################
if [[ "$full_ip" != "" ]];then
     count=$max_ping_retry;
     is_node_up=0;
     while [[ $count -ne 0 ]] ; do
         ping -c 1 $full_ip >/dev/null                     # Try with one packet.
         rc=$?
         if [[ $rc -eq 0 ]] ; then
             ((count = 1))                      # If okay, flag to exit loop.
             is_node_up=1;
         else
            echo "Node still unreachable."
         fi
         ((count = count - 1))                  # So we don't go forever.
     done
     if [[ "$is_node_up" == "1" ]];then
          echo "Node is UP. Now going Further."
     else
          echo "Finally Node is unreachable. Re run. Exiting..."
          exit 1;
     fi
fi
############################################################################################################
############################################ LETS DO THIS !!!!!! ###########################################
                                       ######## Downloading #######
echo "Downloading crash info of node $full_ip to $download_maps_logs_here"
echo "Calling $log_maps_downloader_script_path"
$log_maps_downloader_script_path $full_ip $download_maps_logs_here
status_code=$?
if [[ $status_code -eq 2 ]];then
   echo "Downloader script retured status code 2 which means that this node $full_ip had no crash till now. Exiting..."
   exit 1
elif [[ $status_code -ne 0 ]];then
   echo "Downloader script retured status code $status_code. Exiting..."
   exit 1
else
   echo "Downloaded the stuff from node $full_ip to $download_maps_logs_here"
fi
                        ######### Read img_md5 data & get corresponding maps ########
echo "Extracting control card md5 from $img_md5info_file_path"
control_card_current_image_md5=$(cat $img_md5info_file_path | grep "$control_card_image_path" | awk '{print $1}')
if [[ ${control_card_current_image_md5} == "" ]];then
   echo "It seems that $img_md5info_file_path is blank or not proper. May be your log_maps_downloader should wait extra 1-2 seconds until md5info is generated."
   echo "Just put some sleep in downloader script. so that it wait for creation of md5info. Its not final reason. Just Guessing :) Exiting..."
   exit;
fi
echo "control_card_current_image_md5 is $control_card_current_image_md5"
echo "Searching in $universal_local_md5_file"
image_local_path=$(grep "$control_card_current_image_md5" $universal_local_md5_file | awk '{print $2}')
image_release_server_path=$(grep "$control_card_current_image_md5" $universal_release_md5_file | awk '{print $2}')
if [[ "$image_local_path" != "" ]];then
     echo "The image being used in the node is $image_local_path"
     local_map_tgz_file=${image_local_path/.squash.img/-maps.tgz}
     if [ -e $local_map_tgz_file ];then
        echo "Extracting $local_map_tgz_file in $tgz_maps_path"
        tar -xzvf $local_map_tgz_file -C $tgz_maps_path
     else
        echo "Not able to locate $local_map_tgz_file. on local machine. Exiting..."
        exit 1;
     fi
elif [[ "$image_release_server_path" != "" ]];then
     echo "Node is using release build. Path of which is: $image_release_server_path"
     release_server_map_tgz_file=${image_release_server_path/.squash.img/-maps.tgz}
     release_server_map_tgz_file_name=${release_server_map_tgz_file##*\/}
     echo "Downloading corresponding map $release_server_map_tgz_file to $download_extract_maps_tgz_here"
     ncftpget -u$release_server_username -p$release_server_password $release_server_ip $download_extract_maps_tgz_here $release_server_map_tgz_file;
     status_code=$?
     if [[ $status_code -ne 0 ]];then
         echo "Unable to download the file $release_server_map_tgz_file. Exiting..."
         exit 1;
     fi
     if ! [ -e $download_extract_maps_tgz_here/$release_server_map_tgz_file_name ];then
          echo "Downloaded file doesn't exits, or some problem with name stripping."
          echo "Unable to locate $download_extract_maps_tgz_here/$release_server_map_tgz_file_name. Exiting..."
          exit 1;
     fi
     echo "Now extracting the $download_extract_maps_tgz_here/$release_server_map_tgz_file_name file to $tgz_maps_path"
     tar -xzvf $download_extract_maps_tgz_here/$release_server_map_tgz_file_name -C $tgz_maps_path
     echo "Extraction completed maps dir is $tgz_maps_path"
else
     echo "MD5 Value $control_card_current_image_md5 corresponds to neither a release build nor your pc private builds."
     echo "It might be possible that either you haven't updated your local & release builds md5 database. OR This is someone else 's private build."
     echo "Please get the maps.tgz & then try with different way using the script.(Local method). Exiting..."
     exit 1;
fi
echo ""
echo ""
echo "HURRRRRRRAY!!! WE HAVE GOT THE MAPS FOLDER. :)"
echo ""
                                        ######## Splitting #######
echo "Splitting $download_maps_logs_here according to daemons in $split_logs_in_this"
rm -rf $split_logs_in_this/*
SAVEIFS=$IFS;
grep -nriI "stackdump" $download_maps_logs_here |
while read -r line ; do
  IFS=":";
  set -- $line;
  filename=$1; line_no=$2;
  mix=$3;mix=${mix//\// };minutes=$4;seconds=$5;
  tmp_line=${line//:/ }
  IFS=" ";
  set -- $tmp_line
  task_name=$8   #don't know why its not working with $6. it should be $6 but it seems / is also taken as field separator here.
  set -- $mix
  day=$1;month=$2;year=$3;hours=$4
  let year=year+2000
  final_date="$year/$month/$day $hours:$minutes:$seconds"
  window=30;
  daemon=${filename##*\/}; daemon=${daemon#*init}; daemon=${daemon%%dlog*};
  epoch_time=$(date --date="$final_date" '+%s');
  echo "$epoch_time $filename $line_no $daemon $task_name";
done | sort -k1 -r > $combined_info
IFS=" ";
cat $combined_info| while read info ; do
   set -- $info;
   epoch_time=$1
   filename=$2
   line_no=$3
   daemon=$4
   task_name=$5
   echo $info
   log_count=$(ls -1 $split_logs_in_this/$daemon/*${daemon}* 2>/dev/null|wc -l)
   if [ $log_count -eq 0 ];then
      mkdir -p $split_logs_in_this/$daemon/
      crash_no=$log_count
   else
      crash_no=$log_count
   fi
   tail -n +$line_no $filename | head -${window} > $split_logs_in_this/$daemon/${crash_no}_${daemon}_${task_name}_${epoch_time}
done
IFS=$SAVEIFS;
echo ""
echo "AWWWWWWWWWWWESSSSSSSSSSSOMMMMMMMMMMMMMME. DONE SPLITTING."
echo ""
echo "Splitted logs."
                                 ######Go for processing logs #######
echo "Now Going for processing of these logs"
for daemon in $(ls -1 $split_logs_in_this)
do
if pushd $split_logs_in_this/$daemon;then
   echo "Doing Crash Analysis for daemon $daemon"
   for crash_file in $(ls -1rt 2>/dev/null)
   do
      echo "Crash Analysis for file $crash_file"
      task_name=$(echo "$crash_file" | awk 'BEGIN{FS="_"} {print $3}')
      use_this_linker_map=$(get_daemon_map $daemon $tgz_maps_path)
      splitted_file_full_path=$(readlink -e $crash_file)
      daemon_lower=${daemon,,}
      if ! [ -e $use_this_linker_map ];then
           echo "Got this as linker map $use_this_linker_map. Which doesn't exist."
           echo "check your maps folder for proper map file."
           exit
      fi
      echo "Debug Info"
      echo "perl $crash_analyzer_perl_script_path TARGET $splitted_file_full_path $task_name $download_maps_logs_here/${daemon_lower}.maps $use_this_linker_map ${splitted_file_full_path}.$analysis_result_ext"

      perl $crash_analyzer_perl_script_path TARGET $splitted_file_full_path $task_name $download_maps_logs_here/${daemon_lower}.maps $use_this_linker_map ${splitted_file_full_path}.$analysis_result_ext
   done
popd >/dev/null
fi
done

while [ 1 ]
do
all_analysis=($(find $split_logs_in_this -name "*.$analysis_result_ext" -printf '%T@ %p\n' | sort -k 1n | sed 's/^[^ ]* //'))
total_results=${#all_analysis[@]}
if [ $total_results -eq 0 ];then
   echo "Seems that there was no crash that is successfully Analyzed. :( "
   echo "Exiting..."
fi 
echo "Found $total_results crashes analyzed :) Which one to see?"
for((index=0;index<$total_results;index++))
do
    tmp=${all_analysis[$index]}
    tmp=${tmp##*\/}
    display=$tmp
    SAVEIFS=$IFS
    IFS="_"
    set -- $tmp
    tmp=$4
    IFS=$SAVEIFS
    tmp=${tmp%.$analysis_result_ext}
    time_stamp=$(date -d @$tmp +'%Y-%m-%d %H:%M:%S')    
    echo "$index   $time_stamp   $display"
done
echo "Please Enter index no. That would be selected to navigate.(TO QUIT ENTER q )"
read choice
while (( choice < 0 || choice >= total_results ))
do
    echo "Invalid index. Enter again."
    read choice
    if [[ "$choice" == "q" ]];then
        break;
    fi
done
if [[ "$choice" == "q" ]];then
    echo "quitting..."
    break;
else
    c++filt < ${all_analysis[$choice]}
fi
done
