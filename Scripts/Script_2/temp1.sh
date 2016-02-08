
# normal_user="parmil"
# home_dir=$(su $normal -c "echo $HOME")
home_dir=/home/parmil
backup_dir=$home_dir/full_backup
diff_error_log=$backup_dir/errors_while_diff.txt
all_app_config=$backup_dir/config_files
sources_dir=$backup_dir/sources
mkdir -p $all_app_config
cpan_bundle_dir=$home_dir/.cpan/Bundle
mkdir -p $backup_dir
backup_dpkg_pkg_list=$backup_dir/dpkg_pkg_list.txt
latest_bundle_file=$(ls -lrt $cpan_bundle_dir | tail -n 1 | cut -f8 -d ' ')
backup_perl_bundle_dir=$backup_dir/perl_bundle
mkdir -p $backup_perl_bundle_dir
bundle_to_install=${latest_bundle_file%.*}
diff_backup=$backup_dir/diffs
echo "Backing up list of packages currently isntalled."
dpkg --get-selections | grep install | grep -v deinstall | cut -f1 > $backup_dpkg_pkg_list
total_pkg=$(cat $backup_dpkg_pkg_list | wc -l)
echo "Backed up list of $total_pkg dpkg packages"

echo "Now creating Bundle of currently installed perl packages"
#perl -MCPAN -e 'autobundle'
cp $cpan_bundle_dir/$latest_bundle_file $backup_perl_bundle_dir
echo "Perl Bundling Done!!!"

echo "Now Backing Up fstab to $backup_dir"
cp /etc/fstab $backup_dir

echo "Now Copying vimrc bashrc"
cp $home_dir/.bashrc $backup_dir/bashrc
cp $home_dir/.vimrc $backup_dir/vimrc

echo "Now Backing up sources list to $sources_dir"
mkdir -p $sources_dir
cp -r /etc/apt/sources.list* $sources_dir

echo "Now exporting all Repo.keys"
apt-key exportall > $backup_dir/repo.keys

echo "Now Backing Up all Application 's config directories to $all_app_config"
#tar -zcvf $all_app_config/config.tar.gz $home_dir/.bash* $home_dir/.config $home_dir/.distcc/hosts $home_dir/.thunderbird 2> /dev/null

#exit
echo -n > $diff_error_log

echo "Now checking all your checkout areas."
declare -a all_checkouts=$(for file in $(locate -w taginfo);do [ -L $file ] && echo -n || echo ${file%/taginfo*} ; done | grep -v "cvs\|usr")
declare -a all_tag_files=$(for file in $(locate -w taginfo);do [ -L $file ] && echo -n || echo $file ; done | grep -v "cvs\|usr")
echo "These checkout Areas found"
for checkout in ${all_checkouts[@]}
do
	echo "$checkout"
done
echo "Proceeding to create diffs."
for tagfile in ${all_tag_files[@]}
do
	checkout_dir=${tagfile%/taginfo*}
	echo "In Checkout Area $checkout_dir"
	pushd $checkout_dir > /dev/null
	checkout_diff_dir=$diff_backup/${checkout_dir//\//__}
	
	declare -a all_modules=$(cat $tagfile | awk '{OFS="\t"; print $2}' | grep -v -- "----\|Component\|LINUX")
	for module in ${all_modules[@]}
	do
		pushd ${checkout_dir}/$module* 2>/dev/null > /dev/null #2>/dev/null
		module_push_status=$?
		if [ $module_push_status -eq 0 ]; then

			echo "Module $module"
			module_diff_dir=$checkout_diff_dir/${module//\//__}
			untracked_files_dir=$checkout_diff_dir/${module//\//__}/untracked_files
			declare -a every_change=$(git status | grep -P "\t")
			changed_files=$(echo -n "${every_change[@]}" | wc -l )

			if [ $changed_files -ne 0 ]; then

				mkdir -p $checkout_diff_dir
				count_normal_changes=$(echo -n "${every_change[@]}" |grep ":"  | awk '{OFS="\t"; print $2}' | wc -l)
				if [ $count_normal_changes -ne 0 ]; then
					git diff HEAD > $checkout_diff_dir/${module//\//__}.diff
				fi
				declare -a untracked_files=$(echo -n "${every_change[@]}" |grep -v ":"  | awk '{OFS="\t"; print $2}')
				count_untracked=$(echo -n "${untracked_files[@]}" | wc -l )
				if [ $count_untracked -ne 0 ]; then
					mkdir -p $untracked_files_dir
				for untracked_file in ${untracked_files[@]}
				do
					echo "Copying untracked_file $untracked_file to $untracked_files_dir"
					cp -r $untracked_file $untracked_files_dir/
				done
				fi

				declare -a all_changed_files=$(echo -n "${every_change[@]}" | grep  ":" | grep -v delete | cut -f2 -d ':' | awk '{OFS="\t"; print $1}')
				indivisual_diffable=$(echo -n "${all_changed_files[@]}" | wc -l )
				if [ $indivisual_diffable -ne 0 ]; then
					for changed_file in ${all_changed_files[@]}
					do
						mkdir -p $module_diff_dir
						echo "Changed file $changed_file"
						git diff HEAD $changed_file > $module_diff_dir/${changed_file//\//__}.diff
					done
				fi

			fi
			popd > /dev/null
		else
			echo "Not able to take diff from module : ${checkout_dir}/$module";
			echo "${checkout_dir}/$module" >> $diff_error_log
		fi
	done
	popd > /dev/null
done

echo "Done taking all all_checkouts diffs."

#cat /etc/fstab | awk '{OFS="\t";print $2}'|grep -v ":"|grep "/"
