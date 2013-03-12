package Net::DHCP::Server::Config::Pool;

use strict;
use warnings;
use Net::DHCP::Server::Config;

our $VERSION = '0.01';

=head1 NAME

Net::DHCP::Server::Pool - Perl extension for blah blah blah

=head1 SYNOPSIS

  use Net::DHCP::Server::Pool;
  blah blah blah

=head1 DESCRIPTION

Stub documentation for Net::DHCP::Server::Pool, created by h2xs. It looks like the
author of the extension was negligent enough to leave the stub
unedited.

Blah blah blah.


=head1 METHODS

=head2 new Net::DHCP::Server::Pool()

=over

Constructor description

=back

=cut

sub new {
        my ($class, %data) = @_;

        my $self = {
                        '_ranges' => [],
        };

        bless $self, $class;

        return $self;
}

sub ranges {
	my ($self, $v) = @_;

	if(defined($v)) {
		$self->{'_ranges'} = $v;
	}

	return $self->{'_ranges'};
}

sub add {
        my ($self, $object) = @_;

        if($object =~ /Net::DHCP::Server::Config::Range=/) {
                return $self->addRange($object);
        }
        else {
                return 0;
        }

}

sub addRange {
	my ($self, $range) = @_;

	push(@{$self->ranges()}, $range);

}

sub asText {
	my ($self) = @_;

	my $buf = "Pool: " . $#{$self->ranges()} . " ranges";

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

