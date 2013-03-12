#!/usr/bin/perl -w

use strict;
use Data::Dumper;

use lib '../lib';

use Net::DHCP::Server;

print "start parse\n";

my $server = new Net::DHCP::Server( 
				#	-configFile => './dhcpd.conf',
					-leasesFile => './dhcpd.leases'
);

print "end parse\n";

exit;

foreach my $lease ( @{$server->leases->all()} ) {
	
	print $lease->ip;

	if(defined($lease->host())) {
		print " - " . $lease->host->name;
	}

	print "\n";

}


exit;

