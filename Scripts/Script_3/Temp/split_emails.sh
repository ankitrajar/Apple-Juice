#!/bin/bash
number_of_parameters=$#;
email_file=$1; 
grouping_factor=$2

if [[ "$grouping_factor" == "" ]];then
   grouping_factor=20
fi

if [ $number_of_parameters -lt "1" ];then
echo "Usages: $0 [file-containing-all-email] [grouping-factor(Optional):default is 20]"
exit;
fi

function splitit () {
email_file=$1;    
grouping_factor=$2

total_lines=`cat $email_file|wc -l`
COUNTER=1
fileno=1
dummy_name="email"
while [  $COUNTER -le $total_lines ]; do
       echo -n > ${dummy_name}_${fileno}.txt
       echo "Creating ${dummy_name}_${fileno}.txt"
       for ((index=0; index<$grouping_factor && $COUNTER <= $total_lines; index++))
       do
             email_temp=$(sed -n "${COUNTER}p" "$email_file")
             echo $email_temp >> ${dummy_name}_${fileno}.txt
             let COUNTER=COUNTER+1
       done
       let fileno=fileno+1
done
}

echo Processing...
splitit $email_file $grouping_factor
echo "Done :)"
