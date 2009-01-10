    package Math::MPC;
    use strict;
    use warnings;

    use constant MPC_RNDNN => 0;
    use constant MPC_RNDZN => 1;
    use constant MPC_RNDUN => 2;
    use constant MPC_RNDDN => 3;

    use constant MPC_RNDNZ => 16;
    use constant MPC_RNDZZ => 17;
    use constant MPC_RNDUZ => 18;
    use constant MPC_RNDDZ => 19;

    use constant MPC_RNDNU => 32;
    use constant MPC_RNDZU => 33;
    use constant MPC_RNDUU => 34;
    use constant MPC_RNDDU => 35;

    use constant MPC_RNDND => 48;
    use constant MPC_RNDZD => 49;
    use constant MPC_RNDUD => 50;
    use constant MPC_RNDDD => 51;

    use subs qw(MPC_VERSION MPC_VERSION_MAJOR MPC_VERSION_MINOR
                MPC_VERSION_PATCHLEVEL MPC_VERSION_STRING
                MPC_VERSION MPC_VERSION_NUM);

    use overload
    '+'    => \&overload_add,
    '-'    => \&overload_sub,
    '*'    => \&overload_mul,
    '/'    => \&overload_div,
    '+='   => \&overload_add_eq,
    '-='   => \&overload_sub_eq,
    '*='   => \&overload_mul_eq,
    '/='   => \&overload_div_eq,
    '=='   => \&overload_equiv,
    '!='   => \&overload_not_equiv,
    '!'    => \&overload_not,
    'not'  => \&overload_not,
    '='    => \&overload_copy,
    '""'   => \&overload_string,
    'abs'  => \&overload_abs,
    'bool' => \&overload_true,
    'exp'  => \&overload_exp,
    'log'  => \&overload_log,
    'sqrt' => \&overload_sqrt,
    'sin'  => \&overload_sin,
    'cos'  => \&overload_cos;

    require Exporter;
    *import = \&Exporter::import;
    require DynaLoader;

    @Math::MPC::EXPORT_OK = qw(
MPC_RNDNN MPC_RNDND MPC_RNDNU MPC_RNDNZ MPC_RNDDN MPC_RNDUN MPC_RNDZN MPC_RNDDD 
MPC_RNDDU MPC_RNDDZ MPC_RNDZD MPC_RNDUD MPC_RNDUU MPC_RNDUZ MPC_RNDZU MPC_RNDZZ
MPC_VERSION_MAJOR MPC_VERSION_MINOR MPC_VERSION_PATCHLEVEL MPC_VERSION_STRING
MPC_VERSION MPC_VERSION_NUM Rmpc_get_version
Rmpc_set_default_rounding_mode Rmpc_get_default_rounding_mode
Rmpc_set_prec Rmpc_set_default_prec Rmpc_get_default_prec
Rmpc_set_re_prec Rmpc_set_im_prec
Rmpc_get_prec Rmpc_get_prec2 Rmpc_get_re_prec Rmpc_get_im_prec
RMPC_RE RMPC_IM RMPC_INEX_RE RMPC_INEX_IM
Rmpc_clear Rmpc_clear_ptr Rmpc_clear_mpc
Rmpc_deref4 Rmpc_get_str
Rmpc_init Rmpc_init2 Rmpc_init3
Rmpc_init_nobless Rmpc_init2_nobless Rmpc_init3_nobless
Rmpc_init_set Rmpc_init_set_ui Rmpc_init_set_ui_ui Rmpc_init_set_si_si Rmpc_init_set_ui_fr
Rmpc_init_set_nobless Rmpc_init_set_ui_nobless Rmpc_init_set_ui_ui_nobless
Rmpc_init_set_si_si_nobless Rmpc_init_set_ui_fr_nobless
Rmpc_set Rmpc_set_ui Rmpc_set_si Rmpc_set_d Rmpc_set_ui_ui Rmpc_set_si_si Rmpc_set_d_d Rmpc_set_ui_fr
Rmpc_set_uj_uj Rmpc_set_sj_sj Rmpc_set_fr_fr Rmpc_set_ld_ld
Rmpc_add Rmpc_add_ui Rmpc_add_fr
Rmpc_sub Rmpc_sub_ui Rmpc_ui_sub Rmpc_ui_ui_sub
Rmpc_mul Rmpc_mul_ui Rmpc_mul_si Rmpc_mul_fr Rmpc_mul_i Rmpc_sqr Rmpc_mul_2exp
Rmpc_div Rmpc_div_ui Rmpc_ui_div Rmpc_div_fr Rmpc_sqrt Rmpc_div_2exp
Rmpc_neg Rmpc_abs Rmpc_conj Rmpc_norm Rmpc_exp Rmpc_log
Rmpc_cmp Rmpc_cmp_si Rmpc_cmp_si_si
Rmpc_out_str Rmpc_inp_str c_string r_string i_string 
TRmpc_out_str TRmpc_inp_str
Rmpc_random Rmpc_random2
Rmpc_sin Rmpc_cos Rmpc_tan Rmpc_sinh Rmpc_cosh Rmpc_tanh
Rmpc_real Rmpc_imag Rmpc_arg Rmpc_proj
);

    $Math::MPC::VERSION = '0.52';

    DynaLoader::bootstrap Math::MPC $Math::MPC::VERSION;

    %Math::MPC::EXPORT_TAGS =(mpc => [qw(
MPC_RNDNN MPC_RNDND MPC_RNDNU MPC_RNDNZ MPC_RNDDN MPC_RNDUN MPC_RNDZN MPC_RNDDD 
MPC_RNDDU MPC_RNDDZ MPC_RNDZD MPC_RNDUD MPC_RNDUU MPC_RNDUZ MPC_RNDZU MPC_RNDZZ
MPC_VERSION_MAJOR MPC_VERSION_MINOR MPC_VERSION_PATCHLEVEL MPC_VERSION_STRING
MPC_VERSION MPC_VERSION_NUM Rmpc_get_version
Rmpc_set_default_rounding_mode Rmpc_get_default_rounding_mode
Rmpc_set_prec Rmpc_set_default_prec Rmpc_get_default_prec
Rmpc_set_re_prec Rmpc_set_im_prec
Rmpc_get_prec Rmpc_get_prec2 Rmpc_get_re_prec Rmpc_get_im_prec
RMPC_RE RMPC_IM RMPC_INEX_RE RMPC_INEX_IM
Rmpc_clear Rmpc_clear_ptr Rmpc_clear_mpc
Rmpc_deref4 Rmpc_get_str
Rmpc_init Rmpc_init2 Rmpc_init3
Rmpc_init_nobless Rmpc_init2_nobless Rmpc_init3_nobless
Rmpc_init_set Rmpc_init_set_ui Rmpc_init_set_ui_ui Rmpc_init_set_si_si Rmpc_init_set_ui_fr
Rmpc_init_set_nobless Rmpc_init_set_ui_nobless Rmpc_init_set_ui_ui_nobless
Rmpc_init_set_si_si_nobless Rmpc_init_set_ui_fr_nobless
Rmpc_set Rmpc_set_ui Rmpc_set_si Rmpc_set_d Rmpc_set_ui_ui Rmpc_set_si_si Rmpc_set_d_d Rmpc_set_ui_fr
Rmpc_set_uj_uj Rmpc_set_sj_sj Rmpc_set_fr_fr Rmpc_set_ld_ld
Rmpc_add Rmpc_add_ui Rmpc_add_fr
Rmpc_sub Rmpc_sub_ui Rmpc_ui_sub Rmpc_ui_ui_sub
Rmpc_mul Rmpc_mul_ui Rmpc_mul_si Rmpc_mul_fr Rmpc_mul_i Rmpc_sqr Rmpc_mul_2exp
Rmpc_div Rmpc_div_ui Rmpc_ui_div Rmpc_div_fr Rmpc_sqrt Rmpc_div_2exp
Rmpc_neg Rmpc_abs Rmpc_conj Rmpc_norm Rmpc_exp Rmpc_log
Rmpc_cmp Rmpc_cmp_si Rmpc_cmp_si_si
Rmpc_out_str Rmpc_inp_str c_string r_string i_string
TRmpc_out_str TRmpc_inp_str
Rmpc_random Rmpc_random2
Rmpc_sin Rmpc_cos Rmpc_tan Rmpc_sinh Rmpc_cosh Rmpc_tanh
Rmpc_real Rmpc_imag Rmpc_arg Rmpc_proj
)]);

