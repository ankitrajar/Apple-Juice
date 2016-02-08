#!/usr/bin/perl  
use File::Basename;
my $TOTAL_ARGS = $#ARGV + 1;
if ($TOTAL_ARGS < 6)
{
print "USAGE:$0 <ENV:TARGET/HOST> <Log File Path> <Task Name(NM/UNKNOWN etc.)> <Process Map File Path> <Daemon map .d.map full path> <Result File Path with File Name>\n";
exit;
}
$ENVIRONMENT=shift;
my $LOG_FILE_PATH = shift;
my($LOG_FILE_NAME, $LOG_FILE_DIR, $LOG_FILE_EXT) = fileparse($LOG_FILE_PATH);
my $TASK_NAME=shift;
my $PROCESS_MAP_PATH = shift;
my($PROCESS_MAP_FILE_NAME, $PROCESS_MAP_FILE_DIR, $PROCESS_MAP_FILE_EXT) = fileparse($PROCESS_MAP_PATH);
my $DAEMON_LINKER_MAP_PATH = shift;
my($DAEMON_NAME,$LINKER_MAPS_DIR, $DAEMON_TMP) = fileparse($DAEMON_LINKER_MAP_PATH, qr/\..*/);
$LINKER_MAPS_DIR =~ s/\/$//g;
my $RESULTS_PATH = shift;
my($RESULT_FILE_NAME, $RESULT_FILE_DIR, $RESULT_FILE_EXT) = fileparse($RESULTS_PATH);
my $DAEMON_LINKER_MAP_PATH = $LINKER_MAPS_DIR."/".$DAEMON_NAME.".d.map";

if($ENVIRONMENT !~ /TARGET|HOST/i){
	print "ENV: TARGET or HOST \n";
	exit;
}

if(!(-e $LOG_FILE_PATH)){
	print "LOG_FILE_PATH not found.Hence Exiting\n";
	exit;
}

if(!(-e $RESULT_FILE_DIR)){
    print "RESULT_FILE_DIR, not found.Hence Making it.\n";
    system("mkdir -p $RESULT_FILE_DIR");
}

if(!(-e $PROCESS_MAP_PATH)){
    print "PROCESS_MAP_PATH not found.Hence Exiting\n";
    exit;
}

if(!(-d $LINKER_MAPS_DIR)){
    print "LINKER_MAPS_DIR dir doesn't exist.Hence Exiting\n";
    exit;
}

if(! defined $TASK_NAME) {
    print "TASK_NAME not passed in args.";
    exit;
}

if(! defined $DAEMON_NAME) {
    print "DAEMON_NAME not passed in args.";
    exit;
}

if(-e $RESULTS_PATH){
	system("rm $RESULTS_PATH\n");
}

# if ( $daemon =~ m/^init/) {
#     $daemon =~ s/init//g;
# }

# Since the name of the daemon might involve upper case characters , the .d.maps file will also have upper case characters.
# Lets not change the name of the daemon file but we can change the name of the log file
# Also we can change the name of the .maps file without too much trouble
# So we can modify the name of the log file to the same as that of the daemon .d file
# FIXME : Will this work for init files as well ? 
%hash = getStackInfo($LOG_FILE_PATH);
print_hash(%hash);
my %daemon_map_hash = get_address_hash("$DAEMON_LINKER_MAP_PATH");  # processed only once

process(%hash);

print "Please look at $RESULTS_PATH for results \n";
print "Happy Debugging\n";


#-------------------------------------------------#
#     Routine to get the Statck Info              #
#   Gets the pid and associated addresses         #
#-------------------------------------------------#

sub getStackInfo {
	my $file = shift;
	open(FH,"< $file");
	my %hash = ();

	while(my $line = <FH>){
		if($line =~ /^(.*): $TASK_NAME (.*): StackDump : (.*)/i){
			$date = $1;
			$pid = $3;
			$hash{"$pid"} = ();
			print "Found a Stack dump :-) at date $date for  pid $pid \n";
			while(($line = <FH>) && ($line !~ /$TASK_NAME started with pid/)){
				if($line =~ /$TASK_NAME :(.*): (\d+) (\w+)/){
					push @{array_.$pid}, $3;
								
				}
			}
			$hash{"$pid"} = \@{array_.$pid};
			$time{"$pid"} = $date;
		}	
	} 
	close(FH);
	if(keys %hash){
		return(%hash);
	}else{
		print "No StackDump found in $file \n";
		exit;
	}
}

