#!/usr/bin/perl --
########################################################Dumb Script Maker(don't understand special meanings)###################################
#print qq~Content-type: text/html\n\n~;
#print qq~<font face="arial" size="2">~;
use File::Find;
$dir_mask = "/home/parmil/"; #path in which, folder currently is that u want to convert to scripts
$result_sc = "/home/parmil/pksh.sh";
$diff_sc = "/home/parmil/pkdiff.sh";
$result_dir = "/home/parmil/sidiff";
$input_dir = "/home/parmil/simulator_diffs";
#this will contain final script that is able to write all scripts of that directory.
open(DATA2, ">$result_sc") or die "Cant open $result_sc";
open(DATA3, ">$diff_sc") or die "Cant open $diff_sc";

print DATA2 "mkdir -p $result_dir\n cd $result_dir\n\n";
# find( \&wanted_tom, '/home/parmil/
find( \&wanted_tom, $input_dir);
print DATA2 "\n\nchmod -R 777 $result_dir\n";
exit;

sub wanted_tom {
($dev,$ino,$mode,$nlink,$uid,$gid,$rdev,$size,$atime,$mtime,$ctime,$blksize,$blocks) = stat ($_);
$mode = (stat($_))[2];
$mode = substr(sprintf("%03lo", $mode), -3);
#
if (-d $File::Find::name) {
$dir_name = "$File::Find::name";

$new_dir_name = "$File::Find::name";
$new_dir_name =~ s/$dir_mask//s;
print DATA2 "mkdir -p $result_dir/$new_dir_name\n";
print "$new_dir_name\n";
 } else {
$file_name = "$File::Find::name";
open(DATA1,"<$file_name") or die "Can't open data";
@file = <DATA1>;
# Copy data from one file to another.
# Open new file to write
$new_file_name = "$File::Find::name";
$new_file_name =~ s/$dir_mask//s;
print DATA2 "echo -n \"";
foreach my $line (@file) {
     $line =~ s/([\$"`\\])/\\$1/g;
   print DATA2 $line;
     }
print DATA2 "\" > $result_dir/$new_file_name\n\n";
print DATA3 "echo $file_name \ndiff $result_dir/$new_file_name $file_name\n\n";
close( DATA1 );
print "$new_file_name\n";
 }
  return;
}
close( DATA2 );
close( DATA3 );
