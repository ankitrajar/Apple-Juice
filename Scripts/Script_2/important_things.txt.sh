ifconfig|grep 192.168 | awk '{print $2}' | cut -d ":" -f2
line=`cat -n vsftpd.conf |grep "chroot_local_user="|cut -f1`;echo $line;sudo sed -i 's/chroot_local_user=YES/chroot_local_user=NO/' vsftpd.conf ;cat -n vsftpd.conf |grep "$line";sudo service vsftpd restart;


route |grep ethicc|grep -v "0.0.0" |grep -v "1.1.0"|cut -d '.' -f2



for file in $(ls -1A); do if [ -f $file ];then vi $file +retab +wq; fi done



for di in $(ls -1r); do if [ -d $di ];then pushd $di >/dev/null; if [ "$?" == "0" ];then echo $di; du -hs ./ 2>/dev/null; popd > /dev/null; fi; fi ;done

for di in $(ls -1r); do if [ -d $di ];then pushd $di >/dev/null; if [ "$?" == "0" ];then echo $di; rm -rf user@id\=* 2>/dev/null; popd > /dev/null; fi; fi ;done


python /home/parmil/myscripts/python/inventory.py 192.168.143.147 | grep -A 100 "<CAPTION><B>SFP</B></CAPTION>" | grep "TH" | sed -e 's/<TH >//g' | sed -e 's/<\/TH>//g' | sed -e 's/<INPUT TYPE=BUTTON VALUE=.*(this, 1)" >//g' | sed -e 's/&nbsp;//g' | sed -e 's/<TD >//g' |sed -e 's/<\/TD>/  /g'|sed -e 's/<BR>/  /g' | grep -v "Name Port Operational Status"

ni 192.168.143.147 | grep ^\|....\|.*________________\|
ni 192.168.143.147 | grep ^\|....\|.*________________\| | sed -e 's/_/ /g' | sed -e 's/|/ /g'



python /home/parmil/myscripts/python/inventory.py 192.168.143.147 | grep -A 100 "<CAPTION><B>SFP</B></CAPTION>" | grep "TH" | sed -e 's/<TH >//g' | sed -e 's/<\/TH>//g' | sed -e 's/<INPUT TYPE=BUTTON VALUE=.*(this, 1)" >//g' | sed -e 's/&nbsp;//g' | sed -e 's/<TD >//g' |sed -e 's/<\/TD>/  /g'|sed -e 's/<BR>/  /g' | grep -v "Name Port Operational Status" |column -t


ni 192.168.143.147 | grep ^\|....\|.*________________\| | sed -e 's/_/ /g' | sed -e 's/|/ /g'|column -t


cat WARNINGS_XST | awk 'BEGIN{FS=":";} {print $3}'|awk 'BEGIN{FS="-";} {print $1}' | sort | uniq -c | column -t > warning_stats.txt
cat sample.txt | awk 'BEGIN{FS="(:|-)";} {print $3}' | sort | uniq -c | column -t > warning_stat.txt

cat cpbar.sh | grep -A20 "#OUTLINE#START#" |grep -B20 "#OUTLINE#END#" | grep "echo -e" | wc -l # -1 will give you no of echo.
cat cpbar.sh | grep -A20 "#OUTLINE#START#" |grep -B20 "#OUTLINE#END#" | grep "echo.*x" | awk 'BEGIN{FS="(\"|x)"} {print $2}'| wc -c #+1 will give no of spaces before boundry

