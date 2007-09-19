use warnings;
use strict;
use Math::MPC qw(:mpc);

# mpc_out_str() segfaults on some architectures -
# better to use c_string() - or r_string() and i_string()

print "1..2\n";

Rmpc_set_default_prec(100);

my $str = Math::MPC->new('246' x 7, '3579' x 6);
my $ok = '';

my $ret = Rmpc_out_str($str, 16, 0, MPC_RNDNN);

if($ret == 63) {$ok .= 'a'}
else {print "\nReturned: ", $ret, "\n"}

print "\n";

$ret = Rmpc_out_str($str, 16, 0, MPC_RNDNN, " \n");

if($ret == 63) {$ok .= 'b'}
else {print "Returned: ", $ret, "\n"}

print "\n";

if($ok eq 'ab') {print "ok 1 \n"}
else {print "not ok 1 $ok\n"}

$ok = '';

eval{$ret = Rmpc_out_str($str, 16, 0);};
$ok .= 'a' if $@ =~ /Wrong number of arguments/;

eval{$ret = Rmpc_out_str($str, 16, 0, MPC_RNDNN, 7, 5);};
$ok .= 'b' if $@ =~ /Wrong number of arguments/;

if($ok eq 'ab') {print "ok 2 \n"}
else {print "not ok 2 $ok\n"}



