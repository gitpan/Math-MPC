use warnings;
use strict;
use Math::MPC qw(:mpc);
use Math::MPFR qw(:mpfr);
use Math::BigInt;

print "1..11\n";

Rmpc_set_default_prec(5000);
Rmpfr_set_default_prec(5000);

my ($mpc, $mpc3, $mpc4, $mpfr, $mpfr1, $mpfr2, $mpfr3, $mpfr4, $mpfr5);
my $ok = '';
my $string = 'hello world';
my $mbi = Math::BigInt->new(123456);

eval {$mpc = Math::MPC->new($string);};
if($@ =~ /Math::MPC::new/) {$ok = 'a'}
eval {$mpc = new Math::MPC($string);};
if($@ =~ /Math::MPC::new/) {$ok .= 'b'}
eval {$mpc = Math::MPC::new($string);};
if($@ =~ /Math::MPC::new/) {$ok .= 'c'}
eval {$mpc = Math::MPC->new($string, 0);};
if($@ =~ /Math::MPC::new/) {$ok .= 'd'}
eval {$mpc = new Math::MPC($string, 0);};
if($@ =~ /Math::MPC::new/) {$ok .= 'e'}
eval {$mpc = Math::MPC::new($string, 0);};
if($@ =~ /Math::MPC::new/) {$ok .= 'f'}
eval {$mpc = Math::MPC->new(0, $string);};
if($@ =~ /Math::MPC::new/) {$ok .= 'g'}
eval {$mpc = new Math::MPC(0, $string);};
if($@ =~ /Math::MPC::new/) {$ok .= 'h'}
eval {$mpc = Math::MPC::new(0, $string);};
if($@ =~ /Math::MPC::new/) {$ok .= 'i'}

eval {$mpc = Math::MPC->new($mbi);};
if($@ =~ /First /) {$ok .= 'j'}
eval {$mpc = new Math::MPC($mbi);};
if($@ =~ /First /) {$ok .= 'k'}
eval {$mpc = Math::MPC::new($mbi);};
if($@ =~ /First/) {$ok .= 'l'}
eval {$mpc = Math::MPC->new($mbi, 0);};
if($@ =~ /First /) {$ok .= 'm'}
eval {$mpc = new Math::MPC($mbi, 0);};
if($@ =~ /First /) {$ok .= 'n'}
eval {$mpc = Math::MPC::new($mbi, 0);};
if($@ =~ /First /) {$ok .= 'o'}
eval {$mpc = Math::MPC->new(0, $mbi);};
if($@ =~ /Second /) {$ok .= 'p'}
eval {$mpc = new Math::MPC(0, $mbi);};
if($@ =~ /Second /) {$ok .= 'q'}
eval {$mpc = Math::MPC::new(0, $mbi);};
if($@ =~ /Second /) {$ok .= 'r'}

eval{$mpc = Math::MPC->new(0, '0b115');};
if($@ =~ /Invalid string/) {$ok .= 's'}
eval{$mpc = Math::MPC::new(0, '0B115');};
if($@ =~ /Invalid string/) {$ok .= 't'}

eval{$mpc = Math::MPC->new(0, '0xz115');};
if($@ =~ /Invalid string/) {$ok .= 'u'}
eval{$mpc = Math::MPC::new(0, '0Xz115');};
if($@ =~ /Invalid string/) {$ok .= 'v'}

eval{$mpc = Math::MPC->new('0b115');};
if($@ =~ /Invalid string/) {$ok .= 'w'}
eval{$mpc = Math::MPC::new('0B115');};
if($@ =~ /Invalid string/) {$ok .= 'x'}

eval{$mpc = Math::MPC->new('0xz115');};
if($@ =~ /Invalid string/) {$ok .= 'y'}
eval{$mpc = Math::MPC::new('0Xz115');};
if($@ =~ /Invalid string/) {$ok .= 'z'}

if($ok eq 'abcdefghijklmnopqrstuvwxyz') {print "ok 1\n"}
else {print "not ok 1 $ok\n"}

$ok = ''; 

($mpfr1, $mpfr2, $mpfr3, $mpfr4, $mpfr5) = (Rmpfr_init(), Rmpfr_init(), Rmpfr_init(), Rmpfr_init(), Rmpfr_init()); 

