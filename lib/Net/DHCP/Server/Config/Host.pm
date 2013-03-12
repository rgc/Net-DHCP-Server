package Net::DHCP::Server::Config::Host;

use strict;
use warnings;
use Net::DHCP::Server::Config;

our $VERSION = '0.01';

=head1 NAME

Net::DHCP::Server::Host - Perl extension for blah blah blah

=head1 SYNOPSIS

  use Net::DHCP::Server::Host;
  blah blah blah

=head1 DESCRIPTION

Stub documentation for Net::DHCP::Server::Host, created by h2xs. It looks like the
author of the extension was negligent enough to leave the stub
unedited.

Blah blah blah.


=head1 METHODS

=head2 new Net::DHCP::Server::Host()

=over

Constructor description

=back

=cut

sub new {
        my ($class, %data) = @_;

        my $self = {
                        '_name'     		=> $data{'-name'},
                        '_hardware' 		=> $data{'-hardware'},
                        '_hardware_type' 	=> $data{'-hardware_type'},
			'_options'  		=> [],
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

sub hardware {
	my ($self, $v) = @_;

	if(defined($v)) {
		$self->{'_hardware'} = $v;
	}
	return $self->{'_hardware'};
}

sub hardware_type {
	my ($self, $v) = @_;

	if(defined($v)) {
		$self->{'_hardware_type'} = $v;
	}
	return $self->{'_hardware_type'};
}

sub options {
	my ($self, $v) = @_;

	if(defined($v)) {
		$self->{'_options'} = $v;
	}
	return $self->{'_options'};
}

sub add {
        my ($self, $object) = @_;

        if($object =~ /Net::DHCP::Server::Config::Option=/) {
                return $self->addOption($object);
        }
        else {
                return 0;
        }

}

sub addOption {
	my ($self, $option) = @_;

	push(@{$self->options()}, $option);
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

