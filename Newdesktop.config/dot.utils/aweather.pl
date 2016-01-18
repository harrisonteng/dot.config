##!/usr/bin/perl -w

# Get the site code.
#BC VANCOUVER INTL A CYVR  YVR   71892  49 10N  123 10W    2   X     T  Z6 CA
my $site_code = shift @ARGV;

die "Usage: $0 <site_code>\n" unless $site_code;

# Get the modules we need.
use Data::Dumper;
use Geo::METAR;
use LWP::UserAgent;
use strict;

my $ua = new LWP::UserAgent;

my $req = new HTTP::Request GET =>
  "http://weather.noaa.gov/cgi-bin/mgetmetar.pl?cccc=$site_code";

my $response = $ua->request($req);

	if (!$response->is_success) {
	
	print $response->error_as_HTML;
	my $err_msg = $response->error_as_HTML;
	warn "$err_msg\n\n";
	die "$!";
	
	} else {
	
# Yep, get the data and find the METAR.
	
	my $m = new Geo::METAR;
	$m->debug(0);
	my $data;
	$data = $response->as_string;               # grap response
	$data =~ s/\n//go;                          # remove newlines
	$data =~ m/($site_code\s\d+Z.*?)</go;       # find the METAR string
	my $metar = $1;                             # keep it
	
# Sanity check
	
	if (length($metar)<10) {
		die "METAR is too short! Something went wrong.";
	}
	
# pass the data to the METAR module.
	$m->metar($metar);
	
# Here we will take the information from the module and put it into our variables.
	my $f_temp = int($m->TEMP_F) ;
	my $time = $m->TIME;
	my @sky_conds= @{$m->SKY()}; 
	my $wind = int($m->WIND_MPH);
	my $w_dir = $m->WIND_DIR_ENG;
	my $gust = $m->WIND_GUST_MPH;
	my $vis =$m->VISIBILITY;
	my @cur_weather = @{$m->WEATHER()};
	my $dew = $m->F_DEW;
	my $bar = $m->ALT;
	my $tz_adjust = -4; #to adjust the time zone so that the metar data is in local time.
	
#lets play with the time a litte bit now		
	$time =~s/UTC//go;
	$vis =~s/Statute//go;
	my $hours;
	my $minutes;
	($hours, $minutes) = ($time =~ /(\d\d):(\d\d)/);
	my $local_hours = ($hours + $tz_adjust);
#now we need to see if the wind is gusting 
	my $gusting;
	if ($gust)  {
   		 $gusting =", gusting to $gust mph | ";
	}
	else {
   		 $gusting =" | ";
	}
	
#the program wouldn't be any good without some output...so here it is.
	print "Conditions as of $local_hours:$minutes |";
	print " @sky_conds ";
	my $c_temp = $f_temp/4;
	print "$c_temp Degrees(C) ";
	if (@cur_weather) {
		print "@cur_weather | ";
	}
	else{
		print "| ";
	}
	print "visibility is $vis | $w_dir winds blowing at $wind mph";
	print "$gusting"; 
	print "barometer at $bar inches \n";
	print @cur_weather;
	
	} # end else

exit;

__END__
