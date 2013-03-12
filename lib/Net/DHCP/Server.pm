package Net::DHCP::Server;

use strict;
use warnings;
use Net::DHCP::Server::Config;
use Net::DHCP::Server::Leases;

our $VERSION = '0.01';

=head1 NAME

Net::DHCP::Server - Perl extension for blah blah blah

=head1 SYNOPSIS

  use Net::DHCP::Server;
  blah blah blah

=head1 DESCRIPTION

Stub documentation for Net::DHCP::Server, created by h2xs. It looks like the
author of the extension was negligent enough to leave the stub
unedited.

Blah blah blah.


=head1 METHODS

=head2 new Net::DHCP::Server()

=over

Constructor description

=back

=cut

sub new {
        my ($class, %data) = @_;

        my $self = {
                        _config           => new Net::DHCP::Server::Config(
							-configFile => $data{'-configFile'}
					     ),
                        _leases           => new Net::DHCP::Server::Leases(
							-leasesFile => $data{'-leasesFile'}
					     )
        };

        bless $self, $class;

	$self->syncConfigLeases();

        return $self;
}

sub config {
        my ($self, $v) = @_;

        if(defined($v)) {
                $self->{'_config'} = $v;
        }
        return $self->{'_config'};
}

sub leases {
        my ($self, $v) = @_;

        if(defined($v)) {
                $self->{'_leases'} = $v;
        }
        return $self->{'_leases'};
}

sub syncConfigLeases {
        my ($self, $v) = @_;

	# sync the hosts and *active* leases together...

        my $leases = $self->leases->filter(
                                                -binding_state => 'active',
                                                -current       => 1
                                            );

	foreach my $lease ( @$leases ) {

		my $hosts = $self->config->hosts->filter(
							-hardware => $lease->hardware
						    );

		# hm. should only return 1 host... perhaps filter by subnet also
		# then shift host and set it

		foreach my $host ( @$hosts ) {
			$lease->host($host);
		}
	}

	return;
}

1;
__END__


=head1 SEE ALSO

Net::DHCP::Server(3),
Net::DHCP::Server::Subnet(3),
Net::DHCP::Server::Config(3),
Net::DHCP::Server::SharedNetwork(3),
Net::DHCP::Server::Group(3),
Net::DHCP::Server::Pool(3),
Net::DHCP::Server::Lease(3),
Net::DHCP::Server::Class(3),
Net::DHCP::Server::SubClass(3),
Net::DHCP::Server::Host(3),
Net::DHCP::Server::File::Config(3),
Net::DHCP::Server::File::Lease(3),
Net::DHCP::Server::OMAPI(3)

=head1 AUTHOR

Rob Colantuoni, E<lt>rgc@oss.buffalo.eduE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2007 by Rob Colantuoni

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.5 or,
at your option, any later version of Perl 5 you may have available.

=cut

