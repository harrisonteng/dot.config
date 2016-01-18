#!/usr/bin/perl

# Mail::IMAPClient and SSL Demo Code     v0.01
# ----------------------------------     -----
# 
# This code shows how to make Mail::IMAPClient connect to an SSL IMAP
# server.
#
# It doesn't actually do much, but is an example of how to incorperate it
# into you own code. Thanks to Ganesh Sittampalam for figuring most of this
# stuff out the hard way....
#
#      Nick Burch <nick@tirian.magd.ox.ac.uk>
#           24/08/2004

use strict;
use Mail::IMAPClient;
use IO::Socket::SSL;

# Define our server and credentials here
# * Really ought to able to have several accounts defined
#
#  ** fix me **    your details go below
my $username = 'john.smith';
my $password = 'bitter';
my $server = 'my.imap.provider.invalid';

# Open an SSL session to the IMAP server
# Handles the SSL setup, and gives us back a socket
my $ssl=new IO::Socket::SSL("$server:imaps");
die ("Error connecting - $@") unless defined $ssl;
$ssl->autoflush(1);

# Initialise the IMAP object
# Annoyingly, when giving it a Socket, it won't do the initial IMAP 
# welcome stuff, so we have to do that ourselves a little later on
my $imap=Mail::IMAPClient->new(
	Socket => $ssl,
#	Debug => 1,
	User => $username,
	Password => $password,
	Peek => 1
);

# Tell Mail::IMAPClient we're connected
$imap->State(Mail::IMAPClient::Connected);

# Get the IMAP Server to the point of accepting a login prompt
# Basically, we skip over the welcome messages until at the OK stage
my ($code, $output) = ("","");
until ( $code ) {
	$output = $imap->_read_line or return undef;
	for my $o (@$output) {
		$imap->_debug("Connect: Received this from readline: ".join("/",@$o)."\n");
		$imap->_record($imap->Count,$o);        # $o is a ref
		next unless $o->[Mail::IMAPClient::TYPE] eq "OUTPUT";
		($code) = $o->[Mail::IMAPClient::DATA] =~ /^\*\s+(OK|BAD|NO)/i  ;
	}
}
# Did we get an OK welcome back?
if ($code =~ /BYE|NO /) {
	$imap->State("Unconnected");
	die "IMAP server disconnected";
}

# Now, have Mail::IMAPClient send the login for us
$imap->login;

# From now on, we're OK and connected
# As a demo, print out the IDs of the messages in our inbox
$imap->select('INBOX');
my @mails = ($imap->seen(),$imap->unseen);
foreach my $id (@mails) { print "$id\n"; }

# Disconnect
$imap->close;
