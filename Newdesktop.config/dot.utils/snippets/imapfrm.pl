#!/usr/bin/perl -w

use strict;
use Mail::IMAPClient;
use IO::Socket::SSL;
use MIME::Base64;
use MIME::QuotedPrint;

my $username;
my $password;
my @summary_folders;

if(!(defined($ENV{'IMAP_USERNAME'}))) {
	die "\$IMAP_USERNAME not defined";
}
else {
	$username=$ENV{'IMAP_USERNAME'};
}

if(!(defined($ENV{'IMAP_USERNAME'}))) {
	print "password: ";
	$password=<STDIN>;
	chomp($password);
}
else {
	$password=decode_base64($ENV{'IMAP_PASSWORD'});
}

if(defined($ENV{'SUMMARY_FOLDERS'})) {
	@summary_folders=split(/,/,$ENV{'SUMMARY_FOLDERS'});
}

my $imap = Mail::IMAPClient->new
	( User     => $username, 
	Password => $password,
	Server => 'localhost'
	) or die "Failed to connect: $@";

# Which file are the messages going into
my $folder = "INBOX";

# Select the mailbox to get messages from
$imap->examine($folder) or die "IMAP Select Error: $!";

# Store each message as an array element
my @msgs = $imap->search('ALL') or die "Couldn't get all messages\n"; 

foreach my $msg (@msgs) {
	my $from=$imap->get_header($msg,'From');
	$from=extract_from($from);
	my $subject = decode($imap->get_header($msg,'Subject'));
	display_line($from,$subject);
}

$imap->close($folder);

if(@summary_folders) {
	print "\n";

	foreach my $summary_folder (@summary_folders) {

		$imap->examine($summary_folder) or die "IMAP Select Error: $!";
		my $folder_number=$imap->unseen_count($summary_folder);

		if($folder_number > 0) {
			print "$summary_folder $folder_number unread\n";
		}
      
		$imap->close($summary_folder);
	}

	$imap->logout();

}

####################

sub extract_from {

my $from_line=$_[0];
my $from_name;

if(my @from_vars = $from_line=~/^(?:\<(.*)\>|\"(.*)\"|(.*)\s*\<|.*?\((.*)\)|(.*))/i) {
        foreach my $from_var (@from_vars) {
                if(defined($from_var)) {
                        $from_name=$from_var;
                }
        }

        if(defined($from_name)) {
                chomp($from_name);
                $from_name=decode($from_name);
        }
}

return $from_name;
}

###################

sub decode {

my $string=$_[0];
my ($encoded,$decoded);

if((defined($string)) and ($string=~/\?(iso-8859|utf|windows)-?[0-9]{0,4}\?/i)) {
        my @encoded_chunks=split(/\s+/,$string);
	
        foreach my $chunk (@encoded_chunks) {
                $encoded=(split(/\?/,$chunk))[3];

                if($chunk=~/\?(iso-8859-|utf|windows)-?[0-9]{0,4}\?q/i) {
                        $decoded.=decode_qp($encoded);
                        $decoded=~s/_/ /g;
                }
                elsif($chunk=~/\?(iso-8859-|utf|windows)-?[0-9]{0,4}\?b/i) {
                        $decoded.=decode_base64($encoded);
                }
                else {
                        $decoded.=$chunk." ";
                }
        }
}
else {
        $decoded=$string;
}

return $decoded;
}

##################


sub display_line {

my $from_name=$_[0];
my $subject=$_[1];
my $line;

if(!defined($from_name)) {
        $from_name=" ";
}
if(!defined($subject)) {
        $subject=" ";
}

$line=sprintf "%-21s", $from_name;
$line=$line." ".$subject;
$line=substr($line,0,80);
if($subject ne "DON'T DELETE THIS MESSAGE -- FOLDER INTERNAL DATA") {
        print $line."\n";
}

}

