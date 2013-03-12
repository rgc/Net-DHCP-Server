#!/usr/bin/perl -w
#
# NAME
#   dhcpstatclient.pl
#
# DESCRIPTION
#   This script initiates a telnet session with a remote host
#   and queries that host for its number of DHCP leases currently
#   in use or abandoned on that system.
#
#   For use with Cacti for graphing
#
# AUTHOR
#   Rob Colantuoni
#   SUNYAB CIT/OSS
#
# CREATED
#   Oct 7, 2004

use strict;
use vars qw ( $opt_h $opt_l $opt_s $opt_p $opt_n );
use Getopt::Std;
use IO::Socket::INET;

getopts ('hs:l:n:p:'); # parse command line options

if ($opt_h) {
        &Usage ();
        exit (0);
}

if ($opt_n) {
        if ($opt_n !~ /\w+/) {
                print "'$opt_n' is not a valid hostname.\n";
                &Usage ();
                exit (-1);
        }
} else {
        print "You must specify a valid hostname after -n.\n";
        &Usage ();
        exit (-1);
}

my $line;

my $timeout = 30;

$SIG{ALRM} = sub { print "na\nna\nna\nna\n"; exit; };

alarm $timeout;

my $hostname            = $opt_n;
my $port                = 10008;
my $secs                = 30;
my $opt_lease_type      = 'used';
my $opt_shared_subnet   = 'all';
my $opt_subnet          = 'all';

my $command_set         = '';

if($opt_l) {
        if($opt_l =~ /^used$/ || $opt_l =~/^abandoned$/) {
                $command_set .= "LEASETYPE: $opt_l\n";
        } else {
                print "Invalid lease type clause: $opt_l\n";
                exit(-1);
        }
}

if($opt_s) {
        if($opt_s =~ /^all$/ || $opt_s =~ /^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$/) {
                $command_set .= "SUBNET: $opt_s\n";
        } else {
                print "Invalid subnet clause: $opt_s\n";
                exit(-1);
        }
}

if($opt_p) {
        $command_set .= "SHAREDSUBNET: $opt_p\n";
}

$command_set .= "\n";

my $ping_timeout = 5; # seconds
my $ping_ret_val = `/bin/ping $hostname -c 1 -q -W $ping_timeout`;

if ($ping_ret_val !~ /1\sreceived/) {
   exit (-1); # hostname is unreachable, so exit.
}

my $sock = IO::Socket::INET->new(PeerAddr => $hostname,
                                 PeerPort => $port,
                                 Proto    => 'tcp',
                                 Timeout  => $secs
                                 );

exit (0) if (!defined($sock));

print $sock $command_set;

my @dater = <$sock>;
if($#dater != 3) {
        print STDERR "remote end closed connection. recv'd only $#dater elements.\n";
        print "0\n0\nfailed\n$hostname\n";
} else {
#        print @dater;
	 chomp($dater[0]);
	 chomp($dater[1]);
	 my $t = "active:$dater[0] available:$dater[1]";
	 print $t;
}
close $sock;

exit (0);

sub Usage () {
  print "Usage: $0 -l { used | abandoned } -s { all | subnet IP } -p { shared subnet name } -n remote_dhcp_server\n";
}

