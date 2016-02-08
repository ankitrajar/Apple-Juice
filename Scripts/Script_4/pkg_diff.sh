if [[ "$#" != "2" ]];then
    echo "2 package files needed."
    exit
fi

function dodiff () {
echo "file1 $1, file2 $2"
file1=$1
file2=$2
echo -n >  extra_in_$file2
total_lines=`cat $file2|wc -l`
COUNTER=1
         while [  $COUNTER -lt $total_lines ]; do
		pkg_temp=$(sed -n "${COUNTER}p" "$file2")
                if grep -q "$pkg_temp" $file1; then
		:
		else
		   echo "$pkg_temp" >> extra_in_$file2;
		fi
             let COUNTER=COUNTER+1 
         done
}

dodiff $1 $2
dodiff $2 $1
