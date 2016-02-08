run_as=$(whoami)
if [[ "$#" != "1" ]] || [[ "$run_as" != "root" ]];then
    echo "Usage: $0 package_list_file (run in root previledge mode)"
    exit
fi
packages_to_be_installed=$1
for i in `cat $packages_to_be_installed`
do
#aptitude -y install $i
DEBIAN_FRONTEND=noninteractive aptitude -y install $i
done
