#!/bin/bash
# times run: 4

#$1 = the path to me
TIMES_RUN=$(cat "$1" | grep "times run" | head -1 | cut -d: -f2)
TIMES_RUN=$(($TIMES_RUN + 1))

# the line we want to change is on line 2
sed -i -e "2s/times run:.*$/times run: $TIMES_RUN/" "$1"
echo "This script has been run $TIMES_RUN times."
