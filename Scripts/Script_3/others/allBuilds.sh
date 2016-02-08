#!/bin/bash

my_dir=$PWD
cd $my_dir;

MIRROR=mirror
#NOBUILD='-nobuild';
SYMBOLS='-symbols'
DEBUG='-debug'

TJ100_MC=$PWD/BR_8_0_1

log=$my_dir/buildLogs/newbldbuild$1.log
mkdir -p $my_dir/buildLogs
my_l2_sw='YES';
for i in $@ ; do

    if [ $i == "tj1700" ]; then
        my_l2_sw="YES"
    else
        my_l2_sw="NO"
    fi

    cd $my_dir
    string1="++++++++++++++++++++++++++   Making $i Build with L2_switching = $my_l2_sw   +++++++++++++++++"
    echo $string1
    echo $string1 >> $log


    BUILDDIR=$PWD/MIRROR_cef5
    if [ -d $BUILDDIR ]; then
        echo "Folder present";
    else
        echo "Making Mirror"
        $MIRROR $TJ100_MC $BUILDDIR
    fi

    cd $BUILDDIR/tj100_mc/scripts
    date=`date`
    string="LOG:: Starting build for $i at $date"
    echo $string
    echo $string >> $log

    if [ $i == "tj1700" ]; then
        ./create_install -target=$i -dir=$BUILDDIR -noupdate -noclean -cpu=ppc -swimg  -l2_switching=YES -db $NOBUILD $SYMBOLS $DEBUG -parallels=4>> $log 2>&1
    else
        if [ $i == "xcc360g" ]; then
            ./create_install -target=$i -dir=$BUILDDIR -noupdate -noclean -cpu=ppc -swimg  -l2_switching=YES -db  $NOBUILD $SYMBOLS $DEBUG -parallels=4 >> $log 2>&1
        else
            if [ $i == "elan07" ]; then
                ./create_install -target=$i -dir=$BUILDDIR -noupdate -noclean -cpu=ppc -swimg  -l2_switching=YES >> $log 2>&1
            else
                ./create_install -target=$i -dir=$BUILDDIR -noupdate -noclean -cpu=ppc -swimg -l2_switching=YES -maps $NOBUILD  $SYMBOLS $DEBUG -parallels=4 >> $log 2>&1
            fi
        fi
    fi
    date=`date`
    string="LOG:: Finished build for $i at $date"
    echo $string
    echo $string >> $log
done

