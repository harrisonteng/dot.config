#!/usr/bin/perl -w
#
# check Linux MD and MegaRaid
#
# $Id: check_raid_v2.pl 6138 2012-01-06 23:29:11Z harrison $
#

use strict;
use warnings;
use Getopt::Long qw(:config no_ignore_case);

use constant TRUE     => 1;
use constant FALSE    => 0;
use constant CRITICAL => 2;
use constant WARN     => 1;
use constant OK       => 0;

chomp ( my $hostname=`hostname` );
#options;
my %options = ();
my $verbose;

#techemail
my $techemail="harrison\@localhost";

sub usage_quit{

  # Emit usage message, then exit with given error code.
  print <<"END_OF_MESSAGE"; exit($_[0] || 0);

Usage:
$0 --emails=tech\@m4,tech\@fuse,tech\@emc --total=4 --model=md|mega --bin="/usr/local/m4noctools/MegaRAID/MegaCli/MegaCli64 -LdPdInfo -aALL"

  Check Raid Status

Switches:

  -m, --model=md|mega|areca
			MD,MegaRaid,Areca
  -e, --emails
			[emails] sent alert emails to these addresses
  -t, --total=4 
			expected 4 Raid devices
  -b, --bin=command
			command to check the raid status
  -v, --verbose
			Verbose output , includes every PDs under VD	
END_OF_MESSAGE
}

sub sanityCheck {

        return ( FALSE,"What kind of Raid you want to check on $hostname !\n" ) unless ( $options{'model'} );

        if ( $options{'model'} eq 'mega' || $options{'model'} eq 'areca' ) {
	
		my $binary = (split / /,$options{'bin'})[0];

		unless ( defined $binary ) {
			return ( FALSE,"Where is the binary of Raid Check Tool of $options{'model'} ? \n" );
		}

		unless ( -e $binary ) {
                	return ( FALSE,$binary." is not found on $hostname !\n" );
		}

        }
        return TRUE;
}

sub alert ($$$) {

        my ( $subject,$message,$alertcode ) = @_;

        print $message."\n";

        if ( defined $options{'emails'} ) {

                foreach my $email ( @{$options{'emails'}} ) {

                        open ( MAIL,"|/usr/lib/sendmail $email" );
                        print MAIL<<MSG;

FROM: $hostname\@m4internet.com
To: $email
Subject: $subject

$message

MSG
                        close MAIL;

                }

        }

        exit $alertcode;
}


sub check_soft ($) {

        my $statfile = shift;

        #number of the devices we actually find
        my $total = 0;
        #stats
        my %stats = ();
        #set init values
        my $devid = -1;
        my $raid = '';
        my $status = '';


        open( RAID,'<',$statfile );
		$stats{'rebuild'} = 0;

        while (<RAID>) {
                chomp;
                if ( /^md(\d+)\s*:(.*?)(raid\d+)(.*)/ ) {
                        $devid = $1;
                        $raid = $3;
                        $total++;
                        next;
                }

                if ( $devid >= 0 and /(.*?)blocks(.*)\[(.*?)\]$/ ) {
                        if ( $3 =~ /U+/ ) {
                                $status = 'OK';
                        } elsif ( $3 eq 'U_' ) {
                                $status = 'DEGRADED';
                        }
                        $stats{"md$devid"} = "is $raid and its status is $status";
                        $devid = -1;
                        $raid = '';
                        $status = '';
                }

				if ( /\[(.*?)\]\s+resync/ ){
						$stats{'rebuild'} = 1;
				}

        }

        close RAID;

        #if found MDs less than the expected, alert
        alert( "Only $total MDs are found, expected $options{'total'} on $hostname","contact $techemail immediately ( less disks )",CRITICAL ) if $total < $options{'total'};

        #if any MDs are DEGRADED
        alert( 'There are DEGRADED ones found in : '.join(',',values(%stats)),"contact $techemail immediately",CRITICAL ) if grep /DEGRADED/,values( %stats );

		#if any md is rebuilding ..
		alert( 'Raid is rebuilding...',"Raid is rebuilding",CRITICAL ) if ( $stats{'rebuild'} > 0 );

}