*TRmpc_out_str = \&Rmpc_out_str;
*TRmpc_inp_str = \&Rmpc_inp_str;

sub dl_load_flags {0} # Prevent DynaLoader from complaining and croaking

sub overload_string {
     return Rmpc_get_str($_[0], 10, 0, Rmpc_get_default_rounding_mode());
}

sub Rmpc_get_str {
    my ($r_s, $i_s) = c_string($_[0], $_[1], $_[2], $_[3]);
    my $sep = $i_s =~ /\-/ ? ' -I*' : ' +I*';
    $i_s =~ s/\-//;
    my $s = $r_s . $sep . $i_s;
    return $s;
}

sub c_string {
    my $r_s = r_string($_[0], $_[1], $_[2], $_[3]);
    my $i_s = i_string($_[0], $_[1], $_[2], $_[3]);
    return ($r_s, $i_s);
}

sub r_string {
    my($mantissa, $exponent) = _get_r_string($_[0], $_[1], $_[2], $_[3]);
    if($mantissa =~ /\@nan\@/i || $mantissa =~ /\@inf\@/i) {return $mantissa}
    if($mantissa =~ /\-/ && $mantissa !~ /[^0,\-]/) {return '-0'}
    if($mantissa !~ /[^0,\-]/ ) {return '0'}
    my $sep = $_[1] <= 10 ? 'e' : '@';

    my $len = substr($mantissa, 0, 1) eq '-' ? 2 : 1;

    if(!$_[2]) {
      while(length($mantissa) > $len && substr($mantissa, -1, 1) eq '0') {
           substr($mantissa, -1, 1, '');
      }
    }

    $exponent--;

    if(length($mantissa) == $len) {
      if($exponent) {return $mantissa . $sep . $exponent}
      return $mantissa;
    }

    substr($mantissa, $len, 0, '.');
    if($exponent) {return $mantissa . $sep . $exponent}
    return $mantissa;
}

sub i_string {
    my($mantissa, $exponent) = _get_i_string($_[0], $_[1], $_[2], $_[3]);
    if($mantissa =~ /\@nan\@/i || $mantissa =~ /\@inf\@/i) {return $mantissa}
    if($mantissa =~ /\-/ && $mantissa !~ /[^0,\-]/) {return '-0'}
    if($mantissa !~ /[^0,\-]/ ) {return '0'}

    my $sep = $_[1] <= 10 ? 'e' : '@';

    my $len = substr($mantissa, 0, 1) eq '-' ? 2 : 1;

    if(!$_[2]) {
      while(length($mantissa) > $len && substr($mantissa, -1, 1) eq '0') {
           substr($mantissa, -1, 1, '');
      }
    }

    $exponent--;

    if(length($mantissa) == $len) {
      if($exponent) {return $mantissa . $sep . $exponent}
      return $mantissa;
    }

    substr($mantissa, $len, 0, '.');
    if($exponent) {return $mantissa . $sep . $exponent}
    return $mantissa;
}

