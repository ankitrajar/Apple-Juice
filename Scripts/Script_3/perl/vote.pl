use LWP::UserAgent;
#use JSON;

my $referer = "http://culinaryvoice.ice.edu/culinaryvoice/r4dBLFN";
my $url = "http://culinaryvoice.ice.edu/culinaryvoice/vote";
my $host = "culinaryvoice.ice.edu";
my $message = "entry_id=102";

my @headers = (
'User-Agent' => 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:23.0) Gecko/20100101 Firefox/23.0',
'Accept' => 'application/json, text/javascript, */*; q=0.01',
'Accept-Language' => 'en-US,en;q=0.5',
'Accept-Encoding' => 'gzip, deflate',
'Content-Type' => 'application/x-www-form-urlencoded; charset=UTF-8',
'X-Requested-With' => 'XMLHttpRequest',
'Referer' => 'http://culinaryvoice.ice.edu/culinaryvoice/r4dBLFN',
'Content-Length' => '12',
#Cookie: uid=CgoKE1ULAgpRXx7wAw4VAg==; _ga=GA1.3.737416677.1426784782; _dc_gtm_UA-2701554-1=1
'Connection' => 'keep-alive',
'Pragma' => 'no-cache',
'Cache-Control' => 'no-cache',
Content_Type => 'application/x-www-form-urlencoded',
Content => $message
);

my $browser = LWP::UserAgent->new( );
$browser->cookie_jar({});
$response = $browser->post($url, @headers);
print $response->content;
