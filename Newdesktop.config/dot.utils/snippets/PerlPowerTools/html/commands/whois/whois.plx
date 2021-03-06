#!/usr/bin/perl

# Sample whois(1) client for PPT.
#
# Yiorgos Adamopoulos, adamo@ieee.org, Mon Mar 22 15:28:05 EET 1999
#                                      Mon Mar 22 16:24:23 EET 1999
#
# The command line switches are taken from the FreeBSD whois(1) page
# Added a -6 switch for 6BONE (whois.6bone.net)
# Added a -g switch for .gov (whois.nic.gov)

use IO::Socket;

$host = "whois.internic.net";

while($i = shift) {
	if ($i eq "-a") { $host = "whois.arin.net"; last; }
	elsif ($i eq "-d") { $host = "whois.nic.mil"; last; }
	elsif ($i eq "-p") { $host = "whois.apnic.net"; last; }
	elsif ($i eq "-r") { $host = "whois.ripe.net"; last; }
	elsif ($i eq "-g") { $host = "whois.nic.gov"; last; }
	elsif ($i eq "-6") { $host = "whois.6bone.net"; last; }
	elsif ($i eq "-h") { $host = shift; last; }
	else { unshift(@ARGV, $i); last; }
}

$| = 1;

$sock = new IO::Socket::INET(PeerAddr => $host, 
                             PeerPort => 43,
			     Proto => 'tcp');

die "IO::Socket::INET $!" unless $sock;

foreach $i (@ARGV) {
	print $sock "$i ";
}
print $sock "\n\r";

while($line = <$sock>) {
	print $line
}

close($sock);
