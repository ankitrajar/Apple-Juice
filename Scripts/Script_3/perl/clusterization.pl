#!/usr/bin/perl
use File::Basename;
# take the directory to be processed from first command line argument
opendir($dh, $ARGV[0]);
	my $count=0;
# take only relevant files ie. "*.config"
@list_of_all_matching_files = @ARGV;
# loop through files
foreach my $file_name (@list_of_all_matching_files) {
	$count++;
	print "$count $file_name\n";
  rename("$file_name", "$file_name.bak");
  # open backup file for reading
  open(I, "< $file_name.bak");
  # open a new file, with original name for writing
  open(O, "> $file_name");
  my $prev_line="";
while(my $current_line = <I>) {
  my $current_line_backup=$current_line;
  $current_line =~ /(: .*log00\d{1}:)/g;
  my $current_line_file = $1;
  $prev_line =~ /(: .*log00\d{1}:)/g;
  $prev_line_file = $1;
  # print "$prev_line_file\n";
  # print "$current_line_file\n";
  if ( $current_line_file ne $prev_line_file )
 {
     print O "\n_______________________________________________ $current_line_file ______________________________________\n";
 }
  my $to_print=$current_line_backup;
  $to_print =~ s/: .*log00\d{1}://g;
  print O $to_print; 

  $prev_line = $current_line_backup;
 }
  # close files
  close(I);
  close(O);
}