#---------------------------------#
#   Routine to print hash         #
#---------------------------------#
sub print_hash {
	my(%hash) = @_;
	open(FH,">>$RESULTS_PATH");
	foreach $key (keys %hash){
		print FH "-------------------------------\n";
		print FH "THE PID = $key \n";
		print FH "THE TIME OF CRASH : $time{$key}\n";		
		print FH "-------------------------------\n";
		print FH "The crash address are : \n";
		$array = $hash{$key};
		$i = 0;
		while($array->[$i]){
			print FH " $array->[$i] \n";
			$i++;
		}
	}
	close(FH);
	
}

#---------------------------------#
#   Routine to process hash       #
#---------------------------------#

sub process {
	my(%hash) = @_;	
	foreach my $key (keys %hash){

	open(PID,">>$RESULTS_PATH");
#### Have one format here .. to print pid of daemon
format PID =



============================================================================================
  $TASK_NAME D CRASH : @<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
            $time{$key}
=============================================================================================
. 
#$~ = "PID";
write(PID) ;
	close(PID);

		my $array = $hash{$key};
		my $i = 0;
		while($array->[$i]){
#			print "IN process $key values are $array->[$i] \n";
			my $lookup_file =  findFileToProcess($array->[$i],$key);
			if($lookup_file =~ /$DAEMON_LINKER_MAP_PATH/){
				processmap($array->[$i]);
			}else{
				processpidfile($array->[$i],$PROCESS_MAP_PATH);
			}	
			$i++;
		}
	}
}

#----------------------------------------------------------------#
#   Returns the file which has be looked into for processing     #
#----------------------------------------------------------------#

sub findFileToProcess {
	my($address) = @_;
	my $hex_address = hex($address);

	if($ENVIRONMENT eq "TARGET"){ 
		$bin_boundry = 0x10000000;
		if($hex_address > $bin_boundry){
#			print "*** $address should be looked in $daemon.d.map file \n";
			return($DAEMON_LINKER_MAP_PATH);
		}else{
#			print "*** $address should be looked in *.so.map file \n";
			return($PROCESS_MAP_PATH);
		}
	}else{
		$bin_boundry = 0x40000000;

		if($hex_address > $bin_boundry){
#			print "*** $address should be looked in *.so.map file \n";
			return($DAEMON_LINKER_MAP_PATH);
		}else{
#			print "*** $address should be looked in $daemon.d.map file \n";
			return($PROCESS_MAP_PATH);
		}

	}

}

#----------------------------------------------------------------#
#   Returns the function for the specified address               #
#----------------------------------------------------------------#

sub findFunction{
	my($address, $lookup_file,$pid) = @_;
	if($lookup_file =~ /$DAEMON_LINKER_MAP_PATH/){
		return(processmap($address));
	}else{
		return(processpidfile($address,$PROCESS_MAP_PATH.$pid));
	}
}

#------------------------------------------------#
#  Gets the address hash from the file           #
#------------------------------------------------#
sub get_address_hash {
	my($file) = @_;
	my %address_hash = ();
	if(open(FH , "<$file")){
	}else{
		print "$file could not be opened \n" ;
		return;
	}
	while(my $line = <FH>){
		if($line =~ /(.*)(0x(\w+))(\s+) (.*)$/){
			$address_hash{$2} = $5; 
		}
	}
	close(FH);
	return %address_hash;
}

#---------------------------------------------#
#   finds the the errorneous function         #
#---------------------------------------------#
sub getFunctionName {
	my($address,%address_hash) = @_;
	my @address_array = ();
	@address_array = sort by_hex keys(%address_hash);
#	print "After sorting\n";
	for(my $i=0;$i<$#address_array;$i++){
		if(hex($address_array[$i]) > hex($address)){
#			print "HIGHER ADDRESS = $address_array[$i]\n";
#			print "LOWER ADDRESS = $address_array[$i-1]\n";
#			print "The Culprit ----- $address_hash{$address_array[$i-1]}\n";
            my $offset = hex($address) - hex($address_array[$i-1]);
			return $address_hash{$address_array[$i-1]}." + $offset instruction opcodes";
			#last;
		}
	}
}

