#!/usr/bin/env perl
#
# package to fetch bounced messages and return the bounced info with timestamp and clientip

package imapoverssl;

use strict;
use Mail::IMAPClient;
use bounceCookie;

sub new
{

	my( $class,$domain,$timeout ) = @_;

	my $this = {
		'hostname' => undef,
		'username' => undef,
		'domain'   => undef,
		'timeout'  => undef
	};

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


	bless( $this,$class );

	$this->_setHostname( 'inbound.electric.net' );
	$this->_setDomain( $domain );
	$this->_setUsername( 'bounces',$domain );
	$this->_setPassword( 'b!tt@r' );
	$this->_setTimeout( $timeout );
	$this->_setMonth( \%monthMapping );

	return( $this );

}

sub _setTimeout
{

	my( $this,$timeout ) = @_;
	$this->{'timeout'} = $timeout;

}

sub _setMonth
{
	
	my( $this,$months ) = @_;
	$this->{'month'} = $months;

}

sub _setDomain
{

	my( $this,$domain ) = @_;
	$this->{'domain'} = $domain;

}

sub _setHostname
{

	my( $this,$hostname ) = @_;
	$this->{'hostname'} = $hostname;

};

sub _setUsername
{

	my( $this,$user,$domain ) = @_;
	$this->{'username'} = $user.'@'.$domain;

};

sub _setPassword
{

	my( $this,$password ) = @_;
	$this->{'password'} = $password;

};

sub _setBounceInfo
{

	my( $this,$bounceinfo ) = @_;
	$this->{'bounceinfo'} = $bounceinfo;
}

sub _getBounceInfo
{

	my $this = shift;

	my $domain = $this->{'domain'};

	my $imap = Mail::IMAPClient->new();
	$imap->User($this->{'username'});
	$imap->Password($this->{'password'});
	$imap->Server($this->{'hostname'});
	$imap->Timeout($this->{'timeout'});

	my %bounceinfo;

	if ($imap->connect()) {

    		$imap->select("INBOX");
    		my @msgs = $imap->search('ALL');

    		foreach my $id ( @msgs ) {
	    		my $msg = $imap->message_string( $id );

			#get bid here
			#	X-Env-From: bounces@invoices.fusemail.comi
			(my $hashbid = $msg )=~ s/(.*?)X-Env-From:\s([0-9]+?)\@$domain(.*)/$2/ms;
			my $bid = bounceCrypt($hashbid);

			#get bounce date and time here
			#	Received: by emcmailer; Wed, 08 May 2013 16:32:42 -0700
			( my $dateandtime = $msg ) =~ s/(.*?)Received: by emcmailer;\s(.*?)[a-zA-Z]{3},\s(.*?)\s-(.*)/$3/ms;
			my($day,$month,$year,$hour,$minute,$seconds) = split (/\s|:/,$dateandtime);
			my $timestamp = "$year-".$this->{month}->{$month}."-$day $hour:$minute:$seconds"; 

			#get remote client ip here
			#	X-Outbound-IP: 184.69.73.122
			( my $clientip = $msg ) =~ s/(.*?)X-Outbound-IP:\s(\d+)\.(\d+)\.(\d+)\.(\d+)(.*)/$2.$3.$4.$5/ms;

			#preparing the return data structure
		    	$bounceinfo{$bid} = [ $timestamp,$clientip ];

			#mark down the message as deletion
			$imap->delete($id);
    		}

		#we are all done here so expunge those in INBOX
		$imap->expunge("INBOX");

		#logout imap session
		$imap->logout();

		#set bounceinfo attribute
		$this->_setBounceInfo( \%bounceinfo );

	} else {
		print "$this->{'username'} login failed ";
	}

}

sub getBounceInfo
{

	my $this = shift;
	$this->_getBounceInfo();
	return $this->{'bounceinfo'};

}	

1;
