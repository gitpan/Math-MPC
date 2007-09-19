use ExtUtils::MakeMaker;
use Config;
require 5.006;

$use_64_bit_int = 0; # Let perl decide whether to include 64-bit 'long long' support
$use_long_double = 0;# Let perl decide whether to include 'long double' support

#$use_64_bit_int = -1; # Force exclusion of 64-bit 'long long' support
#$use_long_double = -1;# Force exclusion of 'long double' support

#$use_64_bit_int = 1; # Force inclusion of 64-bit 'long long' support
#$use_long_double = 1;# Force inclusion of 'long double' support

#### Define some globals for later use ###
$CC = $Config{cc};
%args = map{split /\s*=\s*/} @ARGV;
$LIBS = $args{LIBS} || '-lmpc -lmpfr -lgmp';
$INC = $args{INC};
$redirect = $^O =~ /mswin32/i ? '>NUL 2>&1' : '2>/dev/null';
$cl_libs = '';

if($CC eq 'cl') {
  my $fix_slashes = $LIBS;
  $fix_slashes =~ s/\\/\//g; # Just in case backslashes have been used.
  my @elements = split /\-L/, $fix_slashes;

  for(@elements) {
     next if $_ !~ /\-l/;
     my @temp = split /\-l/, $_;

     $temp[0] =~ s/ +//;
     if($temp[0] && (substr($temp[0], -1, 1) ne '/')) {$temp[0] .= '/'}

     for(my $i = 1; $i < @temp; $i++) {
        $temp[$i] = 'lib' . $temp[$i];
        $temp[$i] =~ s/ +//;
        $cl_libs .= $temp[0] . $temp[$i] . $Config{lib_ext} . ' ';
     }
  }
  $cl_libs = "$INC $cl_libs";
  $cl_libs =~ s/\//\\/g; # We need backslashes.
}

else {$cl_libs = "$INC $LIBS"}
### End of globals configuration ###

$| = 1;

print "Checking for a C compiler ....";

if(!have_compiler()) {
  die "

******************************************
Could not find your $Config{cc} compiler.
If you know this is not an issue then feel
free to modify the Makefile.PL to exclude
this test, and then re-run the Makefile.PL.

If the author has made a mistake in the
construction of this test, please let him
know:
sisyphus at cpan dot org
******************************************
";
  }
else {print ".. found\n"}

print "Looking for MPC, GMP and MPFR libraries ...";

if(!have_libraries()) {
  die "

******************************************
Couldn't find libmpc and/or libgmp and/or 
libmpfr - all of which are required for Math::MPC.

To obtain GMP go to:
http://swox.com/gmp/

To obtain MPFR go to:
http://www.mpfr.org/

To obtain MPC go to:
http://www.loria.fr/~zimmerma/software/mpc.html

If you have these 3 libraries installed,
then apparently one (or more) was not
found. Check the README for instructions.
If the instructions are incorrect, please
notify the author:
sisyphus at cpan dot org

You can, of course, modify Makefile.PL so 
that this test is not conducted - then
re-run it.
******************************************
";
}
else {print "... libraries found\n"}

print "Checking that your MPFR library is up to date ...";

$v_ok = get_version();

if($v_ok == 2) {print ".. ok - up to date\n"}

if($v_ok == 1) {
  die "

In attempting to determine your MPFR version, the
executable did not compile. This would indicate that
you don't have a sufficiently recent version of MPFR. 
You need MPFR version 2.2.0 or higher. Get it from:

http://www.mpfr.org/

Alternatively, if you think there's an error in 
this check procedure, then edit the Makefile.PL
to exclude this check, re-run it, and please 
inform the author:
sisyphus at cpan dot org
";
}

if($v_ok == 0) {
  die "

You need MPFR version 2.2.0 or higher. Get it from:

http://www.mpfr.org/

Alternatively, if you think there's an error in 
this check procedure, then edit the Makefile.PL
to exclude this check, re-run it, and please 
inform the author:
sisyphus at cpan dot org
";
}

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
  clean   => { FILES => 'comp.exe check.exe version.exe comp.exe.manifest check.exe.manifest version.exe.manifest' },
);

WriteMakefile(%options);

# Remove the Makefile dependency. Causes problems on a few systems.
sub MY::makefile { '' }

sub have_compiler {
   my $middle = $Config{cc} eq 'cl' ? '' : '-o comp.exe';
   if(system("$CC $middle comp.c $redirect") == 0) {return 1}
   else {return 0}
}

sub have_libraries {
   my $middle = $Config{cc} eq 'cl' ? '' : '-o check.exe';
   if(system("$CC $middle check.c $cl_libs $redirect") == 0) {return 1}
   else {return 0}
}

sub get_version {
   my $middle = $Config{cc} eq 'cl' ? '' : '-o version.exe';
   unless(system("$CC $middle version.c $cl_libs $redirect") == 0) {return 1}
   my $v = $^O =~ /mswin32/i ? `version.exe` : `./version.exe`;
   my @v = split /\./, $v;
   if($v[0] == 2 && $v[1] >= 3 && $v[2] >= 0) {return 2}
   print "\nYou have MPFR version $v\n";
   return 0;
}




