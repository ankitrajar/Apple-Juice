
echo Running Export commands
export GITLSERVER=/home/root/.cmtools
export GITRSERVER=git://gitdepot
export PERL5LIB=$PERL5LIB:$GITLSERVER
git clone $GITRSERVER/cm-utils
export PERL5LIB=$PERL5LIB:/home/root/cm-utils