sub Rmpc_deref4 {
    my ($r_m, $r_e) = _get_r_string($_[0], $_[1], $_[2], $_[3]);
    my ($i_m, $i_e) = _get_i_string($_[0], $_[1], $_[2], $_[3]);
    return ($r_m, $r_e, $i_m, $i_e);
}


sub new {

    # This function caters for 2 possibilities:
    # 1) that 'new' has been called OOP style - in which 
    #    case there will be a maximum of 3 args
    # 2) that 'new' has been called as a function - in
    #    which case there will be a maximum of 2 args.
    # If there are no args, then we just want to return an
    # initialized Math::MPC object
    if(!@_) {return Rmpc_init()}
   
    if(@_ > 3) {die "Too many arguments supplied to new()"}

    # If 'new' has been called OOP style, the first arg is the string "Math::MPC"
    # which we don't need - so let's remove it. However, if the first
    # arg is a Math::MPFR or Math::MPC object (which is a possibility),
    # then we'll get a fatal error when we check it for equivalence to
    # the string "Math::MPC". So we first need to check that it's not
    # an object - which we'll do by using the ref() function:
    if(!ref($_[0]) && $_[0] eq "Math::MPC") {
      shift;
      if(!@_) {return Rmpc_init()}
      } 

    if(_itsa($_[0]) == 10) { # It's a Math::MPC object
      if(@_ > 1) {die "Too many arguments supplied to new() - expected no more than one"}
      my $mpc = Rmpc_init();
      Rmpc_set($mpc, $_[0], Rmpc_get_default_rounding_mode());
      return $mpc;
    } 

    # @_ can now contain a maximum of 2 args - the real and (optionally)
    # the imaginary components.
    if(@_ > 2) {die "Too many arguments supplied to new() - expected no more than two"}

    my ($arg1, $arg2, $type1, $type2);

    # $_[0] is the real component, $_[1] (if supplied)
    # is the imaginary component.
    $arg1 = shift;
    $type1 = _itsa($arg1);

    $arg2 = 0;
    if(@_) {$arg2 = shift}
    $type2 = _itsa($arg2);

    # Die if either of the args are unacceptable.
    if($type1 == 0 || $type1 == 6 || $type1 == 7 || $type1 == 8 || $type1 == 9)
      {die "First argument to new() is inappropriate"}
    if($type2 == 0 || $type2 == 6 || $type2 == 7 || $type2 == 8 || $type2 == 9)
      {die "Second argument to new() is inappropriate"}

    # Create a Math::MPC object that has $arg1 as its
    # real component, and zero as its imaginary component.
    my $mpc1 = _new_real($arg1);

    # Create a Math::MPC object that has $arg2 as its
    # imaginary component, and zero as its real component.
    my $mpc2 = _new_im($arg2);

    # Add the 2 created Math::MPC objects together and return
    # the result
    Rmpc_add($mpc1, $mpc1, $mpc2, Rmpc_get_default_rounding_mode());
    return $mpc1;    
}

sub Rmpc_out_str {
    if(@_ == 5) {
      die "Inappropriate 4th arg supplied to Rmpc_out_str" if _itsa($_[3]) != 10;
      return _Rmpc_out_str($_[0], $_[1], $_[2], $_[3], $_[4]);
    }
    if(@_ == 6) {
      if(_itsa($_[3]) == 10) {return _Rmpc_out_strS($_[0], $_[1], $_[2], $_[3], $_[4], $_[5])}
      die "Incorrect args supplied to Rmpc_out_str" if _itsa($_[4]) != 10;
      return _Rmpc_out_strP($_[0], $_[1], $_[2], $_[3], $_[4], $_[5]);
    }
    if(@_ == 7) {
      die "Inappropriate 5th arg supplied to Rmpc_out_str" if _itsa($_[4]) != 10;
      return _Rmpc_out_strPS($_[0], $_[1], $_[2], $_[3], $_[4], $_[5], $_[6]);
    }
    die "Wrong number of arguments supplied to Rmpc_out_str()";
}

sub MPC_VERSION {return _MPC_VERSION()}
sub MPC_VERSION_MAJOR {return _MPC_VERSION_MAJOR()}
sub MPC_VERSION_MINOR {return _MPC_VERSION_MINOR()}
sub MPC_VERSION_PATCHLEVEL {return _MPC_VERSION_PATCHLEVEL()}
sub MPC_VERSION_STRING {return _MPC_VERSION_STRING()}
sub MPC_VERSION_NUM {return _MPC_VERSION_NUM(@_)}

1;

__END__

=head1 NAME

Math::MPC - perl interface to the MPC (multi precision complex) library.

=head1 DEPENDENCIES

   This module needs the MPC, MPFR and GMP C libraries. (Install GMP
   first, followed by MPFR, followed by MPC.)

   The GMP library is availble from http://gmplib.org
   The MPFR library is available from http://www.mpfr.org/
   The MPC library is available from
    http://www.multiprecision.org/mpc/

