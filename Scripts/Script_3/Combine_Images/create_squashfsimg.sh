#!/bin/bash

# Usage: create_squashimg.sh <input dirname> <output image name>
if [ $# -lt 3 ];
then
   echo "usage : create_squashimg.sh <input dirname> <output image name> <path-to mksquashfs>"
   exit 1;
fi


MKSQUASHFS=$3/mksquashfs

echo Creating $2 from "$1/*"

$MKSQUASHFS $1 $2 -be -force-uid 0 -force-gid 0 -noappend

chmod a+rwx $2
