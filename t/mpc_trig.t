use warnings;
use strict;
use Math::MPFR qw(:mpfr);
use Math::MPC qw(:mpc);

print "1..1\n";

Rmpc_set_default_prec(359);

my $z = Math::MPC->new(2, 2);
my $zz = Math::MPC->new(1,1);
my $mpc1 = Math::MPC->new();
my $mpfr1 = Math::MPFR->new();
my $ok = '';

Rmpc_sin($mpc1, $z, MPC_RNDNN);

RMPC_RE($mpfr1, $mpc1, MPC_RNDNN);
$ok .= 'a' if $mpfr1 < 3.420954862 && $mpfr1 > 3.42095486;
RMPC_IM($mpfr1, $mpc1, MPC_RNDNN);
$ok .= 'b' if $mpfr1 > -1.50930648533 && $mpfr1 < -1.5093064853;

my $mpc2 = sin($zz);

RMPC_RE($mpfr1, $mpc2, MPC_RNDNN);
$ok .= 'c' if $mpfr1 < 1.29845758142 && $mpfr1 > 1.2984575814;
RMPC_IM($mpfr1, $mpc2, MPC_RNDNN);
$ok .= 'd' if $mpfr1 > 0.634963914784 && $mpfr1 < 0.634963914785;

if($ok eq 'abcd') {print "ok 1\n"}
else {print "not ok 1 $ok\n"}

