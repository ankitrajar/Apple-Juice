user=$(whoami)
    if [ "$user" == "root" ]; then
        echo "Can not compile with root priviledge";
        exit;
    fi

init_time=$(date)
    cd /home/prabhath/work/REL_9_1/xccmirror/tj100_mc/src
    source ../scripts/makeenv
    makeenv xcc360g host LINUX26 $PWD NO YES YES 
    cd interfaces/
#    make clean
    make 
    cd ..
    ./version.pl
#cd /home/vikashb/SIMULATOR/MIRROR_xcc360g/modules/ce/src/app/common/nm/ems

    cd app/tj1700/nm/
# make clean
    make 
    echo "compilation started at  : "$init_time
    echo "compilation finished at : "$(date)
