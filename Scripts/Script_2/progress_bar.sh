#!/bin/bash
############################################################## Format of Progress Bar###################################################################
main_display_array="\

                                                                        PROGRESS
      lqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqk
      x                                                                                                                                         x
      mqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqj"
###################################################################### Colors ##########################################################################
txtblk='\e[1;30m' # Black - BOLD #change this 1; to 0; for without bold.
txtred='\e[1;31m' # Red
txtgrn='\e[1;32m' # Green
txtylw='\e[1;33m' # Yellow
txtblu='\e[1;34m' # Blue
txtpur='\e[1;35m' # Purple
txtcyn='\e[1;36m' # Cyan
txtwht='\e[1;37m' # White
bakblk='\033[40m \033[0m'   # Black - Background
bakred='\033[41m \033[0m'   # Red
bakgrn='\033[42m \033[0m'   # Green
bakylw='\033[43m \033[0m'   # Yellow
bakblu='\033[44m \033[0m'   # Blue
bakpur='\033[45m \033[0m'   # Purple
bakcyn='\033[46m \033[0m'   # Cyan
bakwht='\033[47m \033[0m'   # White
txtrst='\033[0m \033[0m'    # Text Reset
color_progress_bar=$bakgrn
color_outline=$txtred
color_percentage=$color_outline
############################################################# Definations & Variables ##################################################################
IFS=""
lines_before_progress_bar=$(($(echo $main_display_array  | wc -l)-1))
total_characters_in_line=$(($(echo $main_display_array  | grep "lqqqqqq" | wc -c)-1)) # -1 to because newline character is there.
IFS=" "
total_characters_without_spaces=$(($(echo $main_display_array  | grep "lqqqqqq" | wc -c)-1)) # -1 to because newline character is there.
bar_filler_char_count=$(($total_characters_without_spaces-6)) #3 by 3 padding.
spaces_before_boundry=$(($total_characters_in_line-$total_characters_without_spaces+3))
no_of_echo_for_bar=$lines_before_progress_bar
difference_bw_bar_n_percentage=2
difference_bw_cursor_n_bar=$(($no_of_echo_for_bar+1))
spaces_before_bar_filling=$(($spaces_before_boundry+1))
position_of_percentage_text=$(($(($bar_filler_char_count/2))+$spaces_before_boundry))
total_percentage=100
half_of_percentage=$((total_percentage/2))
safe_padding=$(($difference_bw_bar_n_percentage+$no_of_echo_for_bar+1))

###################################################################### Functions ######################################################################
PUT(){ echo -en "\033[${1};${2}H";}  
ENTER_INTO_EXTRA_ASCII_CHAR_MODE(){ echo -en "\033%";echo -en "\033(0";}         
WRITE(){ echo -en "\033(B";}  
ENTER_INTO_NORMAL_MODE(){ echo -en "\033[?12l\033[?25h";}

EXTRACT_CURRENT_CURSOR_POSITION () {
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

function DRAW_BAR {
    percDone=$(echo 'scale=2;'$1/$2*$total_percentage | bc)
    halfDone=$(echo $percDone/2 | bc)
    barLen=$(echo ${percDone%'.00'})
    barLen=$((barLen*$half_of_percentage/$bar_filler_char_count))
    halfDone=`expr $halfDone + $spaces_before_bar_filling`
    tput bold
    PUT $percentage_row $position_of_percentage_text; echo -e ${color_percentage}$barLen%  ; #Print the percentage
    PUT $bar_row $halfDone;  echo -e "${color_progress_bar}" #Draw the bar
    tput sgr0
}

######################################################################### Start Script ###############################################################
exec < /dev/tty
oldstty=$(stty -g)   # Save Initial Configuration.
# To tackle the case when cursor position is lowermost. If don't use safe padding before drawing. It will start printing vertically also. 
for ((i=1;i<=$safe_padding;i++))
do
    echo -e " "
done
# Setting cursor at same location.
EXTRACT_CURRENT_CURSOR_POSITION tmp
temp_row=${tmp[0]}
tput cup $(($temp_row-$safe_padding)) 0
# Getting cordinates for drawing bar. will use them later.
EXTRACT_CURRENT_CURSOR_POSITION p1
curr_row=${p1[0]}
bar_row=$(($curr_row+$difference_bw_cursor_n_bar))
percentage_row=$(($bar_row+$difference_bw_bar_n_percentage))
tput_row=$(($percentage_row+1))
ENTER_INTO_EXTRA_ASCII_CHAR_MODE    #Going to extra ascii printing mode. all Upper case letter remain intact. lower case letters are interpreted differently.
IFS=""  
echo -e "${color_outline}${main_display_array[@]}"
WRITE             
# Insert your logic to increment the percentage.
for (( i=0; i<=$bar_filler_char_count; i++ ))  
do
    DRAW_BAR $i $half_of_percentage  #Call bar drawing function "DRAW_BAR"
    sleep .01
done
ENTER_INTO_NORMAL_MODE #Normal mode.
tput cup $tput_row 0
stty $oldstty #set saved config.
########################################################################### End Of Script ##############################################################
