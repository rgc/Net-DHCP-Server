package Net::DHCP::Server::Leases;

use strict;
use warnings;
use Net::DHCP::Server::Leases::Lease;
use Net::DHCP::Server::Leases::File;

our $VERSION = '0.01';

=head1 NAME

Net::DHCP::Server::Leases - Perl extension for blah blah blah

=head1 SYNOPSIS

  use Net::DHCP::Server::Leases;
  blah blah blah

=head1 DESCRIPTION

Stub documentation for Net::DHCP::Server::Leases, created by h2xs. It looks like the
author of the extension was negligent enough to leave the stub
unedited.

Blah blah blah.


=head1 METHODS

=head2 new Net::DHCP::Server::Leases()

=over

Constructor description

=back

=cut

sub new {
        my ($class, %data) = @_;

        my $self = {
              		'_leases'         => []
        };

        bless $self, $class;

	if($data{'-leasesFile'}) {
		return Net::DHCP::Server::Leases::File::Parse($data{'-leasesFile'})
	}

        return $self;
}

sub leases {
        my ($self, $v) = @_;

        if(defined($v)) {
                $self->{'_leases'} = $v;
        }
        return $self->{'_leases'};
}

sub all {
        my ($self) = @_;

	return $self->{'_leases'};
}

sub filter {
        my ($self, %v) = @_;

	my @leases_filtered = ();

	LEASE:
	foreach my $lease (@{$self->leases()}) {
		foreach my $k (keys %v) {
			my $val = $v{$k};
			$k =~ s/^-//g;
			next LEASE if(!defined($lease->$k));
			next LEASE if( $lease->$k ne $val );
		}
		push(@leases_filtered, $lease);
	}
	return \@leases_filtered;
}

sub add {
        my ($self, $object) = @_;

	if($object =~ /Net::DHCP::Server::Leases::Lease=/) {
                return $self->addLease($object);
        }
        else {
                return 0;
        }

}

sub addLease {
        my ($self, $lease) = @_;

        push(@{$self->leases()}, $lease);
	return 1;
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

