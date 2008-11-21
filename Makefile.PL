use ExtUtils::MakeMaker;
use Config;
require 5.006;

$use_64_bit_int = 0; # Let perl decide whether to include 64-bit 'long long' support
$use_long_double = 0;# Let perl decide whether to include 'long double' support

#$use_64_bit_int = -1; # Force exclusion of 64-bit 'long long' support
#$use_long_double = -1;# Force exclusion of 'long double' support

#$use_64_bit_int = 1; # Force inclusion of 64-bit 'long long' support
#$use_long_double = 1;# Force inclusion of 'long double' support

print "\nThis module requires the following C libraries:\n";
print " gmp-4.2.0 (or later)\n mpfr-2.3.0 (or later)\n mpc-0.5.1 (or later)\n\n";

my $defines = $] < 5.008 ? "-DOLDPERL" : "-DNEWPERL";

if($use_64_bit_int == -1) {}                                
elsif($use_64_bit_int == 1) {$defines .= " -DUSE_64_BIT_INT"}
else {
  if($Config::Config{use64bitint} eq 'define' || 
     $Config::Config{use64bitall} eq 'define' ||
     $Config::Config{usemorebits} eq 'define' ||
     $Config::Config{ivsize} == 8 ) {$defines .= " -DUSE_64_BIT_INT"}
}

if($use_long_double == -1) {}
elsif($use_long_double == 1) {$defines .= " -DUSE_LONG_DOUBLE"}
else {
  if($Config::Config{uselongdouble} eq 'define' ||
     $Config::Config{usemorebits} eq 'define' ||
     $Config::Config{nvsize} > 8 ) {$defines .= " -DUSE_LONG_DOUBLE"}
}

$defines =~ /-DUSE_64_BIT_INT/ ? print "Building with 64-bit'long long' support\n" :
                                 print "Building without 64-bit 'long long' support\n";

print "If this is wrong, see the \"64-bit support\" section in the README\n\n";

$defines =~ /-DUSE_LONG_DOUBLE/ ? print "Building with 'long double' support\n" :
                                 print "Building without 'long double' support\n";

print "If this is wrong, see the \"64-bit support\" section in the README\n\n";

my %options = (       
  NAME => 'Math::MPC',
  PREREQ_PM => {'Math::MPFR' => '2.01'},
  DEFINE   => $defines,
  LIBS => [
    '-lmpc -lmpfr -lgmp'
  ],
  VERSION_FROM => 'MPC.pm',
  clean   => { FILES => 'out1.txt out2.txt out3.txt out4.txt out5.txt out6.txt out7.txt' },
);

WriteMakefile(%options);

# Remove the Makefile dependency. Causes problems on a few systems.
sub MY::makefile { '' }

