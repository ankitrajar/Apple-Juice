my $dir = "/home/parmil/myscripts";
opendir DIR,$dir;
my @dir = readdir(DIR);
close DIR;
foreach(@dir){
    if (-f $dir . "/" . $_ ){
        print $_,"   : file\n";
    }elsif(-d $dir . "/" . $_){
        print $_,"   : folder\n";
    }else{
        print $_,"   : other\n";
    }
}