sub check_mega ($) {

        my $megacli = shift;

        my @vdId;
        my @vdState;
        my @vdLevel;
        my @vdSize;
        my @vdPDs;

        my @devices;
        my @states;
        my @data;

	my $total;

        #collect data here
        open ( STAT,"$megacli|" );
        while ( <STAT> ) {

                if ( /Virtual\sDisks?:\s/ ... /Exit\sCode:\s+/ ) {

                        if ( $_ =~ /^RAID\sLevel\s*?:\s*(.*)/ ) {
                                push( @vdId,$1 );
                        } elsif ( $_ =~ /^Size\s*?:(.*)/ ) {
                                push( @vdSize,$1 );
                        } elsif ( $_ =~ /^State\s*?:\s*(.*)/ ) {
                                push( @vdState,$1 );
                        } elsif ( $_ =~ /PD:\s(\d+)/ ) {
				$total++;
                                push( @{$vdPDs[$#vdId]},$1);
                        } elsif ( $_ =~ /^Device\sId:\s?(\d+)/i ) {
                                push( @{$devices[$#vdId]},$1 );
                        } elsif ( $_ =~ /^Firmware\sstate:\s(.*)/i ) {
                                push( @{$states[$#vdId]},$1 );
                        } elsif ( $_ =~ /Inquiry\sData:\s?(.*)/i ) {
                                push( @{$data[$#vdId]},$1 );
                        }
                }
        }

        close STAT;

	my $raidmsg;

	if ( $verbose ) {
		for ( my $i=0;$i<=$#vdId;$i++ ){
			my $summary = "VD$i with Raid Level($vdId[$i]),Size($vdSize[$i]) is $vdState[$i]: ";
			my $detail;
			for ( my $j=0;$j<=$#{$vdPDs[$i]};$j++ ){
				$detail .= "PD$vdPDs[$i]->[$j]($data[$i]->[$j]) on Device Id $devices[$i]->[$j] is $states[$i]->[$j],";
      			}
      			$detail =~ s/(.*),/$1/;
      			$raidmsg .= $summary.$detail."\n";
		}
	}else{
		for ( my $i=0;$i<=$#vdId;$i++ ){
      			my $summary = "VD$i with Raid Level($vdId[$i]),Size($vdSize[$i]) is $vdState[$i].";
      			$raidmsg .= $summary."\n";
		}

	}

        #if found PDs less than the expected, alert
        alert( "Only $total PDs are found, expected $options{'total'} on $hostname","contact $techemail immediately",CRITICAL ) if $total < $options{'total'};

        #if any PDs are DEGRADED
        alert( 'There are DEGRADED ones : '.$raidmsg,"contact $techemail immediately",CRITICAL ) unless ( grep /Optimal/i,@vdState );

	return ( TRUE,$raidmsg );
}

sub check_areca ($) {

	my $arcbin = shift;

	#below interpretation is terrible though it works.
	chomp( my $raidsetinfo=`$arcbin rsf info |grep -v "===" |egrep -v '(TotalCap|GuiErr)' |awk '{print \$2" "\$3" "\$4" "\$5","\$6","\$7","\$10}'` || undef );
	chomp( my $volumesetinfo = `$arcbin vsf info |grep -v "===" |egrep -v '(Raid Name|GuiErr)' |awk '{print \$2","\$3" "\$4" "\$5" "\$6","\$7","\$8","\$10}'` || undef );
	chomp( my $pdinfo = `$arcbin disk info |grep -v '===' |egrep -v '(ModelName|GuiErr)' |awk '{print \$2","\$3","\$4","\$5" "\$6" "\$7" "\$8}'` || undef );

	#error out whenever either above gets wrong
	return ( FALSE,"Can not read RAID info from Areca Raid Controller !" ) unless ( $raidsetinfo && $volumesetinfo && $pdinfo );

	my @raidsetinfo = split /,/,$raidsetinfo;
	my $raidsetstatus = $raidsetinfo[3];
	my $diskexpected = $raidsetinfo[1];

	my @volumesetinfo = split /,/,$volumesetinfo;
	my $volumesetstatus = $volumesetinfo[4];
	my $diskfound = scalar(grep /$raidsetinfo[0]/,(split /\n/,$pdinfo));

	my @diskinfo = map { {$_->[0],$_->[1].'('.$_->[2].')'} } 
			sort { (split /\(|\)/,$a->[0])[1] <=> (split /\(|\)/,$b->[0])[1] } 
			map { my @x=split /,/;[$x[3].'-disk('.$x[0].')',$x[1],$x[2]]; } 
			grep /$raidsetinfo[0]/,(split /\n/,$pdinfo);

	my $summary = 'Raidset status ('.$raidsetstatus.'), Volumeset status('.$volumesetstatus.'), '.$diskfound.' disks ('.$volumesetinfo[3].'/'.$raidsetinfo[2].') in volume ('.$raidsetinfo[0].') as Raid level ('.$volumesetinfo[2].')';

	my $alertcode = CRITICAL;
	#Not Normal status ? alert then
	if ( $raidsetstatus ne 'Normal' or $volumesetstatus ne 'Normal' ) {
		$alertcode = WARN if ( $raidsetstatus =~ /rebuild/i );
		alert( 'Areca Raid is '.$raidsetstatus,$summary,$alertcode );
	}
	
	#found less disks ? alert then
	if ( $diskfound != $diskexpected or $diskfound != $options{'total'} ) {
		$summary = 'Looking for '.$options{'total'}.' disks, found '.$diskexpected.' in Raidset and '.$diskfound.' in Volumeset'.$summary;
		alert( 'Areca Raid got '.$diskfound.' disks,'.$diskexpected.' is expected !',$summary,$alertcode );
	}

	return ( TRUE,$summary,\@diskinfo );

}

MAIN: {


        GetOptions(
                   "h|help"        =>sub{ usage_quit(1) },
                   "emails=s@"     =>sub{ push @{$options{$_[0]}},split(',',$_[1]) },
                   "model=s"       =>sub{ $options{'model'} = (grep /^(md|mega|areca)$/i,$_[1]) ? $_[1] : undef },
                   "total=i"       =>sub{ $options{'total'} = ( $_[1] =~ /\d*/ ) ? $_[1] : undef },
                   "bin=s"         =>sub{ my $file=(split / /,$_[1])[0];$options{'bin'} = ( -e $file ) ? $_[1] : undef },
		   "v|verbose"	   =>\$verbose
                  )|| usage_quit(1);

        my ( $rtncode,$sanity_msg ) = sanityCheck();

        if ( FALSE == $rtncode ){
                print $sanity_msg;
                exit CRITICAL;
        }


        if ( $options{'model'} eq 'md' ) {

                #stat file
				my $statfile  = '/proc/mdstat';

                #check if the statfile is there
                unless ( -f $statfile ) {
                        alert( "No $statfile is located on $hostname","contact $techemail immediately",CRITICAL );
                }else{
                        check_soft( $statfile );
                }

                print "Ok:$options{'total'} mds found on $hostname\n";

        }elsif ( $options{'model'} eq 'mega' ) {

                my ( $rtncode,$msg) = check_mega( $options{'bin'} );
                print $msg;

        }elsif ( $options{'model'} eq 'areca' ) {

		my ( $rtncode,$msg,$detail ) = check_areca( $options{'bin'} );
		$msg = $msg.'. '.join ":",map {join "=>",%$_ } @$detail;
		print $msg;
	}

        exit OK;

}


