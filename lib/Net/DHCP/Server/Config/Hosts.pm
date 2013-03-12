package Net::DHCP::Server::Config::Hosts;

use strict;
use warnings;
use Net::DHCP::Server::Config;

our $VERSION = '0.01';

=head1 NAME

Net::DHCP::Server::Config::Hosts - Perl extension for blah blah blah

=head1 SYNOPSIS

  use Net::DHCP::Server::Config::Hosts;
  blah blah blah

=head1 DESCRIPTION

Stub documentation for Net::DHCP::Server::Hosts, created by h2xs. It looks like the
author of the extension was negligent enough to leave the stub
unedited.

Blah blah blah.


=head1 METHODS

=head2 new Net::DHCP::Server::Config::Hosts()

=over

Constructor description

=back

=cut

sub new {
        my ($class, %data) = @_;

        my $self = {
              		'_hosts'         => [],

			# indexes
			'_idx_hardware'  => {}
        };

        bless $self, $class;

        return $self;
}

sub hosts {
        my ($self, $v) = @_;

        if(defined($v)) {
                $self->{'_hosts'} = $v;
        }
        return $self->{'_hosts'};
}

sub all {
        my ($self) = @_;

	return $self->{'_hosts'};
}

sub filter {
        my ($self, %v) = @_;

	my @hosts = @{$self->hosts()};
	my @hosts_filtered = ();

	# we can shortcut the filter process by using a
	# preloaded index on the hardware attribute
	if(defined($v{'-hardware'})) {
		my $val = $v{'-hardware'};

		if(defined($self->{'_idx_hardware'}->{$val})) {
			@hosts = @{$self->{'_idx_hardware'}->{$val}};
		} else {
			@hosts = ();
		}
	}

	HOST:
	foreach my $host (@hosts) {
		foreach my $k (keys %v) {
			my $val = $v{$k};
			$k =~ s/^-//g;
			next HOST if(!defined($host->$k));
			next HOST if( $host->$k ne $val );
		}
		push(@hosts_filtered, $host);
	}
	return \@hosts_filtered;
}

sub add {
        my ($self, $object) = @_;

	if($object =~ /Net::DHCP::Server::Config::Host=/) {
                return $self->addHost($object);
        }
        else {
                return 0;
        }

}

sub addHost {
        my ($self, $host) = @_;

        push(@{$self->hosts()}, $host);
	
	# push into index
	my $hw = $host->hardware;
	if(!defined($self->{'_idx_hardware'}->{$hw})) {
		$self->{'_idx_hardware'}->{$hw} = [];
	}
	push(@{$self->{'_idx_hardware'}->{$hw}}, $host);

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

