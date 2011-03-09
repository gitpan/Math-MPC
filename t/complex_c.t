use warnings;
use strict;
use Math::MPFR qw(:mpfr);
use Math::MPC qw(:mpc);

my $count = 11;

print "1..$count\n";

Rmpc_set_default_prec2(200, 200);

eval {require Math::Complex_C;};

if($@) {
  warn "Skipping all tests - couldn't load Math::Complex_C";
  for(1 .. $count) {print "ok $_\n"}
  exit 0;
}

unless(Math::MPC::_have_Complex_h()) {
  warn "Skipping all tests - Math::MPC not built with support for 'double _Complex' & 'long double _Complex' types";
  for(1 .. $count) {print "ok $_\n"}
  exit 0;
}

my $cc = Math::Complex_C->new(4.5, -231.125);
my $ccl = Math::Complex_C::Long->new(4.5, -231.125);
my $mpcc = Math::MPC->new();
my $mpfr = Math::MPFR->new();

Rmpc_set_dc($mpcc, $cc, MPC_RNDNN);

RMPC_RE($mpfr, $mpcc);
if($mpfr == 4.5) {print "ok 1\n"}
else {
  warn "\$mpfr: $mpfr\n";
  print "not ok 1\n";
}

RMPC_IM($mpfr, $mpcc);
if($mpfr == -231.125) {print "ok 2\n"}
else {
  warn "\$mpfr: $mpfr\n";
  print "not ok 2\n";
}

Rmpc_set_ldc($mpcc, $ccl, MPC_RNDNN);

RMPC_RE($mpfr, $mpcc);
if($mpfr == 4.5) {print "ok 3\n"}
else {
  warn "\$mpfr: $mpfr\n";
  print "not ok 3\n";
}

RMPC_IM($mpfr, $mpcc);
if($mpfr == -231.125) {print "ok 4\n"}
else {
  warn "\$mpfr: $mpfr\n";
  print "not ok 4\n";
}

Math::Complex_C::assign_c($cc, 3.19, -12.621);
Math::Complex_C::Long::assign_cl($ccl, 3.19, -12.621);

my $mpccl = Math::MPC->new();

Rmpc_set_dc($mpcc, $cc, MPC_RNDNN);
Rmpc_set_ldc($mpccl, $ccl, MPC_RNDNN);

if(Math::Complex_C::_nvsize() == Math::Complex_C::_doublesize()) {
  if($mpcc == $mpccl) {print "ok 5\n"}
  else {print "not ok 5\n"}
}
elsif((Math::Complex_C::_nvsize() == Math::Complex_C::_longdoublesize()) &&
      (Math::Complex_C::_longdoublesize() > Math::Complex_C::_doublesize())) {
  unless($mpcc == $mpccl) {print "ok 5\n"}
  else {print "not ok 5\n"}
}
else {
  warn "Skipping test 5 for this configuration of perl\n";
  print "ok 5\n";
}

my $cc_check = Math::Complex_C->new();
my $ccl_check = Math::Complex_C::Long->new();

Rmpc_get_dc($cc_check, $mpcc, MPC_RNDNN);
Rmpc_get_ldc($ccl_check, $mpccl, MPC_RNDNN);

if($cc_check == $cc) {print "ok 6\n"}
else {
  warn "\$cc_check: $cc_check\n\$cc: $cc\n";
  print "not ok 6\n";
}

if($ccl_check == $ccl) {print "ok 7\n"}
else {
  warn "\$ccl_check: $ccl_check\n\$ccl: $ccl\n";
  print "not ok 7\n";
}

eval {Rmpc_get_dc($ccl_check, $mpcc, MPC_RNDNN);};

if($@) {
  if($@ =~ /1st arg/) {print "ok 8\n"}
  else {
    warn "\$\@: $@\n";
    print "not ok 8\n";
  }
}
else {print "not ok 8\n"}

eval {Rmpc_get_ldc($cc_check, $mpccl, MPC_RNDNN);};

if($@) {
  if($@ =~ /1st arg/) {print "ok 9\n"}
  else {
    warn "\$\@: $@\n";
    print "not ok 9\n";
  }
}
else {print "not ok 9\n"}

eval {Rmpc_set_dc($mpcc, $ccl, MPC_RNDNN);};

if($@) {
  if($@ =~ /2nd arg/) {print "ok 10\n"}
  else {
    warn "\$\@: $@\n";
    print "not ok 10\n";
  }
}
else {print "not ok 10\n"}

eval {Rmpc_set_ldc($mpccl, $cc, MPC_RNDNN);};

if($@) {
  if($@ =~ /2nd arg/) {print "ok 11\n"}
  else {
    warn "\$\@: $@\n";
    print "not ok 11\n";
  }
}
else {print "not ok 11\n"}

