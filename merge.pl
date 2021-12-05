#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper qw(Dumper);

my %freesatNums = ();
my %freesatNames = ();
my %freesatRealNames = ();
my %channelTuning = ();
my $maxChannelNum = -1;

my %overrides = (
	"ITV" => "1:0:1:27A6:805:2:11A0000:0:0:0:",
	"ITV HD" => "1:0:19:5172:810:2:11A0000:0:0:0:",
);

my $freesatchannelsfile = 'freesat-channels-vs-numbers.csv';

open my ($freesatlist), $freesatchannelsfile;
while (my $freesatline = <$freesatlist>) {
	chomp $freesatline;
	my ($num,$name) = split(/,/, $freesatline);
	$freesatNums{$num} = $name;
	$freesatNames{(uc $name)} = $num;
	$freesatRealNames{(uc $name)} = $name;
	if($maxChannelNum lt $num){
		$maxChannelNum = $num;
	}

}
close $freesatlist;

my $namesvschannelsfile = "channels.csv";
open my ($channelslist), $namesvschannelsfile;
while (my $channelline = <$channelslist>) {
	chomp $channelline;
	my ($name, $tuning) = split(/,/, $channelline);
	$channelTuning{(uc $name)} = $tuning;
}
close $channelslist;

print "#NAME Freesat (TV)\r\n";

for my $channel (sort keys %freesatNums) {
	my $num = $channel;
	my $name = $freesatNums{$channel};
	my $tuning = $channelTuning{uc($name)};
	if(defined $overrides{uc($name)}) {
		$tuning = $overrides{uc($name)};
	}
#	print "$num $name $tuning\n";
	if($tuning) {
		print "#SERVICE $tuning\r\n";
	}
}


