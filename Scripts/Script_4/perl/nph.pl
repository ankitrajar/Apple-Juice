#!/usr/bin/perl

use HTTP::Request::Common qw(POST);
use LWP::UserAgent;
use LWP::Simple;
use HTML::Parser;

find_name(@ARGV); 

sub find_name() {
	$name = shift;
	$key = (shift or "name");
	$ua = new LWP::UserAgent;
	#my $url = 'http://postfix/cgi-bin/tejas/tis.cgi';
	my $url = 'http://192.168.0.8/cgi-bin/tejas/tis.cgi?action=searchUserInfo&key=name&keyval=';
	my $res = $ua->request(POST $url,
			[ action => searchUserInfo,
			keyval => $name,
			key => $key],
		      );

	if($res->is_success)  {
	print $res->content;
	#system("html2text", print $res->content);
	print "\n";
	} else {
		print "Error: " . $res->status_line . "\n";
	}                                                                                                                         
}

