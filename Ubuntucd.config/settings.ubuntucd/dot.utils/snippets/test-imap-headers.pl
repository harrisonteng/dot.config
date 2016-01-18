#!/usr/bin/perl

# Quick Imap Script to check headers
# ----------------------------------
#
# Connects to an IMAP server, and lists messages from the INBOX
# You pick the message of interest
# It shows all of the message via the message_string function
# It then shows all the headers via the parse_headers function
#
#	 Nick Burch <nick@tirian.magd.ox.ac.uk>
#	 	10/09/2004

use strict;
use Mail::IMAPClient;

# Define our server and credentials here
#
#  ** fix me **    your details go below
my $username = 'john.smith';
my $password = 'bitter';
my $server = 'my.imap.provider.invalid';

my $imap=Mail::IMAPClient->new(
	Server => $server,
	User => $username,
	Password => $password,
	Peek => 1
);
unless($imap) { 
	die "Couldn't log in - $@\n";
}

# Open the inbox
$imap->select('INBOX');

# Print the list of IDs, subjects and senders
my @mails = ($imap->seen(),$imap->unseen);
print "Listing all messages:\n";
foreach my $id (@mails) { 
	print "$id\n"; 
	print "\tSubject: ".$imap->parse_headers($id,"Subject")->{"Subject"}->[0]."\n";
	print "\tFrom:    ".$imap->parse_headers($id,"From")->{"From"}->[0]."\n";
}

print "\nShow for which message id?\n";
my $mid = <>;
chomp $mid;
print "\n\n";
print "imap->message_string yields:\n\n";
print $imap->message_string($mid);
print "\n\n";
print "imap->parse_headers yields:\n\n";

my %headers = %{$imap->parse_headers( $mid,"ALL" )};
for my $h ( keys %headers ) {
	my @hdrs = @{$headers{$h}};
	print "$h (".scalar @hdrs." entries)\n";
	foreach(@hdrs) { print "\t$_\n"; }
}
