package Net::DHCP::Server::Config::Subnet;

use strict;
use warnings;
use Net::DHCP::Server::Config;

our $VERSION = '0.01';

=head1 NAME

Net::DHCP::Server::Subnet - Perl extension for blah blah blah

=head1 SYNOPSIS

  use Net::DHCP::Server::Subnet;
  blah blah blah

=head1 DESCRIPTION

Stub documentation for Net::DHCP::Server::Subnet, created by h2xs. It looks like the
author of the extension was negligent enough to leave the stub
unedited.

Blah blah blah.


=head1 METHODS

=head2 new Net::DHCP::Server::Subnet()

=over

Constructor description

=back

=cut

sub new {
        my ($class, %data) = @_;

        my $self = {
                        '_ip'      => $data{'-ip'},
                        '_netmask' => $data{'-netmask'},
			'_options' => [],
			'_pools'   => []
        };

        bless $self, $class;

        return $self;
}

sub ip {
	my ($self, $v) = @_;

	if(defined($v)) {
		$self->{'_ip'} = $v;
	}
	return $self->{'_ip'};
}

sub netmask {
	my ($self, $v) = @_;

	if(defined($v)) {
		$self->{'_netmask'} = $v;
	}
	return $self->{'_netmask'};
}

sub options {
	my ($self, $v) = @_;

	if(defined($v)) {
		$self->{'_options'} = $v;
	}
	return $self->{'_options'};
}

sub pools {
	my ($self, $v) = @_;

	if(defined($v)) {
		$self->{'_pools'} = $v;
	}
	return $self->{'_pools'};
}

sub add {
        my ($self, $object) = @_;

        if($object =~ /Net::DHCP::Server::Config::Option=/) {
                return $self->addOption($object);
        }
        elsif($object =~ /Net::DHCP::Server::Config::Pool=/) {
                return $self->addPool($object);
        }
        else {
                return 0;
        }

}

sub addOption {
	my ($self, $option) = @_;

	push(@{$self->options()}, $option);
}

sub addPool {
	my ($self, $pool) = @_;

	push(@{$self->pools()}, $pool);
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

