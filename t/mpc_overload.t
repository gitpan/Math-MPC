use warnings;
use strict;
use Math::MPC qw(:mpc);
use Math::BigInt;

print "1..3\n";

my $mbi2;
my $ok = '';
my $string = 'hello world';
my $mbi = Math::BigInt->new(123456);
my @prec = Rmpc_get_default_prec2();
my $mpc = Rmpc_init3(@prec);
Rmpc_set_ui_ui($mpc, 10, 10, MPC_RNDNN);

eval {$mbi2 = $mpc + $string;};
if($@ =~ /Math::MPC::overload_add/) {$ok = 'a'}
eval {$mbi2 = $mpc - $string;};
if($@ =~ /Math::MPC::overload_sub/) {$ok .= 'b'}
eval {$mbi2 = $mpc / $string;};
if($@ =~ /Math::MPC::overload_div/) {$ok .= 'c'}
eval {$mbi2 = $mpc * $string;};
if($@ =~ /Math::MPC::overload_mul/) {$ok .= 'd'} 
eval {$mbi2 = $mpc + $mbi;};
if($@ =~ /Math::MPC::overload_add/) {$ok .= 'e'}
eval {$mbi2 = $mpc - $mbi;};
if($@ =~ /Math::MPC::overload_sub/) {$ok .= 'f'}
eval {$mbi2 = $mpc / $mbi;};
if($@ =~ /Math::MPC::overload_div/) {$ok .= 'g'}
eval {$mbi2 = $mpc * $mbi;};
if($@ =~ /Math::MPC::overload_mul/) {$ok .= 'h'} 

eval {$mpc += $string;};
if($@ =~ /Math::MPC::overload_add_eq/) {$ok .= 'i'}
eval {$mpc -= $string;};
if($@ =~ /Math::MPC::overload_sub_eq/) {$ok .= 'j'}
eval {$mpc /= $string;};
if($@ =~ /Math::MPC::overload_div_eq/) {$ok .= 'k'}
eval {$mpc *= $string;};
if($@ =~ /Math::MPC::overload_mul_eq/) {$ok .= 'l'} 
eval {$mpc += $mbi;};
if($@ =~ /Math::MPC::overload_add_eq/) {$ok .= 'm'}
eval {$mpc -= $mbi;};
if($@ =~ /Math::MPC::overload_sub_eq/) {$ok .= 'n'}
eval {$mpc /= $mbi;};
if($@ =~ /Math::MPC::overload_div_eq/) {$ok .= 'o'}
eval {$mpc *= $mbi;};
if($@ =~ /Math::MPC::overload_mul_eq/) {$ok .= 'p'}

if($ok eq 'abcdefghijklmnop') {print "ok 1\n"}
else {print "not ok 1 $ok\n"} 

my $num = Math::MPC->new(200, 40);
if(Math::MPC::overload_string($num) eq '2e2 +I*4e1') {print "ok 2\n"}
else {print "not ok 2 ", Math::MPC::overload_string($num), "\n"}

# checking overload_copy subroutine
$ok = '';
$ok .= 'a' if $prec[0] == 53 && $prec[1] == 53;

my $mpc1 = Math::MPC->new(12345, 67890);
Rmpc_set_default_prec2(100, 112);
my $mpc2 = $mpc1;

my @p = Rmpc_get_prec2($mpc2);

$ok .= 'b' if $p[0] == 53 && $p[1] == 53;

$mpc2++;
$ok .= 'c' if $mpc2 == $mpc1 + 1;

@p = Rmpc_get_prec2($mpc2);
$ok .= 'd' if $p[0] == 53 && $p[1] == 53;

my $mpc3 = Rmpc_init3(70, 80);
Rmpc_set_ui_ui($mpc3, 54321, 9876, MPC_RNDNN);

my $mpc4 = $mpc3;
@p = Rmpc_get_prec2($mpc4);

$ok .= 'e' if $p[0] == 70 && $p[1] == 80;

$mpc4 += 1;
$ok .= 'f' if $mpc4 == $mpc3 + 1;

@p = Rmpc_get_prec2($mpc4);
$ok .= 'g' if $p[0] == 70 && $p[1] == 80;

my $mpc5 = $mpc3;
$mpc3 += 1;
@p = Rmpc_get_prec2($mpc5);
$ok .= 'h' if $p[0] == 70 && $p[1] == 80 && $mpc5 == $mpc3 - 1;

if($ok eq 'abcdefgh') {print "ok 3\n"}
else {print "not ok 3 $ok\n"}



