use warnings;
use strict;
use Math::MPFR qw(:mpfr);
use Math::MPC qw(:mpc);

print "1..3\n";

Rmpfr_set_default_prec(640);
Rmpc_set_default_prec(640);

my $mpfr = Math::MPFR->new();
my $mpc = Math::MPC->new();
my $mpc1 = Math::MPC->new();
my $ok = '';

for(1..10){
   Rmpc_random($mpc);
   Rmpc_random($mpc1);

   RMPC_RE($mpfr, $mpc, MPC_RNDNN);
   $ok .= 'a' if $mpfr > -1 && $mpfr < 1;
   $ok .= 'b' unless Rmpfr_nan_p($mpfr);
   $ok .= 'c' if $mpfr != 0;

   RMPC_IM($mpfr, $mpc, MPC_RNDNN);
   $ok .= 'd' if $mpfr > -1 && $mpfr < 1;
   $ok .= 'e' unless Rmpfr_nan_p($mpfr);
   $ok .= 'f' if $mpfr != 0;
   $ok .= 'g' unless $mpc == $mpc1;
}

if($ok eq 'abcdefg' x 10) {print "ok 1\n"}
else {print "not ok 1 $ok\n"}

$ok = '';

for(1..10) {
   Rmpc_random2($mpc, 25, 1);
   Rmpc_random2($mpc, 25, 1);

   RMPC_RE($mpfr, $mpc, MPC_RNDNN);
   $ok .= 'a' if $mpfr > 0 && $mpfr < 10;
   $ok .= 'b' unless Rmpfr_nan_p($mpfr);
   $ok .= 'c' if $mpfr != 0;

   RMPC_IM($mpfr, $mpc, MPC_RNDNN);
   $ok .= 'd' if $mpfr > 0 && $mpfr < 10;
   $ok .= 'e' unless Rmpfr_nan_p($mpfr);
   $ok .= 'f' if $mpfr != 0;
   $ok .= 'g' unless $mpc == $mpc1;
}

if($ok eq 'abcdefg' x 10) {print "ok 2\n"}
else {print "not ok 2 $ok\n"}

$ok = '';

for(1..10) {
   Rmpc_random2($mpc, -25, 1);
   Rmpc_random2($mpc, -25, 1);

   RMPC_RE($mpfr, $mpc, MPC_RNDNN);
   $ok .= 'a' if $mpfr < 0 && $mpfr > -10;
   $ok .= 'b' unless Rmpfr_nan_p($mpfr);
   $ok .= 'c' if $mpfr != 0;

   RMPC_IM($mpfr, $mpc, MPC_RNDNN);
   $ok .= 'd' if $mpfr < 0 && $mpfr > -10;
   $ok .= 'e' unless Rmpfr_nan_p($mpfr);
   $ok .= 'f' if $mpfr != 0;
   $ok .= 'g' unless $mpc == $mpc1;
}

if($ok eq 'abcdefg' x 10) {print "ok 3\n"}
else {print "not ok 3 $ok\n"}