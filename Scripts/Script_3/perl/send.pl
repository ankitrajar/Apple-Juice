use Net::SMS::WAY2SMS;


my $mob=shift @ARGV;
my $msg=join(" ",@ARGV);




foreach my $mob_no (split(",",$mob)) {
	my $sms = Net::SMS::WAY2SMS->new(
        'user' => '8123737674' ,
        'password' => 'tilluchimpu',
        'mob'     => [$mob_no]
	);
    $sms->send("$msg");
}

