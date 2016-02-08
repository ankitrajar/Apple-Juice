#!/usr/bin/perl  
@files = <F:/novels/*>;
foreach $file (@files) {
open   (FILE, "$file");
while($line= <FILE> ){
print "$file" if $line =~ /Okay/;

}
close FILE; 
}