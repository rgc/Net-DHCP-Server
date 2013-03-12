Net-DHCP-Server
===============

A library that I wrote for helping automate DHCP reporting and interaction at UB (www.buffalo.edu)

Initially written in 2004, converted to a library in 2007

INSTALLATION

To install this module type the following:

   perl Makefile.PL
   make
   make test
   make install

DEPENDENCIES

This module requires these other modules and libraries:

  Net::Netmask

GRAPHING

See util/dhcpstatd for graphing with MRTG/Cacti

STRUCTURE

Net::DHCP::Server                - server object containing 'configfile' and 'leasefile'

Net::DHCP::Server::Subnet        - subnet object
Net::DHCP::Server::SharedNetwork - shared network object
Net::DHCP::Server::Group         - group object
Net::DHCP::Server::Pool          - pool object
Net::DHCP::Server::Lease         - lease object
Net::DHCP::Server::Class         - class object
Net::DHCP::Server::SubClass      - subclass object
Net::DHCP::Server::Host          - host object

Net::DHCP::Server::File          - top-level object, subclassed:
Net::DHCP::Server::File::Config  - contains config file parsing
Net::DHCP::Server::File::Lease   - contains lease file parsing


COPYRIGHT AND LICENCE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.5 or,
at your option, any later version of Perl 5 you may have available.

