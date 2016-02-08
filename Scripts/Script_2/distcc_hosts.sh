#echo localhost;
#nmap --open -p U:3632,T:3632 192.168.230.1/24 |grep -v "is closed"|grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}'
echo '--randomize' > $HOME/.distcc/hosts
echo 'localhost' >> $HOME/.distcc/hosts
avahi-browse _distcc._tcp -t -r | grep address | grep -v '10.0.0.2' | grep -v '192.168.230.60' |awk -F [ {'print $2'} | awk -F ] {'print $1'} | sed -e 's/$/,cpp,lzo/g'| cat >> $HOME/.distcc/hosts

cat $HOME/.distcc/hosts

