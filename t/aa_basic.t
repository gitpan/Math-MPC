use warnings;
use strict;
use Math::MPC qw(:mpc);
use Math::MPFR qw(:mpfr);

print "1..1\n";

print STDERR "\n# Using Math::MPFR version ", $Math::MPFR::VERSION, "\n";
print STDERR "# Using Math::MPC version ", $Math::MPC::VERSION, "\n";
print STDERR "# Math::MPFR uses mpfr library version ", MPFR_VERSION_STRING, "\n";
print STDERR "# Math::MPC uses mpfr library version ", Math::MPC::mpfr_v(), "\n";
print STDERR "# Math::MPFR uses gmp library version ", Math::MPFR::gmp_v(), "\n";
print STDERR "# Math::MPC uses gmp library version ", Math::MPC::gmp_v(), "\n";

if($Math::MPC::VERSION eq '0.50') {print "ok 1\n"}
else {print "not ok 1 $Math::MPC::VERSION\n"}