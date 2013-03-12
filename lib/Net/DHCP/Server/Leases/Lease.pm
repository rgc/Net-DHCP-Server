package Net::DHCP::Server::Leases::Lease;

use strict;
use warnings;
use Net::DHCP::Server::Config;
use Net::DHCP::Server::Leases;
use Time::Local;

our $VERSION = '0.01';

=head1 NAME

Net::DHCP::Server::Leases::Lease - Perl extension for blah blah blah

=head1 SYNOPSIS

  use Net::DHCP::Server::Leases::Lease;
  blah blah blah

=head1 DESCRIPTION

Stub documentation for Net::DHCP::Server::Leases::Lease, created by h2xs. It looks like the
author of the extension was negligent enough to leave the stub
unedited.

Blah blah blah.


=head1 METHODS

=head2 new Net::DHCP::Server::Leases::Lease()

=over

Constructor description

lease 128.205.205.192 {
  starts 4 2006/11/09 17:35:13;
  ends 5 2006/08/11 13:03:36;
  tstp 4 2006/11/09 17:35:13;
  tsfp 4 2006/11/09 17:35:13;
  atsfp 4 2006/11/09 17:35:13;
  cltt 5 2006/08/11 12:56:06;
  binding state backup;
  hardware ethernet 00:12:f0:56:15:6b;
  uid "\001\000\022\360V\025k";
  set ddns-rev-name = "192.205.205.128.in-addr.arpa.";
  set ddns-txt = "3161bbeff7bf64d340c267721a94b45ad9";
  set ddns-fwd-name = "cate-dlokes-wireless.cate.buffalo.edu";
  client-hostname "Dave";
}


=back

=cut

sub new {
        my ($class, %data) = @_;

        my $self = {
                        '_ip'          		=> $data{'-ip'},
                        '_starts'    		=> $data{'-starts'},
                        '_ends'      		=> $data{'-ends'},
                        '_tstp'    		=> $data{'-tstp'},
                        '_tsfp'    		=> $data{'-tsfp'},
                        '_atsfp'    		=> $data{'-atsfp'},
                        '_cltt'    		=> $data{'-cltt'},
                        '_binding-state'    	=> $data{'-binding_state'},
                        '_hardware_type'	=> $data{'-hardware_type'},
                        '_hardware'    		=> $data{'-hardware'},
                        '_uid'    		=> $data{'-uid'},
                        '_ddns-rev-name'    	=> $data{'-ddns_rev_name'},
                        '_ddns-txt'    		=> $data{'-ddns_txt'},
                        '_ddns-fwd-name'    	=> $data{'-ddns_fwd_name'},
                        '_client-hostname'	=> $data{'-client_hostname'},

			# references to config objects
			'_host'			=> undef
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

sub starts {
	my ($self, $v) = @_;

	if(defined($v)) {
		$v = $self->fixdate($v);
		$self->{'_starts'} = $v;
	}
	return $self->{'_starts'};
}

sub ends {
	my ($self, $v) = @_;

	if(defined($v)) {
		$v = $self->fixdate($v);
		$self->{'_ends'} = $v;
	}
	return $self->{'_ends'};
}

sub tstp {
	my ($self, $v) = @_;

	if(defined($v)) {
		$v = $self->fixdate($v);
		$self->{'_tstp'} = $v;
	}
	return $self->{'_tstp'};
}

sub tsfp {
	my ($self, $v) = @_;

	if(defined($v)) {
		$v = $self->fixdate($v);
		$self->{'_tsfp'} = $v;
	}
	return $self->{'_tsfp'};
}

sub atsfp {
	my ($self, $v) = @_;

	if(defined($v)) {
		$v = $self->fixdate($v);
		$self->{'_atsfp'} = $v;
	}
	return $self->{'_atsfp'};
}

sub cltt {
	my ($self, $v) = @_;

	if(defined($v)) {
		$v = $self->fixdate($v);
		$self->{'_cltt'} = $v;
	}
	return $self->{'_cltt'};
}

sub binding_state {
	my ($self, $v) = @_;

	if(defined($v)) {
		$self->{'_binding-state'} = $v;
	}
	return $self->{'_binding-state'};
}

sub hardware_type {
	my ($self, $v) = @_;

	if(defined($v)) {
		$self->{'_hardware_type'} = $v;
	}
	return $self->{'_hardware_type'};
}

sub hardware {
	my ($self, $v) = @_;

	if(defined($v)) {
		$self->{'_hardware'} = $v;
	}
	return $self->{'_hardware'};
}

sub uid {
	my ($self, $v) = @_;

	if(defined($v)) {
		$self->{'_uid'} = $v;
	}
	return $self->{'_uid'};
}

sub ddns_rev_name {
	my ($self, $v) = @_;

	if(defined($v)) {
		$self->{'_ddns-rev-name'} = $v;
	}
	return $self->{'_ddns-rev-name'};
}

sub ddns_txt {
	my ($self, $v) = @_;

	if(defined($v)) {
		$self->{'_ddns-txt'} = $v;
	}
	return $self->{'_ddns-txt'};
}

sub ddns_fwd_name {
	my ($self, $v) = @_;

	if(defined($v)) {
		$self->{'_ddns-fwd-name'} = $v;
	}
	return $self->{'_ddns-fwd-name'};
}

sub client_hostname {
	my ($self, $v) = @_;

	if(defined($v)) {
		$self->{'_client-hostname'} = $v;
	}
	return $self->{'_client-hostname'};
}

sub current {
	my ($self) = @_;

	if ($self->starts() <= time &&
      	    $self->ends()   >= time    ) {
     		return 1;
  	
	} else {
     		return 0;
  	}
}

sub host {
	my ($self, $v) = @_;

	if(defined($v)) {
		$self->{'_host'} = $v;
	}
	return $self->{'_host'};
}

sub fixdate {
	my ($self, $dt) = @_;

	if($dt =~ /(\d+) (\d{4})\/(\d{1,2})\/(\d{1,2}) (\d{2}):(\d{2}):(\d{2})/) {

		my ($weekday_num1, $year, $mon, $mday, $hours, $min, $sec) =
		   ($1, $2, $3, $4, $5, $6, $7);
		$mon -= 1; # lease keeps months [1-12] => UNIX keeps months [0..11]

		if ($year > 2037) { # timegm doesn't handle 2038 correctly.
     			$year = 2037;
  		}

		$dt = timegm ($sec, $min, $hours, $mday, $mon, $year);

	}
	return $dt;
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