=head1 DESCRIPTION

   A multiple precision complex number module utilising the MPC library.
   Basically, this module simply wraps the 'mpc' complex number functions
   provided by that library.
   Operator overloading is also available.
   The following documentation heavily plagiarises the mpc documentation.
   (Believe the mpc docs in preference to these docs if/when there's a 
   conflict.)
   See also the Math::MPC test suite for some examples of usage.

   use warnings;
   use Math::MPC qw(:mpc);
   Rmpc_set_default_prec(500); # Set default precision to 500 bits
   my $mpc1 = Math::MPC->new(12.5, 1125); # 12.5 + 1125*i
   $mpc2 = sqrt($mpc1);
   print "Square root of $mpc1 is $mpc2\n";


=head1 ROUNDING MODE

   A complex rounding mode is of the form MPC_RNDxy where "x" and "y"
   are one of "N" (to nearest), "Z" (towards zero), "U" (towards plus
   infinity), "D" (towards minus infinity). The first letter refers to
   the rounding mode for the real part, and the second one for the 
   imaginary part.
   For example MPC_RNDZU indicates to round the real part towards
   zero, and the imaginary part towards plus infinity.
   The default rounding mode is MPC_RNDNN, but this can be changed
   using the Rmpc_set_default_rounding_mode() function.

=head1 MEMORY MANAGEMENT

   Objects can be created with the Rmpc_init* functions, which
   return an object that has been blessed into the package Math::MPC.
   Alternatively, blessed objects can also be created by calling the
   new() function (either as a function or as a method). These
   objects will therefore be automatically cleaned up by the
   DESTROY() function whenever they go out of scope.

   For each Rmpc_init* function there is a corresponding function
   called Rmpc_init*_nobless which returns an unblessed object.
   If you create Math::MPC objects using the '_nobless' versions,
   it will then be up to you to clean up the memory associated with
   these objects by calling Rmpc_clear($op) for each object. 
   Alternatively such objects will be cleaned up when the script ends.
   I don't know why you would want to create unblessed objects. The 
   point is that you can if you want to.

=head1 MIXING MPC OBJECTS WITH MPFR OBJECTS

   Some of the Math::MPC functions below take Math::MPFR objects
   as arguments. (Such arguments have been designated "$mpfr" in the
   documentation that follows.) Obviously, to make use of these 
   functions, you'll need to load the Math::MPFR module. 

