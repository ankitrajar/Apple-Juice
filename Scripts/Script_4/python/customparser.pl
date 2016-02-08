#!/usr/bin/perl

use HTTP::Request::Common qw(GET);
use LWP::UserAgent;
use LWP::Simple;
use HTML::Parser;

find_name(@ARGV); 

sub find_name() {
	$name = shift;
	$key = (shift or "name");
	$ua = new LWP::UserAgent;
		my $p = HTML::Parser->new(api_version => 3);
		$p->handler( start => \&start_handler, "tagname,self");
		$p->handler( end => \&end_handler, "tagname,self" );  
		$p->unbroken_text(1);
		print "\n";
		$p->parse_file("file2") || die "Dieing $!"; 
		print "\n";

}

sub start_handler
{
        my $tag = shift;
        my $self = shift;
 
        if($tag eq "tr") { print "\n"; }
        elsif ($tag eq "td") {
                $self->handler(text => sub { my $t = shift; $t =~ s/\s+/ /g; print "$t\t"; }, "dtext");
        }
}

sub end_handler
{
        my $tag = shift;
        my $self = shift;
        if ($tag eq "td") { $self->handler(text => undef); }
}
