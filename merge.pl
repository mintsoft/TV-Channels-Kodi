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
		my $channelNumber = $freesatNames{$channel};
		my $channelName = $freesatRealNames{$channel};
		my $channelTuning = $channelTuning{$channel};	
		print qq`
INSERT INTO map_channelgroups_channels (idChannel, idGroup, iChannelNumber, iSubChannelNumber, iOrder, iClientChannelNumber, iClientSubChannelNumber)
SELECT map_channelgroups_channels.idChannel, 3 AS idGroup, $channelNumber, iSubChannelNumber, iOrder, iClientChannelNumber, iClientSubChannelNumber FROM map_channelgroups_channels 
	INNER JOIN channels ON channels.idChannel = map_channelgroups_channels.idChannel
WHERE 
	channels.idChannel = (SELECT MIN(idChannel) FROM channels WHERE channels.sChannelName = '$channelName') 
	AND map_channelgroups_channels.idGroup = 1;
`;
	}
}



