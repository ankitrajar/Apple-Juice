use strict;
use warnings;
use autodie;
use File::Basename;



die "Usage: perl $0 log1 log2 > merged.log\n" if !@ARGV;

# Initialize File handles
my @fhs = map {open my $fh, '<', $_; $fh} @ARGV;

# First Line of each file
my @data = map {scalar <$_>} @fhs;
my @prev_file_name="0";
my @current_file_name="0";
# Loop while a next line exists
while (@data) {
    # Pull out the next entry.
    my $index = (sort {$data[$a] cmp $data[$b]} (0..$#data))[0];
    my $next_index = (sort {$data[$a] cmp $data[$b]} (0..$#data))[1];
    print $data[$index];

    my $fd = fileno $fhs[$index];
    my @current_file=readlink("/proc/$$/fd/$fd");
    my @current_file_name = basename(@current_file);

#     my $next_fd = fileno $fhs[$next_index];
#     my @next_file=readlink("/proc/$$/fd/$next_fd");
#     my @next_file_name = basename(@next_file);
# if ( @current_file_name ne @next_file_name )
# {
#     print "_______________________________________________ @current_file_name ______________________________________\n";
# }

    # Fill In next Data at index.
    while (defined($data[$index] = readline $fhs[$index])) {
        last if $data[$index] =~ /^\d{2}\/\d{2}\/\d{2} \d{2}:\d{2}:\d{2}:\d{3}/;
        # print "_______________________________________________ @current_file_name ______________________________________\n";
        print $data[$index];
    }
    # End of that File
    if (! defined($data[$index])) {
        splice @fhs, $index, 1;
        splice @data, $index, 1;
    }
}
