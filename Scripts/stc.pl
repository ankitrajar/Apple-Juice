#!/usr/bin/perl -w

use Tk;

my $mw = MainWindow->new;
$mw->geometry("400x320");
$mw->title("Pseudowire Switching Time Calculator");


my $main_frame = $mw->Frame()->pack(-side => 'top', -fill => 'x');

my $top_frame = $main_frame->Frame(-background => "red")->pack(-side => 'top', -fill => 'x');
my $left_frame = $main_frame->Frame(-background => "black")->pack(-side => 'left', -fill => 'y');
my $right_frame = $main_frame->Frame(-background => "white")->pack(-side => "right");
my $bottom_frame = $main_frame->Frame(-background => "white")->pack(-side => "bottom");
$top_frame->Label(-text => 'PSEUDOWIRE SWITCHING TIME CALCULATOR', -background => "red")->pack();

my $label = $mw -> Label(-text=>"Tx Packets :") -> pack(-fill=>'both');
$e1 = $mw->Entry(-textvariable => \$var1)->pack(-fill=>'both');
my $label = $mw -> Label(-text=>"Rx Packets :") -> pack(-fill=>'both');
$e2 = $mw->Entry(-textvariable => \$var2)->pack(-fill=>'both');
my $label = $mw -> Label(-text=>"Rate :") -> pack(-fill=>'both');
$e4 = $mw->Entry(-textvariable => \$var5)->pack(-fill=>'both');
my $label = $mw -> Label(-text=>"Dropped Packets :") -> pack(-fill=>'both');
$e3 = $mw->Entry(-textvariable => \$var3)->pack(-fill=>'both');
my $label = $mw -> Label(-text=>"Switching Time(msec):") -> pack(-fill=>'both');
$e4 = $mw->Entry(-textvariable => \$var4)->pack(-fill=>'both');

$b1 = $mw->Button(-text => "Calculate", -command => sub { $var3 = abs($var1 - $var2); $var4=abs($var3/$var5)*1000; })->pack(-side=>'top',-fill=>'both');
$b2 = $mw->Button(-text => "Exit", -command => sub {exit})->pack(-side=>'bottom', -fill=>'both');
MainLoop;
