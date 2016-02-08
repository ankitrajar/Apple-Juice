#!/usr/bin/perl

###############################################################################################
# source link : http://digitalpbk.com/2009/12/perl-script-send-free-sms-any-mobile-number-india-using-way2sms
# From CPAN :  from CPAN link itself you can download the source for way2sms.
#
# 
#
# 
#
# Goal : send sms through way2sms.com with few easy options. So I modified this below code accordingly.
#
# Note : This should work only to the Indian regions cell phone numbers only
#
# Usage :
#    Save this file in the path /usr/bin/sms and make it as excutable by setting permission
#    1. $ sms 9876543210 'hello'
#    2. $ sms 9876543210,9876501234,9988776655 'hai dude'
#    3. $ sms -f sms-nos-list-file 'message'
#                sms-nos-list-file is a text file, that contains the 10 digit phone nos with new line character.
#                i.e. each line must have only one phone no.
#                We no need to use +91 or 0 prefix no. So use only 10 digit phone no alone.
####################################################################################################

use WWW::Mechanize;
use Compress::Zlib;

my $mech = WWW::Mechanize->new();

my $username = "7411199851"; #fill in username here
my $keyword = "903191219a";  #fill in password here

my ($text,$mobile,$option);
my @mobilenos;
$option = $ARGV[0];

if ( $option == "-f") {
# reading file and collecting the nos
my $smslistfile = $ARGV[1];
$text = $ARGV[2];
open(FILE,$smslistfile) or die "Can not open file\n";
@mobilenos = <FILE>;
close FILE;
}
else{
my $morenos = $ARGV[0];
if (length($morenos) > 10) {
# splitting nos with comma seperated in the first arg
@mobilenos = split(',',$morenos);
}
else {
# for single phone no
@mobilenos = $morenos;
}
# collecting message to send
$text = $ARGV[1];
}

$deb = 1;

print "Total Character of message is ".length($text)."\n" if($deb);

$text = $text."\n\n\n\n\n" if(length($text) < 135);

$mech->get("http://wwwl.way2sms.com/content/index.html");
unless($mech->success())
{
exit;
}
$dest = $mech->response->content;

print "Fetching...\n" if($deb);

if($mech->response->header("Content-Encoding") eq "gzip")
{
$dest = Compress::Zlib::memGunzip($dest);
$mech->update_html($dest);
}

# Commented the below line from version 1b. Uncomment it for version 1a.
#$dest =~ s/<form name="loginForm"/<form action='..\/auth.cl' name="loginForm"/ig;

# Added the below updated line to replace the above line in the version 1b.
$dest =~ s/<form name="loginForm"/<form action='..\/Login1.action' name="loginForm"/ig;

$mech->update_html($dest);
$mech->form_with_fields(("username","password"));
$mech->field("username",$username);
$mech->field("password",$keyword);

print "Loggin...\n" if($deb);

$mech->submit_form();

$dest= $mech->response->content;

if($mech->response->header("Content-Encoding") eq "gzip")
{
$dest = Compress::Zlib::memGunzip($dest);
$mech->update_html($dest);
}

foreach $mobile (@mobilenos){
# for loop begins
chomp($mobile);
print "\nMessage sending to ".($mobile)."\n";

$mech->get("http://wwwl.way2sms.com//jsp/InstantSMS.jsp?value=0");
$dest= $mech->response->content;
if($mech->response->header("Content-Encoding") eq "gzip")
{
$dest = Compress::Zlib::memGunzip($dest);
$mech->update_html($dest);
}

print "Sending ... \n" if($deb);

$mech->form_with_fields(("MobNo","textArea"));
$mech->field("MobNo",$mobile);
$mech->field("textArea",$text);
$mech->submit_form();

if($mech->success())
{
print "Done \n" if($deb);
}
else
{
print "Failed \n" if($deb);
exit;
}

$dest =  $mech->response->content;
if($mech->response->header("Content-Encoding") eq "gzip")
{
$dest = Compress::Zlib::memGunzip($dest);
#print $dest if($deb);
}

if($dest =~ m/successfully/sig)
{
print "Message sent successfully \n" if($deb);
}

# foreach loop ends
}

print "Message sent to all the numbers\n Bye.\n";
exit;
#EOF
