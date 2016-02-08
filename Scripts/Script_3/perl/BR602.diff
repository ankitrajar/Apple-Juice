    # do dangerous stuff: means start deleting
file2=files_to_delete
total_lines=`cat $file2|wc -l`
COUNTER=1
         while [  $COUNTER -lt $total_lines ]; do
                header_temp=$(sed -n "${COUNTER}p" "$file2")
                echo "Deleting $header_temp";
                rm -rf $header_temp
                let COUNTER=COUNTER+1
         done

