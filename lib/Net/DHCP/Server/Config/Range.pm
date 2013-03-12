package Net::DHCP::Server::Config::Range;

use strict;
use warnings;
use Net::DHCP::Server::Config;
use Net::Netmask;

our $VERSION = '0.01';

=head1 NAME

Net::DHCP::Server::Range - Perl extension for blah blah blah

=head1 SYNOPSIS

  use Net::DHCP::Server::Range;
  blah blah blah

=head1 DESCRIPTION

Stub documentation for Net::DHCP::Server::Range, created by h2xs. It looks like the
author of the extension was negligent enough to leave the stub
unedited.

Blah blah blah.


=head1 METHODS

=head2 new Net::DHCP::Server::Range()

=over

Constructor description

=back

=cut

sub new {
        my ($class, %data) = @_;

        my $self = {
                        '_low_ip'  => $data{'-low_ip'},
                        '_high_ip' => $data{'-high_ip'},
			'_bootp'   => $data{'-bootp'},
        };

        bless $self, $class;

        return $self;
}

sub low_ip {
	my ($self, $v) = @_;

	if(defined($v)) {
		$self->{'_low_ip'} = $v;
	}

	return $self->{'_low_ip'};
}

sub high_ip {
	my ($self, $v) = @_;

	if(defined($v)) {
		$self->{'_high_ip'} = $v;
	}

	return $self->{'_high_ip'};
}

sub bootp {
	my ($self, $v) = @_;

	if(defined($v)) {
		$self->{'_bootp'} = $v;
	}

	return $self->{'_bootp'};
}

sub size {
	my ($self) = @_;

  	my $size = 0;

    	my @blocks = range2cidrlist($self->low_ip(), $self->high_ip());
    	foreach my $block (@blocks) {
       		$size += $block->size();
    	}

	return $size;
}

sub asText {
        my ($self) = @_;

        my $buf = "Range: " . $self->low_ip() . "->" . $self->high_ip() . ", " . $self->size() . " addresses";

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

