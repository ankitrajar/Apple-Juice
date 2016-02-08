./update_mem_watch 150
echo sleeping
declare -a arr=("img_sec" "img_prim") 
for i in "${arr[@]}"
do
echo "$i"
mem_watch=/home/parmil/myscripts/octave/$i/mem_watch_output.txt
input_file=/home/parmil/myscripts/octave/$i/input.txt
finput_file=/home/parmil/myscripts/octave/$i/finput.txt
rm $finput_file $input_file
touch $finput_file $input_file
chmod 777 $finput_file $input_file

cat $mem_watch |grep -v '[a-z]' > $input_file
chmod 777 $input_file
file1=$finput_file
file2=$input_file
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
done
#repeating
#copying to common folder both types of files
cp /home/parmil/myscripts/octave/img_sec/finput.txt /home/parmil/myscripts/octave/img_comm/finput_sec.txt
cp /home/parmil/myscripts/octave/img_prim/finput.txt /home/parmil/myscripts/octave/img_comm/finput.txt

echo Ready to go. Running the octave scripts to genereate latest graphs.
octave severy.m
echo making tar files of images
declare -a arr2=("img_sec" "img_prim" "img_comm")
for i in "${arr2[@]}"
do
echo "compressing $i.tar.gz"
tar -cvz $i/*.png $i/*.txt -f $i.tar.gz
done
cat /home/parmil/myscripts/octave/img_comm/finput_sec.txt|wc -l
cat /home/parmil/myscripts/octave/img_comm/finput.txt|wc -l
echo if you see both the above no. different then img_common will not work properly due to slight time mismatch. retry.
