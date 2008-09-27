use warnings;
use strict;
use Math::MPC qw(:mpc);
use Math::MPFR qw(:mpfr);

print "1..3\n";

Rmpc_set_default_prec(100);

my $mpc = Math::MPC->new('246' x 7, '3579' x 6);
my $ok = '';
my($real, $im) = c_string($mpc, 16, 0, MPC_RNDNN);
my $r = r_string($mpc, 16, 0, MPC_RNDNN);
my $i = i_string($mpc, 16, 0, MPC_RNDNN);

if($r eq $real) {$ok .= 'a'}
else {print "$r ne $real\n"}

if($i eq $im) {$ok .= 'b'}
else {print "$i ne $im\n"}

if($real eq 'd.595a684adcdfe766@16') {$ok .= 'c'}
else {print "$real ne d.595a684adcdfe766\@16\n"}

if($im eq '4.bcbbcfdfb50863475ab@19') {$ok .= 'd'}
else {print "$im ne 4.bcbbcfdfb50863475ab\@19\n"}

($real, $im) = c_string($mpc, 10, 0, MPC_RNDNN);

if($real eq '2.46246246246246246246e20') {$ok .= 'e'}
else {print "$real ne 2.46246246246246246246e20\n"}

if($im eq '3.57935793579357935793579e23') {$ok .= 'f'}
else {print "$im ne 3.57935793579357935793579e23\n"}

my $mpc_simple = Math::MPC->new(16.03125, 15.25);
my $complex_string = Rmpc_get_str($mpc_simple, 16, 0, MPC_RNDNN);
if($complex_string eq '1.008@1 +I*f.4') {$ok .= 'g'}

$complex_string = Rmpc_get_str($mpc_simple, 16, 5, MPC_RNDNN);
if($complex_string eq '1.0080@1 +I*f.4000') {$ok .= 'h'}

$complex_string = Rmpc_get_str($mpc_simple, 10, 0, MPC_RNDNN);
if($complex_string eq '1.603125e1 +I*1.525e1') {$ok .= 'i'}

$complex_string = Rmpc_get_str($mpc_simple, 10, 9, MPC_RNDNN);
if($complex_string eq '1.60312500e1 +I*1.52500000e1') {$ok .= 'j'}

if($ok eq 'abcdefghij') {print "ok 1\n"}
else {print "not ok 1 $ok\n"}

$ok = '';

my $mpc2 = Math::MPC->new(0, 0);
$mpc2 *= -1;

if(Math::MPC::overload_string($mpc2, 10, 0, MPC_RNDNN) eq '-0 -I*0') {$ok .= 'a'}

my $mpfr1 = Math::MPFR->new(-0.0);
my $inf = 1 / $mpfr1;
my $nan = Math::MPFR->new();
my $mpc3 = Math::MPC->new($nan, $inf);

if(lc(Math::MPC::overload_string($mpc3, 10, 0, MPC_RNDNN)) eq '@nan@ -i*@inf@') {$ok .= 'b'}

if($ok eq 'ab') {print "ok 2\n"}
else {print "not ok 2 $ok\n"}

$ok = '';

my $mpc4 = Math::MPC->new(-10, 12.5);
my @vals = Rmpc_deref4($mpc4, 10, 5, MPC_RNDNN);

$ok .= 'a' if $vals[0] eq '-10000';
$ok .= 'b' if $vals[1] == 2;
$ok .= 'c' if $vals[2] eq '12500';
$ok .= 'd' if $vals[3] == 2;

if($ok eq 'abcd') {print "ok 3\n"}
else {print "not ok 3 $ok\n"}
