#!/usr/bin/env perl
use strict;
use warnings;
use Time::Local;
use Mail::IMAPClient;
use IO::Socket::SSL;

my %monthMapping = ( 
        'Jan' => '1',
        'Feb' => '2',
        'Mar' => '3',
        'Apr' => '4',
        'May' => '5',
        'Jun' => '6',
        'Jul' => '7',
        'Aug' => '8',
        'Sep' => '9',
        'Oct' => '10',
        'Nov' => '11',
        'Dec' => '12'
);

my $currentEpoch = time();

# Connect to the IMAP server via SSL
my $socket = IO::Socket::SSL->new(
   PeerAddr => 'inbound.electric.net',
   PeerPort => 993,
  )
  or die "socket(): $@";

# Build up a client attached to the SSL socket.
# Login is automatic as usual when we provide User and Password
my $client = Mail::IMAPClient->new(
   Socket   => $socket,
   User     => 'bounces@collections.fusemail.com',
   Password => 'b!tt@r',
  )
  or die "new(): $@";

# Do something just to see that it's all ok
print "I'm authenticated\n" if $client->IsAuthenticated();
exit;
my @folders = $client->folders();
print join("\n* ", 'Folders:', @folders), "\n";

my $counter = 0;
my $total = 20000;
#my $folder = 'INBOX';
my $folder = 'INBOX.M4.Sanity checks';

$client->select( $folder );
#my @icingamsgs = $client->search( 'TEXT "sanity"' );
my @icingamsgs = $client->search( 'ALL' );

my $oldCount = $client->message_count( $folder );
print "There are ". $oldCount." messages in the $folder folder.\n";

foreach my $id ( @icingamsgs ) {

	last if $counter >= $total;
	my $messageid = $client->get_header( $id, "Message-Id" );
	my $messagedate = $client->get_header( $id, "Date" );
	#Wed, 16 Jan 2013 12:39:37 -0800
	#or │msgdate=14 Mar 2013 05:01:56 -0700 
	#print "msgdate=$messagedate\n";
	#my($weekday,$day,$month,$year,$hour,$min,$sec,$offset);
	#if ( $messagedate =~ /,/ ) {
	#	($weekday,$day,$month,$year,$hour,$min,$sec,$offset) = split (/\s|:/,$messagedate);
	#}else{
	#	($day,$month,$year,$hour,$min,$sec,$offset) = split (/\s|:/,$messagedate);
	#}
	##getEpoch
	#my $ymd = "$year-$monthMapping{$month}-$day";
	#$sec =~ s/^0(\d)+/$1/g;
	#$min =~ s/^0(\d)+/$1/g;
	#$hour =~ s/^0(\d)+/$1/g;
	#print "timmm = $ymd-$hour-$min-$sec\n";
	##exit;
	#my $epoch = timelocal($sec,$min,$hour,$day,$month,$year); 
	##greater than 6 days
	#if ( ( $currentEpoch - $epoch ) > 86400 ){
	print "counter=$counter=$messageid => $messagedate will be deleted\n";
	$client->delete_message( $id );
	$counter++;
		#}else{
		#	print "keep $messageid => $messagedate = $ymd \n";
		#}
}

#expunge them
$client->expunge( $folder ) or die "Could not expunge: $@\n";
$client->message_count( $folder );
print "There are ".$client->message_count( $folder )." messages in the $folder folder ( used to have $oldCount).\n";
# Say bye
$client->logout();
