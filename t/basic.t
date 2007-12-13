use warnings;
use strict;
use Math::MPC qw(:mpc);
use Math::MPFR qw(:mpfr);

print "1..1\n";

print STDERR "\n# Using Math::MPFR version ", $Math::MPFR::VERSION, "\n";
print STDERR "# Using Math::MPC version ", $Math::MPC::VERSION, "\n";
print STDERR "# Using mpfr library version ", MPFR_VERSION_STRING, "\n";
print STDERR "# Using gmp library version ", Math::MPFR::gmp_v(), "\n";

if($Math::MPC::VERSION eq '0.46') {print "ok 1\n"}
else {print "not ok 1 $Math::MPC::VERSION\n"}