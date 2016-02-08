#!/bin/bash
#   Slick Progress Bar
#   Created by: Ian Brown (ijbrown@hotmail.com)
#   Please share with me your modifications
# Functions
PUT(){ echo -en "\033[${1};${2}H";}  
DRAW(){ echo -en "\033%";echo -en "\033(0";}         
WRITE(){ echo -en "\033(B";}  
HIDECURSOR(){ echo -en "\033[?25l";} 
NORM(){ echo -en "\033[?12l\033[?25h";}

extract_current_cursor_position () {
    export $1
    exec < /dev/tty
    oldstty=$(stty -g)
    stty raw -echo min 0
    echo -en "\033[6n" > /dev/tty
    IFS=';' read -r -d R -a pos
    stty $oldstty
    eval "$1[0]=$((${pos[0]:2} - 2))" #row
    eval "$1[1]=$((${pos[1]} - 1))" #column
}

function showBar {
        percDone=$(echo 'scale=2;'$1/$2*100 | bc)
        halfDone=$(echo $percDone/2 | bc) #I prefer a half sized bar graph
        barLen=$(echo ${percDone%'.00'})
        barLen=$((barLen/2))
        halfDone=`expr $halfDone + 7`
        tput bold
        PUT $percentage_row 28; printf "%30.4s  " $barLen%     #Print the percentage
        PUT $bar_row $halfDone;  echo -e "\033[7m \033[0m" #Draw the bar
        tput sgr0
        }
# Start Script
exec < /dev/tty
oldstty=$(stty -g)
safe_padding=9
for ((i=1;i<=$safe_padding;i++))
do
    echo -e " "
done

extract_current_cursor_position tmp
temp_row=${tmp[0]}
tput cup $(($temp_row-$safe_padding)) 0

extract_current_cursor_position p1
        curr_row=${p1[0]}
        bar_row=$(($curr_row+6))
        percentage_row=$(($curr_row+9))
        tput_row=$(($percentage_row+1))
#clear
#HIDECURSOR
echo -e ""                                           
echo -e ""                                          
DRAW    #magic starts here - must use caps in draw mode                                              
echo -e "                                        PLEASE WAIT WHILE SCRIPT IS IN PROGRESS "
echo -e "    lqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqk"  
echo -e "    x                                                                                                       x" 
echo -e "    mqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqj"
WRITE             
#
# Insert your script here
for (( i=0; i<=100; i++ ))  
do
    showBar $i 50  #Call bar drawing function "showBar"
    sleep .1
done
# End of your script
# Clean up at end of script
#PUT 10 12                                          
echo -e ""                                        
NORM
tput cup $tput_row 0
stty $oldstty
