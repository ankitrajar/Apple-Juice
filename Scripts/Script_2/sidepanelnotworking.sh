user=$(whoami)
if [ "$user" != "root" ]; then
    echo "Can not run with non-root priviledge";
    exit;
fi

home_path=$1;

mkdir $home_path/sidepaneltmp
cd $home_path/sidepaneltmp
#  //copy  "tgz image for your control card" from tn100build to your computer
# // Like for  REL_10_0_0_a15_1, i would do following :
ncftpget -uswtn100 -ptn100sw 192.168.0.14 . /home/swtn100/releases/REL_10_0_0/a_x/a15_1/builds/xcc360g-ppc-REL_10_0_0_a15_1.tgz
tar -xvzf xcc360g-ppc-REL_10_0_0_a15_1.tgz
#//tejas directory will be created.
cd tejas
cp -rf ems /usr/sbin/tejas
cd $home_path
rm -rf $home_path/sidepaneltmp
