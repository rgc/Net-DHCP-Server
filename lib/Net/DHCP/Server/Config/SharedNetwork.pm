package Net::DHCP::Server::Config::SharedNetwork;

use strict;
use warnings;
use Net::DHCP::Server::Config;

our $VERSION = '0.01';

=head1 NAME

Net::DHCP::Server::SharedNetwork - Perl extension for blah blah blah

=head1 SYNOPSIS

  use Net::DHCP::Server::SharedNetwork;
  blah blah blah

=head1 DESCRIPTION

Stub documentation for Net::DHCP::Server::SharedNetwork, created by h2xs. It looks like the
author of the extension was negligent enough to leave the stub
unedited.

Blah blah blah.


=head1 METHODS

=head2 new Net::DHCP::Server::SharedNetwork()

=over

Constructor description

=back

=cut

sub new {
        my ($class, %data) = @_;

        my $self = {
                        '_name'    => $data{'-name'},
			'_options' => [],
			'_subnets' => []
        };

        bless $self, $class;

        return $self;
}

sub name {
	my ($self, $v) = @_;

	if(defined($v)) {
		$self->{'_name'} = $v;
	}
	return $self->{'_name'};
}

sub options {
	my ($self, $v) = @_;

	if(defined($v)) {
		$self->{'_options'} = $v;
	}
	return $self->{'_options'};
}

sub subnets {
	my ($self, $v) = @_;

	if(defined($v)) {
		$self->{'_subnets'} = $v;
	}
	return $self->{'_subnets'};
}

sub add {
        my ($self, $object) = @_;

        if($object =~ /Net::DHCP::Server::Config::Option=/) {
                return $self->addOption($object);
        }
        elsif($object =~ /Net::DHCP::Server::Config::Subnet=/) {
                return $self->addSubnet($object);
        }
        else {
                return 0;
        }

}

sub addOption {
	my ($self, $option) = @_;

	push(@{$self->options()}, $option);
}

sub addSubnet {
	my ($self, $subnet) = @_;

	push(@{$self->subnets()}, $subnet);
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

