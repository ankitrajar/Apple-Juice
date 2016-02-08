#!/usr/bin/perl
use warnings;
  # will change, for example, a!!a to a\!\!a
open(DATA1,"<file1") or die "Can't open data";
@file = <DATA1>;
# Copy data from one file to another.
# Open new file to write
# my @file=<> || exit(0);
open(DATA2, ">result");
print DATA2 "echo -n \""; 
foreach my $line (@file) {
     $line =~ s/([\[\]\(\)\?\$"`\\])/\\$1/g;
   print DATA2 $line;
     }
print DATA2 "\" > generated_file; diff generated_file file1;";
close( DATA2 );
close( DATA1 );
#full escape
#     $line =~ s/([;<>\*\|`&\$!#\(\)\[\]\{\}:'"])/\\$1/g;

