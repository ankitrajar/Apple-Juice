current_user=$(whoami)
if [ "$current_user" == "root" ]; then
    echo "Can not run with root priviledge";
    exit;
fi
target_script_path="/home/parmil/toinclude/myscripts"
source_scripts_path="/home/parmil/myscripts"
declare -a scripts_to_update=(
"automate_all.sh"
"diag"
"gaf"
"gas"
"gat"
"generic_octave_script_generator.sh"
"iupload"
"supload"
"relinfo"
"kill_snmp_nm.sh"
"logs"
"modify_cef5_img_loc"
"node"
"phone"
"pkg_diff.sh"
"sim.sh"
"distcc_hosts.sh"
"install.sh"
"update_bashrc_only.sh"
"perl/escape.pl"
"perl/evolution.pl"
"perl/nph.pl"
"perl/phone"
"python/autologin.py"
"python/customparser.pl"
"python/html2text.pl"
"python/inventory.py"
)

for script in ${scripts_to_update[@]}
do
	echo "Copying $source_scripts_path/$script to $target_script_path/$script"
	cp $source_scripts_path/$script $target_script_path/$script
done

echo "Copying ~/.psm_file to $target_script_path/psm_file"
cp ~/.psm_file $target_script_path/psm_file
echo "Copying ~/.tejas_nph to $target_script_path/tejas_nph"
cp ~/.tejas_nph $target_script_path/tejas_nph
echo "Copying ~/.tejas_phone to $target_script_path/tejas_phone"
cp ~/.tejas_phone $target_script_path/tejas_phone
echo "Taking all changes from ~/.bashrc & putting in $target_script_path/bashrc"
cat ~/.bashrc | sed '0,/#%%%%#/d' | sed -e '/#+-+-+#/d' > $target_script_path/bashrc

echo "Done updating all scripts."
echo "Now you can run imksc.pl to create pkish.sh"
