echo file1 should contain new names and file2 should have existing names
file1=$1
file2=$2
total_lines=`cat $file2|wc -l`
COUNTER=1
         while [  $COUNTER -lt $total_lines ]; do
		name_temp=$(sed -n "${COUNTER}p" "$file2")
                replace_temp=$(sed -n "${COUNTER}p" "$file1")
		mv "$name_temp" "$replace_temp"
		echo "$name_temp to $replace_temp";
             let COUNTER=COUNTER+1 
         done
#find my_root_dir -depth -exec rename 's/(.*)\/([^\/]*)/$1\/\L$2/' {} \;

