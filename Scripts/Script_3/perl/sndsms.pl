#!/usr/bin/perl

use Net::SMS::WAY2SMS;

my $s = Net::SMS::WAY2SMS->new(
		'user' => '7411199851' ,
		'password' => ',
		'mob'=>['7411199851', '7204217404']
		);

$s->send('Hello World this is a message from parmil kumar');
