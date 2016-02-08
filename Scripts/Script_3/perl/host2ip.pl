use strict; use warnings;
use Socket;
use Data::Dumper;

my @addresses = gethostbyname('google.com');
my @ips = map { inet_ntoa($_) } @addresses[4 .. $#addresses];
print Dumper(\@ips);
