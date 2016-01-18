#!/usr/bin/env perl
use strict;
use warnings;
use Time::Local;
use Mail::IMAPClient;
use IO::Socket::SSL;

my %monthMapping = ( 
        'Jan' => '01',
        'Feb' => '02',
        'Mar' => '03',
        'Apr' => '04',
        'May' => '05',
        'Jun' => '06',
        'Jul' => '07',
        'Aug' => '08',
        'Sep' => '09',
        'Oct' => '10',
        'Nov' => '11',
        'Dec' => '12'
);

my $currentEpoch = time();

# Connect to the IMAP server via SSL
my $socket = IO::Socket::SSL->new(
   PeerAddr => 'imap.fusemail.net',
   PeerPort => 993,
  )
  or die "socket(): $@";

# Build up a client attached to the SSL socket.
# Login is automatic as usual when we provide User and Password
my $client = Mail::IMAPClient->new(
   Socket   => $socket,
   User     => 'harrison.teng',
   Password => 'N$1nternet',
  )
  or die "new(): $@";

# Do something just to see that it's all ok
print "I'm authenticated\n" if $client->IsAuthenticated();
my @folders = $client->folders();
print join("\n* ", 'Folders:', @folders), "\n";

my $counter = 0;
my $total = 10000;
#my $folder = 'INBOX.EMC.system.Icinga';
#my $folder = 'INBOX.M4.Nagios';
my $folder = 'INBOX.M4.Sanity checks';

$client->select( $folder );
my @icingamsgs = $client->search( 'ALL' );

my $oldCount = $client->message_count( $folder );
print "There are ". $oldCount." messages in the $folder folder.\n";

foreach my $id ( @icingamsgs ) {

	last if $counter >= $total;
	my $messageid = $client->get_header( $id, "Message-Id" );
	my $messagedate = $client->get_header( $id, "Date" );
	#Wed, 16 Jan 2013 12:39:37 -0800
	my($weekday,$day,$month,$year,$hour,$min,$sec,$offset) = split (/\s|:/,$messagedate);
	#getEpoch
	my $ymd = "$year-$monthMapping{$month}-$day";
	my $epoch = timelocal($sec,$min,$hour,$day,$month,$year); 
	#greater than 6 days
	if ( ( $currentEpoch - $epoch ) > 86400 ){
		print "counter=$counter=$messageid => $messagedate will be deleted\n";
		$client->delete_message( $id );
		$counter++;
	}else{
		print "keep $messageid => $messagedate = $ymd \n";
	}
}

#expunge them
$client->expunge( $folder ) or die "Could not expunge: $@\n";
$client->message_count( $folder );
print "There are ".$client->message_count( $folder )." messages in the $folder folder ( used to have $oldCount).\n";
# Say bye
$client->logout();
