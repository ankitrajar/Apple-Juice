#!/usr/bin/perl --
#print qq~Content-type: text/html\n\n~;
#print qq~<font face="arial" size="2">~;

use File::Find;

# find( \&wanted_tom, '/home/thomas/public_html'); # if you want just one website, uncomment this, and comment out the next line
find( \&wanted_tom, '/home/parmil/myscripts');
exit;

sub wanted_tom {
($dev,$ino,$mode,$nlink,$uid,$gid,$rdev,$size,$atime,$mtime,$ctime,$blksize,$blocks) = stat ($_);
$mode = (stat($_))[2];
$mode = substr(sprintf("%03lo", $mode), -3);

if (-d $File::Find::name) {
print "<br><b>--DIR $File::Find::name --ATTR:$mode</b><br>";
 } else {
print "$File::Find::name --ATTR:$mode<br>";
 }
  return;
}
