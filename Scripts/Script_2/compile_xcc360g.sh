user=$(whoami)
if [ "$user" == "root" ]; then
    echo "Can not compile with root priviledge";
    exit;
fi

if [ $# -ne "3" ];then
echo Usages: checkout_path home_path;
exit;
fi

checkout_path=$1;
home_path=$2;
mirror_name=$3;

init_time=$(date)
cd $home_path/$checkout_path/$mirror_name/tj100_mc/src
source ../scripts/makeenv
makeenv xcc360g host LINUX26 $PWD NO YES YES
cd interfaces/ 
make
cd ..
./version.pl
cd app/tj1700/nm/
make
echo "compilation started at  : "$init_time
echo "compilation finished at : "$(date)


