use ExtUtils::MakeMaker;
use Config;
require 5.006;

$do_complex_h = 0; # Let the Makefile.PL decide whether to support the double _Complex and
                   # long double _Complex data types.
#$do_complex_h = 1; # Force inclusion of the double _Complex and long double _Complex data types
#$do_complex_h = -1;# Force exclusion of the double _Complex and long double _Complex data types

unless ($do_complex_h) {
  eval {require Math::Complex_C;};
  $do_complex_h = $@ ? -1 : 1;
}

$use_64_bit_int = 0; # Let perl decide whether to include 64-bit 'long long' support
$use_long_double = 0;# Let perl decide whether to include 'long double' support

#$use_64_bit_int = -1; # Force exclusion of 64-bit 'long long' support
#$use_long_double = -1;# Force exclusion of 'long double' support

#$use_64_bit_int = 1; # Force inclusion of 64-bit 'long long' support
#$use_long_double = 1;# Force inclusion of 'long double' support

print "\nThis module requires the following C libraries:\n";
print " gmp-4.3.2 (or later)\n mpfr-2.4.2 (or later)\n mpc-0.8 (or later)\n\n";

my $defines = $] < 5.008 ? "-DOLDPERL" : "-DNEWPERL";

if($use_64_bit_int == -1) {}                                
elsif($use_64_bit_int == 1) {$defines .= " -DUSE_64_BIT_INT"}
else {
  unless($Config::Config{ivsize} < 8) {
    $defines .= " -DUSE_64_BIT_INT";
  }
}

if($use_long_double == -1) {}
elsif($use_long_double == 1) {$defines .= " -DUSE_LONG_DOUBLE"}
else {
  if($Config::Config{nvsize} > 8 ) {
    $defines .= " -DUSE_LONG_DOUBLE";
  }
}

if($do_complex_h == 1) { $defines .= " -D_DO_COMPLEX_H"}

$defines =~ /-DUSE_64_BIT_INT/ ? print "Building with 64-bit'long long' support\n" :
                                 print "Building without 64-bit 'long long' support\n";

print "If this is wrong, see the \"64-bit support\" section in the README\n\n";

$defines =~ /-DUSE_LONG_DOUBLE/ ? print "Building with 'long double' support\n" :
                                 print "Building without 'long double' support\n";

print "If this is wrong, see the \"64-bit support\" section in the README\n\n";

$defines =~ /-D_DO_COMPLEX_H/ ? print "Trying to build with 'double _Complex' & 'long double _Complex' support\n" :
                                 print "Building without 'double _Complex' & 'long double _Complex' support\n";

print "If this is wrong, see the \"_Complex C types support\" section in the README\n\n";

my %options = (       
  NAME => 'Math::MPC',
  AUTHOR => 'Sisyphus (sisyphus at (@) cpan dot (.) org)',
  ABSTRACT => 'Perl interface to the MPC (multi precision complex) library',
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

