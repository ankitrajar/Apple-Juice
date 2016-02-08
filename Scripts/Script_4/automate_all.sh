current_user=$(whoami)
if [ "$current_user" == "root" ]; then
    echo "Can not run with root priviledge";
    exit;
fi
scripts_path="/home/ankit/myscripts"; #<#<#/home/ankit/myscripts#>#>#
if ! [ -e $scripts_path ];then
	mkdir -p $scripts_path
fi
bashrctoken="#&&&&^^^^BASHRCIDTOKEN^^^^&&&&#"
echo "Copying $(pwd)/* to $scripts_path"
cp -r ./* $scripts_path
echo "Setting up ~/.psm_file using ./psm_file"
cp ./psm_file ~/.psm_file
echo "Setting up ~/.tejas_nph using ./tejas_nph"
cp ./tejas_nph ~/.tejas_nph
echo "Setting up ~/.tejas_phone using ./tejas_phone"
cp ./tejas_phone ~/.tejas_phone
echo "Now going for ~/.bashrc changes."
already_there=$(cat ~/.bashrc | grep "$bashrctoken" | wc -l)
if [ "$already_there" != "1" ];then
    echo "Seems. bashrc don't have these changes. Updating ~/.bashrc"
    cat ./bashrc >> ~/.bashrc
else
    echo "These changes appears to be there in bashrc."
    echo "What should we do?"
    echo "Enter : update ,to update these changes."
    echo "Enter : delete ,to delete whatever these kind of changes present from bashrc"
    echo "Enter : exit ,to exit & do nothing."

while true
do
    read choice
    case "$choice" in 
        update)
                sed -i '/#&&&&^^^^BASHRCIDTOKEN^^^^&&&&#/,$d' ~/.bashrc
                cat ./bashrc >> ~/.bashrc
                exit ;
            ;;
        delete)
                sed -i '/#&&&&^^^^BASHRCIDTOKEN^^^^&&&&#/,$d' ~/.bashrc
                exit ;
            ;;
        exit)
                exit ;
            ;;
        *)
                echo "Invalid choice entered. Enter again."
    esac
done

fi
echo "Updated bashrc"
source ./bashrc
pe
