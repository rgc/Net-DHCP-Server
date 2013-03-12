package Net::DHCP::Server::Config;

use strict;
use warnings;
use Net::DHCP::Server::Config::Subnet;
use Net::DHCP::Server::Config::Pool;
use Net::DHCP::Server::Config::Group;
use Net::DHCP::Server::Config::Host;
use Net::DHCP::Server::Config::Hosts;
use Net::DHCP::Server::Config::SharedNetwork;
use Net::DHCP::Server::Config::Range;
use Net::DHCP::Server::Config::Option;
use Net::DHCP::Server::Config::File;

our $VERSION = '0.01';

=head1 NAME

Net::DHCP::Server::Config - Perl extension for blah blah blah

=head1 SYNOPSIS

  use Net::DHCP::Server::Config;
  blah blah blah

=head1 DESCRIPTION

Stub documentation for Net::DHCP::Server::Config, created by h2xs. It looks like the
author of the extension was negligent enough to leave the stub
unedited.

Blah blah blah.


=head1 METHODS

=head2 new Net::DHCP::Server::Config()

=over

Constructor description

=back

=cut

sub new {
        my ($class, %data) = @_;

        my $self = {
              		'_options'        => [],
                        '_sharedNetworks' => [],
                        '_subnets'        => [],
                        '_groups'         => [],
                        '_hosts'          => new Net::DHCP::Server::Config::Hosts()
        };

        bless $self, $class;

	if($data{'-configFile'}) {
		return Net::DHCP::Server::Config::File::Parse($data{'-configFile'})
	}

        return $self;
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

sub sharedNetworks {
        my ($self, $v) = @_;

        if(defined($v)) {
                $self->{'_sharedNetworks'} = $v;
        }
        return $self->{'_sharedNetworks'};
}

sub groups {
        my ($self, $v) = @_;

        if(defined($v)) {
                $self->{'_groups'} = $v;
        }
        return $self->{'_groups'};
}

sub hosts {
        my ($self, $v) = @_;

        return $self->{'_hosts'};
}

sub add {
        my ($self, $object) = @_;

	if($object =~ /Net::DHCP::Server::Config::Subnet=/) {
		return $self->addSubnet($object);
	} 
	if($object =~ /Net::DHCP::Server::Config::SharedNetwork=/) {
		return $self->addSharedNetwork($object);
	} 
	elsif($object =~ /Net::DHCP::Server::Config::Group=/) {
		return $self->addGroup($object);
	}
	elsif($object =~ /Net::DHCP::Server::Config::Host=/) {
		return $self->addHost($object);
	}
	elsif($object =~ /Net::DHCP::Server::Config::Option=/) {
		return $self->addOption($object);
	}
	else {
		return 0;
	}

}

sub addOption {
        my ($self, $option) = @_;

        push(@{$self->options()}, $option);
	return 1;
}

sub addSubnet {
        my ($self, $subnet) = @_;

        push(@{$self->subnets()}, $subnet);
	return 1;
}

sub addSharedNetwork {
        my ($self, $sharedNetwork) = @_;

        push(@{$self->sharedNetworks()}, $sharedNetwork);
	return 1;
}

sub addGroup {
        my ($self, $group) = @_;

        push(@{$self->groups()}, $group);
	return 1;
}

sub addHost {
        my ($self, $host) = @_;

	$self->hosts->add($host);
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

