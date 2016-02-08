#!/usr/bin/perl --
#print qq~Content-type: text/html\n\n~;
#print qq~<font face="arial" size="2">~;

use File::Find;
$dir_mask = "/home/parmil/";
# find( \&wanted_tom, '/home/thomas/public_html'); # if you want just one website, uncomment this, and comment out the next line
find( \&wanted_tom, '/home/parmil/myscripts');
exit;

sub wanted_tom {
($dev,$ino,$mode,$nlink,$uid,$gid,$rdev,$size,$atime,$mtime,$ctime,$blksize,$blocks) = stat ($_);
$mode = (stat($_))[2];
$mode = substr(sprintf("%03lo", $mode), -3);

if (-d $File::Find::name) {
$dir_name = "$File::Find::name";
$dir_name =~ s/$dir_mask//s;
print "$dir_name\n";
 } else {
$file_name = "$File::Find::name";
$file_name =~ s/$dir_mask//s;
print "$file_name\n";
 }
  return;
}
