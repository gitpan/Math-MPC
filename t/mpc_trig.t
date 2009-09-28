use warnings;
use strict;
use Math::MPFR qw(:mpfr);
use Math::MPC qw(:mpc);

print "1..3\n";

Rmpc_set_default_prec2(359, 359);

my $z = Math::MPC->new(2, 2);
my $zz = Math::MPC->new(1,1);
my $mpc1 = Math::MPC->new();
my $mpfr1 = Math::MPFR->new();
my $tan = Math::MPC->new();
my $zero = Math::MPC->new(0,0);
my $ok = '';

Rmpc_sin($mpc1, $z, MPC_RNDNN);

RMPC_RE($mpfr1, $mpc1);
$ok .= 'a' if $mpfr1 < 3.420954862 && $mpfr1 > 3.42095486;
RMPC_IM($mpfr1, $mpc1);
$ok .= 'b' if $mpfr1 > -1.50930648533 && $mpfr1 < -1.5093064853;

my $mpc2 = sin($zz);

RMPC_RE($mpfr1, $mpc2);
$ok .= 'c' if $mpfr1 < 1.29845758142 && $mpfr1 > 1.2984575814;
RMPC_IM($mpfr1, $mpc2);
$ok .= 'd' if $mpfr1 > 0.634963914784 && $mpfr1 < 0.634963914785;

if($ok eq 'abcd') {print "ok 1\n"}
else {print "not ok 1 $ok\n"}

$ok = '';

my $sin = sin($z);
my $cos = cos($z);
Rmpc_tan($tan, $z, MPC_RNDNN);

my $diff1 = $tan - ($sin / $cos);

RMPC_RE($mpfr1, $diff1);
$ok .= 'a' if $mpfr1 < 0.000001 && $mpfr1 > -0.000001;
RMPC_IM($mpfr1, $diff1);
$ok .= 'b' if $mpfr1 < 0.000001 && $mpfr1 > -0.000001;

RMPC_RE($mpfr1, ($sin * $sin) + ($cos * $cos));
$ok .= 'c' if $mpfr1 < 1.000001 && $mpfr1 > 0.999999;
RMPC_IM($mpfr1, ($sin * $sin) + ($cos * $cos));
$ok .= 'd' if $mpfr1 < 0.000001 && $mpfr1 > -0.000001;

if($ok eq 'abcd') {print "ok 2\n"}
else {print "not ok 2 $ok\n"}

$ok = '';

Rmpc_sin($mpc1, $zero, MPC_RNDNN);
$ok .= 'a' if $mpc1 == 0;

Rmpc_cos($mpc1, $zero, MPC_RNDNN);
$ok .= 'b' if $mpc1 == 1;

Rmpc_tan($mpc1, $zero, MPC_RNDNN);
$ok .= 'c' if $mpc1 == 0;

Rmpc_sinh($mpc1, $zero, MPC_RNDNN);
$ok .= 'd' if $mpc1 == 0;

Rmpc_cosh($mpc1, $zero, MPC_RNDNN);
$ok .= 'e' if $mpc1 == 1;

Rmpc_tanh($mpc1, $zero, MPC_RNDNN);
$ok .= 'f' if $mpc1 == 0;

if($ok eq 'abcdef') {print "ok 3\n"}
else {print "not ok 3 $ok\n"}

