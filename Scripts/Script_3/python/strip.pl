use HTML::Strip;

my $hs = HTML::Strip->new();

my $clean_text = $hs->parse( $raw_html );
$hs->eof;
