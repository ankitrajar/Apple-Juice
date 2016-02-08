echo Welcome
if [ $# -ne "4" ];then
echo Usages: IP User Password Pattern;
exit;
fi
ip=$1;
user=$2;
password=$3;
pattern=$4;
localscript="pattern_killer_script.sh";
outfile="parmil.out";
gcc parmil.c -o $outfile
./$outfile $pattern $localscript
./expect.sh $ip $user $password $localscript
echo Deleting temporary files $localscript $outfile
rm $localscript
rm $outfile
echo Done

