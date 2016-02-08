#!/bin/bash
number_of_parameters=$#;
if [ $number_of_parameters -lt "1" ];then
    echo "Usage: $0 warning_file"
    exit;
fi

warning_file=$1; 
warning_stats=.warning_stats.txt
total_lines=$(cat $warning_file|wc -l)
#####################################################################################################################################################
function init_warning_files () {
warning_file=$1;
cat $warning_file | awk 'BEGIN{FS="(:|-)";} {print $3}' | sort | uniq -c | column -t > $warning_stats
total_stats_lines=`cat $warning_stats|wc -l` #using different variable name. otherwise it will mess with total_lines variable
COUNTER=1
echo "Total $total_stats_lines different types of Warning found."
while [  $COUNTER -le $total_stats_lines ]; do
      warning_stats_temp=$(sed -n "${COUNTER}p" "$warning_stats")
      warning_type=$(echo $warning_stats_temp | awk '{print $2}')
      warning_count=$(echo $warning_stats_temp | awk '{print $1}')
      echo "##################################################################################################" > ${warning_file}_${warning_type}
      echo "          Total No. of Warnings of Type $warning_type is : $warning_count" >> ${warning_file}_${warning_type}
      echo "##################################################################################################" >> ${warning_file}_${warning_type}
      echo "" >> ${warning_file}_${warning_type}
      echo "Total No. of Warnings of Type $warning_type is : $warning_count"
      let COUNTER=COUNTER+1
done
echo "Initialized Separate Warning files."
}
####################################################################################################################################################
function splitit () {
echo "Splitting the warnings"
warning_file=$1;    
total_lines=$2 #Improving execution time. Only once needed to be calculated.
COUNTER=1
while [  $COUNTER -le $total_lines ]; do
      echo -ne "$(($(($COUNTER*100))/$total_lines))% Completed\r"
      warning_temp=$(sed -n "${COUNTER}p" "$warning_file")
      warning_type=$(echo $warning_temp | awk 'BEGIN{FS="(:|-)";} {print $3}')
      echo $warning_temp >> ${warning_file}_${warning_type}
      let COUNTER=COUNTER+1
done
echo "Splitting Completed."
}
###################################################################################################################################################
function verify_correctness () {
warning_file=$1
total_lines=$2 #Improving execution time. Only once needed to be calculated.
indvidual_counter=0
for file in $(ls -1 ${warning_file}_*)
do 
  let indvidual_counter=indvidual_counter+$(($(cat $file | wc -l)-4)); # 4 extra lines are added in every individual file so subtract that.
done
if [[ "$indvidual_counter" == "$total_lines" ]];then
  echo "Indvidual Counter Total Lines : $indvidual_counter"
  echo "Main File Total Lines : $total_lines"
  echo "Verified. Correctly splitted :)"
else
  echo "Indvidual Counter Total Lines : $indvidual_counter"
  echo "Main File Total Lines : $total_lines"
  echo "Seems like some problem is there in script."
fi
}
##################################################################################################################################################
echo Processing...
start_time=$(date +%s)
init_warning_files $warning_file
splitit $warning_file $total_lines
verify_correctness $warning_file $total_lines
end_time=$(date +%s)
echo "Done :)"
execution_time=$(($end_time-$start_time))
echo "Execution Time : $execution_time Seconds"
echo "Speed : $(($total_lines/$execution_time)) lines/sec"

