#! /bin/bash
THIS_SCRIPT_NAME=$0 #storing the string name.
TOTAL_PARAMETERS=$#
if [ $TOTAL_PARAMETERS -lt "3" ];then # if passed argument is not 1 then
echo "USAGE: $THIS_SCRIPT_NAME  SEPARATE_SCRIPTS(1:create separate scripts wrt X_VARIABLE, 0:single graph script.)   X_VARIABLE    ALL_Y_AXIS_VARIABLES"
exit;
fi
#######################################################DEF SECTION################################################
PASSED_PARAMETERS=( "$@" )
SEPARATE_SCRIPTS=$1
X_AXIS_VARIABLE=$2
Y_AXIS_VARIABLES=${PASSED_PARAMETERS[@]:2}
Y_AXIS_VARIABLE_STARTING_NO=2
INPUT_FILENAME="finput.txt"
COMBINED_SOURCING_SCRIPT="source_all_other_octave_scripts.m"
ALL_GRAPHS_TOGETHER_SCRIPT="all_variables_in_one_graph.m"
IMAGE_TYPE="png"
touch $COMBINED_SOURCING_SCRIPT

#######################################################COMMON PART USED###########################################
DEFAULT_HEADER="#! /usr/bin/octave -qf
fig = figure;
data = dlmread(\"$INPUT_FILENAME\",\" \");
size(data);
set(fig, \"visible\", \"off\");"
#######################################################PROCEED TO GENERATE########################################

if [ "$SEPARATE_SCRIPTS" == 1 ];then

	for VARIABLE in "${Y_AXIS_VARIABLES[@]}"
	do

		echo "$DEFAULT_HEADER" > $VARIABLE.m;
		echo "
$X_AXIS_VARIABLE = data(:,1);
$VARIABLE = data(:,2);
plot($X_AXIS_VARIABLE,$VARIABLE,\";$VARIABLE;\"), grid
xlabel(\"$X_AXIS_VARIABLE\");
ylabel(\"$VARIABLE\");
print(\"$VARIABLE.$IMAGE_TYPE\", \"-d$IMAGE_TYPE\");
		" >> $VARIABLE.m

	echo "source $VARIABLE.m" >> $COMBINED_SOURCING_SCRIPT
	done

elif [ "$SEPARATE_SCRIPTS" == 0 ];then

	echo "$DEFAULT_HEADER" > $ALL_GRAPHS_TOGETHER_SCRIPT;
	echo "$X_AXIS_VARIABLE = data(:,1);" >> $ALL_GRAPHS_TOGETHER_SCRIPT
	
	for VARIABLE in "${Y_AXIS_VARIABLES[@]}"
	do
		echo "$VARIABLE = data(:,$Y_AXIS_VARIABLE_STARTING_NO);" >> $ALL_GRAPHS_TOGETHER_SCRIPT
		let Y_AXIS_VARIABLE_STARTING_NO=Y_AXIS_VARIABLE_STARTING_NO+1
	done

	echo -n "plot(" >> $ALL_GRAPHS_TOGETHER_SCRIPT
	for VARIABLE in "${Y_AXIS_VARIABLES[@]}"
	do
	echo -n ",$X_AXIS_VARIABLE,$VARIABLE,\";$VARIABLE;\"" >> $ALL_GRAPHS_TOGETHER_SCRIPT
	done
	echo -n "), grid" >> $ALL_GRAPHS_TOGETHER_SCRIPT

	echo "
xlabel(\"$X_AXIS_VARIABLE\");
ylabel(\"ALL_VARIABLES\");
print(\"ALL.$IMAGE_TYPE\", \"-d$IMAGE_TYPE\");
	" >> $ALL_GRAPHS_TOGETHER_SCRIPT
else
	echo "Invalid Value of SEPARATE_SCRIPTS. Renter"
	exit
fi
