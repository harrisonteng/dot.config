#!/usr/bin/perl -w
use strict;
#use encoding 'utf8';
use Weather::Google;
use Math::Units qw/convert/;

binmode( STDOUT, ":encoding(UTF-8)" );
my $LOCATION = "Vancouver"; # set to city name or postal code
my $gw = new Weather::Google($LOCATION);

# single-character icons for weather conditions
# returns one string with one icon per argument
sub i {
	my $i='';
	$i .=	/sun/i ?                        
				chr 0x2600 :
			/cloud/i ?
				chr 0x2601 :
			/rain|shower/i ?
				chr 0x2602 :
			/snow/i	?			
				 '*':
			$_ foreach @_;
# the above regexes probably don't cover ALL conditions
# but they do cover the ones I have seen over the past few days
	return $i
}

# format a temperature
# originally the second argument was $f but I found that 
# I had to convert the temperature much more than I had to 
# not convert the temperature. If you are one of those types 
# that thinks in non-SI units, you might want to change that.
sub t {
	my ($t, $c) = @_;
	return int($c ? $t : convert($t,'F','C')) . chr 0x00b0;
}

print '[', t($gw->temp_c,1), '(',t($gw->forecast(0,'high')), '/',
		t($gw->forecast(0,'low')), ')',
		i($gw->forecast(0,'condition')), '|',
		i($gw->forecast(1,'condition')),
		t($gw->forecast(1,'high')), '/',
		t($gw->forecast(1,'low')), ']';
