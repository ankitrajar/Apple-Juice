    use LWP::UserAgent;
    use HTTP::Cookies;

    my $ua = LWP::UserAgent->new(agent=>"Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20100101 Firefox/14.0.1");

    $ua->cookie_jar({ file => "/absolute/path/to/cookies.txt", autosave => 1 });
    # if windows, use \ instead of /

    # $ua->proxy(['http', 'ftp'], 'http://localhost:9666/');

    # below line seems to have done the trick
    push @{ $ua->requests_redirectable }, 'POST';

    my $response = $ua->post(
            'http://site5.way2sms.com/Login1.action',{
            "username" => "8123737674", # set your username
            "password" => "tilluchimpu", # set your password
            "userLogin" => "yes",
            "message" => "hello ji",
            "mobileNo" => "8123737674",
            }
    );

    if($response->is_success && $response->decoded_content =~ /Logout/i){ # you can have your name too in place of Logout
            print "Logged in!\r\n";
    }

    my $mob = "8123737674"; # mobile to send message to
    my $mes = "Hello! 123."; # message
#http://site21.way2sms.com/main.action?section=s&Token=676D7BDD115BC54C84B01E842BFE599E.w803&vfType=register_verify
    my $smsresp = $ua->post(
            "http://site5.way2sms.com/main.action",
            {
                    'Action' => 'ssaction',
                    'HiddenAction' => 'ss',
                    'catnamedis' => 'Birthday',
                    'chkall' => 'on',
                    'MobNo' => $mob,
                    'textArea' => $mes,
            });

     if ($smsresp->is_success && $smsresp->decoded_content =~ /Submitted/i) {
         print "Sent!\r\n";
     }
