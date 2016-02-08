#!/usr/bin/perl
use File::Basename;
# take the directory to be processed from first command line argument
opendir($dh, $ARGV[0]);
	my $count=0;
my $extra_pattern  =$ARGV[1];
# take only relevant files ie. "*.config"
@list_of_all_matching_files = grep { /.*log00.*/ } readdir($dh);
# loop through files
foreach my $file_name (@list_of_all_matching_files) {
	$count++;
	print "$count $file_name\n";
  # # generate source string from the filename
  # ($s) = ($_ =~ /.*_(\w+)\.config.*/);
  # $s = "${s}Common";
  # # generate replacement string from the filename
  # $r = "~ /${s}[/ >";
  # # # move original file to a backup
  # rename("${ARGV[0]}${_}", "${ARGV[0]}${_}.bak");
  # # open backup file for reading
  # open(I, "< ${ARGV[0]}${_}.bak");
  # # open a new file, with original name for writing
  # open(O, "> ${ARGV[0]}${_}");
    # # move original file to a backup
  rename("${ARGV[0]}$file_name", "${ARGV[0]}$file_name.bak");
  # open backup file for reading
  open(I, "< ${ARGV[0]}$file_name.bak");
  # open a new file, with original name for writing
  open(O, "> ${ARGV[0]}$file_name");
  # go through the file, replacing strings
  # while(<I>) { $_ =~ s/$s/$r/g; print O $_; }
    #   my @current_file=readlink("/proc/$$/fd/I");
    # my @current_file_name = basename(@current_file);
while(<I>) {
	next if $_ =~ /^$/;
	$_ =~ s/^(\d+)\/(\d+)\/(\d+) (\d+):(\d+):(\d+):(\d+)/$1\/$2\/$3\ $4:$5:$6:$7: ${extra_pattern}_$file_name/g; 
	print O $_; 
}
  # close files
  close(I);
  close(O);
}

# end of file.



# 's/^(\d+)\/(\d+)\/(\d+) (\d+):(\d+):(\d+):(\d+)/$1\/$2\/$3\ $4:$5:$6:$7: $0/g;'
