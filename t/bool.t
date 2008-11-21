use strict;
use warnings;
use Math::MPC qw(:mpc);
use Math::MPFR qw(:mpfr);

print "1..2\n";

print "# Using mpfr version ", MPFR_VERSION_STRING, "\n";
print "# Usinf mpc library version ", MPC_VERSION_STRING, "\n";

my $nan = Math::MPC->new();
my $t1 = Math::MPFR->new();
my $t2 = Math::MPFR->new();
my $untrue1 = Math::MPC->new(Math::MPFR->new(), 0);
my $untrue2 = Math::MPC->new(0, Math::MPFR->new());
my $ok = '';

if(Rmpfr_erangeflag_p()) {Rmpfr_clear_erangeflag()}

RMPC_RE($t1, $nan, MPC_RNDNN);
RMPC_IM($t2, $nan, MPC_RNDNN);

if(Rmpfr_nan_p($t1) && Rmpfr_nan_p($t2))
  {$ok .= 'a'}

RMPC_RE($t1, $untrue1, MPC_RNDNN);
RMPC_IM($t2, $untrue1, MPC_RNDNN);

if(Rmpfr_nan_p($t1) && !Rmpfr_nan_p($t2))
  {$ok .= 'b'}

RMPC_RE($t1, $untrue2, MPC_RNDNN);
RMPC_IM($t2, $untrue2, MPC_RNDNN);

if(!Rmpfr_nan_p($t1) && Rmpfr_nan_p($t2))
  {$ok .= 'c'}

if(!$nan)       {$ok .= 'd'}
if(!$untrue1)   {$ok .= 'e'}
if(!$untrue2)   {$ok .= 'f'}

if($nan)        {$ok .= 'A'}
if($untrue1)    {$ok .= 'B'}
if($untrue2)    {$ok .= 'C'}

if($ok eq 'abcdef') {print "ok 1\n"}
else {print "not ok 1 $ok\n"}

if(!Rmpfr_erangeflag_p()) {print "ok 2\n"}
else {print "not ok 2 - the erangeflag has been set and we don't want that\n"}

