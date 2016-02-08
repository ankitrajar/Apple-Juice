user=$(whoami)
if [ "$user" == "root" ]; then
    echo "Can not run with root priviledge";
    exit;
fi

if [ $# -ne "2" ];then
echo "This script will remove all objects related to header files in input file but you have to ";
echo "manually delete the object file of the header file that you frist searched in cscope to get this list";
echo Usages: Input_File_with_Path          Path_of_mirror_needed_to_recompile\(PLEASE DONT GIVE  \'/\' IN THE END OF PATH\) ;
exit;
fi

echo Cleaning up files if already exists
echo Deleting results1 results2 results2.unique files_to_delete
rm results1 results2 results2.unique files_to_delete

input_file=$1;
recomp_path=$2;
echo "Make recompilable script started";
cat $input_file |cut -d ' ' -f2 > results1
echo "Results After extracting only file names";
cat results1
cat results1 | cut -d '.' -f1 > results2
rm -rf results1
echo "After removing the filetype info results";
cat results2
echo "Removing duplicate entry from results2 to save some time";
awk '!x[$0]++' results2 > results2.unique
#can also use theis 
#sort results2 | uniq > results2.unique
echo After removing duplicates
cat results2.unique
file2=results2.unique
total_lines=`cat $file2|wc -l`
COUNTER=1
         while [  $COUNTER -lt $total_lines ]; do
                header_temp=$(sed -n "${COUNTER}p" "$file2")
                echo "locate $recomp_path/*$header_temp*.*o*";
                locate  "$recomp_path/*$header_temp*.*o*" >> files_to_delete
                let COUNTER=COUNTER+1
         done
echo "Files to be deleted are ";
cat files_to_delete
echo Cleaning up previous files
echo Deleting results2 and results.unique
rm results2
rm results2.unique
echo " ";
echo Please Make sure that no header or cpp file get deleted so verify from file
echo Enter yes to proceed no to exit. You can edit the result file than press yes

read -p "Are you sure? " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
    # do dangerous stuff: means start deleting
file2=files_to_delete
total_lines=`cat $file2|wc -l`
COUNTER=1
         while [  $COUNTER -lt $total_lines ]; do
                header_temp=$(sed -n "${COUNTER}p" "$file2")
                echo "Deleting $header_temp";
                rm $header_temp
                let COUNTER=COUNTER+1
         done

fi

echo REMEMBER
echo
echo "This script will remove all objects related to header files in input file but you have to ";
echo "manually delete the object file of the header file that you frist searched in cscope to get this list";

