#!/usr/bin/perl
BEGIN {
    die "Sorry, only Linux is now supported!\n" if $^O ne "linux";
}
use strict;
use warnings;
use utf8;
use Scalar::Util qw/looks_like_number/;
use Getopt::Std;
$Getopt::Std::STANDARD_HELP_VERSION = 1;
use FindBin qw($Script);
our $VERSION = "0.102";

# Config dir
our $CONFIG_DIR = "$ENV{HOME}/.pquote";
mkdir $CONFIG_DIR unless -d $CONFIG_DIR;

# Check whether this is the service
my $is_service = check_unique();

# getopts
my %opts;
getopts("q:a:", \%opts);
# q : change quota for this program, default is 120m
# a : add more quota for today
if ($ARGV[0]){
    my $program = Program->new($ARGV[0], to_nonzero_int($opts{q}));
    my $extra_quota = to_nonzero_int($opts{a});
    if ($extra_quota){
        $program->{left} = $program->{left} + $extra_quota;
        $program->writelog();
    }
    print "$program->{name} left $program->{left} minutes\n";
    exit(0) unless $is_service;
}

$is_service or die "Only one instance service can run\n";

my @programs = get_programs();

# Daemonize
open(STDOUT, ">", "/dev/null");
open(STDERR, ">", "/dev/null");
chdir($ENV{HOME});
exit(0) if fork();
exit(0) if fork();

while(1){
    # mainloop
    for (@programs){
        $_->check();
    }
    sleep(60);
    @programs = get_programs();
}

sub to_nonzero_int {
    my $self = shift;
    return int($self) if defined($self) and looks_like_number($self) and $self > 0;
}

sub find_process_by_name{
    # if the second argument is true, then also check the cmdline file
    my $program = shift;
    my $process_name = substr($program, 0, 15);
    my $check_cmdline = shift;
    my $is_matched;
    my @results;
    opendir(PROC_DIR, "/proc/");
    while(readdir PROC_DIR){
        $is_matched = 0;
        next unless looks_like_number($_) and -d "/proc/$_";
        if (-f "/proc/$_/stat"){
            open(PROC, "/proc/$_/stat");
            my $line = <PROC>;
            close PROC;
            $is_matched = 1 if $line =~ / \($process_name\) /;
        }
        if (!$is_matched && $check_cmdline && -f "/proc/$_/cmdline"){
            open(PROC, "/proc/$_/cmdline");
            my $line = <PROC>;
            close(PROC);
            $is_matched = 1 if defined($line) and $line =~ /$program/;
        }
        if ($is_matched){
            unless (wantarray){
                closedir(PROC_DIR);
                return $_;
            }
            push @results, $_;
        }
    }
    closedir(PROC_DIR);
    if (wantarray && @results){
        return @results;
    }
    else {
        return;
    }
}

sub check_unique{
    # Return true if this process is the unique one of this script
    my @process = find_process_by_name($Script, 1);
    return @process == 1;
}

sub interact {
    my $name;
    while (!$name){
        print STDOUT "Entry a program name you want to track:\n";
        $name = <STDIN>;
        # cleanup whitespaces
        chomp($name);
        $name =~ s/^\s*//;
        $name =~ s/\s*$//;
    }
    print STDOUT "Entry the time in minute that this program can run in a day:\n";
    my $quota = <STDIN>;
    # only get the first digital part
    ($quota) = $quota =~ /(\d+)/;
    return $name, $quota;
}

sub get_programs {
    my @logfiles = glob("$CONFIG_DIR/*.yml");
    if (@logfiles) {
        my @programs;
        for (@logfiles) {
            my ($name) = /([^\/]*)\.yml$/;
            push @programs, Program->new($name);
        }
        return @programs;
    }
    elsif (-t STDIN && -t STDOUT) {
        my ($name, $quota) = interact();
        my $program = Program->new($name, $quota);
        return $program;
    }
}

sub notify {
    system("notify-send", $_[0]);
}

sub HELP_MESSAGE{
    print {$_[0]} <<'EOF';

pquota.pl - Quit programs that have run for specified minutes in a day

Usage:
    pquota.pl                    Run this service
    pquota.pl [OPTIONS] program  Show how many minute(s) left for this program,
                                 and track new program if not tracked
        OPTIONS:
            -q int               Set the quota for this program, default is 120
            -a int               Add extra quota for this program for today
    pquota.pl --help             Show this help
    pquota.pl --version          Show version information


Bug report to <cheeselee@fedoraproject.org>.
Copyright (C) 2011, Rui-bin Li.
This program is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.
EOF
}

{
    package Program;
    use POSIX qw/strftime/;
    use constant DEFAULT_QUOTA => 120;

    sub new{
        my %program;
        $program{name} = $_[1];
        my $self = bless \%program;
        if (-f $self->logfile){
            $self->readlog();
            if ($_[2] and $self->{quota} != $_[2]){
                $self->{quota} = $_[2];
                $self->writelog();
            }
        }
        else {
            $self->{quota} = $_[2] || DEFAULT_QUOTA;
            $self->{left} = $self->{quota};
            $self->{date} = _today();
            $self->writelog();
        }
        return $self;
    }
    sub renew{
        my $self = shift;
        $self->{quota} ||= DEFAULT_QUOTA;
        $self->{left} ||= $self->{quota};
        $self->{date} = _today();
        $self->writelog;
    }
    sub check{
        my $self = shift;
        my @processes = main::find_process_by_name($self->{name});
        if (@processes){
            $self->readlog();
            my $today = _today();
            if ($self->{date} != $today){
                $self->{date} = $today;
                $self->{left} = $self->{quota};
                $self->writelog()
            }
            else{
                if ($self->{left} > 0){
                    $self->{left}--;
                    $self->writelog();
                }
            }

            if ($self->{left} <= 0){
                for (@processes){
                    kill(15, $_);
                }
                main::notify("$self->{name} exited");
            }
            elsif ($self->{left} <= 5){
                main::notify("$self->{name} will close in $self->{left} minutes");
            }
            elsif ($self->{left} == 10){
                main::notify("$self->{name} will close in 10 minutes");
            }
        }
    }
    sub logfile {
        my $self = shift;
        return "$CONFIG_DIR/$self->{name}.yml";
    }
    sub readlog {
        my $self = shift;
        if (-f $self->logfile){
            open(my $log, "<", $self->logfile);
            local $/;
            my $setting = <$log>;
            close($log);
            ($self->{date}, $self->{left}, $self->{quota}) =
                $setting =~ /date: (\d+)\n+left: (\d+)\n+quota: (\d+)/;
        }
        for ("date", "left", "quota"){
            if (!defined($self->{$_})){
                $self->renew();
                return;
            }
        }
    }
    sub writelog{
        my $self = shift;
        open(my $log, ">", $self->logfile);
        print $log <<"EOF";
date: $self->{date}

left: $self->{left}

quota: $self->{quota}
EOF
        close($log);
    }

    sub _today {
        return strftime "%Y%m%d", localtime(time);
    }
}
