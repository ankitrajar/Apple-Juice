
file1=finput.txt
file2=input.txt
rm $file1
touch $file1
chmod 777 $file1
total_lines=`cat $file2|wc -l`
COUNTER=1
time=0
         while [  $COUNTER -lt $total_lines ]; do
		temp_line=$(sed -n "${COUNTER}p" "$file2")
		   echo "$time $temp_line" >> $file1;
             let COUNTER=COUNTER+1 
	     let time=time+5
         done