{
my $mpc1 = Math::MPC->new();
my $mpc2 = Math::MPC::new();
RMPC_RE($mpfr1, $mpc1, MPC_RNDNN);
RMPC_IM($mpfr2, $mpc1, MPC_RNDNN);
RMPC_RE($mpfr3, $mpc2, MPC_RNDNN);
RMPC_IM($mpfr4, $mpc2, MPC_RNDNN);
}
$ok .= 'a' if Rmpfr_nan_p($mpfr1);
$ok .= 'b' if Rmpfr_nan_p($mpfr2);
$ok .= 'c' if Rmpfr_nan_p($mpfr3);
$ok .= 'd' if Rmpfr_nan_p($mpfr4);

if($ok eq 'abcd') {print "ok 2\n"}
else {print "not ok 2 $ok\n"}

$ok = '';

{
my $mpc1 = Math::MPC->new(~0);
my $mpc2 = Math::MPC::new(~0);
RMPC_RE($mpfr1, $mpc1, MPC_RNDNN);
RMPC_IM($mpfr2, $mpc1, MPC_RNDNN);
RMPC_RE($mpfr3, $mpc2, MPC_RNDNN);
RMPC_IM($mpfr4, $mpc2, MPC_RNDNN);
}

$ok .= 'a' if $mpfr1 == ~0;
$ok .= 'b' if $mpfr2 == 0;
$ok .= 'c' if $mpfr3 == ~0;
$ok .= 'd' if $mpfr4 == 0;

if($ok eq 'abcd') {print "ok 3\n"}
else {print "not ok 3 $ok\n"}

$ok = '';

{
my $mpc1 = Math::MPC->new(-7, ~0);
my $mpc2 = Math::MPC::new(-7, ~0);
RMPC_RE($mpfr1, $mpc1, MPC_RNDNN);
RMPC_IM($mpfr2, $mpc1, MPC_RNDNN);
RMPC_RE($mpfr3, $mpc2, MPC_RNDNN);
RMPC_IM($mpfr4, $mpc2, MPC_RNDNN);
}

$ok .= 'a' if $mpfr1 == -7;
$ok .= 'b' if $mpfr2 == ~0;
$ok .= 'c' if $mpfr3 == -7;
$ok .= 'd' if $mpfr4 == ~0;

if($ok eq 'abcd') {print "ok 4\n"}
else {print "not ok 4 $ok\n"}

$ok = '';

{
my $mpc1 = Math::MPC->new(2199023255552.5, -7);
my $mpc2 = Math::MPC::new(2199023255552.5, -7);
RMPC_RE($mpfr1, $mpc1, MPC_RNDNN);
RMPC_IM($mpfr2, $mpc1, MPC_RNDNN);
RMPC_RE($mpfr3, $mpc2, MPC_RNDNN);
RMPC_IM($mpfr4, $mpc2, MPC_RNDNN);
}

$ok .= 'a' if $mpfr1 == 2199023255552.5;
$ok .= 'b' if $mpfr2 == -7;
$ok .= 'c' if $mpfr3 == 2199023255552.5;
$ok .= 'd' if $mpfr4 == -7;

if($ok eq 'abcd') {print "ok 5\n"}
else {print "not ok 5 $ok\n"}

$ok = '';

{
my $mpc1 = Math::MPC->new('2199023255552' x 7, -2199023255552.5);
my $mpc2 = Math::MPC::new('2199023255552' x 7, -2199023255552.5);
RMPC_RE($mpfr1, $mpc1, MPC_RNDNN);
RMPC_IM($mpfr2, $mpc1, MPC_RNDNN);
RMPC_RE($mpfr3, $mpc2, MPC_RNDNN);
RMPC_IM($mpfr4, $mpc2, MPC_RNDNN);
$mpfr = Math::MPFR->new($mpfr1);
}

$ok .= 'a' if $mpfr1 == '2199023255552' x 7;
$ok .= 'b' if $mpfr2 == -2199023255552.5;
$ok .= 'c' if $mpfr3 == '2199023255552' x 7;
$ok .= 'd' if $mpfr4 == -2199023255552.5;

