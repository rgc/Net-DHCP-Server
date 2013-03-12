package Net::DHCP::Server::Leases::File;

use strict;
use warnings;
use Net::DHCP::Server::Leases;
use FileHandle ();

our $VERSION = '0.01';

=head1 NAME

Net::DHCP::Server::Leases::File - Perl extension for blah blah blah

=head1 SYNOPSIS

  use Net::DHCP::Server::Leases::File;
  blah blah blah

=head1 DESCRIPTION

Stub documentation for Net::DHCP::Server::Leases::File, created by h2xs. It looks like the
author of the extension was negligent enough to leave the stub
unedited.

Blah blah blah.


=head1 METHODS

=head2 Net::DHCP::Server::Leases::File::Parse()

=over

Constructor description

=back

=cut

sub removeComments {
	my ($line) = @_;

	$line =~ s/^(.*?)(#.*)$/$1/g;

	return $line;
}

#
# I'd like to use a standard parsing lib, like Parse::RecDescent
# or something, but for now I'm parsing manually.
#

sub Parse {
	my ($file) = @_;

	my $fh 		  	= new FileHandle();
	my $lease_current 	= undef;
	my $leases_object 	= new Net::DHCP::Server::Leases();

  	# we populate a hash first b/c there may be multiple leases for the same
  	# IP... only the last entry in the file is to be returned.
	my $leases_temp_hash 	= {};

	# open file readonly
	$fh->open($file, "r");

	while(my $line = <$fh>) {

		$line = removeComments($line) if($line =~ /#/);

		if($line =~ /^\s*$/) {
			next;
		}

		if( $line =~ /^(.*?)\s*{\s*$/ ) {
			my $pretext = $1;
		
			if    ($pretext =~ /^\s*lease\s+(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})\s*/i) {
				$lease_current = new Net::DHCP::Server::Leases::Lease(
									   	       -ip      => $1
										     );
			} else {
				$lease_current = "IGNORE";
			}

		}
		elsif( $line =~ /^\s*};*/ ) {
			next if($lease_current eq "IGNORE");
		
			$leases_temp_hash->{$lease_current->ip} = $lease_current;
			$lease_current = undef;

		} else {

			# parse out lease attributes

#			if ( $line =~ /^\s*(starts|ends|tstp|tsfp|atsfp|cltt) (.*?);\s*/) {
#				$obj->$1($2);
#			}

			if ( $line =~ /starts (\d+ \d{4}\/\d{1,2}\/\d{1,2} \d{2}:\d{2}:\d{2})/) {
				$lease_current->starts($1);
			}

			elsif ( $line =~ /ends (\d+ \d{4}\/\d{1,2}\/\d{1,2} \d{2}:\d{2}:\d{2})/) {
				$lease_current->ends($1);
			}

			elsif ( $line =~ /^\s*binding state (\w+);/) {
				$lease_current->binding_state($1);
			}

			elsif ( $line =~ /hardware (\S+) (\w{2}.\w{2}.\w{2}.\w{2}.\w{2}.\w{2})/) {
				$lease_current->hardware_type($1);
				$lease_current->hardware($2);
			}

			elsif ( $line =~ /uid \"(.*?)\";/) {
				$lease_current->uid($1);
			}
	
#			elsif ( $line =~ /^\s*set ddns-rev-name = \"*(.*?)\"*;\s*/) {
#				$obj->ddns_rev_name($1);
#			}

#			elsif ( $line =~ /^\s*set ddns-txt = \"*(.*?)\"*;\s*/) {
#				$obj->ddns_txt($1);
#			}

			elsif ( $line =~ /set ddns-fwd-name = \"(.*?)\";/) {
				$lease_current->ddns_fwd_name($1);
			}

			elsif ( $line =~ /client-hostname \"(.*?)\";/) {
				$lease_current->client_hostname($1);
			}

		} # else
	} # while
	$fh->close();

#	my @v = values %$leases_temp_hash;
# 	$leases_object->leases(\@v);
#	foreach my $lease ( values %$leases_temp_hash) {
# 		$leases_object->addLease($lease);
#	}

	# there shouldn't be anything left on the stack, otherwise the file was poorly formed.
#	if($#lease_stack >= 0) {
#		die "Lease file poorly formed!";
#
#	} else {
		# return Net::DHCP::Server::Leases object
		return $leases_object;
#	}

}

1;
__END__


=head1 SEE ALSO

Net::DHCP::Server(3),

=head1 AUTHOR

Rob Colantuoni, E<lt>rgc@oss.buffalo.eduE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2007 by Rob Colantuoni

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.5 or,
at your option, any later version of Perl 5 you may have available.

=cut

