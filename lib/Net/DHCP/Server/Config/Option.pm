package Net::DHCP::Server::Config::Option;

use strict;
use warnings;
use Net::DHCP::Server::Config;

our $VERSION = '0.01';

=head1 NAME

Net::DHCP::Server::Option - Perl extension for blah blah blah

=head1 SYNOPSIS

  use Net::DHCP::Server::Option;
  blah blah blah

=head1 DESCRIPTION

Stub documentation for Net::DHCP::Server::Option, created by h2xs. It looks like the
author of the extension was negligent enough to leave the stub
unedited.

Blah blah blah.


=head1 METHODS

=head2 new Net::DHCP::Server::Option()

=over

Constructor description

=back

=cut

sub new {
        my ($class, %data) = @_;

        my $self = {
                        '_name'  => $data{'-name'},
                        '_value' => $data{'-value'},
                        '_code'  => $data{'-code'},
                        '_type'  => $data{'-type'}
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

sub value {
	my ($self, $v) = @_;

	if(defined($v)) {
		$self->{'_value'} = $v;
	}
	return $self->{'_value'};
}

sub code {
	my ($self, $v) = @_;

	if(defined($v)) {
		$self->{'_code'} = $v;
	}
	return $self->{'_code'};
}

sub type {
	my ($self, $v) = @_;

	if(defined($v)) {
		$self->{'_type'} = $v;
	}
	return $self->{'_type'};
}

sub asText {
        my ($self) = @_;

        my $buf = "Option: " . $self->name() . " = " . $self->value();

        return $buf;
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

