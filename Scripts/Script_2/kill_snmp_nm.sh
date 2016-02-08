user=$(whoami)
if [ "$user" != "root" ]; then
    echo "Can not run with non-root priviledge use su or sudo";
    exit;
fi

snmp_pids=`ps -ef | grep -iw "[s]nmpd" | awk '{print $2}'`
nm_pids=`ps -ef| grep -iw "[n]m\.d" | awk '{print $2}'`

echo Checking and killing snmpd if already running
if [ "$snmp_pids" != "" ]; then
for signal in "-15" "-1" "-9"
do
  pids=`ps -ef | grep -iw "[s]nmpd" | awk '{print $2}'`
  kill $signal $pids 2> /dev/null
  echo Trying to Kill pid $pids with signal $signal
done
fi

echo Checking if nm.d is already running and killing it.
if [ "$nm_pids" !=  "" ]; then
for signal in "-15" "-1" "-9"
do
  pids=`ps -ef| grep -iw "[n]m\.d" | awk '{print $2}'`
  kill $signal $pids 2> /dev/null
  echo Trying to Kill pid $pids with signal $signal
done
fi
echo No snmp or nm.d is running!!! 
