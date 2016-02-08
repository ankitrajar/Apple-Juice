#!/usr/bin/perl
############################################################# Mutater Perl Script ########################################
#the extra string used as #~!@# is for self protection(of mutation perl script) while mutating the orginal script file.
use warnings;
$option=$ARGV[0];
$module_type=$ARGV[1];
$module_name=$ARGV[2];
$input_file_path=$ARGV[3];
$adding_module_file=$ARGV[4];
$output_file_path=$input_file_path."_evolved";
$num_args = $#ARGV + 1;
if ( (($num_args != 5) && ($option !~ /delete/)) || (($option =~ /delete/) && ($num_args != 4)) ) {
	print "\nUsage: mutate.pl add/update/delete module_type module_name input_file_path adding_module_file\nIncase of delete only 3 args\n";
	exit;
}

open(DATA1,"<$input_file_path") or die "Can't open script_file";
@file = <DATA1>;
open(DATA2, ">$output_file_path");
if($num_args == 5)
{
	open(DATA3,"<$adding_module_file") or die "Can't open module_file";
	@module_file = <DATA3>;
}

if ( ($option =~ /add/) )
{
	use Switch;
	switch($module_type){
		case "tj100_mc"     { print "Calling add function for $module_type\n"; add(); }
		case "licence"      { print "Calling add function for $module_type\n"; add(); }
		else                { print "Unknown module_type\n" }
	}
}

elsif ( ($option =~ /update/) )
{
	use Switch;
	switch($module_type){
		case "tj100_mc"     { print "Calling update function for $module_type\n"; update(); }
		case "licence"      { print "Calling update function for $module_type\n"; update(); }
		else                { print "Unknown module_type\n" }
	}
}

elsif ( ($option =~ /delete/) )
{
	use Switch;
	switch($module_type){
		case "tj100_mc"     { print "Calling delete function for $module_type\n"; delete_module(); }
		case "licence"      { print "Calling delete function for $module_type\n"; delete_module(); }
		else                { print "Unknown module_type\n" }
	}
}

else
{
	print "Unknown Option.\n";
}

close( DATA2 );
close( DATA1 );
if($num_args == 5)
{
	close( DATA3 );
}

sub add {

COPY: foreach my $line (@file) 
      { 

	      if ( ($line =~ /#modify#$module_type#array#end/) && ($line !~ /#~!@#/) ) #~!@#
	      {
		      print DATA2 "\"$module_name\"\n";
		      print DATA2 $line;
	      }

	      elsif ( ($line =~ /#modify#$module_type#case#end/) && ($line !~ /#~!@#/) ) #~!@#
	      {
     print DATA2 "\
#modify#$module_type#case#$module_name#start
  *$module_name*)
    ${module_type}_diff_file_name=\"${module_type}_${module_name}.diff\";
    ;;
#modify#$module_type#case#$module_name#end

";
              print DATA2 $line;
	      }

	      elsif ( ($line =~ /#modify#$module_type#file#end/) && ($line !~ /#~!@#/) ) #~!@#
	      {
print DATA2 "\
#modify#$module_type#file#$module_name#start
echo -n \"";
			foreach my $module_file_line (@module_file)
			{
			$module_file_line =~ s/([\$"`\\])/\\$1/g;
			print DATA2 $module_file_line;
			}
		print DATA2 "\" > \$${module_type}_diff_file_path/${module_type}_$module_name.diff";
		print DATA2 "\n#modify#$module_type#file#$module_name#end\n\n";    
		print DATA2 $line;
	      }
	      else
	      {
			print DATA2 $line;
	      }
      }

}

sub update {
	$my_flag=0;
COPY: foreach my $line (@file)
      {
	      if ( ($line =~ /#modify#$module_type#file#$module_name#start/) && ($line !~ /#~!@#/) ) #~!@#
	      {
		      $my_flag=1;
		      print DATA2 "\
#modify#$module_type#file#$module_name#start
echo -n \"";
		      foreach my $module_file_line (@module_file)
		      {
			      $module_file_line =~ s/([\$"`\\])/\\$1/g;
			      print DATA2 $module_file_line;
		      }
		      print DATA2 "\" > \$${module_type}_diff_file_path/${module_type}_$module_name.diff";
		      print DATA2 "\n#modify#$module_type#file#$module_name#end\n\n";
	      }
	      elsif (($line !~ /#modify#$module_type#file#$module_name#end/) && ($my_flag == 1) && ($line !~ /#~!@#/)) #~!@#
	      {
		      next;
	      }

	      elsif (($line =~ /#modify#$module_type#file#$module_name#end/) && ($my_flag == 1) && ($line !~ /#~!@#/)) #~!@#
	      {
		      $my_flag=0;
		      next;
	      }

	      else
	      {
		      print DATA2 $line;
	      }

      }

}


sub delete_module {
	$my_flag=0;
COPY: foreach my $line (@file)
      {

	      if ( ($line =~ /^#modify#$module_type#array#start$/) && ($line !~ /#~!@#/) ) #~!@#
	      {
		      $my_flag=1;
		      print DATA2 $line;
		      next;
	      }
	      elsif (($line !~ /^\"$module_name\"$/) && ($my_flag == 1) && ($line !~ /#~!@#/)) #~!@#
	      {
		      print DATA2 $line;
	      }

	      elsif (($line =~ /^\"$module_name\"$/) && ($my_flag == 1) && ($line !~ /#~!@#/)) #~!@#
	      {
		      $my_flag=2;
		      next;
	      }

	      elsif ( ($line =~ /#modify#$module_type#case#$module_name#start/) && ($line !~ /#~!@#/) ) #~!@#
	      {
		      $my_flag=4;
		      next;
	      }
	      elsif (($line !~ /#modify#$module_type#case#$module_name#end/) && ($my_flag == 4) && ($line !~ /#~!@#/)) #~!@#
	      {
		      next;
	      }

	      elsif (($line =~ /#modify#$module_type#case#$module_name#end/) && ($my_flag == 4) && ($line !~ /#~!@#/)) #~!@#
	      {
		      $my_flag=2;
		      next;
	      }

	      elsif ( ($line =~ /#modify#$module_type#file#$module_name#start/) && ($line !~ /#~!@#/) ) #~!@#
	      {
		      $my_flag=3;
		      next;
	      }

	      elsif (($line !~ /#modify#$module_type#file#$module_name#end/) && ($my_flag == 3) && ($line !~ /#~!@#/)) #~!@#
	      {
		      next;
	      }

	      elsif (($line =~ /#modify#$module_type#file#$module_name#end/) && ($my_flag == 3) && ($line !~ /#~!@#/)) #~!@#
	      {
		      $my_flag=2;
		      next;
	      }
	      else
	      {
		      print DATA2 $line;
	      }

      }

}

