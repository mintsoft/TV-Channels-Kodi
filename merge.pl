#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper qw(Dumper);

my %freesatNums = ();
my %freesatNames = ();
my %freesatRealNames = ();
my %channelTuning = ();
my $maxChannelNum = -1;

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

for my $channel (keys %channelTuning) {
	if(defined $freesatNames{$channel}) {
		print "$freesatNames{$channel},$freesatRealNames{$channel},$channelTuning{$channel}\n" ;
	}
}

print $/.$/.$maxChannelNum;
