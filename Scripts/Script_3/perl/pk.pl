#!/usr/bin/perl
use warnings;
  # will change, for example, a!!a to a\!\!a
open(DATA1,"<file1") or die "Can't open data";
@file = <DATA1>;
# Copy data from one file to another.
# Open new file to write
open(DATA2, ">result");
foreach my $line (@file) {
     $line =~ s/([\$"`\\])/\\$1/g;
   print DATA2 $line;
     }
close( DATA2 );
close( DATA1 );
#full escape
#     $line =~ s/([;<>\*\|`&\$!#\(\)\[\]\{\}:'"])/\\$1/g;

