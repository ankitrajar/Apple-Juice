#!/usr/bin/perl --
################################################################Intelligent script maker######################################################
#print qq~Content-type: text/html\n\n~;
#print qq~<font face="arial" size="2">~;
# to escape a line from processed by script use #~~~
#so i have added these symbols in the line
# to skip a script creation of a file use <#tilde tilde tilde tilde #>
# no < > should be there and no space sould be in tilde(~) and put this in the frist line of file.
#or wherever you put it after that line it will not write that file in script.
use File::Find;
$dir_mask = "/home/parmil/"; #path in which, input_dir present
$result_sc = "/home/parmil/pkish.sh"; #resulting script with all the scripts embedded in it.
$diff_sc = "/home/parmil/pkidiff.sh"; #resulting diff script so that it will compare all the scripts generated with original.To test imksc.pl working fine.
$result_dir = "/home/parmil/rexp"; #all scripts generated from result_sc will be put in this dir.
$input_dir = "/home/parmil/myscripts"; #input scripts directory.
#this will contain final script that is able to write all scripts of that directory.
open(DATA2, ">$result_sc") or die "Cant open $result_sc"; 
open(DATA3, ">$diff_sc") or die "Cant open $diff_sc";

find( \&write_def, $input_dir); #calling write_def function so that it will write all defination section initially
print DATA2 "#Please enter the values in above declartion than run the script\n\n";
close( DATA2 );

open(DATA2, ">>$result_sc") or die "Cant open $result_sc";
find( \&wanted_tom, $input_dir); #now it will write after defination section. start embedding scripts.
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
$new_dir_name =~ s/$dir_mask//s; #dir_mask is parent path of input_dir so that we can make it base independent.
print DATA2 "mkdir -p $result_dir/$new_dir_name\n"; #in the script we have to create any new directories.
print "$new_dir_name\n";
 } else {
$file_name = "$File::Find::name"; #if its file then we will start embedding things.
open(DATA1,"<$file_name") or die "Can't open data";
@file = <DATA1>;
# Copy data from one file to another.
# Open new file to write
$new_file_name = "$File::Find::name";
$new_file_name =~ s/$dir_mask//s;
print DATA2 "echo -n \"";
COPY: foreach my $line (@file) 
{ 
if ( ($line =~ /#~~~~#/) && ($line !~ /#~~~/) ) #~~~
{ #if total file escaping sequence is used then stop processing that file.
last COPY;
}
if ( ($line =~ /; ####/) && ($line !~ /#~~~/) ) #~~~
 { #if substitution sequence is there then do substitution and don't escape the dollar sign.
     $line =~ s/.*####//g; #~~~
     $line =~ s/(["`\\])/\\$1/g;
 }
else
 { #else if its normal line then escape dollar double qoute single qoute and escape character itself
     $line =~ s/([\$"`\\])/\\$1/g;
 }
     print DATA2 $line;
}
print DATA2 "\" > $result_dir/$new_file_name\n\n"; #redirect all this echo to the resulting script.
print DATA3 "echo $file_name \ndiff $result_dir/$new_file_name $file_name\n\n"; #also wirte in diff script for this file.
close( DATA1 );
print "$new_file_name\n";
 }
  return;
}

sub write_def {
($dev,$ino,$mode,$nlink,$uid,$gid,$rdev,$size,$atime,$mtime,$ctime,$blksize,$blocks) = stat ($_);
$mode = (stat($_))[2];
$mode = substr(sprintf("%03lo", $mode), -3);
#
if (-d $File::Find::name) {
#its directory so do nothing.
 } else {
$file_name = "$File::Find::name";
open(DATA1,"<$file_name") or die "Can't open data";
@file = <DATA1>;
$flag=0;
# Copy data from one file to another.
# Open new file to write
$new_file_name = "$File::Find::name";
$new_file_name =~ s/$dir_mask//s;
DEF: foreach my $line (@file)
{
if ( ($line =~ /#~~~~#/) && ($line !~ /#~~~/) ) #~~~
{ #if total file skip sequce is there leave current file.
last DEF;
}

if ( ($line !~ /#~~~/) && ($line =~ /; ####/) ) #~~~
 {   $flag=1; #substitution sequence found; will write in defination section. flag=1 per file so that can write for which file these are.
     $temp = $line;    
     $temp =~ s/\";.*//g;
     $temp =~ s/.*\"//g;
     $temp =~ s/\n//g;
     $line =~ s/.*\"\$//g;
     $line =~ s/\";\n//g;
     print DATA2 "$line\=\"\"; #example $line\=\"$temp\";\n";
 }
}
if ($flag == 1)
{
print DATA2 "#Above declarations are for $new_file_name\n";
}
close( DATA1 );
 }
  return;
}
close( DATA3 );
