
perl -MCPAN -e 'my $c = "CPAN::HandleConfig"; $c->load(doit => 1, autoconfig => 1); $c->edit(prerequisites_policy => "follow"); $c->edit(build_requires_install_policy => "yes"); $c->commit'
perl -MCPAN -e 'autobundle'
ls -lrt ~/.cpan/Bundle | tail -n 1 | cut -f8 -d ' '
PERL_MM_USE_DEFAULT=1 perl -MCPAN -e 'install My::Module'
sudo perl -MCPAN -e 'install Bundle::Snapshot_2015_07_10_00'

cat /parmil/osmc_latest2/BR_8_0_1_a66_1/taginfo | awk '{OFS="\t"; print $2}'
for file in $(locate -w taginfo);do [ -L $file ] && echo -n || echo $file ; done | grep -v "cvs\|usr"
for module in $(cat /parmil/osmc_latest2/BR_8_0_1_a66_1/taginfo | awk '{OFS="\t"; print $2}') ; do  ls "/parmil/osmc_latest2/BR_8_0_1_a66_1/$module" ; done 2>/dev/null


pushd  /parmil/osmc_latest2/BR_8_0_1_a66_1/tj100_mc/ ; git status | grep :*/ | grep -v git  | awk '{OFS="\t"; print $3}'; popd
orig=${orig//\//__}

pushd  /parmil/osmc_latest2/BR_8_0_1_a66_1/tj100_mc ; for file in $(git status | grep :*/ | grep -v git |grep -v delete | awk '{OFS="\t"; print $3}'); do git diff HEAD $file ; done ; popd



for file in $(locate -w taginfo);do [ -L $file ] && echo -n || echo ${file%/taginfo*} ; done | grep -v "cvs\|usr"
