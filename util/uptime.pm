
use POSIX;

# We need to preserve an API of:
#
# $ut = txtut (uptime (`who -b));
#
# so other scripts don't break.  So we have to use some nonsense code.

sub txtut () {

  # Run `uptime`, then parse out and format relevant info for mrtg.

  my $throwaway = shift;
  my $ret_val;

  my $uptime = `/usr/bin/uptime`;
  my ($years, $days, $hours, $mins, $secs) = (0,0,'00','00','00'); # defaults

  if ($uptime =~ /year\(s\)/) {
      ($years) = ($uptime =~ /^.*\s+(\d+) year\(s\),\s+.*$/);
  }

  if ($uptime =~ /day\(s\)/) {
      ($days) = ($uptime =~ /^.*\s+(\d+) day\(s\),\s+.*$/);
  }

  if ($uptime =~ /hr\(s\)/) {
      ($hours) = ($uptime =~ /^.*\s+(\d+) hr\(s\),\s+.*$/);
  }

  if ($uptime =~ /min\(s\)/) {
      ($mins) = ($uptime =~ /^.*\s+(\d+) min\(s\),\s+.*$/);
  }

  if ($uptime =~ /^.*,\s+\d+:\d+,\s+.*$/) {
      ($hours, $mins) = ($uptime =~ /^.*,\s+(\d+):(\d+),\s+.*$/);
  }

  if ($uptime =~ /^.*up\s+\d+:\d+,\s+.*$/) {
      ($hours, $mins) = ($uptime =~ /^.*up\s+(\d+):(\d+),\s+.*$/);
  }

  $hours = LPad (0, 2, $hours);

  if ($years != 0) {
     $ret_val = "$years years $days days $hours:$mins:$secs";
  }
  else {
     $ret_val = "$days days $hours:$mins:$secs";
  }

  return $ret_val;
}

sub uptime () {

  my $throwaway = shift;
  return 1;
}

sub LPad () {

  # Left-pad the value of pad_source with the value of $pad_char, up to a
  # string length of $pad_length.

  my $pad_char = shift;
  my $pad_length = shift;
  my $pad_source = shift;

  if (($pad_length) =~ /\D/) {
     print STDERR "Value of pad_length $pad_length must be numeric\n";
     exit (-1);
  }

  my $ret_val = $pad_source;

  while (length ($ret_val) < $pad_length) {
    $ret_val = $pad_char . $ret_val;
  }

  return $ret_val;
}

1;
