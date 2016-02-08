#!/bin/bash
number_of_parameters=$#;
warning_file=$1; 
warning_stats=.warning_stats.txt

if [ $number_of_parameters -lt "1" ];then
    echo "Usage: $0 warning_file"
    exit;
fi

function init_warning_files () {
warning_file=$1;
cat $warning_file | awk 'BEGIN{FS="(:|-)";} {print $3}' | sort | uniq -c | column -t > $warning_stats
total_lines=`cat $warning_stats|wc -l`
COUNTER=1
echo "Total $total_lines different types of Warning found."
while [  $COUNTER -le $total_lines ]; do
      warning_stats_temp=$(sed -n "${COUNTER}p" "$warning_stats")
      warning_type=$(echo $warning_stats_temp | awk '{print $2}')
      warning_count=$(echo $warning_stats_temp | awk '{print $1}')
      echo "##################################################################################################" > ${warning_file}_${warning_type}
      echo "          Total No. of Warnings of Type $warning_type is : $warning_count" >> ${warning_file}_${warning_type}
      echo "##################################################################################################" >> ${warning_file}_${warning_type}
      echo "" >> ${warning_file}_${warning_type}
      let COUNTER=COUNTER+1
done
echo "Initialized Separate Warning files."
}

function splitit () {
echo "Splitting the warnings"
warning_file=$1;    
total_lines=`cat $warning_file|wc -l`
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

function verify_correctness () {
warning_file=$1
indvidual_counter=0
total_lines=`cat $warning_file|wc -l`
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

echo Processing...
init_warning_files $warning_file
splitit $warning_file
verify_correctness $warning_file
echo "Done :)"

