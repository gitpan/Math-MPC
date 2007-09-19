use warnings;
use strict;
use Math::MPC qw(:mpc);
use Math::BigInt;

print "1..2\n";

my $mbi2;
my $ok = '';
my $string = 'hello world';
my $mbi = Math::BigInt->new(123456);
my ($mpc, $ignore) = Rmpc_init_set_ui_ui(10, 10, MPC_RNDNN);

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
if(Math::MPC::overload_string($num) eq '2e2+I*4e1') {print "ok 2\n"}
else {print "not ok 2 ", Math::MPC::overload_string($num), "\n"}

