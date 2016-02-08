#!/bin/bash
set -e

user="parmil"; ####user="$your_pc_username"; #<#<#$(whoami)#>#>#
email="parmilk"; #####email="$email_intials";
home_dir="/home/$user";
full_email="$email@india.tejasnetworks.com";
your_name="Parmil Kumar"; ####your_name="$your_official_name";
cd $home_dir

current_user=$(whoami)
if [ "$current_user" != "root" ]; then
    echo "Can not run with non-root priviledge use su or sudo";
    exit;
fi

echo "
user=$user
email=$email
full_email=$full_email
your_name=$your_name
"

cd /home/$user
pwd
touch export_commands.sh
echo "
echo Running Export commands
export GITLSERVER=/home/$user/.cmtools
export GITRSERVER=git://gitdepot
export PERL5LIB=\$PERL5LIB:\$GITLSERVER
git clone \$GITRSERVER/cm-utils
export PERL5LIB=\$PERL5LIB:/home/$user/cm-utils
"> export_commands.sh

chmod 777 export_commands.sh
su $user -c "source export_commands.sh";
echo Adding entries to .bashrc
echo "

export CVSROOT=:ext:$email@tn100build:/tn100/cvs
export CVS_RSH=/usr/bin/rsh

export GITLSERVER=/home/$user/.cmtools
export GITRSERVER=git://gitdepot
export PERL5LIB=\$PERL5LIB:\$GITLSERVER
export PERL5LIB=\$PERL5LIB:/home/$user/cm-utils
export PERLLIB=\$PERLLIB:\$GITLSERVER

export CSCOPE_EDITOR=vim
export TEJAS_CCACHE=YES
export CCACHE_PREFIX=distcc
export DISTCC_DIR=/home/$user/.distcc
" >> /home/$user/.bashrc

echo Creating .distcc 
cd /home/$user
su $user -c "mkdir .distcc"
cd .distcc
su $user -c "touch hosts"
echo "localhost" > hosts

echo Sourcing .bashrc
su $user -c "source /home/$user/.bashrc"
echo Creating mkdir eldk  ELDK41  ELDK42  eldk-5.2.1  hardhat  hexftp  perl  smc in /opt
cd /opt
mkdir eldk  ELDK41  ELDK42  eldk-5.2.1  hardhat  hexftp  perl  smc
cd /
mkdir tj100
cd /mnt
mkdir releases  swtn100
cd /home
mkdir tj100reg
cd tj100reg
mkdir mountdir
echo created tj100 releases  swtn100 tj100reg tj100reg/mountdir
echo Adding entries to fstab
echo "

hulk:/tn100buildserver/buildtools/swtn100/eldk /opt/eldk nfs  nfsvers=3,defaults 0 0
hulk:/tn100buildserver/buildtools/swtn100/ELDK42   /opt/ELDK42   nfs  nfsvers=3,defaults  0 0
hulk:/tn100buildserver/buildtools/swtn100/eldk-5.2.1   /opt/eldk-5.2.1   nfs  nfsvers=3,defaults  0 0
hulk:/tn100buildserver/buildtools/swtn100/ELDK41   /opt/ELDK41   nfs  nfsvers=3,defaults  0 0
hulk:/tn100buildserver/buildtools/swtn100/hexftp   /opt/hexftp   nfs  nfsvers=3,defaults  0 0
hulk:/tn100buildserver/tj100      /tj100   nfs  nfsvers=3,defaults  0 0
hulk:/tn100buildserver/releases   /mnt/releases   nfs  nfsvers=3,defaults  0 0
hulk:/tn100buildserver/swtn100   /mnt/swtn100   nfs  nfsvers=3,defaults  0 0
tejweb:/smc     /opt/smc   nfs  nfsvers=3,defaults  0 0

192.168.0.113:/tn100buildserver/buildtools/regtools/perl /opt/perl nfs nfsvers=3,defaults 0 0
hulk:/tn100buildserver/buildtools/swtn100/hardhat /opt/hardhat nfs ro,nolock,soft 0 0
hulk:/tn100buildserver/buildtools/swtn100/tj100reg /home/tj100reg/mountdir   nfs     nfsvers=3,defaults 0 0
" >> /etc/fstab

echo Remounting after adding entries to fstab
cd /opt
mount -a

cd /home/$user/cm-utils
su $user -c "export GITLSERVER=/home/$user/.cmtools"
su $user -c " export GITRSERVER=git://gitdepot"
su $user -c "export PERL5LIB=\$PERL5LIB:\$GITLSERVER"
cd /home/$user/cm-utils
pwd
#root execution
./tjgitinstall --system
#non root exec
su $user -c "./tjgitinstall --user $full_email \"$your_name\" "
#if its asking for password while cvs checkout then check if rsh is installed or not.
