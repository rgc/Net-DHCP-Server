package Net::DHCP::Server::Config::File;

use strict;
use warnings;
use Net::DHCP::Server::Config;
use FileHandle;

our $VERSION = '0.01';

=head1 NAME

Net::DHCP::Server::Config::File - Perl extension for blah blah blah

=head1 SYNOPSIS

  use Net::DHCP::Server::Config::File;
  blah blah blah

=head1 DESCRIPTION

Stub documentation for Net::DHCP::Server::Config::File::Config, created by h2xs. It looks like the
author of the extension was negligent enough to leave the stub
unedited.

Blah blah blah.


=head1 METHODS

=head2 Net::DHCP::Server::Config::File::Parse()

=over

Constructor description

=back

=cut

sub removeComments {
	my ($line) = @_;

	$line =~ s/^(.*?)(#.*)$/$1/g;

	return $line;
}

#
# I'd like to use a standard parsing lib, like Parse::RecDescent
# or something, but for now I'm parsing manually.
#
# ok, this is how 'Parse' works...
#
# load the files. "include" statements are parsed out and files loaded recursively.
#
# create a hierarchy stack, push on a Net::DHCP::Server::Config object
#
# for each line:
#   remove the comments from the line
#
#   parse out "hierarchal" (bracket) objects that can contain other objects.
#   when we encounter a starting bracket, parse it, create the object and push
#   it onto the stack.
#
#   if we come across a non-hierarchal object, we go up the stack and call the
#   add() function as we go. this ensures that these non-hierarchal objects get
#   added to a hierarchal object that can hold them.
#
#   for example:  a host might be incorrectly declared within a "group".
#                 however, $group->add($host) returns false, so we would travel
#                 up the stack until we hit an object that returns true for
#                 add($host). the only object that would do so it the top-level
#                 Net::DHCP::Server::Config object.
#                 This is correct b/c hosts are global.
#
#
#  if we run across a closing bracket, we pop the last hierarchal object off the
#  stack and run up the stack with ->add(), just as we did with non-hierarchal
#  objects.
#
#  the end result is that the stack contains only a single Config object, which
#  is returned.
#
#  if the stack doesn't contain a single item, the config is not correct.
#


sub Parse {
	my ($file) = @_;

	my $lines = readFile($file);

	my @hierarchy = ();

	# we need a top-level object
	push(@hierarchy, new Net::DHCP::Server::Config());

	foreach my $line ( @$lines ) {

		my $object = undef;

		$line = removeComments($line);

		# let's parse out the hierarchal objects and push them onto the stack...

		while( ($line =~ s/^(\s*)(});*//g) || ($line =~ s/^\s*(.*?)\s*({)\s*$//g) ) {
			my $pretext = $1;
			my $bracket = $2;
			
			if($bracket eq '{') {
				if    ($pretext =~ /^\s*subnet\s+(.*)\s+netmask\s+(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})\s*$/i) {
					my $subnet = new Net::DHCP::Server::Config::Subnet(
										   -ip      => $1,
										   -netmask => $2
										  );
					push(@hierarchy, $subnet);
				}

				elsif ($pretext =~ /^\s*pool\s*$/i ) {
					my $pool = new Net::DHCP::Server::Config::Pool();
					push(@hierarchy, $pool);
				}

				elsif ($pretext =~ /^\s*group\s*$/i ) {
					my $group = new Net::DHCP::Server::Config::Group();
					push(@hierarchy, $group);
				}

				elsif ($pretext =~ /^\s*shared-network\s+(.*?)\s*$/i ) {
					my $shared = new Net::DHCP::Server::Config::SharedNetwork( -name => $1 );
					push(@hierarchy, $shared);
				}

				elsif ($pretext =~ /^\s*host\s+(.*?)\s*$/i ) {
					my $host = new Net::DHCP::Server::Config::Host( -name => $1 );
					push(@hierarchy, $host);
				}

				else {
					push(@hierarchy, "IGNORE: $pretext");
				}

			}

			# pop hierarchal objects off the stack when their matching bracket is found

			if($bracket eq '}') {
				$object = pop(@hierarchy);
			}	
		}

		# parse out range statements

                if ($line =~ /^\s*range (dynamic-bootp )*(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})\s+(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3});/) {
			my $bootp   = ($1)?1:0;
                	my $low_ip  = $2;
                  	my $high_ip = $3;
			
			$object = new Net::DHCP::Server::Config::Range(
                                                               -bootp   => $bootp,
                                                               -low_ip  => $low_ip,
                                                               -high_ip => $high_ip
						               );
		}
		
		# parse out option statements
                
		if ( $line =~ /^\s*option (.*?) code \d+\s*=/) {
			# skip option definition statements
			# e.g.
			# option campus code 180 = string;
		}
                elsif ( ($line =~ /^\s*option (.*?)\s*=\s*\"*(.*?)\"*\;*\s*$/) ||
                        ($line =~ /^\s*option (.*?) \"*(.*?)\"*\;*\s*$/)
                      ) {
			# option can be set either way:
			#   option subnet-mask 255.255.255.0;
			#   option campus = "north";

			my $option_name  = $1;
			my $option_value = $2;

			$object = new Net::DHCP::Server::Config::Option(
                                                                -name => $1,
                                                                -value => $2
                                                               );

		}

		# host properties
         	if ( $line =~ /^\s*hardware\s(\w+)\s(.*?);/) {
			my $type = $1;
			my $hw   = $2;

			my $i = $#hierarchy;
			next if($hierarchy[$i] !~ /Net::DHCP::Server::Config::Host=/);
                        $hierarchy[$i]->hardware_type($type);
                        $hierarchy[$i]->hardware($hw);
                }

		# add object to the stack, where it is accepted
		if(defined($object)) {
			next if($object =~ /^IGNORE/);

			my $i = $#hierarchy;
			while($i>=0) {
				if($hierarchy[$i] !~ /^IGNORE/) {
					last if($hierarchy[$i]->add($object));
				}
				$i--;
			}
		}
	}

	# there should be one 'Config' object left on the stack, otherwise the config was poorly formed.
	if($#hierarchy != 0) {
		die "Config file poorly formed!";

	} else {
		# return Net::DHCP::Server::Config object
		return pop(@hierarchy);
	}

}

sub readFile {
	my ($file) = @_;

	my @lines  = ();	
	
	my $fh = new FileHandle();

	# open file readonly
	$fh->open($file, "r");

	while(my $line = <$fh>) {

		if($line =~ /^\s*include\s\"*(.*?)\"*\;/) {
			my $includeFile = $1;

			# recursively load "include" files
			my @includeLines = @{readFile($includeFile)};

			push(@lines, "# including $file below:");
			@lines = (@lines, @includeLines);

		} else {

			push(@lines, $line);
		}
	}
	$fh->close();

	return \@lines;
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