#------------------------------------------------#
#   finds the the function in map file           #
#------------------------------------------------#

sub processmap {
	my($address) = @_;
	my $file = $DAEMON_NAME.".d.map";
	open(FUNCTION,">>$RESULTS_PATH");
	my $err_func = getFunctionName($address,%daemon_map_hash);
	if(!$err_func){
		$err_func = "Not found";
	}

#have one format here ... To print address and function name
format FUNCTION =
@<<<<<<<<<|^<<<<<<<<<<<<<<<<<<<< |^<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
$address      $file                $err_func
~~        		                 |^<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
	                              $err_func	
-------------------------------------------------------------------------------------------------------
. 
write(FUNCTION) ;
	
	close(FUNCTION);

#	print "Errored function for $address is $err_func \n";
	return;
}

#---------------------------------------------------#
#   finds the the function through in pidfile file   #
#---------------------------------------------------#

sub processpidfile {
	my($address,$file) = @_;
	my @address_array = ();
	my %address_hash = ();
	my $so_name = "";
	my $offset = "";
	open(DAEMON_MAP , "<$file");
	my $so_file = "";
	my $prev_so_file = "";
	my $old_base_add = "";
	while(my $line = <DAEMON_MAP>){
		my($address_range,$temp1,$temp2,$time,$temp3,$so_file) = split(" ",$line);
		my($new_base_add,$new_last_add) = split("-",$address_range); 	
		if($so_file eq $prev_so_file){	
			$new_base_add = $old_base_add;
		}else{
			$old_base_add = $new_base_add;
			$prev_so_file = $so_file;
		}
		$address_range = "$new_base_add-$new_last_add";
		$address_hash{$so_file} = $address_range;
	}
	close(DAEMON_MAP);
	foreach my $key (keys %address_hash){
		my($base_add,$last_add) = split("-",$address_hash{$key});
		if((hex($base_add) <= hex($address)) && (hex($last_add) >= hex($address))){
#			print "Found the bad .so -- it is $address_hash{$key} \n";
			$key =~ /(.*)sharedobj\/(.*)/;
			$so_name = $2;
#			print "The name of the so is $so_name\n"; 
			$offset = hex($address) - hex($base_add);
			$offset = sprintf "%lx",$offset;
#			print "Offset in the .so file is ".$offset." \n";
			last;
		}
	}
	findSoFunction($address,$so_name,$offset);
	return;
}

#---------------------------------------#
#   Finds the function in the .so file  #
#---------------------------------------#
sub findSoFunction {
	my($address,$file,$offset) = @_;
	my %address_hash = ();
	my $err_function = "";
	if($file){
		$file =~ /lib(.*).so/;
		my $so_file = $1.".lo.so.map";
		if(!(-e "$LINKER_MAPS_DIR/$so_file")){
#			print "$so_file is not present in the $mapPath\n";
		 	$err_function = "$so_file is not present in the $LINKER_MAPS_DIR";
		}else{
			%address_hash = get_address_hash("$LINKER_MAPS_DIR/$so_file");
			$err_function = getFunctionName($offset,%address_hash);
		 	if(!$err_function){
#				print "Function for $offset not found\n";
				$err_function = "Function for $offset not found";
			}else{
#				print "Errored function for $offset is $err_function \n";
			}
		}
	}else{
		$err_function = "Corresponding .so for $address not found in $PROCESS_MAP_FILE_NAME";	
	}

### Have one format here .. to print address , so-name and err_func
format SO_FUNCTION =
@<<<<<<<<<|^<<<<<<<<<<<<<<<<<<<< |^<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
$address      $file                  $err_function
~~                  			 |^<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
	    				  $err_function
---------------------------------------------------------------------------------------------------------
. 
write(SO_FUNCTION) ;
	
	close(SO_FUNCTION);


}

#---------------------------------#
#   Sorts the array on hex value  #
#---------------------------------#

sub by_hex {
	return( hex($a) <=> hex($b) );
}