=head1 FUNCTIONS

   Most of the following functions are simply wrappers around an mpc
   function of the same name. eg. Rmpc_neg() is a wrapper around
   mpc_neg().

   "$rop", "$op1", "$op2", etc. are Math::MPC objects - the
   return value of one of the Rmpc_init* functions. They are in fact 
   references to mpc structures. The "$op" variables are the operands
   and "$rop" is the variable that stores the result of the operation.
   Generally, $rop, $op1, $op2, etc. can be the same perl variable 
   referencing the same mpc structure, though often they will be 
   distinct perl variables referencing distinct mpc structures.
   Eg something like Rmpc_add($r1, $r1, $r1, $rnd),
   where $r1 *is* the same reference to the same mpc structure,
   would add $r1 to itself and store the result in $r1. Alternatively,
   you could (courtesy of operator overloading) simply code it
   as $r1 += $r1. Otoh, Rmpc_add($r1, $r2, $r3, $rnd), where each of the
   arguments is a different reference to a different mpc structure
   would add $r2 to $r3 and store the result in $r1. Alternatively
   it could be coded as $r1 = $r2 + $r3.

   "$ui" means an integer that will fit into a C 'unsigned long int',

   "$si" means an integer that will fit into a C 'signed long int'.

   "$uj" means an integer that will fit into a C 'uintmax_t'. Don't
   use any of these functions unless your perl was compiled with 64
   bit integer support.

   "$sj" means an integer that will fit into a C 'intmax_t'. Don't
   use any of these functions unless your perl was compiled with 64
   bit integer support.

   "$double" is a C double.

   "$ld" is a C long double. Don't use these functions unless your
   perl was compiled with long double support.

   "$bool" means a value (usually a 'signed long int') in which
   the only interest is whether it evaluates as false or true.

   "$str" simply means a string of symbols that represent a number,
   eg '1234567890987654321234567@7' which might be a base 10 number,
   or 'zsa34760sdfgq123r5@11' which would have to represent a base 36
   number (because "z" is a valid digit only in base 36). Valid
   bases for MPC numbers are 2 to 36 (inclusive).

   "$rnd" is simply one of the 16 rounding mode values (discussed above).

   "$p" is the (unsigned long) value for precision.

   "$mpfr" is a Math::MPFR object (floating point).

   ######################

   FUNCTION RETURN VALUES

    Most MPC functions have a return value ($si) which is used to 
    indicate the position of the rounded real or imaginary parts with 
    respect to the exact (infinite precision) values. The functions 
    RMPC_INEX_RE($si) and RMPC_INEX_IM($si) return 0 if the corresponding
    rounded value is exact, a negative value if the rounded value is less
    than the exact one, and a positive value if it is greater than the
    exact one. However, some functions do not completely fulfill this -
    in some cases the sign is not guaranteed, and in some cases a
    non-zero value is returned although the result is exact. In these
    cases the function documentation explains the exact meaning of the
    return value. However, the return value never wrongly indicates an
    exact computation.

   ###########################

   MANIPULATING ROUNDING MODES

   Rmpc_set_default_rounding_mode($rnd);
    Sets the default rounding mode to $rnd.
    The default rounding mode is to nearest initially (MPC_RNDNN).
    The default rounding mode is the rounding mode that is used in
    overloaded operations.

   $ui = Rmpc_get_default_rounding_mode();
    Returns the numeric value of the current default rounding mode.
    This will initially be 0 (MPC_RNDNN).

   ##########

   INITIALIZATION

   Normally, a variable should be initialized once only or at least
   be cleared, using `Rmpc_clear', between initializations - but
   don't explicitly call Rmpc_clear() on blessed objects. 'DESTROY'
  (which calls 'Rmpc_clear') is automatically called on blessed 
   objects whenever they go out of scope.

   First read the section 'MEMORY MANAGEMENT' (above).

   Rmpc_set_default_prec($p);
    Set the default precision to be *exactly* $p bits.  The
    precision of a variable means the number of bits used to store its
    mantissa.  All subsequent calls to `mpc_init' will use this
    precision, but previously initialized variables are unaffected.
    This default precision is set to 53 bits initially.
    It sets the precision of both real and imaginary parts alike.

   $ui = Rmpc_get_default_prec();
    Returns the current default MPC precision in bits.

   $ui = Rmpc_get_prec($op);
    If the real and imaginary part of $op have the same precision,
    it is returned. Otherwise 0 is returned.

   $ui = Rmpc_get_re_prec($op);
   $ui = Rmpc_get_im_prec($op)
   ($re_prec, $im_prec) = Rmpc_get_prec2($op);
    Get (respectively) the precision of the real part of $op, the
    precision of the imaginary part of $op, or an array containing
    both real and imaginary parts of $op.

   $rop = Math::MPC->new();
   $rop = Math::MPC::new();
   $rop = new Math::MPC();
   $rop = Rmpc_init();
   $rop = Rmpc_init_nobless();
    Initialize $rop, and set its real and imaginary parts to NaN.
    The precision of $rop is the default precision, which can be
    changed by a call to `Rmpc_set_default_prec'.

   $rop = Rmpc_init2($p);
   $rop = Rmpc_init2_nobless($p);
    Initialize $rop, set its precision to be *exactly* $p bits, 
    and set its real and imaginary parts to NaN.

   $rop = Rmpc_init3($p_r, $p_i);
   $rop = Rmpc_init3_nobless($p_r, $p_i);
    Initialize $rop, set the precision of the real part to be 
    *exactly* $p_r bits, set the precision of the imaginary part to
    be *exactly* $p_i bits, and set its real and imaginary parts to
    NaN.

   Rmpc_set_prec($op, $p);
    Reset the precision of $op to be exactly $p bits, and set its
    real/imaginary parts to NaN.

   Rmpc_set_re_prec($op, $p);
   Rmpc_set_im_prec($op, $p);
    Set (respectively) the precision of the real part of $op to be
    exactly $p bits and the precision of the imaginary part of $op
    to be exactly $p bits. In both cases the value is set to NaN.
    (There are currently no corresponding MPC library functions.)

   ##########

   ASSIGNMENT

   $si = Rmpc_set($rop, $op, $rnd);
   $si = Rmpc_set_ui($rop, $ui, $rnd);
   $si2 = Rmpc_set_si($rop, $si1, $rnd);
   $si = Rmpc_set_d($rop, $double, $rnd);
    Set the value of $rop from 2nd arg, rounded to the precision of
    $rop towards the given direction $rnd.

   $si = Rmpc_set_ui_ui($rop, $ui1, $ui2, $rnd);
   $si3 = Rmpc_set_si_si($rop, $si1, $si2, $rnd);
   $si = Rmpc_set_d_d($rop, $double1, $double2, $rnd);
   $si = Rmpc_set_ui_fr($rop, $ui, $mpfr, $rnd);
    Set the real part of $rop from 2nd arg, and the imaginary part
    of $rop from 3rd arg, according to the rounding mode $rnd.

   void Rmpc_set_uj_uj($rop, $uj1, $uj2, $rnd);
   void Rmpc_set_sj_sj($rop, $sj1, $sj2, $rnd);
   void Rmpc_set_ld_ld($rop, $ld1, $ld2, $rnd);
    Don't use the first 2 functions unless Math::MPC::_has_longlong()
    returns a true value. Don't use the 3rd function unless
    Math::MPC::_has_longdouble() returns true.
    These functions are provided for convenience - there are no 
    mpc library equivalents. Assign to $rop, using (respectively)
    unsigned long long, signed long long, and long double values,
    rounded according to $rnd.

   void Rmpc_set_fr_fr($rop, $mpfr1, $mpfr2, $rnd);
    This function is provided for convenience - there are no 
    mpc library equivalents. Assign to $rop, using the values of 
    the two Math::MPFR objects ($mpfr1 and $mpfr2), rounded 
    according to $rnd.

   ################################################

   COMBINED INITIALIZATION AND ASSIGNMENT

   NOTE: Do NOT use these functions if $rop has already been initialised
   or created by calling new(). Instead use the Rmpc_set* functions in
   the section 'ASSIGNMENT' (above).

   First read the section 'MEMORY MANAGEMENT' (above).

   $rop = Math::MPC->new($arg1 [, $arg2]);
   $rop = Math::MPC::new($arg1 [, $arg2]);
   $rop = new Math::MPC($arg1, [, $arg2]);
    Returns a Math::MPC object whose real component has a value of $arg1,
    rounded in the default rounding direction, with default precision. 
    If $arg2 is supplied, the imaginary component of the returned
    Math::MPC object is set to $arg2, rounded in the default rounding
    direction, with default precision. Otherwise the imaginary component
    of the returned Math::MPC object is set to zero. $arg1 & $arg2 can be
    either a number (signed integer, unsigned integer, signed fraction or
    unsigned fraction), a string that represents a numeric value, or a
    Math::MPFR object. If a string argument begins with "0b" or "0B",
    then the string is treated as a base 2 string. Elsif it begins with
    "0x" or "0X" it is treated as a base 16 string. Else it is treated
    as a base 10 string.

   ($rop, $si) = Rmpc_init_set($op, $rnd);
   ($rop, $si) = Rmpc_init_set_nobless($op, $rnd);
   ($rop, $si) = Rmpc_init_set_ui($ui, $rnd);
   ($rop, $si) = Rmpc_init_set_ui_nobless($ui, $rnd);
    Initialize $rop and set its value from the 1st arg, rounded to
    direction $rnd. The precision of $rop will be taken from the
    active default precision, as set by `Rmpc_set_default_prec'.

   ($rop, $si) = Rmpc_init_set_ui_ui($ui1, $ui2, $rnd);
   ($rop, $si) = Rmpc_init_set_ui_ui_nobless($ui1, $ui2, $rnd);
   ($rop, $si) = Rmpc_init_set_si_si($si1, $si2, $rnd);
   ($rop, $si) = Rmpc_init_set_si_si_nobless($si1, $si2, $rnd);
   ($rop, $si) = Rmpc_init_set_ui_fr($ui, $mpfr, $rnd);
   ($rop, $si) = Rmpc_init_set_ui_fr_nobless($ui, $mpfr, $rnd);
    Initialize $rop, set the value of the real part from the 1st arg 
    and the value of the imaginary part from the 2nd arg (both values
    rounded to direction $rnd). The precision of $rop will be taken
    from the active default precision, as set by `Rmpc_set_default_prec'.

   ##########

   ARITHMETIC

   $si = Rmpc_add($rop, $op1, $op2, $rnd);
   $si = Rmpc_add_ui($rop, $op, $ui, $rnd);
   $si = Rmpc_add_fr($rop, $op, $mpfr, $rnd);
    Set $rop to 2nd arg + 3rd arg rounded in the direction $rnd.


   $si = Rmpc_sub($rop, $op1, $op2, $rnd);
   $si = Rmpc_sub_ui($rop, $op, $ui, $rnd);
   $si = Rmpc_ui_sub($rop, $ui, $op, $rnd);
    Set $rop to 2nd arg - 3rd arg rounded in the direction $rnd.

   $si = Rmpc_ui_ui_sub($rop, $ui_r, $ui_i, $op, $rnd);
    The real part of $rop is set to $ui_r minus the real part of $op
    (rounded in the direction $rnd) - and the imaginary part of $rop
    is set to $ui_r minus the imaginary part of $op (rounded in the
    direction $rnd)


   $si = Rmpc_mul($rop, $op1, $op2, $rnd);
   $si = Rmpc_mul_ui($rop, $op, $ui, $rnd);
   $si = Rmpc_mul_si($rop, $op, $si1, $rnd);
   $si = Rmpc_mul_fr($rop, $op, $mpfr, $rnd);
    Set $rop to 2nd arg * 3rd arg rounded in the direction $rnd.

   $si = Rmpc_mul_i($rop, $op, $si1, $rnd);
    If $si1 >= 0 (non-negative), set $rop to $op times the 
    imaginary unit i - else set $rop to $op times -i.


   $si = Rmpc_div($rop, $op1, $op2, $rnd);
   $si = Rmpc_div_ui($rop, $op, $ui, $rnd);
   $si = Rmpc_ui_div($rop, $ui, $op, $rnd);
   $si = Rmpc_div_fr($rop, $op, $mpfr, $rnd);
    Set $rop to 2nd arg / 3rd arg rounded in the direction $rnd. 

   $si = Rmpc_sqr($rop, $op, $rnd);
    Set $rop to the square of $op, rounded in direction $rnd.

   $si = Rmpc_sqrt($rop, $op, $rnd);
    Set $rop to the square root of the 2nd arg rounded in the
    direction $rnd. When the return value is 0, it means the result
    is exact. Else it's unknown whether the result is exact or not.

   $si = Rmpc_neg($rop, $op, $rnd);
    Set $rop to -$op rounded in the direction $rnd. Just
    changes the sign if $rop and $op are the same variable.

   $si = Rmpc_conj($rop, $op, $rnd);
    Set $rop to the conjugate of $op rounded in the direction $rnd.
    Just changes the sign of the imaginary part if $rop and $op are
    the same variable.

   $si = Rmpc_abs($mpfr, $op, $rnd);
    Set the floating-point number $mpfr to the absolute value of $op,
    rounded in the direction $rnd. Return 0 iff the result is exact.

   $si = Rmpc_norm($mpfr, $op, $rnd);
    Set the floating-point number $mpfr to the norm of $op (ie the
    square of its absolute value), rounded in the direction $rnd.
    Return 0 iff the result is exact.

   $si = Rmpc_mul_2exp($rop, $op, $ui, $rnd);
    Set $rop to $op times 2 raised to $ui rounded according to $rnd.
    Just increases the exponents of the real and imaginary parts by
    $ui when $rop and $op are identical.

   $si = Rmpc_div_2exp($rop, $op, $ui, $rnd);
    Set $rop to $op divided by 2 raised to $ui rounded according to
    $rnd. Just decreases the exponents of the real and imaginary 
    parts by $ui when $rop and $op are identical.

   ##########

   COMPARISON

   $si = Rmpc_cmp($op1, $op2);
   $si = Rmpc_cmp_si($op, $si1);
    Compare 1st and 2nd args. The return value $si can be decomposed
    into $x = RMPC_INEX_RE($si) and $y = RMPC_INEX_IM($si), such that $x
    is positive if the real part of the 1st arg is greater than that of
    the 2nd arg, zero if both real parts are equal, and negative if the
    real part of the 1st arg is less than that of the 2nd arg.
    Likewise for $y.
    Both 1st and 2nd args are considered to their full own precision,
    which may differ. 
    It is not allowed that one of the operands has a NaN (Not-a-Number)
    part.
    The storage of the return value is such that equality can be simply
    checked with Rmpc_cmp($first_arg, $second_arg) == 0.

   $si = Rmpc_cmp_si_si($op, $si1, $si2);
    As for the above comparison functions - except that $op is being
    compared with $si1 + ($si2 * i).

   #######

   SPECIAL

   Rmpc_exp($rop, $op, $rnd);
    Set $rop to the exponential of $op, rounded according to $rnd
    with the precision of $rop.

   Rmpc_log($rop, $op, $rnd);
    Set $rop to the log of $op, rounded according to $rnd with the
    precision of $rop.

   $si = Rmpc_arg ($mpfr, $op, $rnd);
     Set $mpfr to the argument of $op, with a branch cut along the
     negative real axis. ($mpfr is a Math::MPFR object.)

   $si = Rmpc_proj ($rop, $op, $rnd);
     Compute a projection of $op onto the Riemann sphere. Set $rop 
     to $op, rounded in the direction $rnd, except when at least one 
     part of $op is infinite (even if the other part is a NaN) in 
     which case the real part of $rop is set to plus infinity and its
     imaginary part to a signed zero with the same sign as the 
     imaginary part of $op.

   ##########

   TRIGONOMETRIC

   Rmpc_sin($rop, $op, $rnd);
    Set $rop to the sine of $op, rounded according to $rnd with the
    precision of $rop.

   Rmpc_cos($rop, $op, $rnd);
    Set $rop to the cosine of $op, rounded according to $rnd with
    the precision of $rop.

   Rmpc_tan($rop, $op, $rnd);
    Set $rop to the tangent of $op, rounded according to $rnd with
    the precision of $rop.

   Rmpc_sinh($rop, $op, $rnd);
    Set $rop to the hyperbolic sine of $op, rounded according to 
    $rnd with the precision of $rop.

   Rmpc_cosh($rop, $op, $rnd);
    Set $rop to the hyperbolic cosine of $op, rounded according to 
    $rnd with the precision of $rop.

   Rmpc_tanh($rop, $op, $rnd);
    Set $rop to the hyperbolic tangent of $op, rounded according to
    $rnd with the precision of $rop.

   ##########

   CONVERSION

   ($real, $im) = c_string($op, $base, $digits, $rnd);
   $real = r_string($op, $base, $digits, $rnd);
   $im = i_string($op, $base, $digits, $rnd);
    $real is a string containing the value of the real part of $op.
    $im is a string containing the value of the imaginary part of $op.
    $real and $im will be of the form XeY (X@Y for bases greater than 10)
    - where X is the mantissa (in base $base) and Y is the exponent (in 
    base 10). 
    For example, -31.4132' would be returned as -3.14132e1. $digits is the
    number of digits that will be written in the mantissa. If $digits is 
    zero, the mantissa will contain the maximum number of digits
    accurately representable. The mantissa will be rounded in the 
    direction specified by $rnd.

   @vals = Rmpc_deref4($op, $base, $digits, $rnd);
    @vals contains (in order) the real mantissa, the real exponent, the
    imaginary mantissa, and the imaginary exponent of $op.The mantissas,
    expressed in base $base and rounded according to $rnd), contain an 
    implicit radix point to the left of the first (ie leftmost) digit.
    The exponents are always expressed in base 10. $digits is the number
    of digits that will be written in the mantissa. If $digits is zero
    the mantissa will contain the maximum number of digits accurately
    representable.    

   RMPC_RE($mpfr, $op, $rnd);
   RMPC_IM($mpfr, $op, $rnd);
    Set $mpfr to the value of the real (respectively imaginary) component
    of $op. $mpfr will be an exact copy of the real/imaginary component 
    of op - ie the precision of $mpfr will be set to the precision of the
    real/imaginary component of $op before the copy is made. 

   $si = Rmpc_real($mpfr, $op, $rnd);
   $si = Rmpc_imag($mpfr, $op, $rnd);
     Set $mpfr to the value of the real (respectively imaginary) part of
     $op, rounded in the direction $rnd. ($mpfr is a Math::MPFR object.)

   #############

   I-O FUNCTIONS

   $ul = Rmpc_inp_str($rop, $stream, $base, $rnd);
    Input a string in base $base from $stream, rounded according to $rnd, 
    and put the read complex in $rop. Each of the real and imaginary 
    parts should be of the form X@Ym or, if the base is 10 or less, 
    alternatively XeY or XEY. (X is the mantissa, Y is the exponent.
    The mantissa is always in the specified base. The exponent is always
    read in decimal. This function first reads the real part, followed by
    the imaginary part. The argument $base may be in the range 2 to 36.
    Return the number of bytes read, or if an error occurred, return 0.

   $ul = Rmpc_out_str([$prefix,] $stream, $base, $digits, $op, $rnd [, $suffix]);
    This function changed from 1st release (version 0.45) of Math::MPC. 
    Output $op to $stream, in base $base, rounded according to $rnd. First
    the real part is printed, followed by the imaginary part. The base may
    vary from 2 to 36.  Print at most $digits significant digits for each
    part, or if $digits is 0, the maximum number of digits accurately 
    representable by $op. In addition to the significant digits, a decimal
    point at the right of the first digit and a trailing exponent, in the
    form eYYY , are printed.  (If $base is greater than 10, "@" will be
    used as exponent delimiter.) $prefix and $suffix are optional
    arguments containing a string that will be prepended/appended to the
    output of $op. Return the number of bytes written. (The contents of 
    $prefix and $suffix are not included in the count.)


   #############

   RANDOM NUMBERS

   Rmpc_random($rop);
    Assign a random complex to $rop, with real and imaginary parts
    uniformly distributed in the interval -1 < X < 1.

   Rmpc_random2($rop, $si, $ui);
    Assign a random complex to $rop, with real and imaginary part
    of at most $si limbs, with long strings of zeros and ones in the
    binary representation. The exponent of the real (resp. imaginary)
    part is in the interval -$ui to +$ui. (I find that the exponent can
    be equal to -$ui, but is always less than +$ui - not sure if that's
    a bug in the MPC library.)
    This function is useful for testing functions and algorithms, since
    this kind of random numbers have proven to be more likely to trigger
    corner-case bugs.  
    Negative (mantissa) parts are generated when $si is negative.

   ####################

   OPERATOR OVERLOADING

    Overloading works with numbers, strings (bases 2, 10, and 16
    only - see step '4.' below) and Math::MPC objects.
    Overloaded operations are performed using the current
    "default rounding mode" (which you can determine using the
    'Rmpc_get_default_rounding_mode' function, and change using
    the 'Rmpc_set_default_rounding_mode' function).

    Be aware that when you use overloading with a string operand,
    the overload subroutine converts that string operand to a
    Math::MPC object with *current default precision*, and using
    the *current default rounding mode*.

    The following operators are overloaded:
     + - * / sqrt (Return object has default precision)
     += -= *= /= (Precision remains unchanged)
     == != 
     ! not
     abs (Returns an MPFR object, blessed into package Math::MPFR)
     exp log (Return object has default precision)
     sin cos (Return object has default precision)
     = ""

    Attempting to use the overloaded operators with objects that
    have been blessed into some package other than 'Math::MPC'
    will not work. The workaround is to convert this "foreign" 
    object to a Math::MPC object - thus allowing it to work with
    the overloaded operator.

    In those situations where the overload subroutine operates on 2
    perl variables, then obviously one of those perl variables is
    a Math::MPC object. To determine the value of the other variable
    the subroutine works through the following steps (in order),
    using the first value it finds, or croaking if it gets
    to step 6:

    1. If the variable is an unsigned long then that value is used.
       The variable is considered to be an unsigned long if 
       (perl 5.8) the UOK flag is set or if (perl 5.6) SvIsUV() 
       returns true.(In the case of perls built with -Duse64bitint,
       the variable is treated as an unsigned long long int if the
       UOK flag is set.)

    2. If the variable is a signed long int, then that value is used.
       The variable is considered to be a signed long int if the
       IOK flag is set. (In the case of perls built with
       -Duse64bitint, the variable is treated as a signed long long
       int if the IOK flag is set.)

    3. If the variable is a double, then that value is used. The
       variable is considered to be a double if the NOK flag is set.
       (In the case of perls built with -Duselongdouble, the variable
       is treated as a long double if the NOK flag is set.)

    4. If the variable is a string (ie the POK flag is set) then the
       value of that string is used. If the POK flag is set, but the
       string is not a valid number, the subroutine croaks with an 
       appropriate error message. If the string starts with '0b' or
       '0B' it is regarded as a base 2 number. If it starts with '0x'
       or '0X' it is regarded as a base 16 number. Otherwise it is
       regarded as a base 10 number.

    5. If the variable is a Math::MPC object then the value of that
       object is used.

    6. If none of the above is true, then the second variable is
       deemed to be of an invalid type. The subroutine croaks with
       an appropriate error message.

   #####################

   MISCELLANEOUS

   $ui = MPC_VERSION_MAJOR;
    Returns the 'x' in the 'x.y.z' of the MPC library version.

   $ui =MPC_VERSION_MINOR;
    Returns the 'y' in the 'x.y.z' of the MPC library version.

   $ui = MPC_VERSION_PATCHLEVEL;
    Returns the 'z' in the 'x.y.z' of the MPC library version.

   $ui = MPC_VERSION();
    An integer value derived from the library's major, minor and
    patchlevel values.

   $ui = MPC_VERSION_NUM($major, $minor, $patchlevel);
    Returns an integer in the same format as used by MPC_VERSION,
    using the given $major, $minor and $patchlevel.

   $string = MPC_VERSION_STRING;
    $string contains the MPC library version ('x.y.z'), as defined
    by the header file (mpc.h)

   $string = Rmpc_get_version();
    $string contains the MPC library version ('x.y.z'), as defined
    by the library.

   ####################

=head1 TODO

    For completeness, we probably should wrap mpc_realref and
    mpc_imagref - though I don't think there's much to be
    achieved by doing this in a *perl* context. 

=head1 BUGS

    You can get segfaults if you pass the wrong type of
    argument to the functions - so if you get a segfault, the
    first thing to do is to check that the argument types 
    you have supplied are appropriate.

=head1 LICENSE

    This program is free software; you may redistribute it and/or 
    modify it under the same terms as Perl itself.
    Copyright 2006-2008, Sisyphus

=head1 AUTHOR

    Sisyphus <sisyphus at(@) cpan dot (.) org>

=cut