if($ok eq 'abcd') {print "ok 6\n"}
else {print "not ok 6 $ok\n"}

$ok = '';

$string = '2199023255552' x 7;
$string = '-' . $string;

{
my $mpc1 = Math::MPC->new($mpfr, $string);
my $mpc2 = Math::MPC::new($mpfr, $string);
RMPC_RE($mpfr1, $mpc1, MPC_RNDNN);
RMPC_IM($mpfr2, $mpc1, MPC_RNDNN);
RMPC_RE($mpfr3, $mpc2, MPC_RNDNN);
RMPC_IM($mpfr4, $mpc2, MPC_RNDNN);
}

$ok .= 'a' if $mpfr1 == $mpfr;
$ok .= 'b' if $mpfr2 == $string;
$ok .= 'c' if $mpfr3 == $mpfr;
$ok .= 'd' if $mpfr4 == $string;

if($ok eq 'abcd') {print "ok 7\n"}
else {print "not ok 7 $ok\n"}

$ok = '';

{
my $mpc1 = Math::MPC->new(6, $mpfr);
my $mpc2 = Math::MPC::new(6, $mpfr);
$mpc3 = Math::MPC->new($mpc1);
$mpc4 = Math::MPC::new($mpc1);
RMPC_RE($mpfr1, $mpc1, MPC_RNDNN);
RMPC_IM($mpfr2, $mpc1, MPC_RNDNN);
RMPC_RE($mpfr3, $mpc2, MPC_RNDNN);
RMPC_IM($mpfr4, $mpc2, MPC_RNDNN);
}

$ok .= 'a' if $mpfr1 == 6;
$ok .= 'b' if $mpfr2 == $mpfr;
$ok .= 'c' if $mpfr3 == 6;
$ok .= 'd' if $mpfr4 == $mpfr;

if($ok eq 'abcd') {print "ok 8\n"}
else {print "not ok 8 $ok\n"}

$ok = '';

{
my $mpc1 = Math::MPC->new($mpc3);
my $mpc2 = Math::MPC::new($mpc4);
if($mpc3 == $mpc1) {$ok .= 'a'}
if($mpc4 == $mpc2) {$ok .= 'b'}
if($mpc1 == $mpc2) {$ok .= 'c'} 
}

if($ok eq 'abc'){print "ok 9\n"}
else {print "not ok 9 $ok\n"}

$ok = '';

{
my $mpc1 = Math::MPC->new('0b111', '0xff');
my $mpc2 = Math::MPC::new('0B111', '0XFF');
RMPC_RE($mpfr1, $mpc1, MPC_RNDNN);
RMPC_IM($mpfr2, $mpc1, MPC_RNDNN);
RMPC_RE($mpfr3, $mpc2, MPC_RNDNN);
RMPC_IM($mpfr4, $mpc2, MPC_RNDNN);
}

$ok .= 'a' if $mpfr1 == 7;
$ok .= 'b' if $mpfr2 == 255;
$ok .= 'c' if $mpfr3 == 7;
$ok .= 'd' if $mpfr4 == 255;

if($ok eq 'abcd') {print "ok 10\n"}
else {print "not ok 10 $ok\n"}

$ok = '';

eval{my $m_p_c = Math::MPC->new(1, 2, 3);};
if($@ =~ /Too many arguments supplied to new/) {$ok .= 'a'}

$mpc = Math::MPC->new(6, 5);

eval{my $m_p_c = Math::MPC->new($mpc, 2);};
if($@ =~ /Too many arguments supplied to new\(\) \- expected no more than one/) {$ok .= 'b'}

eval{my $m_p_c = Math::MPC::new(1, 2, 3);};
if($@ =~ /Too many arguments supplied to new\(\) \- expected no more than two/) {$ok .= 'c'}

eval{my $m_p_c = Math::MPC->new($mbi, 2);};
if($@ =~ /First argument to new\(\) is inappropriate/) {$ok .= 'd'}

eval{my $m_p_c = Math::MPC->new(2, $mbi);};
if($@ =~ /Second argument to new\(\) is inappropriate/) {$ok .= 'e'}

if($ok eq 'abcde') {print "ok 11\n"}
else {print "not ok 11 $ok\n"}

$ok = '';


