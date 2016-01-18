#!/usr/bin/perl -w

use Net::SMTP;
use strict;
use warnings;

use MIME::Base64 qw( encode_base64 );

my $from = 'harrison.teng@fusemail.com';
my $smtpip = $ARGV[0];
#my $billingreportdir = $ARGV[2];

#print "billingreport=>$billingreportdir\n";
my $attachTextFile= '/tmp/a.csv';

my $boundary = 'frontier';

open(DAT, "$attachTextFile") || die("Could not open text file!");
my @textFile = <DAT>;
close(DAT);

my $smtp = Net::SMTP->new($smtpip, Timeout => 60) || die("Could not create SMTP object.");
print "Sending mail\n";
$smtp->mail($from);
#my $to = qq{\\\"\"darren.c.hogan\@aib.ie\@ad.aib.pri,\t
#            paul.d.o'donovan\@aib.ie\"\@rly45b.srv.mailcontrol.com\\\"
my $to = "pedramtest\@production.fusemail.com";
$smtp->recipient($to, { SkipBad => 1 });
$smtp->data();
$smtp->datasend("List-Unsubscribe: blahblah\@spam.com\n");
$smtp->datasend("To: $to\t\n");
$smtp->datasend("From: $from\n");
$smtp->datasend("Subject: Bulk test billing report for iCritical\n");
$smtp->datasend("MIME-Version: 1.0\n");
$smtp->datasend("Content-type: multipart/mixed;\n\tboundary=\"$boundary\"\n");
$smtp->datasend("\n");
$smtp->datasend("--$boundary\n");
$smtp->datasend("Content-type: text/plain\n");
$smtp->datasend("Content-Disposition: quoted-printable\n");
$smtp->datasend("\nHi Dmitry and Billing-Audit guy,\n");
$smtp->datasend("\nLast week's billing information for iCritical is attached.");
$smtp->datasend("\nIf there is any concerns, please let me know it. \n");
$smtp->datasend("\nHave a nice day!\n");
$smtp->datasend("\nThanks,\n");
$smtp->datasend("\nCase\n");
$smtp->datasend("--$boundary\n");
$smtp->datasend("Content-Type: application/text; name=\"$attachTextFile\"\n");
$smtp->datasend("Content-Disposition: attachment; filename=\"$attachTextFile\"\n");
$smtp->datasend("\n");
$smtp->datasend("@textFile\n");
$smtp->datasend("--$boundary\n");
$smtp->dataend();
$smtp->quit;
print "Mail with billing information sent.\n";
exit; 
