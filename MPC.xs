#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include <stdio.h>

#ifndef _MSC_VER
#include <inttypes.h>
#include <limits.h>
#ifdef _DO_COMPLEX_H
#include <complex.h>
#endif
#endif

#include <gmp.h>
#include <mpfr.h>
#include <mpc.h>

#ifndef _MPC_H_HAVE_COMPLEX
#undef _DO_COMPLEX_H
#endif

#ifdef _MSC_VER
#pragma warning(disable:4700 4715 4716)
#define intmax_t __int64
#endif

#ifdef OLDPERL
#define SvUOK SvIsUV
#endif

#ifndef Newx
#  define Newx(v,n,t) New(0,v,n,t)
#endif

#ifndef Newxz
#  define Newxz(v,n,t) Newz(0,v,n,t)
#endif

#if MPC_VERSION_MAJOR > 0 || MPC_VERSION_MINOR > 8
#define SIN_COS_AVAILABLE 1
#endif

#define MPC_RE(x) ((x)->re)
#define MPC_IM(x) ((x)->im)

#define VOID_MPC_SET_X_Y(real_t, imag_t, z, real_value, imag_value, rnd)     \
   {                                                                     \
     int _inex_re, _inex_im;                                             \
     _inex_re = (mpfr_set_ ## real_t) (MPC_RE (z), (real_value), MPC_RND_RE (rnd)); \
     _inex_im = (mpfr_set_ ## imag_t) (MPC_IM (z), (imag_value), MPC_RND_IM (rnd)); \
   }

#define MY_CXT_KEY "Math::MPC::_guts" XS_VERSION

typedef struct {
  mp_prec_t _perl_default_prec_re;
  mp_prec_t _perl_default_prec_im;
  mpc_rnd_t _perl_default_rounding_mode;
} my_cxt_t;

START_MY_CXT

#define DEFAULT_PREC MY_CXT._perl_default_prec_re,MY_CXT._perl_default_prec_im
#define DEFAULT_PREC_RE MY_CXT._perl_default_prec_re
#define DEFAULT_PREC_IM MY_CXT._perl_default_prec_im
#define DEFAULT_ROUNDING_MODE MY_CXT._perl_default_rounding_mode

/* These (CXT) values set at boot ... MPC_RNDNN == 0 */
/*
mpc_rnd_t _perl_default_rounding_mode = MPC_RNDNN;
mp_prec_t _perl_default_prec_re = 53;
mp_prec_t _perl_default_prec_im = 53;
*/



/* This function is used by overload_mul and overload_mul_eq whenn           */
/* USE_64_BIT_INT is defined.                                                */
/* It is based on some code posted by Philippe Theveny.                      */

int _mpc_mul_sj (mpc_ptr rop, mpc_ptr op, intmax_t i, mpc_rnd_t rnd) {

#ifdef USE_64_BIT_INT

   mpfr_t x;
   int inex;

   mpfr_init2 (x, sizeof(intmax_t) * CHAR_BIT);
   mpfr_set_sj (x, i, GMP_RNDN);

   inex = mpc_mul_fr (rop, op, x, rnd);

   mpfr_clear (x);
   return inex;
}

#else

   croak("_mpc_mul_sj not implememnted on this build of perl");
}

#endif


/* This function is used by overload_mul and overload_mul_eq whenn           */
/* USE_LONG_DOUBLE is defined.                                               */
/* It is based on some code posted by Philippe Theveny.                      */

int _mpc_mul_ld (mpc_ptr rop, mpc_ptr op, long double i, mpc_rnd_t rnd) {

#ifdef USE_LONG_DOUBLE

   mpfr_t x;
   int inex;

   mpfr_init2 (x, sizeof(long double) * CHAR_BIT);
   mpfr_set_ld (x, i, GMP_RNDN);

   inex = mpc_mul_fr (rop, op, x, rnd);

   mpfr_clear (x);
   return inex;
}

#else

   croak("_mpc_mul_ld not implememnted on this build of perl");
}

#endif


/* This function is used by overload_mul and overload_mul_eq.                */
/* It is based on some code posted by Philippe Theveny.                      */

int _mpc_mul_d (mpc_ptr rop, mpc_ptr op, double i, mpc_rnd_t rnd) {
   mpfr_t x;
   int inex;

   mpfr_init2 (x, sizeof(double) * CHAR_BIT);
   mpfr_set_d (x, i, GMP_RNDN);

   inex = mpc_mul_fr (rop, op, x, rnd);

   mpfr_clear (x);
   return inex;
}


/* This function is used by overload_div and overload_div_eq whenn           */
/* USE_64_BIT_INT is defined.                                                */
/* It is based on some code posted by Philippe Theveny.                      */

int _mpc_div_sj (mpc_ptr rop, mpc_ptr op, intmax_t i, mpc_rnd_t rnd) {

#ifdef USE_64_BIT_INT

   mpfr_t x;
   int inex;

   mpfr_init2 (x, sizeof(intmax_t) * CHAR_BIT);
   mpfr_set_sj (x, i, GMP_RNDN);

   inex = mpc_div_fr (rop, op, x, rnd);

   mpfr_clear (x);
   return inex;
}

#else

   croak("_mpc_div_sj not implememnted on this build of perl");
}

#endif


/* This function is used by overload_div and overload_div_eq whenn           */
/* USE_64_BIT_INT is defined.                                                */
/* It is based on some code posted by Philippe Theveny.                      */

int _mpc_sj_div (mpc_ptr rop, intmax_t i, mpc_ptr op, mpc_rnd_t rnd) {

#ifdef USE_64_BIT_INT

   mpfr_t x;
   int inex;

   mpfr_init2 (x, sizeof(intmax_t) * CHAR_BIT);
   mpfr_set_sj (x, i, GMP_RNDN);

   inex = mpc_fr_div (rop, x, op, rnd);

   mpfr_clear (x);
   return inex;
}

#else

   croak("_mpc_sj_div not implememnted on this build of perl");
}

#endif


/* This function is used by overload_div and overload_div_eq whenn           */
/* USE_LONG_DOUBLE is defined.                                               */
/* It is based on some code posted by Philippe Theveny.                      */

int _mpc_div_ld (mpc_ptr rop, mpc_ptr op, long double i, mpc_rnd_t rnd) {

#ifdef USE_LONG_DOUBLE

   mpfr_t x;
   int inex;

   mpfr_init2 (x, sizeof(long double) * CHAR_BIT);
   mpfr_set_ld (x, i, GMP_RNDN);

   inex = mpc_div_fr (rop, op, x, rnd);

   mpfr_clear (x);
   return inex;
}

#else

   croak("_mpc_div_ld not implememnted on this build of perl");
}

#endif


/* This function is used by overload_div and overload_div_eq whenn           */
/* USE_LONG_DOUBLE is defined.                                               */
/* It is based on some code posted by Philippe Theveny.                      */

int _mpc_ld_div (mpc_ptr rop, long double i, mpc_ptr op, mpc_rnd_t rnd) {

#ifdef USE_LONG_DOUBLE

   mpfr_t x;
   int inex;

   mpfr_init2 (x, sizeof(long double) * CHAR_BIT);
   mpfr_set_ld (x, i, GMP_RNDN);

   inex = mpc_fr_div (rop, x, op, rnd);

   mpfr_clear (x);
   return inex;
}

#else

   croak("_mpc_ld_div not implememnted on this build of perl");
}

#endif

/* This function is used by overload_div and overload_div_eq.                */
/* It is based on some code posted by Philippe Theveny.                      */
int _mpc_div_d (mpc_ptr rop, mpc_ptr op, double i, mpc_rnd_t rnd) {
   mpfr_t x;
   int inex;

   mpfr_init2 (x, sizeof(double) * CHAR_BIT);
   mpfr_set_d (x, i, GMP_RNDN);

   inex = mpc_div_fr (rop, op, x, rnd);

   mpfr_clear (x);
   return inex;
}


/* This function is used by overload_div and overload_div_eq.                */
/* It is based on some code posted by Philippe Theveny.                      */
int _mpc_d_div (mpc_ptr rop, double i, mpc_ptr op, mpc_rnd_t rnd) {
   mpfr_t x;
   int inex;

   mpfr_init2 (x, sizeof(double) * CHAR_BIT);
   mpfr_set_d (x, i, GMP_RNDN);

   inex = mpc_fr_div (rop, x, op, rnd);

   mpfr_clear (x);
   return inex;
}

void Rmpc_set_default_rounding_mode(SV * round) {
     dMY_CXT;
     DEFAULT_ROUNDING_MODE = (mpc_rnd_t)SvUV(round);    
}

SV * Rmpc_get_default_rounding_mode() {
     dMY_CXT;
     return newSVuv(DEFAULT_ROUNDING_MODE);
}

void Rmpc_set_default_prec(SV * prec) {
     dMY_CXT;
     DEFAULT_PREC_RE = (mp_prec_t)SvUV(prec);
     DEFAULT_PREC_IM = (mp_prec_t)SvUV(prec);
} 

void Rmpc_set_default_prec2(SV * prec_re, SV * prec_im) {
     dMY_CXT;
     DEFAULT_PREC_RE = (mp_prec_t)SvUV(prec_re);
     DEFAULT_PREC_IM = (mp_prec_t)SvUV(prec_im);
} 

SV * Rmpc_get_default_prec() {
     dMY_CXT;
     if(DEFAULT_PREC_RE == DEFAULT_PREC_IM)
       return newSVuv(DEFAULT_PREC_RE);
     return newSVuv(0);
}

void Rmpc_get_default_prec2() {
     dXSARGS;
     dMY_CXT;
     EXTEND(SP, 2);
     ST(0) = sv_2mortal(newSVuv(DEFAULT_PREC_RE));
     ST(1) = sv_2mortal(newSVuv(DEFAULT_PREC_IM));
     XSRETURN(2);
}

void Rmpc_set_prec(mpc_t * p, SV * prec) {
     mpc_set_prec(*p, SvUV(prec));
}

void Rmpc_set_re_prec(mpc_t * p, SV * prec) {
     mpfr_set_prec(MPC_RE(*p), SvUV(prec));
}

void Rmpc_set_im_prec(mpc_t * p, SV * prec) {
     mpfr_set_prec(MPC_IM(*p), SvUV(prec));
}

SV * Rmpc_get_prec(mpc_t * x) {
     return newSVuv(mpc_get_prec(*x));
}

void Rmpc_get_prec2(mpc_t * x) {
     dXSARGS;
     mp_prec_t re, im;
     mpc_get_prec2(&re, &im, *x);
     /* sp = mark; *//* not needed */
     EXTEND(SP, 2);
     ST(0) = sv_2mortal(newSVuv(re));
     ST(1) = sv_2mortal(newSVuv(im));
     /* PUTBACK; *//* not needed */
     XSRETURN(2);
}

SV * Rmpc_get_im_prec(mpc_t * x) {
     return newSVuv(mpfr_get_prec(MPC_IM(*x)));
}

SV * Rmpc_get_re_prec(mpc_t * x) {
     return newSVuv(mpfr_get_prec(MPC_RE(*x)));
}

void RMPC_RE(mpfr_t * fr, mpc_t * x) {
     mp_prec_t precision = mpfr_get_prec(MPC_RE(*x));
     mpfr_set_prec(*fr, precision);
     mpfr_set(*fr, MPC_RE(*x), GMP_RNDN); /* No rounding will be done, anyway */
}

void RMPC_IM(mpfr_t * fr, mpc_t * x) {
     mp_prec_t precision = mpfr_get_prec(MPC_IM(*x));
     mpfr_set_prec(*fr, precision);
     mpfr_set(*fr, MPC_IM(*x), GMP_RNDN); /* No rounding will be done, anyway */
}

SV * RMPC_INEX_RE(SV * x) {
     return newSViv(MPC_INEX_RE(SvIV(x)));
}

SV * RMPC_INEX_IM(SV * x) {
     return newSViv(MPC_INEX_IM(SvIV(x)));
}

void DESTROY(mpc_t * p) {
     mpc_clear(*p);
     Safefree(p);
}

void Rmpc_clear(mpc_t * p) {
     mpc_clear(*p);
     Safefree(p);
}

void Rmpc_clear_mpc(mpc_t * p) {
     mpc_clear(*p);
}

void Rmpc_clear_ptr(mpc_t * p) {
     Safefree(p);
}

SV * Rmpc_init2(SV * prec) {
     mpc_t * mpc_t_obj;
     SV * obj_ref, * obj;

     New(1, mpc_t_obj, 1, mpc_t);
     if(mpc_t_obj == NULL) croak("Failed to allocate memory in Rmpc_init2 function");
     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, "Math::MPC");
     mpc_init2 (*mpc_t_obj, SvUV(prec));

     sv_setiv(obj, INT2PTR(IV,mpc_t_obj));
     SvREADONLY_on(obj);
     return obj_ref;
}

SV * Rmpc_init3(SV * prec_r, SV * prec_i) {
     mpc_t * mpc_t_obj;
     SV * obj_ref, * obj;

     New(1, mpc_t_obj, 1, mpc_t);
     if(mpc_t_obj == NULL) croak("Failed to allocate memory in Rmpc_init3 function");
     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, "Math::MPC");
     mpc_init3 (*mpc_t_obj, SvUV(prec_r), SvUV(prec_i));

     sv_setiv(obj, INT2PTR(IV,mpc_t_obj));
     SvREADONLY_on(obj);
     return obj_ref;
}

SV * Rmpc_init2_nobless(SV * prec) {
     mpc_t * mpc_t_obj;
     SV * obj_ref, * obj;

     New(1, mpc_t_obj, 1, mpc_t);
     if(mpc_t_obj == NULL) croak("Failed to allocate memory in Rmpc_init2_nobless function");
     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, NULL);
     mpc_init2 (*mpc_t_obj, SvUV(prec));

     sv_setiv(obj, INT2PTR(IV,mpc_t_obj));
     SvREADONLY_on(obj);
     return obj_ref;
}

SV * Rmpc_init3_nobless(SV * prec_r, SV * prec_i) {
     mpc_t * mpc_t_obj;
     SV * obj_ref, * obj;

     New(1, mpc_t_obj, 1, mpc_t);
     if(mpc_t_obj == NULL) croak("Failed to allocate memory in Rmpc_init3_nobless function");
     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, NULL);
     mpc_init3 (*mpc_t_obj, SvUV(prec_r), SvUV(prec_i));

     sv_setiv(obj, INT2PTR(IV,mpc_t_obj));
     SvREADONLY_on(obj);
     return obj_ref;
}

SV * Rmpc_set(mpc_t * p, mpc_t * q, SV * round) {
     return newSViv(mpc_set(*p, *q, (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_set_ui(mpc_t * p, SV * q, SV * round) {
     return newSViv(mpc_set_ui(*p, SvUV(q), (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_set_si(mpc_t * p, SV * q, SV * round) {
     return newSViv(mpc_set_si(*p, SvIV(q), (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_set_ld(mpc_t * p, SV * q, SV * round) {
#ifdef USE_LONG_DOUBLE
     return newSViv(mpc_set_ld(*p, SvNV(q), (mpc_rnd_t)SvUV(round)));
#else
     croak("Rmpc_set_ld not implemented for this build of perl");
#endif
}

SV * Rmpc_set_uj(mpc_t * p, SV * q, SV * round) {
#ifdef USE_64_BIT_INT
     return newSViv(mpc_set_uj(*p, SvUV(q), (mpc_rnd_t)SvUV(round)));
#else
     croak("Rmpc_set_uj not implemented for this build of perl");
#endif
}

SV * Rmpc_set_sj(mpc_t * p, SV * q, SV * round) {
#ifdef USE_64_BIT_INT
     return newSViv(mpc_set_sj(*p, SvIV(q), (mpc_rnd_t)SvUV(round)));
#else
     croak("Rmpc_set_sj not implemented for this build of perl");
#endif
}

SV * Rmpc_set_z(mpc_t * p, mpz_t * q, SV * round) {
     return newSViv(mpc_set_z(*p, *q, (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_set_f(mpc_t * p, mpf_t * q, SV * round) {
     return newSViv(mpc_set_f(*p, *q, (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_set_q(mpc_t * p, mpq_t * q, SV * round) {
     return newSViv(mpc_set_q(*p, *q, (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_set_d(mpc_t * p, SV * q, SV * round) {
     return newSViv(mpc_set_d(*p, SvNV(q), (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_set_fr(mpc_t * p, mpfr_t * q, SV * round) {
     return newSViv(mpc_set_fr(*p, *q, (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_set_ui_ui(mpc_t * p, SV * q_r, SV * q_i, SV * round) {
     return newSViv(mpc_set_ui_ui(*p, SvUV(q_r), SvUV(q_i), (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_set_si_si(mpc_t * p, SV * q_r, SV * q_i, SV * round) {
     return newSViv(mpc_set_si_si(*p, SvIV(q_r), SvIV(q_i), (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_set_d_d(mpc_t * p, SV * q_r, SV * q_i, SV * round) {
     return newSViv(mpc_set_d_d(*p, SvNV(q_r), SvNV(q_i), (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_set_ld_ld(mpc_t * mpc, SV * ld1, SV * ld2, SV * round) {
#ifdef USE_LONG_DOUBLE
     return newSViv(mpc_set_ld_ld(*mpc, SvNV(ld1), SvNV(ld2), (mpc_rnd_t) SvUV(round)));
#else
     croak("Rmpc_set_ld_ld not implemented for this build of perl");
#endif
}

SV * Rmpc_set_z_z(mpc_t * p, mpz_t * q_r, mpz_t * q_i, SV * round) {
     return newSViv(mpc_set_z_z(*p, *q_r, *q_i, (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_set_q_q(mpc_t * p, mpq_t * q_r, mpq_t * q_i, SV * round) {
     return newSViv(mpc_set_q_q(*p, *q_r, *q_i, (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_set_f_f(mpc_t * p, mpf_t * q_r, mpf_t * q_i, SV * round) {
     return newSViv(mpc_set_f_f(*p, *q_r, *q_i, (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_set_fr_fr(mpc_t * p, mpfr_t * q_r, mpfr_t * q_i, SV * round) {
     return newSViv(mpc_set_fr_fr(*p, *q_r, *q_i, (mpc_rnd_t)SvUV(round)));
}

int Rmpc_set_d_ui(mpc_t * mpc, SV * d, SV * ui, SV * round) {
     MPC_SET_X_Y(d, ui, *mpc, (double)SvNV(d), (unsigned long)SvUV(ui), (mpc_rnd_t) SvUV(round));
}

int Rmpc_set_d_si(mpc_t * mpc, SV * d, SV * si, SV * round) {
     MPC_SET_X_Y(d, si, *mpc, (double)SvNV(d), (signed long int)SvIV(si), (mpc_rnd_t) SvUV(round));
}

int Rmpc_set_d_fr(mpc_t * mpc, SV * d, mpfr_t * mpfr, SV * round) {
     MPC_SET_X_Y(d, fr, *mpc, (double)SvNV(d), *mpfr, (mpc_rnd_t) SvUV(round));
}

int Rmpc_set_ui_d(mpc_t * mpc, SV * ui, SV * d, SV * round) {
     MPC_SET_X_Y(ui, d, *mpc, (unsigned long)SvUV(ui), (double)SvNV(d), (mpc_rnd_t) SvUV(round));
}

int Rmpc_set_ui_si(mpc_t * mpc, SV * ui, SV * si, SV * round) {
     MPC_SET_X_Y(ui, si, *mpc, (unsigned long)SvUV(ui), (signed long int)SvIV(si), (mpc_rnd_t) SvUV(round));
}

int Rmpc_set_ui_fr(mpc_t * mpc, SV * ui, mpfr_t * mpfr, SV * round) {
     MPC_SET_X_Y(ui, fr, *mpc, (unsigned long)SvUV(ui), *mpfr, (mpc_rnd_t) SvUV(round));
}

int Rmpc_set_si_d(mpc_t * mpc, SV * si, SV * d, SV * round) {
     MPC_SET_X_Y(si, d, *mpc, (signed long int)SvIV(si), (double)SvNV(d), (mpc_rnd_t) SvUV(round));
}

int Rmpc_set_si_ui(mpc_t * mpc, SV * si, SV * ui, SV * round) {
     MPC_SET_X_Y(si, ui, *mpc, (signed long int)SvIV(si), (unsigned long)SvUV(ui), (mpc_rnd_t) SvUV(round));
}

int Rmpc_set_si_fr(mpc_t * mpc, SV * si, mpfr_t * mpfr, SV * round) {
     MPC_SET_X_Y(si, fr, *mpc, (signed long int)SvIV(si), *mpfr, (mpc_rnd_t) SvUV(round));
}

int Rmpc_set_fr_d(mpc_t * mpc, mpfr_t * mpfr, SV * d, SV * round) {
     MPC_SET_X_Y(fr, d, *mpc, *mpfr, (double)SvNV(d), (mpc_rnd_t) SvUV(round));
}

int Rmpc_set_fr_ui(mpc_t * mpc, mpfr_t * mpfr, SV * ui, SV * round) {
     MPC_SET_X_Y(fr, ui, *mpc, *mpfr, (unsigned long)SvUV(ui), (mpc_rnd_t) SvUV(round));
}

int Rmpc_set_fr_si(mpc_t * mpc, mpfr_t * mpfr, SV * si, SV * round) {
     MPC_SET_X_Y(fr, si, *mpc, *mpfr , (signed long int)SvIV(si), (mpc_rnd_t) SvUV(round));
}

int Rmpc_set_ld_ui(mpc_t * mpc, SV * d, SV * ui, SV * round) {
#ifdef USE_LONG_DOUBLE
     MPC_SET_X_Y(ld, ui, *mpc, SvNV(d), (unsigned long)SvUV(ui), (mpc_rnd_t) SvUV(round));
#else
     croak("Rmpc_set_ld_ui not implemented for this build of perl");
#endif
}

int Rmpc_set_ld_si(mpc_t * mpc, SV * d, SV * si, SV * round) {
#ifdef USE_LONG_DOUBLE
     MPC_SET_X_Y(ld, si, *mpc, SvNV(d), (signed long int)SvIV(si), (mpc_rnd_t) SvUV(round));
#else
     croak("Rmpc_set_ld_si not implemented for this build of perl");
#endif
}

int Rmpc_set_ld_fr(mpc_t * mpc, SV * d, mpfr_t * mpfr, SV * round) {
#ifdef USE_LONG_DOUBLE
     MPC_SET_X_Y(ld, fr, *mpc, SvNV(d), *mpfr, (mpc_rnd_t) SvUV(round));
#else
     croak("Rmpc_set_ld_fr not implemented for this build of perl");
#endif
}

int Rmpc_set_ui_ld(mpc_t * mpc, SV * ui, SV * d, SV * round) {
#ifdef USE_LONG_DOUBLE
     MPC_SET_X_Y(ui, ld, *mpc, (unsigned long)SvUV(ui), SvNV(d), (mpc_rnd_t) SvUV(round));
#else
     croak("Rmpc_set_ui_ld not implemented for this build of perl");
#endif
}

int Rmpc_set_si_ld(mpc_t * mpc, SV * si, SV * d, SV * round) {
#ifdef USE_LONG_DOUBLE
     MPC_SET_X_Y(si, ld, *mpc, (signed long int)SvIV(si), SvNV(d), (mpc_rnd_t) SvUV(round));
#else
     croak("Rmpc_set_si_ld not implemented for this build of perl");
#endif
}

int Rmpc_set_fr_ld(mpc_t * mpc, mpfr_t * mpfr, SV * d, SV * round) {
#ifdef USE_LONG_DOUBLE
     MPC_SET_X_Y(fr, ld, *mpc, *mpfr, SvNV(d), (mpc_rnd_t) SvUV(round));
#else
     croak("Rmpc_set_fr_ld not implemented for this build of perl");
#endif
}

int Rmpc_set_d_uj(mpc_t * mpc, SV * d, SV * ui, SV * round) {
#ifdef USE_64_BIT_INT
     MPC_SET_X_Y(d, uj, *mpc, (double)SvNV(d), SvUV(ui), (mpc_rnd_t) SvUV(round));
#else
     croak("Rmpc_set_d_uj not implemented for this build of perl");
#endif
}

int Rmpc_set_d_sj(mpc_t * mpc, SV * d, SV * si, SV * round) {
#ifdef USE_64_BIT_INT
     MPC_SET_X_Y(d, sj, *mpc, (double)SvNV(d), SvIV(si), (mpc_rnd_t) SvUV(round));
#else
     croak("Rmpc_set_d_sj not implemented for this build of perl");
#endif
}

int Rmpc_set_sj_d(mpc_t * mpc, SV * si, SV * d, SV * round) {
#ifdef USE_64_BIT_INT
     MPC_SET_X_Y(sj, d, *mpc, SvIV(si), (double)SvNV(d), (mpc_rnd_t) SvUV(round));
#else
     croak("Rmpc_set_sj_d not implemented for this build of perl");
#endif
}

int Rmpc_set_uj_d(mpc_t * mpc, SV * ui, SV * d, SV * round) {
#ifdef USE_64_BIT_INT
     MPC_SET_X_Y(uj, d, *mpc, SvUV(ui), (double)SvNV(d), (mpc_rnd_t) SvUV(round));
#else
     croak("Rmpc_set_uj_d not implemented for this build of perl");
#endif
}

int Rmpc_set_uj_fr(mpc_t * mpc, SV * ui, mpfr_t * mpfr, SV * round) {
#ifdef USE_64_BIT_INT
     MPC_SET_X_Y(uj, fr, *mpc, SvUV(ui), *mpfr, (mpc_rnd_t) SvUV(round));
#else
     croak("Rmpc_set_uj_fr not implemented for this build of perl");
#endif
}

int Rmpc_set_sj_fr(mpc_t * mpc, SV * si, mpfr_t * mpfr, SV * round) {
#ifdef USE_64_BIT_INT
     MPC_SET_X_Y(sj, fr, *mpc, SvIV(si), *mpfr, (mpc_rnd_t) SvUV(round));
#else
     croak("Rmpc_set_sj_fr not implemented for this build of perl");
#endif
}

int Rmpc_set_fr_uj(mpc_t * mpc, mpfr_t * mpfr, SV * ui, SV * round) {
#ifdef USE_64_BIT_INT
     MPC_SET_X_Y(fr, uj, *mpc, *mpfr, SvUV(ui), (mpc_rnd_t) SvUV(round));
#else
     croak("Rmpc_set_fr_uj not implemented for this build of perl");
#endif
}

int Rmpc_set_fr_sj(mpc_t * mpc, mpfr_t * mpfr, SV * si, SV * round) {
#ifdef USE_64_BIT_INT
     MPC_SET_X_Y(fr, sj, *mpc, *mpfr , SvIV(si), (mpc_rnd_t) SvUV(round));
#else
     croak("Rmpc_set_fr_sj not implemented for this build of perl");
#endif
}

int Rmpc_set_uj_sj(mpc_t * mpc, SV * ui, SV * si, SV * round) {
#ifdef USE_64_BIT_INT
     MPC_SET_X_Y(uj, sj, *mpc, SvUV(ui), SvIV(si), (mpc_rnd_t) SvUV(round));
#else
     croak("Rmpc_set_uj_si, Rmpc_set_ui_sj and Rmpc_set_uj_sj not implemented for this build of perl");
#endif
}

int Rmpc_set_sj_uj(mpc_t * mpc, SV * si, SV * ui, SV * round) {
#ifdef USE_64_BIT_INT
     MPC_SET_X_Y(sj, uj, *mpc, SvIV(si), SvUV(ui), (mpc_rnd_t) SvUV(round));
#else
     croak("Rmpc_set_sj_ui, Rmpc_set_si_uj and Rmpc_set_sj_uj not implemented for this build of perl");
#endif
}


int Rmpc_set_ld_uj(mpc_t * mpc, SV * d, SV * ui, SV * round) {
#ifdef USE_64_BIT_INT
#ifdef USE_LONG_DOUBLE
     MPC_SET_X_Y(ld, uj, *mpc, SvNV(d), SvUV(ui), (mpc_rnd_t) SvUV(round));
#else
     croak("Rmpc_set_ld_uj not implemented for this build of perl");
#endif
#else
     croak("Rmpc_set_ld_uj not implemented for this build of perl");
#endif
}

int Rmpc_set_ld_sj(mpc_t * mpc, SV * d, SV * si, SV * round) {
#ifdef USE_64_BIT_INT
#ifdef USE_LONG_DOUBLE
     MPC_SET_X_Y(ld, sj, *mpc, SvNV(d), SvIV(si), (mpc_rnd_t) SvUV(round));
#else
     croak("Rmpc_set_ld_sj not implemented for this build of perl");
#endif
#else
     croak("Rmpc_set_ld_sj not implemented for this build of perl");
#endif
}

int Rmpc_set_uj_ld(mpc_t * mpc, SV * ui, SV * d, SV * round) {
#ifdef USE_64_BIT_INT
#ifdef USE_LONG_DOUBLE
     MPC_SET_X_Y(uj, ld, *mpc, SvUV(ui), SvNV(d), (mpc_rnd_t) SvUV(round));
#else
     croak("Rmpc_set_uj_ld not implemented for this build of perl");
#endif
#else
     croak("Rmpc_set_uj_ld not implemented for this build of perl");
#endif
}

int Rmpc_set_sj_ld(mpc_t * mpc, SV * si, SV * d, SV * round) {
#ifdef USE_64_BIT_INT
#ifdef USE_LONG_DOUBLE
     MPC_SET_X_Y(sj, ld, *mpc, SvIV(si), SvNV(d), (mpc_rnd_t) SvUV(round));
#else
     croak("Rmpc_set_sj_ld not implemented for this build of perl");
#endif
#else
     croak("Rmpc_set_sj_ld not implemented for this build of perl");
#endif
}

int Rmpc_set_f_ui(mpc_t * mpc, mpf_t * mpf, SV * ui, SV * round) {
     MPC_SET_X_Y(f, ui, *mpc, *mpf, (unsigned long int)SvUV(ui), (mpc_rnd_t) SvUV(round));
}

int Rmpc_set_q_ui(mpc_t * mpc, mpq_t * mpq, SV * ui, SV * round) {
     MPC_SET_X_Y(q, ui, *mpc, *mpq, (unsigned long int)SvUV(ui), (mpc_rnd_t) SvUV(round));
}

int Rmpc_set_z_ui(mpc_t * mpc, mpz_t * mpz, SV * ui, SV * round) {
     MPC_SET_X_Y(z, ui, *mpc, *mpz, (unsigned long int)SvUV(ui), (mpc_rnd_t) SvUV(round));
}

int Rmpc_set_f_si(mpc_t * mpc, mpf_t * mpf, SV * si, SV * round) {
     MPC_SET_X_Y(f, si, *mpc, *mpf, (signed long int)SvIV(si), (mpc_rnd_t) SvUV(round));
}

int Rmpc_set_q_si(mpc_t * mpc, mpq_t * mpq, SV * si, SV * round) {
     MPC_SET_X_Y(q, si, *mpc, *mpq, (signed long int)SvIV(si), (mpc_rnd_t) SvUV(round));
}

int Rmpc_set_z_si(mpc_t * mpc, mpz_t * mpz, SV * si, SV * round) {
     MPC_SET_X_Y(z, si, *mpc, *mpz, (signed long int)SvIV(si), (mpc_rnd_t) SvUV(round));
}

int Rmpc_set_f_d(mpc_t * mpc, mpf_t * mpf, SV * d, SV * round) {
     MPC_SET_X_Y(f, d, *mpc, *mpf, (double)SvNV(d), (mpc_rnd_t) SvUV(round));
}

int Rmpc_set_q_d(mpc_t * mpc, mpq_t * mpq, SV * d, SV * round) {
     MPC_SET_X_Y(q, d, *mpc, *mpq, (double)SvNV(d), (mpc_rnd_t) SvUV(round));
}

int Rmpc_set_z_d(mpc_t * mpc, mpz_t * mpz, SV * d, SV * round) {
     MPC_SET_X_Y(z, d, *mpc, *mpz, (double)SvNV(d), (mpc_rnd_t) SvUV(round));
}

int Rmpc_set_f_uj(mpc_t * mpc, mpf_t * mpf, SV * uj, SV * round) {
#ifdef USE_64_BIT_INT
     MPC_SET_X_Y(f, uj, *mpc, *mpf, (unsigned long long)SvUV(uj), (mpc_rnd_t) SvUV(round));
#else
     croak("Rmpc_set_f_uj not implemented for this build of perl");
#endif
}

int Rmpc_set_q_uj(mpc_t * mpc, mpq_t * mpq, SV * uj, SV * round) {
#ifdef USE_64_BIT_INT
     MPC_SET_X_Y(q, uj, *mpc, *mpq, (unsigned long long)SvUV(uj), (mpc_rnd_t) SvUV(round));
#else
     croak("Rmpc_set_q_uj not implemented for this build of perl");
#endif
}

int Rmpc_set_z_uj(mpc_t * mpc, mpz_t * mpz, SV * uj, SV * round) {
#ifdef USE_64_BIT_INT
     MPC_SET_X_Y(z, uj, *mpc, *mpz, (unsigned long long)SvUV(uj), (mpc_rnd_t) SvUV(round));
#else
     croak("Rmpc_set_z_uj not implemented for this build of perl");
#endif
}

int Rmpc_set_f_sj(mpc_t * mpc, mpf_t * mpf, SV * sj, SV * round) {
#ifdef USE_64_BIT_INT
     MPC_SET_X_Y(f, sj, *mpc, *mpf, (signed long long)SvIV(sj), (mpc_rnd_t) SvUV(round));
#else
     croak("Rmpc_set_f_sj not implemented for this build of perl");
#endif
}

int Rmpc_set_q_sj(mpc_t * mpc, mpq_t * mpq, SV * sj, SV * round) {
#ifdef USE_64_BIT_INT
     MPC_SET_X_Y(q, sj, *mpc, *mpq, (signed long long)SvIV(sj), (mpc_rnd_t) SvUV(round));
#else
     croak("Rmpc_set_q_sj not implemented for this build of perl");
#endif
}

int Rmpc_set_z_sj(mpc_t * mpc, mpz_t * mpz, SV * sj, SV * round) {
#ifdef USE_64_BIT_INT
     MPC_SET_X_Y(z, sj, *mpc, *mpz, (signed long long)SvIV(sj), (mpc_rnd_t) SvUV(round));
#else
     croak("Rmpc_set_z_sj not implemented for this build of perl");
#endif
}

int Rmpc_set_f_ld(mpc_t * mpc, mpf_t * mpf, SV * ld, SV * round) {
#ifdef USE_LONG_DOUBLE
     MPC_SET_X_Y(f, ld, *mpc, *mpf, (long double)SvNV(ld), (mpc_rnd_t) SvUV(round));
#else
     croak("Rmpc_set_f_ld not implemented for this build of perl");
#endif
}

int Rmpc_set_q_ld(mpc_t * mpc, mpq_t * mpq, SV * ld, SV * round) {
#ifdef USE_LONG_DOUBLE
     MPC_SET_X_Y(q, ld, *mpc, *mpq, (long double)SvNV(ld), (mpc_rnd_t) SvUV(round));
#else
     croak("Rmpc_set_q_ld not implemented for this build of perl");
#endif
}

int Rmpc_set_z_ld(mpc_t * mpc, mpz_t * mpz, SV * ld, SV * round) {
#ifdef USE_LONG_DOUBLE
     MPC_SET_X_Y(z, ld, *mpc, *mpz, (long double)SvNV(ld), (mpc_rnd_t) SvUV(round));
#else
     croak("Rmpc_set_z_ld not implemented for this build of perl");
#endif
}

/*
##############################
##############################
*/

int Rmpc_set_ui_f(mpc_t * mpc, SV * ui, mpf_t * mpf, SV * round) {
     MPC_SET_X_Y(ui, f, *mpc, (unsigned long int)SvUV(ui), *mpf, (mpc_rnd_t) SvUV(round));
}

int Rmpc_set_ui_q(mpc_t * mpc, SV * ui, mpq_t * mpq, SV * round) {
     MPC_SET_X_Y(ui, q, *mpc, (unsigned long int)SvUV(ui), *mpq, (mpc_rnd_t) SvUV(round));
}

int Rmpc_set_ui_z(mpc_t * mpc, SV * ui, mpz_t * mpz, SV * round) {
     MPC_SET_X_Y(ui, z, *mpc, (unsigned long int)SvUV(ui), *mpz, (mpc_rnd_t) SvUV(round));
}

int Rmpc_set_si_f(mpc_t * mpc, SV * si, mpf_t * mpf, SV * round) {
     MPC_SET_X_Y(si, f, *mpc, (signed long int)SvIV(si), *mpf, (mpc_rnd_t) SvUV(round));
}

int Rmpc_set_si_q(mpc_t * mpc, SV * si, mpq_t * mpq, SV * round) {
     MPC_SET_X_Y(si, q, *mpc, (signed long int)SvIV(si), *mpq, (mpc_rnd_t) SvUV(round));
}

int Rmpc_set_si_z(mpc_t * mpc, SV * si, mpz_t * mpz, SV * round) {
     MPC_SET_X_Y(si, z, *mpc, (signed long int)SvIV(si), *mpz, (mpc_rnd_t) SvUV(round));
}

int Rmpc_set_d_f(mpc_t * mpc, SV * d, mpf_t * mpf, SV * round) {
     MPC_SET_X_Y(d, f, *mpc, (double)SvNV(d), *mpf, (mpc_rnd_t) SvUV(round));
}

int Rmpc_set_d_q(mpc_t * mpc, SV * d, mpq_t * mpq, SV * round) {
     MPC_SET_X_Y(d, q, *mpc, (double)SvNV(d), *mpq, (mpc_rnd_t) SvUV(round));
}

int Rmpc_set_d_z(mpc_t * mpc, SV * d, mpz_t * mpz, SV * round) {
     MPC_SET_X_Y(d, z, *mpc, (double)SvNV(d), *mpz, (mpc_rnd_t) SvUV(round));
}

int Rmpc_set_uj_f(mpc_t * mpc, SV * uj, mpf_t * mpf, SV * round) {
#ifdef USE_64_BIT_INT
     MPC_SET_X_Y(uj, f, *mpc, (unsigned long long)SvUV(uj), *mpf, (mpc_rnd_t) SvUV(round));
#else
     croak("Rmpc_set_uj_f not implemented for this build of perl");
#endif
}

int Rmpc_set_uj_q(mpc_t * mpc, SV * uj, mpq_t * mpq, SV * round) {
#ifdef USE_64_BIT_INT
     MPC_SET_X_Y(uj, q, *mpc, (unsigned long long)SvUV(uj), *mpq, (mpc_rnd_t) SvUV(round));
#else
     croak("Rmpc_set_uj_q not implemented for this build of perl");
#endif
}

int Rmpc_set_uj_z(mpc_t * mpc, SV * uj, mpz_t * mpz, SV * round) {
#ifdef USE_64_BIT_INT
     MPC_SET_X_Y(uj, z, *mpc, (unsigned long long)SvUV(uj), *mpz, (mpc_rnd_t) SvUV(round));
#else
     croak("Rmpc_set_uj_z not implemented for this build of perl");
#endif
}

int Rmpc_set_sj_f(mpc_t * mpc, SV * sj, mpf_t * mpf, SV * round) {
#ifdef USE_64_BIT_INT
     MPC_SET_X_Y(sj, f, *mpc, (signed long long)SvIV(sj), *mpf, (mpc_rnd_t) SvUV(round));
#else
     croak("Rmpc_set_sj_f not implemented for this build of perl");
#endif
}

int Rmpc_set_sj_q(mpc_t * mpc, SV * sj, mpq_t * mpq, SV * round) {
#ifdef USE_64_BIT_INT
     MPC_SET_X_Y(sj, q, *mpc, (signed long long)SvIV(sj), *mpq, (mpc_rnd_t) SvUV(round));
#else
     croak("Rmpc_set_sj_q not implemented for this build of perl");
#endif
}

int Rmpc_set_sj_z(mpc_t * mpc, SV * sj, mpz_t * mpz, SV * round) {
#ifdef USE_64_BIT_INT
     MPC_SET_X_Y(sj, z, *mpc, (signed long long)SvIV(sj), *mpz, (mpc_rnd_t) SvUV(round));
#else
     croak("Rmpc_set_sj_z not implemented for this build of perl");
#endif
}

int Rmpc_set_ld_f(mpc_t * mpc, SV * ld, mpf_t * mpf, SV * round) {
#ifdef USE_LONG_DOUBLE
     MPC_SET_X_Y(ld, f, *mpc, (long double)SvNV(ld), *mpf, (mpc_rnd_t) SvUV(round));
#else
     croak("Rmpc_set_ld_f not implemented for this build of perl");
#endif
}

int Rmpc_set_ld_q(mpc_t * mpc, SV * ld, mpq_t * mpq, SV * round) {
#ifdef USE_LONG_DOUBLE
     MPC_SET_X_Y(ld, q, *mpc, (long double)SvNV(ld), *mpq, (mpc_rnd_t) SvUV(round));
#else
     croak("Rmpc_set_ld_q not implemented for this build of perl");
#endif
}

int Rmpc_set_ld_z(mpc_t * mpc, SV * ld, mpz_t * mpz, SV * round) {
#ifdef USE_LONG_DOUBLE
     MPC_SET_X_Y(ld, z, *mpc, (long double)SvNV(ld), *mpz, (mpc_rnd_t) SvUV(round));
#else
     croak("Rmpc_set_ld_z not implemented for this build of perl");
#endif
}

/*
##############################
##############################
*/

int Rmpc_set_f_q(mpc_t * mpc, mpf_t * mpf, mpq_t * mpq, SV * round) {
     MPC_SET_X_Y(f, q, *mpc, *mpf, *mpq, (mpc_rnd_t) SvUV(round));
}

int Rmpc_set_q_f(mpc_t * mpc, mpq_t * mpq, mpf_t * mpf, SV * round) {
     MPC_SET_X_Y(q, f, *mpc, *mpq, *mpf, (mpc_rnd_t) SvUV(round));
}

int Rmpc_set_f_z(mpc_t * mpc, mpf_t * mpf, mpz_t * mpz, SV * round) {
     MPC_SET_X_Y(f, z, *mpc, *mpf, *mpz, (mpc_rnd_t) SvUV(round));
}

int Rmpc_set_z_f(mpc_t * mpc, mpz_t * mpz, mpf_t * mpf, SV * round) {
     MPC_SET_X_Y(z, f, *mpc, *mpz, *mpf, (mpc_rnd_t) SvUV(round));
}

int Rmpc_set_q_z(mpc_t * mpc, mpq_t * mpq, mpz_t * mpz, SV * round) {
     MPC_SET_X_Y(q, z, *mpc, *mpq, *mpz, (mpc_rnd_t) SvUV(round));
}

int Rmpc_set_z_q(mpc_t * mpc, mpz_t * mpz, mpq_t * mpq, SV * round) {
     MPC_SET_X_Y(z, q, *mpc, *mpz, *mpq, (mpc_rnd_t) SvUV(round));
}

int Rmpc_set_f_fr(mpc_t * mpc, mpf_t * mpf, mpfr_t * mpfr, SV * round) {
     MPC_SET_X_Y(f, fr, *mpc, *mpf, *mpfr, (mpc_rnd_t) SvUV(round));
}

int Rmpc_set_fr_f(mpc_t * mpc, mpfr_t * mpfr, mpf_t * mpf, SV * round) {
     MPC_SET_X_Y(fr, f, *mpc, *mpfr, *mpf, (mpc_rnd_t) SvUV(round));
}

int Rmpc_set_q_fr(mpc_t * mpc, mpq_t * mpq, mpfr_t * mpfr, SV * round) {
     MPC_SET_X_Y(q, fr, *mpc, *mpq, *mpfr, (mpc_rnd_t) SvUV(round));
}

int Rmpc_set_fr_q(mpc_t * mpc, mpfr_t * mpfr, mpq_t * mpq, SV * round) {
     MPC_SET_X_Y(fr, q, *mpc, *mpfr, *mpq, (mpc_rnd_t) SvUV(round));
}

int Rmpc_set_z_fr(mpc_t * mpc, mpz_t * mpz, mpfr_t * mpfr, SV * round) {
     MPC_SET_X_Y(z, fr, *mpc, *mpz, *mpfr, (mpc_rnd_t) SvUV(round));
}

int Rmpc_set_fr_z(mpc_t * mpc, mpfr_t * mpfr, mpz_t * mpz, SV * round) {
     MPC_SET_X_Y(fr, z, *mpc, *mpfr, *mpz, (mpc_rnd_t) SvUV(round));
}


/*
##############################
##############################
*/

SV * Rmpc_set_uj_uj(mpc_t * mpc, SV * uj1, SV * uj2, SV * round) {
#ifdef USE_64_BIT_INT
     return newSViv(mpc_set_uj_uj(*mpc, (unsigned long long)SvUV(uj1), 
                    (unsigned long long)SvUV(uj2), (mpc_rnd_t)SvUV(round)));
#else
     croak("Rmpc_set_ui_uj, Rmpc_set_uj_ui and Rmpc_set_uj_uj not implemented for this build of perl");
#endif
}

SV * Rmpc_set_sj_sj(mpc_t * mpc, SV * sj1, SV * sj2, SV * round) {
#ifdef USE_64_BIT_INT
     return newSViv(mpc_set_sj_sj(*mpc, (signed long long)SvIV(sj1), 
                    (signed long long)SvIV(sj2), (mpc_rnd_t)SvUV(round)));
#else
     croak("Rmpc_set_si_sj, Rmpc_set_sj_si and Rmpc_set_sj_sj not implemented for this build of perl");
#endif
}

SV * Rmpc_add(mpc_t * a, mpc_t * b, mpc_t * c, SV * round) {
     return newSViv(mpc_add(*a, *b, *c, (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_add_ui(mpc_t * a, mpc_t * b, SV * c, SV * round){
     return newSViv(mpc_add_ui(*a, *b, SvUV(c), (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_add_fr(mpc_t * a, mpc_t * b, mpfr_t * c, SV * round){
     return newSViv(mpc_add_fr(*a, *b, *c, (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_sub(mpc_t * a, mpc_t * b, mpc_t * c, SV * round) {
     return newSViv(mpc_sub(*a, *b, *c, (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_sub_ui(mpc_t * a, mpc_t * b, SV * c, SV * round) {
     return newSViv(mpc_sub_ui(*a, *b, SvUV(c), (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_ui_sub(mpc_t * a, SV * b, mpc_t * c, SV * round) {
     return newSViv(mpc_ui_sub(*a, SvUV(b), *c, (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_ui_ui_sub(mpc_t * a, SV * b_r, SV * b_i, mpc_t * c, SV * round) {
     return newSViv(mpc_ui_ui_sub(*a, SvUV(b_r), SvUV(b_i), *c, (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_mul(mpc_t * a, mpc_t * b, mpc_t * c, SV * round) {
     return newSViv(mpc_mul(*a, *b, *c, (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_mul_ui(mpc_t * a, mpc_t * b, SV * c, SV * round){
     return newSViv(mpc_mul_ui(*a, *b, SvUV(c), (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_mul_si(mpc_t * a, mpc_t * b, SV * c, SV * round){
     return newSViv(mpc_mul_si(*a, *b, SvIV(c), (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_mul_fr(mpc_t * a, mpc_t * b, mpfr_t * c, SV * round){
     return newSViv(mpc_mul_fr(*a, *b, *c, (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_mul_i(mpc_t * a, mpc_t * b, SV * sign, SV * round){
     return newSViv(mpc_mul_i(*a, *b, SvIV(sign), (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_sqr(mpc_t * a, mpc_t * b, SV * round) {
     return newSViv(mpc_sqr(*a, *b, (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_div(mpc_t * a, mpc_t * b, mpc_t * c, SV * round) {
     return newSViv(mpc_div(*a, *b, *c, (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_div_ui(mpc_t * a, mpc_t * b, SV * c, SV * round){
     return newSViv(mpc_div_ui(*a, *b, SvUV(c), (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_ui_div(mpc_t * a, SV * b, mpc_t * c, SV * round) {
     return newSViv(mpc_ui_div(*a, SvUV(b), *c, (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_div_fr(mpc_t * a, mpc_t * b, mpfr_t * c, SV * round){
     return newSViv(mpc_div_fr(*a, *b, *c, (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_sqrt(mpc_t * a, mpc_t * b, SV * round) {
     return newSViv(mpc_sqrt(*a, *b, (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_pow(mpc_t * a, mpc_t * b, mpc_t * pow, SV * round) {
     return newSViv(mpc_pow(*a, *b, *pow, (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_pow_d(mpc_t * a, mpc_t * b, SV * pow, SV * round) {
     return newSViv(mpc_pow_d(*a, *b, SvNV(pow), (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_pow_ld(mpc_t * a, mpc_t * b, SV * pow, SV * round) {
#ifdef USE_LONG_DOUBLE
     return newSViv(mpc_pow_ld(*a, *b, SvNV(pow), (mpc_rnd_t)SvUV(round)));
#else
     croak("Rmpc_pow_ld not implemented on this build of perl");
#endif
}

SV * Rmpc_pow_si(mpc_t * a, mpc_t * b, SV * pow, SV * round) {
     return newSViv(mpc_pow_si(*a, *b, SvIV(pow), (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_pow_ui(mpc_t * a, mpc_t * b, SV * pow, SV * round) {
     return newSViv(mpc_pow_ui(*a, *b, SvUV(pow), (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_pow_z(mpc_t * a, mpc_t * b, mpz_t * pow, SV * round) {
     return newSViv(mpc_pow_z(*a, *b, *pow, (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_pow_fr(mpc_t * a, mpc_t * b, mpfr_t * pow, SV * round) {
     return newSViv(mpc_pow_fr(*a, *b, *pow, (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_neg(mpc_t * a, mpc_t * b, SV * round) {
     return newSViv(mpc_neg(*a, *b, (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_abs(mpfr_t * a, mpc_t * b, SV * round) {
     return newSViv(mpc_abs(*a, *b, (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_conj(mpc_t * a, mpc_t * b, SV * round) {
     return newSViv(mpc_conj(*a, *b, (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_norm(mpfr_t * a, mpc_t * b, SV * round) {
     return newSViv(mpc_norm(*a, *b, (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_mul_2exp(mpc_t * a, mpc_t * b, SV * c, SV * round) {
     return newSViv(mpc_mul_2exp(*a, *b, SvUV(c), (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_div_2exp(mpc_t * a, mpc_t * b, SV * c, SV * round) {
     return newSViv(mpc_div_2exp(*a, *b, SvUV(c), (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_cmp(mpc_t * a, mpc_t * b) {
     return newSViv(mpc_cmp(*a, *b));
}

SV * Rmpc_cmp_si(mpc_t * a, SV * b) {
     return newSViv(mpc_cmp_si(*a, SvIV(b)));
}

SV * Rmpc_cmp_si_si(mpc_t * a, SV * b, SV * c) {
     return newSViv(mpc_cmp_si_si(*a, SvIV(b), SvIV(c)));
}

SV * Rmpc_exp(mpc_t * a, mpc_t * b, SV * round) {
     return newSViv(mpc_exp(*a, *b, (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_log(mpc_t * rop, mpc_t * op, SV * round) {
     return newSViv(mpc_log(*rop, *op, (mpc_rnd_t)SvUV(round)));
}

SV * _Rmpc_out_str(FILE * stream, SV * base, SV * dig, mpc_t * p, SV * round) {
     size_t ret;
     if(SvIV(base) < 2 || SvIV(base) > 36) croak("2nd argument supplied to Rmpc_out_str is out of allowable range (must be between 2 and 36 inclusive)");
     ret = mpc_out_str(stream, (int)SvIV(base), (size_t)SvUV(dig), *p, (mpc_rnd_t)SvUV(round));
     fflush(stream);
     return newSVuv(ret);
}

SV * _Rmpc_out_strS(FILE * stream, SV * base, SV * dig, mpc_t * p, SV * round, SV * suff) {
     size_t ret;
     if(SvIV(base) < 2 || SvIV(base) > 36) croak("2nd argument supplied to Rmpc_out_str is out of allowable range (must be between 2 and 36 inclusive)");
     ret = mpc_out_str(stream, (int)SvIV(base), (size_t)SvUV(dig), *p, (mpc_rnd_t)SvUV(round));
     fflush(stream);
     fprintf(stream, "%s", SvPV_nolen(suff));
     fflush(stream);
     return newSVuv(ret);
}

SV * _Rmpc_out_strP(SV * pre, FILE * stream, SV * base, SV * dig, mpc_t * p, SV * round) {
     size_t ret;
     if(SvIV(base) < 2 || SvIV(base) > 36) croak("3rd argument supplied to Rmpc_out_str is out of allowable range (must be between 2 and 36 inclusive)");
     fprintf(stream, "%s", SvPV_nolen(pre));
     fflush(stream);
     ret = mpc_out_str(stream, (int)SvIV(base), (size_t)SvUV(dig), *p, (mpc_rnd_t)SvUV(round));
     fflush(stream);
     return newSVuv(ret);
}

SV * _Rmpc_out_strPS(SV * pre, FILE * stream, SV * base, SV * dig, mpc_t * p, SV * round, SV * suff) {
     size_t ret;
     if(SvIV(base) < 2 || SvIV(base) > 36) croak("3rd argument supplied to Rmpc_out_str is out of allowable range (must be between 2 and 36 inclusive)");
     fprintf(stream, "%s", SvPV_nolen(pre));
     fflush(stream);
     ret = mpc_out_str(stream, (int)SvIV(base), (size_t)SvUV(dig), *p, (mpc_rnd_t)SvUV(round));
     fflush(stream);
     fprintf(stream, "%s", SvPV_nolen(suff));
     fflush(stream);
     return newSVuv(ret);
}


SV * Rmpc_inp_str(mpc_t * p, FILE * stream, SV * base, SV * round) {
     if(SvIV(base) < 2 || SvIV(base) > 36) croak("3rd argument supplied to TRmpfr_inp_str is out of allowable range (must be between 2 and 36 inclusive)");
     return newSViv(mpc_inp_str(*p, stream, NULL, (int)SvIV(base), (mpc_rnd_t)SvUV(round)));
}

/* Removed in mpc-0.7
void Rmpc_random(mpc_t * p) {
     mpc_random(*p);
}
*/

/* Removed in mpc-0.7
void Rmpc_random2(mpc_t * p, SV * s, SV * exp) {
     mpc_random2(*p, SvIV(s), SvUV(exp));
}
*/

SV * Rmpc_sin(mpc_t * rop, mpc_t * op, SV * round) {
     return newSViv(mpc_sin(*rop, *op, (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_cos(mpc_t * rop, mpc_t * op, SV * round) {
     return newSViv(mpc_cos(*rop, *op, (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_tan(mpc_t * rop, mpc_t * op, SV * round) {
     return newSViv(mpc_tan(*rop, *op, (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_sinh(mpc_t * rop, mpc_t * op, SV * round) {
     return newSViv(mpc_sinh(*rop, *op, (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_cosh(mpc_t * rop, mpc_t * op, SV * round) {
     return newSViv(mpc_cosh(*rop, *op, (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_tanh(mpc_t * rop, mpc_t * op, SV * round) {
     return newSViv(mpc_tanh(*rop, *op, (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_asin(mpc_t * rop, mpc_t * op, SV * round) {
     return newSViv(mpc_asin(*rop, *op, (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_acos(mpc_t * rop, mpc_t * op, SV * round) {
     return newSViv(mpc_acos(*rop, *op, (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_atan(mpc_t * rop, mpc_t * op, SV * round) {
     return newSViv(mpc_atan(*rop, *op, (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_asinh(mpc_t * rop, mpc_t * op, SV * round) {
     return newSViv(mpc_asinh(*rop, *op, (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_acosh(mpc_t * rop, mpc_t * op, SV * round) {
     return newSViv(mpc_acosh(*rop, *op, (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_atanh(mpc_t * rop, mpc_t * op, SV * round) {
     return newSViv(mpc_atanh(*rop, *op, (mpc_rnd_t)SvUV(round)));
}

SV * overload_true(mpc_t *a, SV *second, SV * third) {
     if(
       ( mpfr_nan_p(MPC_RE(*a)) || !mpfr_cmp_ui(MPC_RE(*a), 0) ) &&
       ( mpfr_nan_p(MPC_IM(*a)) || !mpfr_cmp_ui(MPC_IM(*a), 0) )
       ) return newSVuv(0);
     return newSVuv(1);
}

/********************************/
/********************************/
/********************************/
/********************************/
/********************************/
/********************************/
/********************************/
/********************************/

SV * overload_mul(mpc_t * a, SV * b, SV * third) {
     dMY_CXT;
     mpc_t * mpc_t_obj;
     SV * obj_ref, * obj;

     New(1, mpc_t_obj, 1, mpc_t);
     if(mpc_t_obj == NULL) croak("Failed to allocate memory in overload_mul function");
     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, "Math::MPC");
     mpc_init3(*mpc_t_obj, DEFAULT_PREC);
     sv_setiv(obj, INT2PTR(IV,mpc_t_obj));
     SvREADONLY_on(obj);

#ifdef USE_64_BIT_INT

     if(SvUOK(b)) {
#ifdef _MSC_VER
       mpc_set_str(*mpc_t_obj, SvPV_nolen(b), 10, DEFAULT_ROUNDING_MODE);
#else
       mpc_set_uj(*mpc_t_obj, SvUV(b), DEFAULT_ROUNDING_MODE);
#endif
       mpc_mul(*mpc_t_obj, *a, *mpc_t_obj, DEFAULT_ROUNDING_MODE);
       return obj_ref;
     }

     if(SvIOK(b)) {
#ifdef _MSC_VER
       mpc_set_str(*mpc_t_obj, SvPV_nolen(b), 10, DEFAULT_ROUNDING_MODE);
       mpc_mul(*mpc_t_obj, *a, *mpc_t_obj, DEFAULT_ROUNDING_MODE);
#else
       /* mpc_set_sj(*mpc_t_obj, SvIV(b), DEFAULT_ROUNDING_MODE); */
       _mpc_mul_sj(*mpc_t_obj, *a, SvIV(b), DEFAULT_ROUNDING_MODE);
#endif
       /* mpc_mul(*mpc_t_obj, *a, *mpc_t_obj, DEFAULT_ROUNDING_MODE); */
       return obj_ref;
     }

#else
     if(SvUOK(b)) {
       mpc_mul_ui(*mpc_t_obj, *a, SvUV(b), DEFAULT_ROUNDING_MODE);
       return obj_ref;
       }

     if(SvIOK(b)) {
       mpc_mul_si(*mpc_t_obj, *a, SvIV(b), DEFAULT_ROUNDING_MODE);
       return obj_ref;
     }
#endif

     if(SvNOK(b)) {
#ifdef USE_LONG_DOUBLE
       _mpc_mul_ld(*mpc_t_obj, *a, (long double)SvNV(b), DEFAULT_ROUNDING_MODE);
#else
       _mpc_mul_d(*mpc_t_obj,*a, (double)SvNV(b), DEFAULT_ROUNDING_MODE);
#endif

      return obj_ref;
     }

     if(SvPOK(b)) {
       if(mpc_set_str(*mpc_t_obj, SvPV_nolen(b), 0, DEFAULT_ROUNDING_MODE) == -1)
         croak("Invalid string supplied to Math::MPC::overload_mul");
       mpc_mul(*mpc_t_obj, *a, *mpc_t_obj, DEFAULT_ROUNDING_MODE);
       return obj_ref;
     }

     if(sv_isobject(b)) {
       if(strEQ(HvNAME(SvSTASH(SvRV(b))), "Math::MPC")) {
         mpc_mul(*mpc_t_obj, *a, *(INT2PTR(mpc_t *, SvIV(SvRV(b)))), DEFAULT_ROUNDING_MODE);
         return obj_ref;
         }
       }

     croak("Invalid argument supplied to Math::MPC::overload_mul");
}

SV * overload_add(mpc_t* a, SV * b, SV * third) {
     dMY_CXT;
     mpc_t * mpc_t_obj;
     SV * obj_ref, * obj;

     New(1, mpc_t_obj, 1, mpc_t);
     if(mpc_t_obj == NULL) croak("Failed to allocate memory in overload_add function");
     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, "Math::MPC");
     mpc_init3(*mpc_t_obj, DEFAULT_PREC);
     sv_setiv(obj, INT2PTR(IV,mpc_t_obj));
     SvREADONLY_on(obj);

#ifdef USE_64_BIT_INT

     if(SvUOK(b)) {
#ifdef _MSC_VER
       mpc_set_str(*mpc_t_obj, SvPV_nolen(b), 10, DEFAULT_ROUNDING_MODE);
#else
       mpc_set_uj(*mpc_t_obj, SvUV(b), DEFAULT_ROUNDING_MODE);
#endif
       mpc_add(*mpc_t_obj, *a, *mpc_t_obj, DEFAULT_ROUNDING_MODE);
       return obj_ref;
     }

     if(SvIOK(b)) {
#ifdef _MSC_VER
       mpc_set_str(*mpc_t_obj, SvPV_nolen(b), 10, DEFAULT_ROUNDING_MODE);
#else
       mpc_set_sj(*mpc_t_obj, SvIV(b), DEFAULT_ROUNDING_MODE);
#endif
       mpc_add(*mpc_t_obj, *a, *mpc_t_obj, DEFAULT_ROUNDING_MODE);
       return obj_ref;
     }

#else

     if(SvUOK(b)) {
       mpc_add_ui(*mpc_t_obj, *a, SvUV(b), DEFAULT_ROUNDING_MODE);
       return obj_ref;
       }

     if(SvIOK(b)) {
       if(SvIV(b) >= 0) {
         mpc_add_ui(*mpc_t_obj, *a, SvUV(b), DEFAULT_ROUNDING_MODE);
         return obj_ref;
         }
       mpc_sub_ui(*mpc_t_obj, *a, SvIV(b) * -1, DEFAULT_ROUNDING_MODE);
       return obj_ref;
       }

#endif

     if(SvNOK(b)) {
#ifdef USE_LONG_DOUBLE
       mpc_set_ld(*mpc_t_obj, SvNV(b), DEFAULT_ROUNDING_MODE);
       mpc_add(*mpc_t_obj, *a, *mpc_t_obj, DEFAULT_ROUNDING_MODE);
#else
       mpc_set_d(*mpc_t_obj, SvNV(b), DEFAULT_ROUNDING_MODE);
       mpc_add(*mpc_t_obj, *mpc_t_obj, *a, DEFAULT_ROUNDING_MODE);
#endif

       return obj_ref;
     }

     if(SvPOK(b)) {
       if(mpc_set_str(*mpc_t_obj, SvPV_nolen(b), 0, DEFAULT_ROUNDING_MODE) == -1)
         croak("Invalid string supplied to Math::MPC::overload_add");
       mpc_add(*mpc_t_obj, *a, *mpc_t_obj, DEFAULT_ROUNDING_MODE);
       return obj_ref;
     }

     if(sv_isobject(b)) {
       if(strEQ(HvNAME(SvSTASH(SvRV(b))), "Math::MPC")) {
         mpc_add(*mpc_t_obj, *a, *(INT2PTR(mpc_t *, SvIV(SvRV(b)))), DEFAULT_ROUNDING_MODE);
         return obj_ref;
         }
       }

     croak("Invalid argument supplied to Math::MPC::overload_add");
}

SV * overload_sub(mpc_t * a, SV * b, SV * third) {
     dMY_CXT;
     mpc_t * mpc_t_obj;
     SV * obj_ref, * obj;

     New(1, mpc_t_obj, 1, mpc_t);
     if(mpc_t_obj == NULL) croak("Failed to allocate memory in overload_sub function");
     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, "Math::MPC");
     mpc_init3(*mpc_t_obj, DEFAULT_PREC);
     sv_setiv(obj, INT2PTR(IV,mpc_t_obj));
     SvREADONLY_on(obj);

#ifdef USE_64_BIT_INT
     if(SvUOK(b)) {
#ifdef _MSC_VER
       mpc_set_str(*mpc_t_obj, SvPV_nolen(b), 10, DEFAULT_ROUNDING_MODE);
#else
       mpc_set_uj(*mpc_t_obj, SvUV(b), DEFAULT_ROUNDING_MODE);
#endif
       if(third == &PL_sv_yes) mpc_sub(*mpc_t_obj, *mpc_t_obj, *a, DEFAULT_ROUNDING_MODE);
       else mpc_sub(*mpc_t_obj, *a, *mpc_t_obj, DEFAULT_ROUNDING_MODE);
       return obj_ref;
       }

     if(SvIOK(b)) {
#ifdef _MSC_VER
       mpc_set_str(*mpc_t_obj, SvPV_nolen(b), 10, DEFAULT_ROUNDING_MODE);
#else
       mpc_set_sj(*mpc_t_obj, SvIV(b), DEFAULT_ROUNDING_MODE);
#endif
       if(third == &PL_sv_yes) mpc_sub(*mpc_t_obj, *mpc_t_obj, *a, DEFAULT_ROUNDING_MODE);
       else mpc_sub(*mpc_t_obj, *a, *mpc_t_obj, DEFAULT_ROUNDING_MODE);
       return obj_ref;
       }
#else
     if(SvUOK(b)) {
       if(third == &PL_sv_yes) mpc_ui_sub(*mpc_t_obj, SvUV(b), *a, DEFAULT_ROUNDING_MODE);
       else mpc_sub_ui(*mpc_t_obj, *a, SvUV(b), DEFAULT_ROUNDING_MODE);
       return obj_ref;
       }

     if(SvIOK(b)) {
       if(SvIV(b) >= 0) {
         if(third == &PL_sv_yes) mpc_ui_sub(*mpc_t_obj, SvUV(b), *a, DEFAULT_ROUNDING_MODE);
         else mpc_sub_ui(*mpc_t_obj, *a, SvUV(b), DEFAULT_ROUNDING_MODE);
         return obj_ref;
         }
       mpc_add_ui(*mpc_t_obj, *a, SvIV(b) * -1, DEFAULT_ROUNDING_MODE);
       if(third == &PL_sv_yes) mpc_neg(*mpc_t_obj, *mpc_t_obj, DEFAULT_ROUNDING_MODE);
       return obj_ref;
       }
#endif

     if(SvNOK(b)) {
#ifdef USE_LONG_DOUBLE
       mpc_set_ld(*mpc_t_obj, SvNV(b), DEFAULT_ROUNDING_MODE);
#else
       mpc_set_d(*mpc_t_obj, SvNV(b), DEFAULT_ROUNDING_MODE);
#endif
       if(third == &PL_sv_yes) mpc_sub(*mpc_t_obj, *mpc_t_obj, *a, DEFAULT_ROUNDING_MODE);
       else mpc_sub(*mpc_t_obj, *a, *mpc_t_obj, DEFAULT_ROUNDING_MODE);
       return obj_ref;
       }

     if(SvPOK(b)) {
       if(mpc_set_str(*mpc_t_obj, SvPV_nolen(b), 0, DEFAULT_ROUNDING_MODE) == -1)
         croak("Invalid string supplied to Math::MPC::overload_sub");
       if(third == &PL_sv_yes) mpc_sub(*mpc_t_obj, *mpc_t_obj, *a, DEFAULT_ROUNDING_MODE);
       else mpc_sub(*mpc_t_obj, *a, *mpc_t_obj, DEFAULT_ROUNDING_MODE);
       return obj_ref;
       }

     if(sv_isobject(b)) {
       if(strEQ(HvNAME(SvSTASH(SvRV(b))), "Math::MPC")) {
         mpc_sub(*mpc_t_obj, *a, *(INT2PTR(mpc_t *, SvIV(SvRV(b)))), DEFAULT_ROUNDING_MODE);
         return obj_ref;
         }
       }

     croak("Invalid argument supplied to Math::MPC::overload_sub function");
}

SV * overload_div(mpc_t * a, SV * b, SV * third) {
     dMY_CXT;
     mpc_t * mpc_t_obj;
     SV * obj_ref, * obj;

     New(1, mpc_t_obj, 1, mpc_t);
     if(mpc_t_obj == NULL) croak("Failed to allocate memory in overload_div function");
     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, "Math::MPC");
     mpc_init3(*mpc_t_obj, DEFAULT_PREC);
     sv_setiv(obj, INT2PTR(IV,mpc_t_obj));
     SvREADONLY_on(obj);

#ifdef USE_64_BIT_INT
     if(SvUOK(b)) {
#ifdef _MSC_VER
       mpc_set_str(*mpc_t_obj, SvPV_nolen(b), 10, DEFAULT_ROUNDING_MODE);
#else
       mpc_set_uj(*mpc_t_obj, SvUV(b), DEFAULT_ROUNDING_MODE);
#endif
       if(third == &PL_sv_yes) mpc_div(*mpc_t_obj, *mpc_t_obj, *a, DEFAULT_ROUNDING_MODE);
       else mpc_div(*mpc_t_obj, *a, *mpc_t_obj, DEFAULT_ROUNDING_MODE);
       return obj_ref;
       }

     if(SvIOK(b)) {
#ifdef _MSC_VER
       mpc_set_str(*mpc_t_obj, SvPV_nolen(b), 10, DEFAULT_ROUNDING_MODE);
       if(third == &PL_sv_yes) mpc_div(*mpc_t_obj, *mpc_t_obj, *a, DEFAULT_ROUNDING_MODE);
       else mpc_div(*mpc_t_obj, *a, *mpc_t_obj, DEFAULT_ROUNDING_MODE);
#else
       /* mpc_set_sj(*mpc_t_obj, SvIV(b), DEFAULT_ROUNDING_MODE); */
       if(third == &PL_sv_yes) _mpc_sj_div(*mpc_t_obj, SvIV(b), *a, DEFAULT_ROUNDING_MODE);
       else _mpc_div_sj(*mpc_t_obj, *a, SvIV(b), DEFAULT_ROUNDING_MODE);
#endif
       /* if(third == &PL_sv_yes) mpc_div(*mpc_t_obj, *mpc_t_obj, *a, DEFAULT_ROUNDING_MODE);
       else mpc_div(*mpc_t_obj, *a, *mpc_t_obj, DEFAULT_ROUNDING_MODE); */
       return obj_ref;
       }
#else
     if(SvUOK(b)) {
       if(third == &PL_sv_yes) mpc_ui_div(*mpc_t_obj, SvUV(b), *a, DEFAULT_ROUNDING_MODE);
       else mpc_div_ui(*mpc_t_obj, *a, SvUV(b), DEFAULT_ROUNDING_MODE);
       return obj_ref;
       }

     if(SvIOK(b)) {
       if(SvIV(b) >= 0) {
         if(third == &PL_sv_yes) mpc_ui_div(*mpc_t_obj, SvUV(b), *a, DEFAULT_ROUNDING_MODE);
         else mpc_div_ui(*mpc_t_obj, *a, SvUV(b), DEFAULT_ROUNDING_MODE);
         return obj_ref;
         }
       if(third == &PL_sv_yes) mpc_ui_div(*mpc_t_obj, SvIV(b) * -1, *a, DEFAULT_ROUNDING_MODE);
       else mpc_div_ui(*mpc_t_obj, *a, SvIV(b) * -1, DEFAULT_ROUNDING_MODE);
       mpc_neg(*mpc_t_obj, *mpc_t_obj, DEFAULT_ROUNDING_MODE);
       return obj_ref;
       }
#endif

     if(SvNOK(b)) {
#ifdef USE_LONG_DOUBLE
       /* mpc_set_ld(*mpc_t_obj, SvNV(b), DEFAULT_ROUNDING_MODE); */
       if(third == &PL_sv_yes) _mpc_ld_div(*mpc_t_obj, (long double)SvNV(b), *a, DEFAULT_ROUNDING_MODE);
       else _mpc_div_ld(*mpc_t_obj, *a, (long double)SvNV(b), DEFAULT_ROUNDING_MODE);
#else
       /* mpc_set_d(*mpc_t_obj, SvNV(b), DEFAULT_ROUNDING_MODE); */
       if(third == &PL_sv_yes) _mpc_d_div(*mpc_t_obj, (double)SvNV(b), *a, DEFAULT_ROUNDING_MODE);
       else _mpc_div_d(*mpc_t_obj, *a, (double)SvNV(b), DEFAULT_ROUNDING_MODE);
#endif
       /* if(third == &PL_sv_yes) mpc_div(*mpc_t_obj, *mpc_t_obj, *a, DEFAULT_ROUNDING_MODE); */
       /* else mpc_div(*mpc_t_obj, *a, *mpc_t_obj, DEFAULT_ROUNDING_MODE); */
       return obj_ref;
       }

     if(SvPOK(b)) {
       if(mpc_set_str(*mpc_t_obj, SvPV_nolen(b), 0, DEFAULT_ROUNDING_MODE) == -1)
         croak("Invalid string supplied to Math::MPC::overload_div");
       if(third == &PL_sv_yes) mpc_div(*mpc_t_obj, *mpc_t_obj, *a, DEFAULT_ROUNDING_MODE);
       else mpc_div(*mpc_t_obj, *a, *mpc_t_obj, DEFAULT_ROUNDING_MODE);
       return obj_ref;
       }

     if(sv_isobject(b)) {
       if(strEQ(HvNAME(SvSTASH(SvRV(b))), "Math::MPC")) {
         mpc_div(*mpc_t_obj, *a, *(INT2PTR(mpc_t *, SvIV(SvRV(b)))), DEFAULT_ROUNDING_MODE);
         return obj_ref;
         }
       }

     croak("Invalid argument supplied to Math::MPC::overload_div function");

}


SV * overload_div_eq(SV * a, SV * b, SV * third) {
     dMY_CXT;
     mpc_t temp;

     SvREFCNT_inc(a);

#ifdef USE_64_BIT_INT
     if(SvUOK(b)) {
       mpc_init3(temp, DEFAULT_PREC);
#ifdef _MSC_VER
       mpc_set_str(temp, SvPV_nolen(b), 10, DEFAULT_ROUNDING_MODE);
#else
       mpc_set_uj(temp, SvUV(b), DEFAULT_ROUNDING_MODE);
#endif
       mpc_div(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), temp, DEFAULT_ROUNDING_MODE);
       mpc_clear(temp);
       return a;
       }

     if(SvIOK(b)) {
       /* mpc_init3(temp, DEFAULT_PREC); */
#ifdef _MSC_VER
       mpc_init3(temp, DEFAULT_PREC);
       mpc_set_str(temp, SvPV_nolen(b), 10, DEFAULT_ROUNDING_MODE);
       mpc_div(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), temp, DEFAULT_ROUNDING_MODE);
       mpc_clear(temp);
#else
       /* mpc_set_sj(temp, SvIV(b), DEFAULT_ROUNDING_MODE); */
       _mpc_div_sj(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), SvIV(b), DEFAULT_ROUNDING_MODE);
#endif
       /* mpc_div(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), temp, DEFAULT_ROUNDING_MODE);
       mpc_clear(temp); */
       return a;
       }
#else
     if(SvUOK(b)) {
       mpc_div_ui(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), SvUV(b), DEFAULT_ROUNDING_MODE);
       return a;
       }

     if(SvIOK(b)) {
       if(SvIV(b) >= 0) {
         mpc_div_ui(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), SvUV(b), DEFAULT_ROUNDING_MODE);
         return a;
         }
       mpc_div_ui(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), SvIV(b) * -1, DEFAULT_ROUNDING_MODE);
       mpc_neg(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), DEFAULT_ROUNDING_MODE);
       return a;
       }
#endif

     if(SvNOK(b)) {
       /* mpc_init3(temp, DEFAULT_PREC); */
#ifdef USE_LONG_DOUBLE
       _mpc_div_ld(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), (long double)SvNV(b), DEFAULT_ROUNDING_MODE);
       /* mpc_set_ld(temp, SvNV(b), DEFAULT_ROUNDING_MODE); */
#else
       _mpc_div_d(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), (double)SvNV(b), DEFAULT_ROUNDING_MODE);
       /* mpc_set_d(temp, SvNV(b), DEFAULT_ROUNDING_MODE); */
#endif
       /* mpc_div(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), temp, DEFAULT_ROUNDING_MODE); */
       /* mpc_clear(temp); */
       return a;
       }

     if(SvPOK(b)) {
       mpc_init3(temp, DEFAULT_PREC);
       if(mpc_set_str(temp, SvPV_nolen(b), 0, DEFAULT_ROUNDING_MODE) == -1) {
         SvREFCNT_dec(a);
         croak("Invalid string supplied to Math::MPC::overload_div_eq");
         } 
       mpc_div(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), temp, DEFAULT_ROUNDING_MODE);
       mpc_clear(temp);
       return a;
       }

     if(sv_isobject(b)) {
       if(strEQ(HvNAME(SvSTASH(SvRV(b))), "Math::MPC")) {
         mpc_div(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(b)))), DEFAULT_ROUNDING_MODE);
         return a;
         }
       }

     SvREFCNT_dec(a);
     croak("Invalid argument supplied to Math::MPC::overload_div_eq function");

}

SV * overload_sub_eq(SV * a, SV * b, SV * third) {
     dMY_CXT;
     mpc_t temp;

     SvREFCNT_inc(a);

#ifdef USE_64_BIT_INT
     if(SvUOK(b)) {
       mpc_init3(temp, DEFAULT_PREC);
#ifdef _MSC_VER
       mpc_set_str(temp, SvPV_nolen(b), 10, DEFAULT_ROUNDING_MODE);
#else
       mpc_set_uj(temp, SvUV(b), DEFAULT_ROUNDING_MODE);
#endif
       mpc_sub(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), temp, DEFAULT_ROUNDING_MODE);
       mpc_clear(temp);
       return a;
       }

     if(SvIOK(b)) {
       mpc_init3(temp, DEFAULT_PREC);
#ifdef _MSC_VER
       mpc_set_str(temp, SvPV_nolen(b), 10, DEFAULT_ROUNDING_MODE);
#else
       mpc_set_sj(temp, SvIV(b), DEFAULT_ROUNDING_MODE);
#endif
       mpc_sub(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), temp, DEFAULT_ROUNDING_MODE);
       mpc_clear(temp);
       return a;
       }
#else
     if(SvUOK(b)) {
       mpc_sub_ui(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), SvUV(b), DEFAULT_ROUNDING_MODE);
       return a;
       }

     if(SvIOK(b)) {
       if(SvIV(b) >= 0) {
         mpc_sub_ui(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), SvUV(b), DEFAULT_ROUNDING_MODE);
         return a;
         }
       mpc_add_ui(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), SvIV(b) * -1, DEFAULT_ROUNDING_MODE);
       return a;
       }
#endif

     if(SvNOK(b)) {
       mpc_init3(temp, DEFAULT_PREC);

#ifdef USE_LONG_DOUBLE
       mpc_set_ld(temp, SvNV(b), DEFAULT_ROUNDING_MODE);
#else
       mpc_set_d(temp, SvNV(b), DEFAULT_ROUNDING_MODE);
#endif
       mpc_sub(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), temp, DEFAULT_ROUNDING_MODE);
       mpc_clear(temp);
       return a;
       }

     if(SvPOK(b)) {
       mpc_init3(temp, DEFAULT_PREC);
       if(mpc_set_str(temp, SvPV_nolen(b), 0, DEFAULT_ROUNDING_MODE) == -1) {
         SvREFCNT_dec(a);
         croak("Invalid string supplied to Math::MPC::overload_sub_eq");
         }
       mpc_sub(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), temp, DEFAULT_ROUNDING_MODE);
       mpc_clear(temp);
       return a;
       }

     if(sv_isobject(b)) {
       if(strEQ(HvNAME(SvSTASH(SvRV(b))), "Math::MPC")) {
         mpc_sub(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(b)))), DEFAULT_ROUNDING_MODE);
         return a;
         }
       }

     SvREFCNT_dec(a);
     croak("Invalid argument supplied to Math::MPC::overload_sub_eq function");

}

SV * overload_add_eq(SV * a, SV * b, SV * third) {
     dMY_CXT;
     mpc_t temp;
     SvREFCNT_inc(a);

#ifdef USE_64_BIT_INT
     if(SvUOK(b)) {
       mpc_init3(temp, DEFAULT_PREC);
#ifdef _MSC_VER
       mpc_set_str(temp, SvPV_nolen(b), 10, DEFAULT_ROUNDING_MODE);
#else
       mpc_set_uj(temp, SvUV(b), DEFAULT_ROUNDING_MODE);
#endif
       mpc_add(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), temp, DEFAULT_ROUNDING_MODE);
       mpc_clear(temp);
       return a;
       }

     if(SvIOK(b)) {
       mpc_init3(temp, DEFAULT_PREC);
 #ifdef _MSC_VER
       mpc_set_str(temp, SvPV_nolen(b), 10, DEFAULT_ROUNDING_MODE);
#else
       mpc_set_sj(temp, SvIV(b), DEFAULT_ROUNDING_MODE);
#endif
       mpc_add(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), temp, DEFAULT_ROUNDING_MODE);
       mpc_clear(temp);
       return a;
       }
#else
     if(SvUOK(b)) {
       mpc_add_ui(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), SvUV(b), DEFAULT_ROUNDING_MODE);
       return a;
       }

     if(SvIOK(b)) {
       if(SvIV(b) >= 0) {
         mpc_add_ui(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), SvUV(b), DEFAULT_ROUNDING_MODE);
         return a;
         }
       mpc_sub_ui(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), SvIV(b) * -1, DEFAULT_ROUNDING_MODE);
       return a;
       }
#endif

     if(SvNOK(b)) {
       mpc_init3(temp, DEFAULT_PREC);
#ifdef USE_LONG_DOUBLE
       mpc_set_ld(temp, SvNV(b), DEFAULT_ROUNDING_MODE);
#else
       mpc_set_d(temp, SvNV(b), DEFAULT_ROUNDING_MODE);
#endif
       mpc_add(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), temp, DEFAULT_ROUNDING_MODE);
       mpc_clear(temp);
       return a;
       }

     if(SvPOK(b)) {
       mpc_init3(temp, DEFAULT_PREC);
       if(mpc_set_str(temp, SvPV_nolen(b), 0, DEFAULT_ROUNDING_MODE) == -1) {
         SvREFCNT_dec(a);
         croak("Invalid string supplied to Math::MPC::overload_add_eq");
         }
       mpc_add(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), temp, DEFAULT_ROUNDING_MODE);
       mpc_clear(temp);
       return a;
       }

     if(sv_isobject(b)) {
       if(strEQ(HvNAME(SvSTASH(SvRV(b))), "Math::MPC")) {
         mpc_add(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(b)))), DEFAULT_ROUNDING_MODE);
         return a;
         }
       }

     SvREFCNT_dec(a);
     croak("Invalid argument supplied to Math::MPC::overload_add_eq");
}

SV * overload_mul_eq(SV * a, SV * b, SV * third) {
     dMY_CXT;
     mpc_t temp;

     SvREFCNT_inc(a);

#ifdef USE_64_BIT_INT
     if(SvUOK(b)) {
       mpc_init3(temp, DEFAULT_PREC);
#ifdef _MSC_VER
       mpc_set_str(temp, SvPV_nolen(b), 10, DEFAULT_ROUNDING_MODE);
#else
       mpc_set_uj(temp, SvUV(b), DEFAULT_ROUNDING_MODE);
#endif
       mpc_mul(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), temp, DEFAULT_ROUNDING_MODE);
       mpc_clear(temp);
       return a;
       }

     if(SvIOK(b)) {
       /* mpc_init3(temp, DEFAULT_PREC); */
#ifdef _MSC_VER
       mpc_init3(temp, DEFAULT_PREC);
       mpc_set_str(temp, SvPV_nolen(b), 10, DEFAULT_ROUNDING_MODE);
       mpc_mul(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), temp, DEFAULT_ROUNDING_MODE);
       mpc_clear(temp);
#else
       /* mpc_set_sj(temp, SvIV(b), DEFAULT_ROUNDING_MODE); */
       _mpc_mul_sj(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), SvUV(b), DEFAULT_ROUNDING_MODE);
#endif
       /* mpc_mul(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), temp, DEFAULT_ROUNDING_MODE);
       mpc_clear(temp); */
       return a;
       }
#else
     if(SvUOK(b)) {
       mpc_mul_ui(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), SvUV(b), DEFAULT_ROUNDING_MODE);
       return a;
       }

     if(SvIOK(b)) {
       mpc_mul_si(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), SvUV(b), DEFAULT_ROUNDING_MODE);
       return a;
       }

#endif

     if(SvNOK(b)) {
       /* mpc_init3(temp, DEFAULT_PREC); */
#ifdef USE_LONG_DOUBLE
       _mpc_mul_ld(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), (long double)SvNV(b), DEFAULT_ROUNDING_MODE);
       /* mpc_set_ld(temp, SvNV(b), DEFAULT_ROUNDING_MODE); */
#else
       _mpc_mul_d(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), (double)SvNV(b), DEFAULT_ROUNDING_MODE);
       /* mpc_set_d(temp, SvNV(b), DEFAULT_ROUNDING_MODE); */
#endif
       /* mpc_mul(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), temp, DEFAULT_ROUNDING_MODE); */
       /* mpc_clear(temp); */
       return a;
       }

     if(SvPOK(b)) {
       mpc_init3(temp, DEFAULT_PREC);
       if(mpc_set_str(temp, SvPV_nolen(b), 0, DEFAULT_ROUNDING_MODE) == -1) {
         SvREFCNT_dec(a);
         croak("Invalid string supplied to Math::MPC::overload_mul_eq");
         }
       mpc_mul(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), temp, DEFAULT_ROUNDING_MODE);
       mpc_clear(temp);
       return a;
       }

     if(sv_isobject(b)) {
       if(strEQ(HvNAME(SvSTASH(SvRV(b))), "Math::MPC")) {
         mpc_mul(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(b)))), DEFAULT_ROUNDING_MODE);
         return a;
         }
       }

     SvREFCNT_dec(a);
     croak("Invalid argument supplied to Math::MPC::overload_mul_eq");
}

SV * overload_pow(mpc_t * a, SV * b, SV * third) {
     dMY_CXT;
     mpc_t * mpc_t_obj;
     SV * obj_ref, * obj;

     New(1, mpc_t_obj, 1, mpc_t);
     if(mpc_t_obj == NULL) croak("Failed to allocate memory in overload_pow function");
     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, "Math::MPC");
     mpc_init3(*mpc_t_obj, DEFAULT_PREC);
     sv_setiv(obj, INT2PTR(IV,mpc_t_obj));
     SvREADONLY_on(obj);

#ifdef USE_64_BIT_INT

     if(SvUOK(b)) {
#ifdef _MSC_VER
       mpc_set_str(*mpc_t_obj, SvPV_nolen(b), 10, DEFAULT_ROUNDING_MODE);
#else
       mpc_set_uj(*mpc_t_obj, SvUV(b), DEFAULT_ROUNDING_MODE);
#endif
       mpc_pow(*mpc_t_obj, *a, *mpc_t_obj, DEFAULT_ROUNDING_MODE);
       return obj_ref;
     }

     if(SvIOK(b)) {
#ifdef _MSC_VER
       mpc_set_str(*mpc_t_obj, SvPV_nolen(b), 10, DEFAULT_ROUNDING_MODE);
#else
       mpc_set_sj(*mpc_t_obj, SvIV(b), DEFAULT_ROUNDING_MODE);
#endif
       mpc_pow(*mpc_t_obj, *a, *mpc_t_obj, DEFAULT_ROUNDING_MODE);
       return obj_ref;
     }

#else
     if(SvUOK(b)) {
       mpc_pow_ui(*mpc_t_obj, *a, SvUV(b), DEFAULT_ROUNDING_MODE);
       return obj_ref;
       }

     if(SvIOK(b)) {
       mpc_pow_si(*mpc_t_obj, *a, SvIV(b), DEFAULT_ROUNDING_MODE);
       return obj_ref;
     }
#endif

     if(SvNOK(b)) {
#ifdef USE_LONG_DOUBLE
       mpc_pow_ld(*mpc_t_obj, *a, SvNV(b), DEFAULT_ROUNDING_MODE);
#else
       mpc_pow_d(*mpc_t_obj, *a, SvNV(b), DEFAULT_ROUNDING_MODE);
#endif

     return obj_ref;
     }

     if(SvPOK(b)) {
       if(mpc_set_str(*mpc_t_obj, SvPV_nolen(b), 0, DEFAULT_ROUNDING_MODE) == -1)
         croak("Invalid string supplied to Math::MPC::overload_pow");
       mpc_pow(*mpc_t_obj, *a, *mpc_t_obj, DEFAULT_ROUNDING_MODE);
       return obj_ref;
     }

     if(sv_isobject(b)) {
       if(strEQ(HvNAME(SvSTASH(SvRV(b))), "Math::MPC")) {
         mpc_pow(*mpc_t_obj, *a, *(INT2PTR(mpc_t *, SvIV(SvRV(b)))), DEFAULT_ROUNDING_MODE);
         return obj_ref;
       }
     }

     croak("Invalid argument supplied to Math::MPC::overload_pow");
}

SV * overload_pow_eq(SV * a, SV * b, SV * third) {
     dMY_CXT;
     mpc_t temp;

     SvREFCNT_inc(a);

#ifdef USE_64_BIT_INT
     if(SvUOK(b)) {
       mpc_init3(temp, DEFAULT_PREC);
#ifdef _MSC_VER
       mpc_set_str(temp, SvPV_nolen(b), 10, DEFAULT_ROUNDING_MODE);
#else
       mpc_set_uj(temp, SvUV(b), DEFAULT_ROUNDING_MODE);
#endif
       mpc_pow(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), temp, DEFAULT_ROUNDING_MODE);
       mpc_clear(temp);
       return a;
     }

     if(SvIOK(b)) {
       mpc_init3(temp, DEFAULT_PREC);
#ifdef _MSC_VER
       mpc_set_str(temp, SvPV_nolen(b), 10, DEFAULT_ROUNDING_MODE);
#else
       mpc_set_sj(temp, SvIV(b), DEFAULT_ROUNDING_MODE);
#endif
       mpc_pow(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), temp, DEFAULT_ROUNDING_MODE);
       mpc_clear(temp);
       return a;
     }
#else
     if(SvUOK(b)) {
       mpc_pow_ui(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), SvUV(b), DEFAULT_ROUNDING_MODE);
       return a;
     }

     if(SvIOK(b)) {
       mpc_pow_si(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), SvIV(b), DEFAULT_ROUNDING_MODE);
       return a;
     }

#endif

     if(SvNOK(b)) {
#ifdef USE_LONG_DOUBLE
       mpc_pow_ld(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), SvNV(b), DEFAULT_ROUNDING_MODE);
#else
       mpc_pow_d(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), SvNV(b), DEFAULT_ROUNDING_MODE);
#endif
       return a;
     }

     if(SvPOK(b)) {
       mpc_init3(temp, DEFAULT_PREC);
       if(mpc_set_str(temp, SvPV_nolen(b), 0, DEFAULT_ROUNDING_MODE) == -1) {
         SvREFCNT_dec(a);
         croak("Invalid string supplied to Math::MPC::overload_pow_eq");
       }
       mpc_pow(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), temp, DEFAULT_ROUNDING_MODE);
       mpc_clear(temp);
       return a;
     }

     if(sv_isobject(b)) {
       if(strEQ(HvNAME(SvSTASH(SvRV(b))), "Math::MPC")) {
         mpc_pow(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(b)))), DEFAULT_ROUNDING_MODE);
         return a;
       }
     }

     SvREFCNT_dec(a);
     croak("Invalid argument supplied to Math::MPC::overload_pow_eq");
}

SV * overload_equiv(mpc_t * a, SV * b, SV * third) {
     dMY_CXT;
     mpfr_t temp;
     mpc_t t;
     int ret;

     if(mpfr_nan_p(MPC_RE(*a)) || mpfr_nan_p(MPC_IM(*a))) return newSViv(0);

#ifdef USE_64_BIT_INT
     if(SvUOK(b)) {
       mpfr_init2(temp, DEFAULT_PREC_RE);
#ifdef _MSC_VER
       mpfr_set_str(temp, SvPV_nolen(b), 10, DEFAULT_ROUNDING_MODE & 3);
#else
       mpfr_set_uj(temp, SvUV(b), DEFAULT_ROUNDING_MODE & 3);
#endif
       mpc_init3(t, DEFAULT_PREC);
       mpc_set_ui_ui(t, 0, 0, DEFAULT_ROUNDING_MODE);
       mpc_add_fr(t, t, temp, DEFAULT_ROUNDING_MODE);
       mpfr_clear(temp);
       ret = mpc_cmp(*a, t);
       mpc_clear(t);
       if(ret == 0) return newSViv(1);
       return newSViv(0);
       }

     if(SvIOK(b)) {
       mpfr_init2(temp, DEFAULT_PREC_RE);
#ifdef _MSC_VER
       mpfr_set_str(temp, SvPV_nolen(b), 10, DEFAULT_ROUNDING_MODE & 3);
#else
       mpfr_set_sj(temp, SvIV(b), DEFAULT_ROUNDING_MODE & 3);
#endif
       mpc_init3(t, DEFAULT_PREC);
       mpc_set_ui_ui(t, 0, 0, DEFAULT_ROUNDING_MODE);
       mpc_add_fr(t, t, temp, DEFAULT_ROUNDING_MODE);
       mpfr_clear(temp);
       ret = mpc_cmp(*a, t);
       mpc_clear(t);
       if(ret == 0) return newSViv(1);
       return newSViv(0);
       }
#else
     if(SvUOK(b)) {
       mpc_init3(t, DEFAULT_PREC);
       mpc_set_ui(t, SvUV(b), DEFAULT_ROUNDING_MODE);
       ret = mpc_cmp(*a, t);
       mpc_clear(t);
       if(ret == 0) return newSViv(1);
       return newSViv(0);
       }

     if(SvIOK(b)) {
       ret = mpc_cmp_si(*a, SvIV(b));
       if(ret == 0) return newSViv(1);
       return newSViv(0);
       }
#endif

     if(SvNOK(b)) {
#ifdef USE_LONG_DOUBLE
       mpfr_init2(temp, DEFAULT_PREC_RE);
       mpfr_set_ld(temp, SvNV(b), DEFAULT_ROUNDING_MODE & 3);
       if(mpfr_nan_p(temp)) {
         mpfr_clear(temp);
         return newSViv(0);
       }
       mpc_init3(t, DEFAULT_PREC);
       mpc_set_ui_ui(t, 0, 0, DEFAULT_ROUNDING_MODE);
       mpc_add_fr(t, t, temp, DEFAULT_ROUNDING_MODE);
       mpfr_clear(temp);
       ret = mpc_cmp(*a, t);
       mpc_clear(t);
#else
       mpc_init3(t, DEFAULT_PREC);
       mpc_set_d(t, SvNV(b), DEFAULT_ROUNDING_MODE);
       if(mpfr_nan_p(MPC_RE(t))) ret = 1;
       else ret = mpc_cmp(*a, t);
       mpc_clear(t);
#endif
       if(ret == 0) return newSViv(1);
       return newSViv(0);
       }

     if(SvPOK(b)) {
       mpfr_init2(temp, DEFAULT_PREC_RE);
       if(mpfr_set_str(temp, (char *)SvPV_nolen(b), 0, DEFAULT_ROUNDING_MODE & 3))
         croak("Invalid string supplied to Math::MPC::overload_equiv");
       mpc_init3(t, DEFAULT_PREC);
       mpc_set_ui_ui(t, 0, 0, DEFAULT_ROUNDING_MODE);
       mpc_add_fr(t, t, temp, DEFAULT_ROUNDING_MODE);
       mpfr_clear(temp);
       ret = mpc_cmp(*a, t);
       mpc_clear(t);
       if(ret == 0) return newSViv(1);
       return newSViv(0);
       }

     if(sv_isobject(b)) {
       if(strEQ(HvNAME(SvSTASH(SvRV(b))), "Math::Complex_C")) {

       }
       if(strEQ(HvNAME(SvSTASH(SvRV(b))), "Math::MPC")) {
         if(mpfr_nan_p(MPC_RE(*(INT2PTR(mpc_t *, SvIV(SvRV(b)))))) ||
            mpfr_nan_p(MPC_IM(*(INT2PTR(mpc_t *, SvIV(SvRV(b))))))) return newSViv(0);
         ret = mpc_cmp(*a, *(INT2PTR(mpc_t *, SvIV(SvRV(b)))));
         if(ret == 0) return newSViv(1);
         return newSViv(0);
         }
       }

     croak("Invalid argument supplied to Math::MPC::overload_equiv");
}

SV * overload_not_equiv(mpc_t * a, SV * b, SV * third) {
     dMY_CXT;
     mpfr_t temp;
     mpc_t t;
     int ret;

     if(mpfr_nan_p(MPC_RE(*a)) || mpfr_nan_p(MPC_IM(*a))) return newSViv(1);

#ifdef USE_64_BIT_INT
     if(SvUOK(b)) {
       mpfr_init2(temp, DEFAULT_PREC_RE);
#ifdef _MSC_VER
       mpfr_set_str(temp, SvPV_nolen(b), 10, DEFAULT_ROUNDING_MODE & 3);
#else
       mpfr_set_uj(temp, SvUV(b), DEFAULT_ROUNDING_MODE & 3);
#endif
       mpc_init3(t, DEFAULT_PREC);
       mpc_set_ui_ui(t, 0, 0, DEFAULT_ROUNDING_MODE);
       mpc_add_fr(t, t, temp, DEFAULT_ROUNDING_MODE);
       mpfr_clear(temp);
       ret = mpc_cmp(*a, t);
       mpc_clear(t);
       if(ret == 0) return newSViv(0);
       return newSViv(1);
       }

     if(SvIOK(b)) {
       mpfr_init2(temp, DEFAULT_PREC_RE);
#ifdef _MSC_VER
       mpfr_set_str(temp, SvPV_nolen(b), 10, DEFAULT_ROUNDING_MODE & 3);
#else
       mpfr_set_sj(temp, SvIV(b), DEFAULT_ROUNDING_MODE & 3);
#endif
       mpc_init3(t, DEFAULT_PREC);
       mpc_set_ui_ui(t, 0, 0, DEFAULT_ROUNDING_MODE);
       mpc_add_fr(t, t, temp, DEFAULT_ROUNDING_MODE);
       mpfr_clear(temp);
       ret = mpc_cmp(*a, t);
       mpc_clear(t);
       if(ret == 0) return newSViv(0);
       return newSViv(1);
       }
#else
     if(SvUOK(b)) {
       mpc_init3(t, DEFAULT_PREC);
       mpc_set_ui(t, SvUV(b), DEFAULT_ROUNDING_MODE);
       ret = mpc_cmp(*a, t);
       mpc_clear(t);
       if(ret == 0) return newSViv(0);
       return newSViv(1);
       }

     if(SvIOK(b)) {
       ret = mpc_cmp_si(*a, SvIV(b));
       if(ret == 0) return newSViv(0);
       return newSViv(1);
       }
#endif

     if(SvNOK(b)) {
#ifdef USE_LONG_DOUBLE
       mpfr_init2(temp, DEFAULT_PREC_RE);
       mpfr_set_ld(temp, SvNV(b), DEFAULT_ROUNDING_MODE & 3);
       if(mpfr_nan_p(temp)) {
         mpfr_clear(temp);
         return newSViv(1);
       }
       mpc_init3(t, DEFAULT_PREC);
       mpc_set_ui_ui(t, 0, 0, DEFAULT_ROUNDING_MODE);
       mpc_add_fr(t, t, temp, DEFAULT_ROUNDING_MODE);
       mpfr_clear(temp);
       ret = mpc_cmp(*a, t);
       mpc_clear(t);
#else
       mpc_init3(t, DEFAULT_PREC);
       mpc_set_d(t, SvNV(b), DEFAULT_ROUNDING_MODE);
       if(mpfr_nan_p(MPC_RE(t))) ret = 1;
       else ret = mpc_cmp(*a, t);
       mpc_clear(t);
#endif
       if(ret == 0) return newSViv(0);
       return newSViv(1);
       }

     if(SvPOK(b)) {
       mpfr_init2(temp, DEFAULT_PREC_RE);
       if(mpfr_set_str(temp, (char *)SvPV_nolen(b), 0, DEFAULT_ROUNDING_MODE & 3))
         croak("Invalid string supplied to Math::MPC::overload_not_equiv");
       mpc_init3(t, DEFAULT_PREC);
       mpc_set_ui_ui(t, 0, 0, DEFAULT_ROUNDING_MODE);
       mpc_add_fr(t, t, temp, DEFAULT_ROUNDING_MODE);
       mpfr_clear(temp);
       ret = mpc_cmp(*a, t);
       mpc_clear(t);
       if(ret == 0) return newSViv(0);
       return newSViv(1);
       }

     if(sv_isobject(b)) {
       if(strEQ(HvNAME(SvSTASH(SvRV(b))), "Math::MPC")) {
         if(mpfr_nan_p(MPC_RE(*(INT2PTR(mpc_t *, SvIV(SvRV(b)))))) ||
            mpfr_nan_p(MPC_IM(*(INT2PTR(mpc_t *, SvIV(SvRV(b))))))) return newSViv(1);
         if(mpc_cmp(*a, *(INT2PTR(mpc_t *, SvIV(SvRV(b)))))) return newSViv(1);
         return newSViv(0);
         }
       }

     croak("Invalid argument supplied to Math::MPC::overload_not_equiv");
}

SV * overload_not(mpc_t * a, SV * second, SV * third) {
     if(mpfr_nan_p(MPC_RE(*a)) || mpfr_nan_p(MPC_IM(*a))) return newSViv(1); /* Thanks Jean-Louis Morel */
     if(mpc_cmp_si_si(*a, 0, 0)) return newSViv(0);
     return newSViv(1);
}

SV * overload_sqrt(mpc_t * p, SV * second, SV * third) {
     dMY_CXT;
     mpc_t * mpc_t_obj;
     SV * obj_ref, * obj;

     New(1, mpc_t_obj, 1, mpc_t);
     if(mpc_t_obj == NULL) croak("Failed to allocate memory in overload_sqrt function");
     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, "Math::MPC");
     mpc_init3(*mpc_t_obj, DEFAULT_PREC);

     mpc_sqrt(*mpc_t_obj, *p, DEFAULT_ROUNDING_MODE);
     sv_setiv(obj, INT2PTR(IV,mpc_t_obj));
     SvREADONLY_on(obj);
     return obj_ref;
}

void overload_copy(mpc_t * p, SV * second, SV * third) {
     dXSARGS;
     dMY_CXT;
     mpc_t * mpc_t_obj;
     SV * obj_ref, * obj;
     mp_prec_t re, im;

     New(1, mpc_t_obj, 1, mpc_t);
     if(mpc_t_obj == NULL) croak("Failed to allocate memory in overload_copy function");
     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, "Math::MPC");

     mpc_get_prec2(&re, &im, *p);
     mpc_init3(*mpc_t_obj, re, im);
     mpc_set(*mpc_t_obj, *p, DEFAULT_ROUNDING_MODE);
     sv_setiv(obj, INT2PTR(IV,mpc_t_obj));
     SvREADONLY_on(obj);
     ST(0) = sv_2mortal(obj_ref);
     /* PUTBACK; *//* not needed */
     XSRETURN(1);
}

SV * overload_abs(mpc_t * p, SV * second, SV * third) {
     dMY_CXT;
     mpfr_t * mpfr_t_obj;
     SV * obj_ref, * obj;

     New(1, mpfr_t_obj, 1, mpfr_t);
     if(mpfr_t_obj == NULL) croak("Failed to allocate memory in overload_abs function");
     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, "Math::MPFR");
     mpfr_init(*mpfr_t_obj);

     mpc_abs(*mpfr_t_obj, *p, DEFAULT_ROUNDING_MODE);
     sv_setiv(obj, INT2PTR(IV,mpfr_t_obj));
     SvREADONLY_on(obj);
     return obj_ref;
}

SV * overload_exp(mpc_t * p, SV * second, SV * third) {
     dMY_CXT;
     mpc_t * mpc_t_obj;
     SV * obj_ref, * obj;

     New(1, mpc_t_obj, 1, mpc_t);
     if(mpc_t_obj == NULL) croak("Failed to allocate memory in overload_exp function");
     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, "Math::MPC");
     mpc_init3(*mpc_t_obj, DEFAULT_PREC);

     mpc_exp(*mpc_t_obj, *p, DEFAULT_ROUNDING_MODE);
     sv_setiv(obj, INT2PTR(IV,mpc_t_obj));
     SvREADONLY_on(obj);
     return obj_ref;
}

SV * overload_log(mpc_t * p, SV * second, SV * third) {
     dMY_CXT;
     mpc_t * mpc_t_obj;
     SV * obj_ref, * obj;

     New(1, mpc_t_obj, 1, mpc_t);
     if(mpc_t_obj == NULL) croak("Failed to allocate memory in overload_exp function");
     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, "Math::MPC");
     mpc_init3(*mpc_t_obj, DEFAULT_PREC);

     mpc_log(*mpc_t_obj, *p, DEFAULT_ROUNDING_MODE);
     sv_setiv(obj, INT2PTR(IV,mpc_t_obj));
     SvREADONLY_on(obj);
     return obj_ref;
}

SV * overload_sin(mpc_t * p, SV * second, SV * third) {
     dMY_CXT;
     mpc_t * mpc_t_obj;
     SV * obj_ref, * obj;

     New(1, mpc_t_obj, 1, mpc_t);
     if(mpc_t_obj == NULL) croak("Failed to allocate memory in overload_sin function");
     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, "Math::MPC");
     mpc_init3(*mpc_t_obj, DEFAULT_PREC);

     mpc_sin(*mpc_t_obj, *p, DEFAULT_ROUNDING_MODE);
     sv_setiv(obj, INT2PTR(IV,mpc_t_obj));
     SvREADONLY_on(obj);
     return obj_ref;
}

SV * overload_cos(mpc_t * p, SV * second, SV * third) {
     dMY_CXT;
     mpc_t * mpc_t_obj;
     SV * obj_ref, * obj;

     New(1, mpc_t_obj, 1, mpc_t);
     if(mpc_t_obj == NULL) croak("Failed to allocate memory in overload_sin function");
     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, "Math::MPC");
     mpc_init3(*mpc_t_obj, DEFAULT_PREC);

     mpc_cos(*mpc_t_obj, *p, DEFAULT_ROUNDING_MODE);
     sv_setiv(obj, INT2PTR(IV,mpc_t_obj));
     SvREADONLY_on(obj);
     return obj_ref;
}

void _get_r_string(mpc_t * p, SV * base, SV * n_digits, SV * round) {
     dXSARGS;
     char * out;
     mp_exp_t ptr;
     unsigned long b = SvUV(base);

     if(b < 2 || b > 36) croak("Second argument supplied to r_string() is not in acceptable range");

     out = mpfr_get_str(0, &ptr, b, SvUV(n_digits), MPC_RE(*p), (mpc_rnd_t)SvUV(round) & 3);

     if(out == NULL) croak("An error occurred in _get_r_string()");

     /* sp = mark; *//* not needed */
     ST(0) = sv_2mortal(newSVpv(out, 0));
     mpfr_free_str(out);
     ST(1) = sv_2mortal(newSViv(ptr));
     /* PUTBACK; *//* not needed */
     XSRETURN(2);
}

void _get_i_string(mpc_t * p, SV * base, SV * n_digits, SV * round) {
     dXSARGS;
     char * out;
     mp_exp_t ptr;
     unsigned long b = SvUV(base);

     if(b < 2 || b > 36) croak("Second argument supplied to i_string() is not in acceptable range");

     out = mpfr_get_str(0, &ptr, b, SvUV(n_digits), MPC_IM(*p), (mpc_rnd_t)SvUV(round) & 3);

     if(out == NULL) croak("An error occurred in _get_i_string()");

     /* sp = mark; *//* not needed */
     ST(0) = sv_2mortal(newSVpv(out, 0));
     mpfr_free_str(out);
     ST(1) = sv_2mortal(newSViv(ptr));
     /* PUTBACK; *//* not needed */
     XSRETURN(2);
}


/* ########################################
   ########################################
   ########################################
   ########################################
   ########################################
   ######################################## */



SV * _itsa(SV * a) {
     if(SvUOK(a)) return newSVuv(1);
     if(SvIOK(a)) return newSVuv(2);
     if(SvNOK(a)) return newSVuv(3);
     if(SvPOK(a)) return newSVuv(4);
     if(sv_isobject(a)) {
       if(strEQ(HvNAME(SvSTASH(SvRV(a))), "Math::MPFR")) return newSVuv(5);
       if(strEQ(HvNAME(SvSTASH(SvRV(a))), "Math::GMPf")) return newSVuv(6);
       if(strEQ(HvNAME(SvSTASH(SvRV(a))), "Math::GMPq")) return newSVuv(7);
       if(strEQ(HvNAME(SvSTASH(SvRV(a))), "Math::GMPz")) return newSVuv(8);
       if(strEQ(HvNAME(SvSTASH(SvRV(a))), "Math::GMP")) return newSVuv(9);
       if(strEQ(HvNAME(SvSTASH(SvRV(a))), "Math::MPC")) return newSVuv(10);
       }
     return newSVuv(0);
}

SV * _new_real(SV * b) {
     dMY_CXT;
     mpc_t * mpc_t_obj;
     mpfr_t temp;
     SV * obj_ref, * obj;

     New(1, mpc_t_obj, 1, mpc_t);
     if(mpc_t_obj == NULL) croak("Failed to allocate memory in _new_real function");
     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, "Math::MPC");
     mpc_init3(*mpc_t_obj, DEFAULT_PREC);

     sv_setiv(obj, INT2PTR(IV,mpc_t_obj));
     SvREADONLY_on(obj);

#ifdef USE_64_BIT_INT

     if(SvUOK(b)) {
       mpfr_init2(temp, DEFAULT_PREC_RE);
#ifdef _MSC_VER
       mpfr_set_str(temp, SvPV_nolen(b), 10, DEFAULT_ROUNDING_MODE & 3);
#else
       mpfr_set_uj(temp, SvUV(b), DEFAULT_ROUNDING_MODE & 3);
#endif
       mpc_set_fr(*mpc_t_obj, temp, DEFAULT_ROUNDING_MODE);
       mpfr_clear(temp);
       return obj_ref;
     }

     if(SvIOK(b)) {
       mpfr_init2(temp, DEFAULT_PREC_RE);
#ifdef _MSC_VER
       mpfr_set_str(temp, SvPV_nolen(b), 10, DEFAULT_ROUNDING_MODE & 3);
#else
       mpfr_set_sj(temp, SvIV(b), DEFAULT_ROUNDING_MODE & 3);
#endif
       mpc_set_fr(*mpc_t_obj, temp, DEFAULT_ROUNDING_MODE);
       mpfr_clear(temp);
       return obj_ref;
     }

#else
     if(SvUOK(b)) {
       mpc_set_ui(*mpc_t_obj, SvUV(b), DEFAULT_ROUNDING_MODE);
       return obj_ref;
       }

     if(SvIOK(b)) {
       mpc_set_si(*mpc_t_obj, SvIV(b), DEFAULT_ROUNDING_MODE);
       return obj_ref;
     }
#endif

     if(SvNOK(b)) {
#ifdef USE_LONG_DOUBLE
       mpc_set_ld(*mpc_t_obj, SvNV(b), DEFAULT_ROUNDING_MODE);
#else
       mpc_set_d(*mpc_t_obj, SvNV(b), DEFAULT_ROUNDING_MODE);
#endif

     return obj_ref;
     }

     if(SvPOK(b)) {
       mpfr_init2(temp, DEFAULT_PREC_RE);
       if(mpfr_set_str(temp, SvPV_nolen(b), 0, DEFAULT_ROUNDING_MODE & 3))
         croak("Invalid string supplied to Math::MPC::new");
       mpc_set_fr(*mpc_t_obj, temp, DEFAULT_ROUNDING_MODE);
       mpfr_clear(temp);
       return obj_ref;
     }

     if(sv_isobject(b)) {
       if(strEQ(HvNAME(SvSTASH(SvRV(b))), "Math::MPFR")) {
         mpc_set_fr(*mpc_t_obj, *(INT2PTR(mpfr_t *, SvIV(SvRV(b)))), DEFAULT_ROUNDING_MODE);
         return obj_ref;
       }
       if(strEQ(HvNAME(SvSTASH(SvRV(b))), "Math::GMPf")) {
         mpc_set_f(*mpc_t_obj, *(INT2PTR(mpf_t *, SvIV(SvRV(b)))), DEFAULT_ROUNDING_MODE);
         return obj_ref;
       }
       if(strEQ(HvNAME(SvSTASH(SvRV(b))), "Math::GMPq")) {
         mpc_set_q(*mpc_t_obj, *(INT2PTR(mpq_t *, SvIV(SvRV(b)))), DEFAULT_ROUNDING_MODE);
         return obj_ref;
       }
       if(strEQ(HvNAME(SvSTASH(SvRV(b))), "Math::GMP") ||
          strEQ(HvNAME(SvSTASH(SvRV(b))), "Math::GMPz"))  {
         mpc_set_z(*mpc_t_obj, *(INT2PTR(mpz_t *, SvIV(SvRV(b)))), DEFAULT_ROUNDING_MODE);
         return obj_ref;
       }
     }

     croak("Invalid argument supplied to Math::MPC::_new_real");
}

SV * _new_im(SV * b) {
     dMY_CXT;
     mpc_t * mpc_t_obj;
     mpfr_t temp;
     SV * obj_ref, * obj;
     int ret;

     New(1, mpc_t_obj, 1, mpc_t);
     if(mpc_t_obj == NULL) croak("Failed to allocate memory in Rmpc_init function");
     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, "Math::MPC");
     mpc_init3(*mpc_t_obj, DEFAULT_PREC);

     sv_setiv(obj, INT2PTR(IV,mpc_t_obj));
     SvREADONLY_on(obj);

#ifdef USE_64_BIT_INT

     if(SvUOK(b)) {
       mpfr_init2(temp, DEFAULT_PREC_IM);
#ifdef _MSC_VER
       mpfr_set_str(temp, SvPV_nolen(b), 10, DEFAULT_ROUNDING_MODE / 16);
#else
       mpfr_set_uj(temp, SvUV(b), DEFAULT_ROUNDING_MODE / 16);
#endif
       VOID_MPC_SET_X_Y(ui, fr, *mpc_t_obj, 0, temp, DEFAULT_ROUNDING_MODE);
       mpfr_clear(temp);
       return obj_ref;
     }

     if(SvIOK(b)) {
       mpfr_init2(temp, DEFAULT_PREC_IM);
#ifdef _MSC_VER
       mpfr_set_str(temp, SvPV_nolen(b), 10, DEFAULT_ROUNDING_MODE / 16);
#else
       mpfr_set_sj(temp, SvIV(b), DEFAULT_ROUNDING_MODE / 16);
#endif
       VOID_MPC_SET_X_Y(ui, fr, *mpc_t_obj, 0, temp, DEFAULT_ROUNDING_MODE);
       mpfr_clear(temp);
       return obj_ref;
     }

#else
     if(SvUOK(b)) {
       mpc_set_ui_ui(*mpc_t_obj, 0, SvUV(b), DEFAULT_ROUNDING_MODE);
       return obj_ref;
       }

     if(SvIOK(b)) {
       mpc_set_si_si(*mpc_t_obj, 0, SvIV(b), DEFAULT_ROUNDING_MODE);
       return obj_ref;
     }
#endif

     if(SvNOK(b)) {
#ifdef USE_LONG_DOUBLE
       mpc_set_ld_ld(*mpc_t_obj, 0, SvNV(b), DEFAULT_ROUNDING_MODE);
#else
       mpc_set_d_d(*mpc_t_obj, 0, SvNV(b), DEFAULT_ROUNDING_MODE);
#endif

     return obj_ref;
     }

     if(SvPOK(b)) {
       mpfr_init2(temp, DEFAULT_PREC_IM);
       if(mpfr_set_str(temp, SvPV_nolen(b), 0, DEFAULT_ROUNDING_MODE / 16))
         croak("Invalid string supplied to Math::MPC::new");
       VOID_MPC_SET_X_Y(ui, fr, *mpc_t_obj, 0, temp, DEFAULT_ROUNDING_MODE);
       mpfr_clear(temp);
       return obj_ref;
     }

     if(sv_isobject(b)) {
       if(strEQ(HvNAME(SvSTASH(SvRV(b))), "Math::MPFR")) {
         VOID_MPC_SET_X_Y(ui, fr, *mpc_t_obj, 0, *(INT2PTR(mpfr_t *, SvIV(SvRV(b)))), DEFAULT_ROUNDING_MODE);
         return obj_ref;
       }
       if(strEQ(HvNAME(SvSTASH(SvRV(b))), "Math::GMPf")) {
         mpfr_init2(temp, DEFAULT_PREC_IM);
         mpfr_set_f(temp, *(INT2PTR(mpf_t *, SvIV(SvRV(b)))), DEFAULT_ROUNDING_MODE / 16);
         VOID_MPC_SET_X_Y(ui, fr, *mpc_t_obj, 0, temp, DEFAULT_ROUNDING_MODE);
         mpfr_clear(temp);
         return obj_ref;
       }
       if(strEQ(HvNAME(SvSTASH(SvRV(b))), "Math::GMPq")) {
         mpfr_init2(temp, DEFAULT_PREC_IM);
         mpfr_set_q(temp, *(INT2PTR(mpq_t *, SvIV(SvRV(b)))), DEFAULT_ROUNDING_MODE / 16);
         VOID_MPC_SET_X_Y(ui, fr, *mpc_t_obj, 0, temp, DEFAULT_ROUNDING_MODE);
         mpfr_clear(temp);
         return obj_ref;
       }
       if(strEQ(HvNAME(SvSTASH(SvRV(b))), "Math::GMP") ||
          strEQ(HvNAME(SvSTASH(SvRV(b))), "Math::GMPz"))  {
         mpfr_init2(temp, DEFAULT_PREC_IM);
         mpfr_set_z(temp, *(INT2PTR(mpz_t *, SvIV(SvRV(b)))), DEFAULT_ROUNDING_MODE / 16);
         VOID_MPC_SET_X_Y(ui, fr, *mpc_t_obj, 0, temp, DEFAULT_ROUNDING_MODE);
         mpfr_clear(temp);
         return obj_ref;
       }
     }

     croak("Invalid argument supplied to Math::MPC::_new_im");
}

int _has_longlong() {
#ifdef USE_64_BIT_INT
    return 1;
#else
    return 0;
#endif
}

int _has_longdouble() {
#ifdef USE_LONG_DOUBLE
    return 1;
#else
    return 0;
#endif
}

/* Has inttypes.h been included ? */
int _has_inttypes() {
#ifdef _MSC_VER
return 0;
#else
#if defined USE_64_BIT_INT || defined USE_LONG_DOUBLE
return 1;
#else
return 0;
#endif
#endif
}

SV * gmp_v() {
     return newSVpv(gmp_version, 0);
}

SV * mpfr_v() {
     return newSVpv(mpfr_get_version(), 0);
}

/* Not yet available
SV * RMPC_MAX_PREC(mpc_t * a) {
     return newSVuv(MPC_MAX_PREC(*a));
}
*/

SV * _MPC_VERSION_MAJOR() {
     return newSVuv(MPC_VERSION_MAJOR);
}

SV * _MPC_VERSION_MINOR() {
     return newSVuv(MPC_VERSION_MINOR);
}
  
SV * _MPC_VERSION_PATCHLEVEL() {
     return newSVuv(MPC_VERSION_PATCHLEVEL);
}

SV * _MPC_VERSION() {
     return newSVuv(MPC_VERSION);
}

SV * _MPC_VERSION_NUM(SV * x, SV * y, SV * z) {
     return newSVuv(MPC_VERSION_NUM((unsigned long)SvUV(x), (unsigned long)SvUV(y), (unsigned long)SvUV(z)));
}

SV * _MPC_VERSION_STRING() {
     return newSVpv(MPC_VERSION_STRING, 0);
}

SV * Rmpc_get_version() {
     return newSVpv(mpc_get_version(), 0);
}

SV * Rmpc_real(mpfr_t * rop, mpc_t * op, SV * round) {
     return newSViv(mpc_real(*rop, *op, (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_imag(mpfr_t * rop, mpc_t * op, SV * round) {
     return newSViv(mpc_imag(*rop, *op, (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_arg(mpfr_t * rop, mpc_t * op, SV * round) {
     return newSViv(mpc_arg(*rop, *op, (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_proj(mpc_t * rop, mpc_t * op, SV * round) {
     return newSViv(mpc_proj(*rop, *op, (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_get_str(SV * base, SV * dig, mpc_t * op, SV * round) {
     char * out;
     SV * outsv;
     out = mpc_get_str((int)SvIV(base), (size_t)SvUV(dig), *op, (mpc_rnd_t)SvUV(round));
     outsv = newSVpv(out, 0);
     mpc_free_str(out);
     return outsv;
}

SV * Rmpc_set_str(mpc_t * rop, SV * str, SV * base, SV * round) {
     return newSViv(mpc_set_str(*rop, SvPV_nolen(str), (int)SvIV(base), (mpc_rnd_t)SvUV(round)));
}

SV * Rmpc_strtoc(mpc_t * rop, SV * str, SV * base, SV * round) {
     return newSViv(mpc_strtoc(*rop, SvPV_nolen(str), NULL, (int)SvIV(base), (mpc_rnd_t)SvUV(round)));
}

void Rmpc_set_nan(mpc_t * a) {
     mpc_set_nan(*a);
}

void Rmpc_swap(mpc_t * a, mpc_t * b) {
     mpc_swap(*a, *b);
}

/* atan2(x, y) = atan(x / y) */
SV * overload_atan2(mpc_t * p, mpc_t * q, SV * third) {
     dMY_CXT;
     mpc_t * mpc_t_obj;
     SV * obj_ref, * obj;

     New(1, mpc_t_obj, 1, mpc_t);
     if(mpc_t_obj == NULL) croak("Failed to allocate memory in overload_atan2 function");
     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, "Math::MPC");
     mpc_init3(*mpc_t_obj, DEFAULT_PREC);

     mpc_div(*mpc_t_obj, *p, *q, DEFAULT_ROUNDING_MODE);

     mpc_atan(*mpc_t_obj, *mpc_t_obj, DEFAULT_ROUNDING_MODE);
     sv_setiv(obj, INT2PTR(IV,mpc_t_obj));
     SvREADONLY_on(obj);
     return obj_ref;
}

SV * Rmpc_sin_cos(mpc_t * rop_sin, mpc_t * rop_cos, mpc_t * op, SV * rnd_sin, SV * rnd_cos) {
#ifdef SIN_COS_AVAILABLE
     return newSViv(mpc_sin_cos(*rop_sin, *rop_cos, *op, (mpc_rnd_t)SvUV(rnd_sin), (mpc_rnd_t)SvUV(rnd_cos)));
#else
     croak("Rmpc_­sin_cos() not supported by your version (%s) of the mpc library", MPC_VERSION_STRING);
#endif
}

void Rmpc_get_dc(SV * crop, mpc_t * op, SV * round) {
#ifdef _DO_COMPLEX_H
     if(sv_isobject(crop) && strEQ(HvNAME(SvSTASH(SvRV(crop))), "Math::Complex_C::Long"))
       croak("1st arg to Rmpc_get_dc is a Math::Complex_C::Long object - expects a Math::Complex_C object");
     *(INT2PTR(double _Complex *, SvIV(SvRV(crop)))) = mpc_get_dc(*op, (mpc_rnd_t)SvUV(round)); 
#else
     croak("Rmpc_get_dc() not implemented");
#endif
}

void Rmpc_get_ldc(SV * crop, mpc_t * op, SV * round) {
#ifdef _DO_COMPLEX_H
     if(sv_isobject(crop) && strEQ(HvNAME(SvSTASH(SvRV(crop))), "Math::Complex_C"))
       croak("1st arg to Rmpc_get_ldc is a Math::Complex_C object - expects a Math::Complex_C::Long object");
     *(INT2PTR(long double _Complex *, SvIV(SvRV(crop)))) = mpc_get_ldc(*op, (mpc_rnd_t)SvUV(round));
#else
     croak("Rmpc_get_ldc() not implemented");
#endif
}

SV * Rmpc_set_dc(mpc_t * op, SV * crop, SV * round) {
#ifdef _DO_COMPLEX_H
     if(sv_isobject(crop) && strEQ(HvNAME(SvSTASH(SvRV(crop))), "Math::Complex_C::Long"))
       croak("2nd arg to Rmpc_set_dc is a Math::Complex_C::Long object - expects a Math::Complex_C object");
     return newSViv(mpc_set_dc(*op, *(INT2PTR(double _Complex *, SvIV(SvRV(crop)))), (mpc_rnd_t)SvUV(round)));
#else
     croak("Rmpc_set_dc() not implemented");
#endif
}

SV * Rmpc_set_ldc(mpc_t * op, SV * crop, SV * round) {
#ifdef _DO_COMPLEX_H
     if(sv_isobject(crop) && strEQ(HvNAME(SvSTASH(SvRV(crop))), "Math::Complex_C"))
       croak("2nd arg to Rmpc_set_ldc is a Math::Complex_C object - expects a Math::Complex_C::Long object");
     return newSViv(mpc_set_ldc(*op, *(INT2PTR(long double _Complex *, SvIV(SvRV(crop)))), (mpc_rnd_t)SvUV(round)));
#else
     croak("Rmpc_set_ldc() not implemented");
#endif
}

SV * _have_Complex_h() {
#ifdef _DO_COMPLEX_H
     return newSVuv(1);
#else
     return newSVuv(0);
#endif
}

SV * _mpfr_buildopt_tls_p() {
#if MPFR_VERSION_MAJOR >= 3
     return newSViv(mpfr_buildopt_tls_p());
#else
     croak("Math::MPC::_mpfr_buildopt_tls_p not implemented with this version of the mpfr library - we have %s but need at least 3.0.0", MPFR_VERSION_STRING);
#endif
}

SV * get_xs_version() {
     return newSVpv(XS_VERSION, 0);
}

void CLONE(SV * x, ...) {
   MY_CXT_CLONE;
}

MODULE = Math::MPC	PACKAGE = Math::MPC	

PROTOTYPES: DISABLE


int
_mpc_mul_sj (rop, op, i, rnd)
	mpc_ptr	rop
	mpc_ptr	op
	intmax_t	i
	mpc_rnd_t	rnd

int
_mpc_mul_ld (rop, op, i, rnd)
	mpc_ptr	rop
	mpc_ptr	op
	long double	i
	mpc_rnd_t	rnd

int
_mpc_mul_d (rop, op, i, rnd)
	mpc_ptr	rop
	mpc_ptr	op
	double	i
	mpc_rnd_t	rnd

int
_mpc_div_sj (rop, op, i, rnd)
	mpc_ptr	rop
	mpc_ptr	op
	intmax_t	i
	mpc_rnd_t	rnd

int
_mpc_sj_div (rop, i, op, rnd)
	mpc_ptr	rop
	intmax_t	i
	mpc_ptr	op
	mpc_rnd_t	rnd

int
_mpc_div_ld (rop, op, i, rnd)
	mpc_ptr	rop
	mpc_ptr	op
	long double	i
	mpc_rnd_t	rnd

int
_mpc_ld_div (rop, i, op, rnd)
	mpc_ptr	rop
	long double	i
	mpc_ptr	op
	mpc_rnd_t	rnd

int
_mpc_div_d (rop, op, i, rnd)
	mpc_ptr	rop
	mpc_ptr	op
	double	i
	mpc_rnd_t	rnd

int
_mpc_d_div (rop, i, op, rnd)
	mpc_ptr	rop
	double	i
	mpc_ptr	op
	mpc_rnd_t	rnd

void
Rmpc_set_default_rounding_mode (round)
	SV *	round
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	Rmpc_set_default_rounding_mode(round);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

SV *
Rmpc_get_default_rounding_mode ()

void
Rmpc_set_default_prec (prec)
	SV *	prec
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	Rmpc_set_default_prec(prec);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

void
Rmpc_set_default_prec2 (prec_re, prec_im)
	SV *	prec_re
	SV *	prec_im
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	Rmpc_set_default_prec2(prec_re, prec_im);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

SV *
Rmpc_get_default_prec ()

void
Rmpc_get_default_prec2 ()
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	Rmpc_get_default_prec2();
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

void
Rmpc_set_prec (p, prec)
	mpc_t *	p
	SV *	prec
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	Rmpc_set_prec(p, prec);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

void
Rmpc_set_re_prec (p, prec)
	mpc_t *	p
	SV *	prec
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	Rmpc_set_re_prec(p, prec);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

void
Rmpc_set_im_prec (p, prec)
	mpc_t *	p
	SV *	prec
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	Rmpc_set_im_prec(p, prec);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

SV *
Rmpc_get_prec (x)
	mpc_t *	x

void
Rmpc_get_prec2 (x)
	mpc_t *	x
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	Rmpc_get_prec2(x);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

SV *
Rmpc_get_im_prec (x)
	mpc_t *	x

SV *
Rmpc_get_re_prec (x)
	mpc_t *	x

void
RMPC_RE (fr, x)
	mpfr_t *	fr
	mpc_t *	x
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	RMPC_RE(fr, x);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

void
RMPC_IM (fr, x)
	mpfr_t *	fr
	mpc_t *	x
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	RMPC_IM(fr, x);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

SV *
RMPC_INEX_RE (x)
	SV *	x

SV *
RMPC_INEX_IM (x)
	SV *	x

void
DESTROY (p)
	mpc_t *	p
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	DESTROY(p);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

void
Rmpc_clear (p)
	mpc_t *	p
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	Rmpc_clear(p);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

void
Rmpc_clear_mpc (p)
	mpc_t *	p
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	Rmpc_clear_mpc(p);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

void
Rmpc_clear_ptr (p)
	mpc_t *	p
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	Rmpc_clear_ptr(p);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

SV *
Rmpc_init2 (prec)
	SV *	prec

SV *
Rmpc_init3 (prec_r, prec_i)
	SV *	prec_r
	SV *	prec_i

SV *
Rmpc_init2_nobless (prec)
	SV *	prec

SV *
Rmpc_init3_nobless (prec_r, prec_i)
	SV *	prec_r
	SV *	prec_i

SV *
Rmpc_set (p, q, round)
	mpc_t *	p
	mpc_t *	q
	SV *	round

SV *
Rmpc_set_ui (p, q, round)
	mpc_t *	p
	SV *	q
	SV *	round

SV *
Rmpc_set_si (p, q, round)
	mpc_t *	p
	SV *	q
	SV *	round

SV *
Rmpc_set_ld (p, q, round)
	mpc_t *	p
	SV *	q
	SV *	round

SV *
Rmpc_set_uj (p, q, round)
	mpc_t *	p
	SV *	q
	SV *	round

SV *
Rmpc_set_sj (p, q, round)
	mpc_t *	p
	SV *	q
	SV *	round

SV *
Rmpc_set_z (p, q, round)
	mpc_t *	p
	mpz_t *	q
	SV *	round

SV *
Rmpc_set_f (p, q, round)
	mpc_t *	p
	mpf_t *	q
	SV *	round

SV *
Rmpc_set_q (p, q, round)
	mpc_t *	p
	mpq_t *	q
	SV *	round

SV *
Rmpc_set_d (p, q, round)
	mpc_t *	p
	SV *	q
	SV *	round

SV *
Rmpc_set_fr (p, q, round)
	mpc_t *	p
	mpfr_t *	q
	SV *	round

SV *
Rmpc_set_ui_ui (p, q_r, q_i, round)
	mpc_t *	p
	SV *	q_r
	SV *	q_i
	SV *	round

SV *
Rmpc_set_si_si (p, q_r, q_i, round)
	mpc_t *	p
	SV *	q_r
	SV *	q_i
	SV *	round

SV *
Rmpc_set_d_d (p, q_r, q_i, round)
	mpc_t *	p
	SV *	q_r
	SV *	q_i
	SV *	round

SV *
Rmpc_set_ld_ld (mpc, ld1, ld2, round)
	mpc_t *	mpc
	SV *	ld1
	SV *	ld2
	SV *	round

SV *
Rmpc_set_z_z (p, q_r, q_i, round)
	mpc_t *	p
	mpz_t *	q_r
	mpz_t *	q_i
	SV *	round

SV *
Rmpc_set_q_q (p, q_r, q_i, round)
	mpc_t *	p
	mpq_t *	q_r
	mpq_t *	q_i
	SV *	round

SV *
Rmpc_set_f_f (p, q_r, q_i, round)
	mpc_t *	p
	mpf_t *	q_r
	mpf_t *	q_i
	SV *	round

SV *
Rmpc_set_fr_fr (p, q_r, q_i, round)
	mpc_t *	p
	mpfr_t *	q_r
	mpfr_t *	q_i
	SV *	round

int
Rmpc_set_d_ui (mpc, d, ui, round)
	mpc_t *	mpc
	SV *	d
	SV *	ui
	SV *	round

int
Rmpc_set_d_si (mpc, d, si, round)
	mpc_t *	mpc
	SV *	d
	SV *	si
	SV *	round

int
Rmpc_set_d_fr (mpc, d, mpfr, round)
	mpc_t *	mpc
	SV *	d
	mpfr_t *	mpfr
	SV *	round

int
Rmpc_set_ui_d (mpc, ui, d, round)
	mpc_t *	mpc
	SV *	ui
	SV *	d
	SV *	round

int
Rmpc_set_ui_si (mpc, ui, si, round)
	mpc_t *	mpc
	SV *	ui
	SV *	si
	SV *	round

int
Rmpc_set_ui_fr (mpc, ui, mpfr, round)
	mpc_t *	mpc
	SV *	ui
	mpfr_t *	mpfr
	SV *	round

int
Rmpc_set_si_d (mpc, si, d, round)
	mpc_t *	mpc
	SV *	si
	SV *	d
	SV *	round

int
Rmpc_set_si_ui (mpc, si, ui, round)
	mpc_t *	mpc
	SV *	si
	SV *	ui
	SV *	round

int
Rmpc_set_si_fr (mpc, si, mpfr, round)
	mpc_t *	mpc
	SV *	si
	mpfr_t *	mpfr
	SV *	round

int
Rmpc_set_fr_d (mpc, mpfr, d, round)
	mpc_t *	mpc
	mpfr_t *	mpfr
	SV *	d
	SV *	round

int
Rmpc_set_fr_ui (mpc, mpfr, ui, round)
	mpc_t *	mpc
	mpfr_t *	mpfr
	SV *	ui
	SV *	round

int
Rmpc_set_fr_si (mpc, mpfr, si, round)
	mpc_t *	mpc
	mpfr_t *	mpfr
	SV *	si
	SV *	round

int
Rmpc_set_ld_ui (mpc, d, ui, round)
	mpc_t *	mpc
	SV *	d
	SV *	ui
	SV *	round

int
Rmpc_set_ld_si (mpc, d, si, round)
	mpc_t *	mpc
	SV *	d
	SV *	si
	SV *	round

int
Rmpc_set_ld_fr (mpc, d, mpfr, round)
	mpc_t *	mpc
	SV *	d
	mpfr_t *	mpfr
	SV *	round

int
Rmpc_set_ui_ld (mpc, ui, d, round)
	mpc_t *	mpc
	SV *	ui
	SV *	d
	SV *	round

int
Rmpc_set_si_ld (mpc, si, d, round)
	mpc_t *	mpc
	SV *	si
	SV *	d
	SV *	round

int
Rmpc_set_fr_ld (mpc, mpfr, d, round)
	mpc_t *	mpc
	mpfr_t *	mpfr
	SV *	d
	SV *	round

int
Rmpc_set_d_uj (mpc, d, ui, round)
	mpc_t *	mpc
	SV *	d
	SV *	ui
	SV *	round

int
Rmpc_set_d_sj (mpc, d, si, round)
	mpc_t *	mpc
	SV *	d
	SV *	si
	SV *	round

int
Rmpc_set_sj_d (mpc, si, d, round)
	mpc_t *	mpc
	SV *	si
	SV *	d
	SV *	round

int
Rmpc_set_uj_d (mpc, ui, d, round)
	mpc_t *	mpc
	SV *	ui
	SV *	d
	SV *	round

int
Rmpc_set_uj_fr (mpc, ui, mpfr, round)
	mpc_t *	mpc
	SV *	ui
	mpfr_t *	mpfr
	SV *	round

int
Rmpc_set_sj_fr (mpc, si, mpfr, round)
	mpc_t *	mpc
	SV *	si
	mpfr_t *	mpfr
	SV *	round

int
Rmpc_set_fr_uj (mpc, mpfr, ui, round)
	mpc_t *	mpc
	mpfr_t *	mpfr
	SV *	ui
	SV *	round

int
Rmpc_set_fr_sj (mpc, mpfr, si, round)
	mpc_t *	mpc
	mpfr_t *	mpfr
	SV *	si
	SV *	round

int
Rmpc_set_uj_sj (mpc, ui, si, round)
	mpc_t *	mpc
	SV *	ui
	SV *	si
	SV *	round

int
Rmpc_set_sj_uj (mpc, si, ui, round)
	mpc_t *	mpc
	SV *	si
	SV *	ui
	SV *	round

int
Rmpc_set_ld_uj (mpc, d, ui, round)
	mpc_t *	mpc
	SV *	d
	SV *	ui
	SV *	round

int
Rmpc_set_ld_sj (mpc, d, si, round)
	mpc_t *	mpc
	SV *	d
	SV *	si
	SV *	round

int
Rmpc_set_uj_ld (mpc, ui, d, round)
	mpc_t *	mpc
	SV *	ui
	SV *	d
	SV *	round

int
Rmpc_set_sj_ld (mpc, si, d, round)
	mpc_t *	mpc
	SV *	si
	SV *	d
	SV *	round

int
Rmpc_set_f_ui (mpc, mpf, ui, round)
	mpc_t *	mpc
	mpf_t *	mpf
	SV *	ui
	SV *	round

int
Rmpc_set_q_ui (mpc, mpq, ui, round)
	mpc_t *	mpc
	mpq_t *	mpq
	SV *	ui
	SV *	round

int
Rmpc_set_z_ui (mpc, mpz, ui, round)
	mpc_t *	mpc
	mpz_t *	mpz
	SV *	ui
	SV *	round

int
Rmpc_set_f_si (mpc, mpf, si, round)
	mpc_t *	mpc
	mpf_t *	mpf
	SV *	si
	SV *	round

int
Rmpc_set_q_si (mpc, mpq, si, round)
	mpc_t *	mpc
	mpq_t *	mpq
	SV *	si
	SV *	round

int
Rmpc_set_z_si (mpc, mpz, si, round)
	mpc_t *	mpc
	mpz_t *	mpz
	SV *	si
	SV *	round

int
Rmpc_set_f_d (mpc, mpf, d, round)
	mpc_t *	mpc
	mpf_t *	mpf
	SV *	d
	SV *	round

int
Rmpc_set_q_d (mpc, mpq, d, round)
	mpc_t *	mpc
	mpq_t *	mpq
	SV *	d
	SV *	round

int
Rmpc_set_z_d (mpc, mpz, d, round)
	mpc_t *	mpc
	mpz_t *	mpz
	SV *	d
	SV *	round

int
Rmpc_set_f_uj (mpc, mpf, uj, round)
	mpc_t *	mpc
	mpf_t *	mpf
	SV *	uj
	SV *	round

int
Rmpc_set_q_uj (mpc, mpq, uj, round)
	mpc_t *	mpc
	mpq_t *	mpq
	SV *	uj
	SV *	round

int
Rmpc_set_z_uj (mpc, mpz, uj, round)
	mpc_t *	mpc
	mpz_t *	mpz
	SV *	uj
	SV *	round

int
Rmpc_set_f_sj (mpc, mpf, sj, round)
	mpc_t *	mpc
	mpf_t *	mpf
	SV *	sj
	SV *	round

int
Rmpc_set_q_sj (mpc, mpq, sj, round)
	mpc_t *	mpc
	mpq_t *	mpq
	SV *	sj
	SV *	round

int
Rmpc_set_z_sj (mpc, mpz, sj, round)
	mpc_t *	mpc
	mpz_t *	mpz
	SV *	sj
	SV *	round

int
Rmpc_set_f_ld (mpc, mpf, ld, round)
	mpc_t *	mpc
	mpf_t *	mpf
	SV *	ld
	SV *	round

int
Rmpc_set_q_ld (mpc, mpq, ld, round)
	mpc_t *	mpc
	mpq_t *	mpq
	SV *	ld
	SV *	round

int
Rmpc_set_z_ld (mpc, mpz, ld, round)
	mpc_t *	mpc
	mpz_t *	mpz
	SV *	ld
	SV *	round

int
Rmpc_set_ui_f (mpc, ui, mpf, round)
	mpc_t *	mpc
	SV *	ui
	mpf_t *	mpf
	SV *	round

int
Rmpc_set_ui_q (mpc, ui, mpq, round)
	mpc_t *	mpc
	SV *	ui
	mpq_t *	mpq
	SV *	round

int
Rmpc_set_ui_z (mpc, ui, mpz, round)
	mpc_t *	mpc
	SV *	ui
	mpz_t *	mpz
	SV *	round

int
Rmpc_set_si_f (mpc, si, mpf, round)
	mpc_t *	mpc
	SV *	si
	mpf_t *	mpf
	SV *	round

int
Rmpc_set_si_q (mpc, si, mpq, round)
	mpc_t *	mpc
	SV *	si
	mpq_t *	mpq
	SV *	round

int
Rmpc_set_si_z (mpc, si, mpz, round)
	mpc_t *	mpc
	SV *	si
	mpz_t *	mpz
	SV *	round

int
Rmpc_set_d_f (mpc, d, mpf, round)
	mpc_t *	mpc
	SV *	d
	mpf_t *	mpf
	SV *	round

int
Rmpc_set_d_q (mpc, d, mpq, round)
	mpc_t *	mpc
	SV *	d
	mpq_t *	mpq
	SV *	round

int
Rmpc_set_d_z (mpc, d, mpz, round)
	mpc_t *	mpc
	SV *	d
	mpz_t *	mpz
	SV *	round

int
Rmpc_set_uj_f (mpc, uj, mpf, round)
	mpc_t *	mpc
	SV *	uj
	mpf_t *	mpf
	SV *	round

int
Rmpc_set_uj_q (mpc, uj, mpq, round)
	mpc_t *	mpc
	SV *	uj
	mpq_t *	mpq
	SV *	round

int
Rmpc_set_uj_z (mpc, uj, mpz, round)
	mpc_t *	mpc
	SV *	uj
	mpz_t *	mpz
	SV *	round

int
Rmpc_set_sj_f (mpc, sj, mpf, round)
	mpc_t *	mpc
	SV *	sj
	mpf_t *	mpf
	SV *	round

int
Rmpc_set_sj_q (mpc, sj, mpq, round)
	mpc_t *	mpc
	SV *	sj
	mpq_t *	mpq
	SV *	round

int
Rmpc_set_sj_z (mpc, sj, mpz, round)
	mpc_t *	mpc
	SV *	sj
	mpz_t *	mpz
	SV *	round

int
Rmpc_set_ld_f (mpc, ld, mpf, round)
	mpc_t *	mpc
	SV *	ld
	mpf_t *	mpf
	SV *	round

int
Rmpc_set_ld_q (mpc, ld, mpq, round)
	mpc_t *	mpc
	SV *	ld
	mpq_t *	mpq
	SV *	round

int
Rmpc_set_ld_z (mpc, ld, mpz, round)
	mpc_t *	mpc
	SV *	ld
	mpz_t *	mpz
	SV *	round

int
Rmpc_set_f_q (mpc, mpf, mpq, round)
	mpc_t *	mpc
	mpf_t *	mpf
	mpq_t *	mpq
	SV *	round

int
Rmpc_set_q_f (mpc, mpq, mpf, round)
	mpc_t *	mpc
	mpq_t *	mpq
	mpf_t *	mpf
	SV *	round

int
Rmpc_set_f_z (mpc, mpf, mpz, round)
	mpc_t *	mpc
	mpf_t *	mpf
	mpz_t *	mpz
	SV *	round

int
Rmpc_set_z_f (mpc, mpz, mpf, round)
	mpc_t *	mpc
	mpz_t *	mpz
	mpf_t *	mpf
	SV *	round

int
Rmpc_set_q_z (mpc, mpq, mpz, round)
	mpc_t *	mpc
	mpq_t *	mpq
	mpz_t *	mpz
	SV *	round

int
Rmpc_set_z_q (mpc, mpz, mpq, round)
	mpc_t *	mpc
	mpz_t *	mpz
	mpq_t *	mpq
	SV *	round

int
Rmpc_set_f_fr (mpc, mpf, mpfr, round)
	mpc_t *	mpc
	mpf_t *	mpf
	mpfr_t *	mpfr
	SV *	round

int
Rmpc_set_fr_f (mpc, mpfr, mpf, round)
	mpc_t *	mpc
	mpfr_t *	mpfr
	mpf_t *	mpf
	SV *	round

int
Rmpc_set_q_fr (mpc, mpq, mpfr, round)
	mpc_t *	mpc
	mpq_t *	mpq
	mpfr_t *	mpfr
	SV *	round

int
Rmpc_set_fr_q (mpc, mpfr, mpq, round)
	mpc_t *	mpc
	mpfr_t *	mpfr
	mpq_t *	mpq
	SV *	round

int
Rmpc_set_z_fr (mpc, mpz, mpfr, round)
	mpc_t *	mpc
	mpz_t *	mpz
	mpfr_t *	mpfr
	SV *	round

int
Rmpc_set_fr_z (mpc, mpfr, mpz, round)
	mpc_t *	mpc
	mpfr_t *	mpfr
	mpz_t *	mpz
	SV *	round

SV *
Rmpc_set_uj_uj (mpc, uj1, uj2, round)
	mpc_t *	mpc
	SV *	uj1
	SV *	uj2
	SV *	round

SV *
Rmpc_set_sj_sj (mpc, sj1, sj2, round)
	mpc_t *	mpc
	SV *	sj1
	SV *	sj2
	SV *	round

SV *
Rmpc_add (a, b, c, round)
	mpc_t *	a
	mpc_t *	b
	mpc_t *	c
	SV *	round

SV *
Rmpc_add_ui (a, b, c, round)
	mpc_t *	a
	mpc_t *	b
	SV *	c
	SV *	round

SV *
Rmpc_add_fr (a, b, c, round)
	mpc_t *	a
	mpc_t *	b
	mpfr_t *	c
	SV *	round

SV *
Rmpc_sub (a, b, c, round)
	mpc_t *	a
	mpc_t *	b
	mpc_t *	c
	SV *	round

SV *
Rmpc_sub_ui (a, b, c, round)
	mpc_t *	a
	mpc_t *	b
	SV *	c
	SV *	round

SV *
Rmpc_ui_sub (a, b, c, round)
	mpc_t *	a
	SV *	b
	mpc_t *	c
	SV *	round

SV *
Rmpc_ui_ui_sub (a, b_r, b_i, c, round)
	mpc_t *	a
	SV *	b_r
	SV *	b_i
	mpc_t *	c
	SV *	round

SV *
Rmpc_mul (a, b, c, round)
	mpc_t *	a
	mpc_t *	b
	mpc_t *	c
	SV *	round

SV *
Rmpc_mul_ui (a, b, c, round)
	mpc_t *	a
	mpc_t *	b
	SV *	c
	SV *	round

SV *
Rmpc_mul_si (a, b, c, round)
	mpc_t *	a
	mpc_t *	b
	SV *	c
	SV *	round

SV *
Rmpc_mul_fr (a, b, c, round)
	mpc_t *	a
	mpc_t *	b
	mpfr_t *	c
	SV *	round

SV *
Rmpc_mul_i (a, b, sign, round)
	mpc_t *	a
	mpc_t *	b
	SV *	sign
	SV *	round

SV *
Rmpc_sqr (a, b, round)
	mpc_t *	a
	mpc_t *	b
	SV *	round

SV *
Rmpc_div (a, b, c, round)
	mpc_t *	a
	mpc_t *	b
	mpc_t *	c
	SV *	round

SV *
Rmpc_div_ui (a, b, c, round)
	mpc_t *	a
	mpc_t *	b
	SV *	c
	SV *	round

SV *
Rmpc_ui_div (a, b, c, round)
	mpc_t *	a
	SV *	b
	mpc_t *	c
	SV *	round

SV *
Rmpc_div_fr (a, b, c, round)
	mpc_t *	a
	mpc_t *	b
	mpfr_t *	c
	SV *	round

SV *
Rmpc_sqrt (a, b, round)
	mpc_t *	a
	mpc_t *	b
	SV *	round

SV *
Rmpc_pow (a, b, pow, round)
	mpc_t *	a
	mpc_t *	b
	mpc_t *	pow
	SV *	round

SV *
Rmpc_pow_d (a, b, pow, round)
	mpc_t *	a
	mpc_t *	b
	SV *	pow
	SV *	round

SV *
Rmpc_pow_ld (a, b, pow, round)
	mpc_t *	a
	mpc_t *	b
	SV *	pow
	SV *	round

SV *
Rmpc_pow_si (a, b, pow, round)
	mpc_t *	a
	mpc_t *	b
	SV *	pow
	SV *	round

SV *
Rmpc_pow_ui (a, b, pow, round)
	mpc_t *	a
	mpc_t *	b
	SV *	pow
	SV *	round

SV *
Rmpc_pow_z (a, b, pow, round)
	mpc_t *	a
	mpc_t *	b
	mpz_t *	pow
	SV *	round

SV *
Rmpc_pow_fr (a, b, pow, round)
	mpc_t *	a
	mpc_t *	b
	mpfr_t *	pow
	SV *	round

SV *
Rmpc_neg (a, b, round)
	mpc_t *	a
	mpc_t *	b
	SV *	round

SV *
Rmpc_abs (a, b, round)
	mpfr_t *	a
	mpc_t *	b
	SV *	round

SV *
Rmpc_conj (a, b, round)
	mpc_t *	a
	mpc_t *	b
	SV *	round

SV *
Rmpc_norm (a, b, round)
	mpfr_t *	a
	mpc_t *	b
	SV *	round

SV *
Rmpc_mul_2exp (a, b, c, round)
	mpc_t *	a
	mpc_t *	b
	SV *	c
	SV *	round

SV *
Rmpc_div_2exp (a, b, c, round)
	mpc_t *	a
	mpc_t *	b
	SV *	c
	SV *	round

SV *
Rmpc_cmp (a, b)
	mpc_t *	a
	mpc_t *	b

SV *
Rmpc_cmp_si (a, b)
	mpc_t *	a
	SV *	b

SV *
Rmpc_cmp_si_si (a, b, c)
	mpc_t *	a
	SV *	b
	SV *	c

SV *
Rmpc_exp (a, b, round)
	mpc_t *	a
	mpc_t *	b
	SV *	round

SV *
Rmpc_log (rop, op, round)
	mpc_t *	rop
	mpc_t *	op
	SV *	round

SV *
_Rmpc_out_str (stream, base, dig, p, round)
	FILE *	stream
	SV *	base
	SV *	dig
	mpc_t *	p
	SV *	round

SV *
_Rmpc_out_strS (stream, base, dig, p, round, suff)
	FILE *	stream
	SV *	base
	SV *	dig
	mpc_t *	p
	SV *	round
	SV *	suff

SV *
_Rmpc_out_strP (pre, stream, base, dig, p, round)
	SV *	pre
	FILE *	stream
	SV *	base
	SV *	dig
	mpc_t *	p
	SV *	round

SV *
_Rmpc_out_strPS (pre, stream, base, dig, p, round, suff)
	SV *	pre
	FILE *	stream
	SV *	base
	SV *	dig
	mpc_t *	p
	SV *	round
	SV *	suff

SV *
Rmpc_inp_str (p, stream, base, round)
	mpc_t *	p
	FILE *	stream
	SV *	base
	SV *	round

SV *
Rmpc_sin (rop, op, round)
	mpc_t *	rop
	mpc_t *	op
	SV *	round

SV *
Rmpc_cos (rop, op, round)
	mpc_t *	rop
	mpc_t *	op
	SV *	round

SV *
Rmpc_tan (rop, op, round)
	mpc_t *	rop
	mpc_t *	op
	SV *	round

SV *
Rmpc_sinh (rop, op, round)
	mpc_t *	rop
	mpc_t *	op
	SV *	round

SV *
Rmpc_cosh (rop, op, round)
	mpc_t *	rop
	mpc_t *	op
	SV *	round

SV *
Rmpc_tanh (rop, op, round)
	mpc_t *	rop
	mpc_t *	op
	SV *	round

SV *
Rmpc_asin (rop, op, round)
	mpc_t *	rop
	mpc_t *	op
	SV *	round

SV *
Rmpc_acos (rop, op, round)
	mpc_t *	rop
	mpc_t *	op
	SV *	round

SV *
Rmpc_atan (rop, op, round)
	mpc_t *	rop
	mpc_t *	op
	SV *	round

SV *
Rmpc_asinh (rop, op, round)
	mpc_t *	rop
	mpc_t *	op
	SV *	round

SV *
Rmpc_acosh (rop, op, round)
	mpc_t *	rop
	mpc_t *	op
	SV *	round

SV *
Rmpc_atanh (rop, op, round)
	mpc_t *	rop
	mpc_t *	op
	SV *	round

SV *
overload_true (a, second, third)
	mpc_t *	a
	SV *	second
	SV *	third

SV *
overload_mul (a, b, third)
	mpc_t *	a
	SV *	b
	SV *	third

SV *
overload_add (a, b, third)
	mpc_t *	a
	SV *	b
	SV *	third

SV *
overload_sub (a, b, third)
	mpc_t *	a
	SV *	b
	SV *	third

SV *
overload_div (a, b, third)
	mpc_t *	a
	SV *	b
	SV *	third

SV *
overload_div_eq (a, b, third)
	SV *	a
	SV *	b
	SV *	third

SV *
overload_sub_eq (a, b, third)
	SV *	a
	SV *	b
	SV *	third

SV *
overload_add_eq (a, b, third)
	SV *	a
	SV *	b
	SV *	third

SV *
overload_mul_eq (a, b, third)
	SV *	a
	SV *	b
	SV *	third

SV *
overload_pow (a, b, third)
	mpc_t *	a
	SV *	b
	SV *	third

SV *
overload_pow_eq (a, b, third)
	SV *	a
	SV *	b
	SV *	third

SV *
overload_equiv (a, b, third)
	mpc_t *	a
	SV *	b
	SV *	third

SV *
overload_not_equiv (a, b, third)
	mpc_t *	a
	SV *	b
	SV *	third

SV *
overload_not (a, second, third)
	mpc_t *	a
	SV *	second
	SV *	third

SV *
overload_sqrt (p, second, third)
	mpc_t *	p
	SV *	second
	SV *	third

void
overload_copy (p, second, third)
	mpc_t *	p
	SV *	second
	SV *	third
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	overload_copy(p, second, third);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

SV *
overload_abs (p, second, third)
	mpc_t *	p
	SV *	second
	SV *	third

SV *
overload_exp (p, second, third)
	mpc_t *	p
	SV *	second
	SV *	third

SV *
overload_log (p, second, third)
	mpc_t *	p
	SV *	second
	SV *	third

SV *
overload_sin (p, second, third)
	mpc_t *	p
	SV *	second
	SV *	third

SV *
overload_cos (p, second, third)
	mpc_t *	p
	SV *	second
	SV *	third

void
_get_r_string (p, base, n_digits, round)
	mpc_t *	p
	SV *	base
	SV *	n_digits
	SV *	round
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	_get_r_string(p, base, n_digits, round);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

void
_get_i_string (p, base, n_digits, round)
	mpc_t *	p
	SV *	base
	SV *	n_digits
	SV *	round
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	_get_i_string(p, base, n_digits, round);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

SV *
_itsa (a)
	SV *	a

SV *
_new_real (b)
	SV *	b

SV *
_new_im (b)
	SV *	b

int
_has_longlong ()

int
_has_longdouble ()

int
_has_inttypes ()

SV *
gmp_v ()

SV *
mpfr_v ()

SV *
_MPC_VERSION_MAJOR ()

SV *
_MPC_VERSION_MINOR ()

SV *
_MPC_VERSION_PATCHLEVEL ()

SV *
_MPC_VERSION ()

SV *
_MPC_VERSION_NUM (x, y, z)
	SV *	x
	SV *	y
	SV *	z

SV *
_MPC_VERSION_STRING ()

SV *
Rmpc_get_version ()

SV *
Rmpc_real (rop, op, round)
	mpfr_t *	rop
	mpc_t *	op
	SV *	round

SV *
Rmpc_imag (rop, op, round)
	mpfr_t *	rop
	mpc_t *	op
	SV *	round

SV *
Rmpc_arg (rop, op, round)
	mpfr_t *	rop
	mpc_t *	op
	SV *	round

SV *
Rmpc_proj (rop, op, round)
	mpc_t *	rop
	mpc_t *	op
	SV *	round

SV *
Rmpc_get_str (base, dig, op, round)
	SV *	base
	SV *	dig
	mpc_t *	op
	SV *	round

SV *
Rmpc_set_str (rop, str, base, round)
	mpc_t *	rop
	SV *	str
	SV *	base
	SV *	round

SV *
Rmpc_strtoc (rop, str, base, round)
	mpc_t *	rop
	SV *	str
	SV *	base
	SV *	round

void
Rmpc_set_nan (a)
	mpc_t *	a
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	Rmpc_set_nan(a);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

void
Rmpc_swap (a, b)
	mpc_t *	a
	mpc_t *	b
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	Rmpc_swap(a, b);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

SV *
overload_atan2 (p, q, third)
	mpc_t *	p
	mpc_t *	q
	SV *	third

SV *
Rmpc_sin_cos (rop_sin, rop_cos, op, rnd_sin, rnd_cos)
	mpc_t *	rop_sin
	mpc_t *	rop_cos
	mpc_t *	op
	SV *	rnd_sin
	SV *	rnd_cos

void
Rmpc_get_dc (crop, op, round)
	SV *	crop
	mpc_t *	op
	SV *	round
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	Rmpc_get_dc(crop, op, round);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

void
Rmpc_get_ldc (crop, op, round)
	SV *	crop
	mpc_t *	op
	SV *	round
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	Rmpc_get_ldc(crop, op, round);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

SV *
Rmpc_set_dc (op, crop, round)
	mpc_t *	op
	SV *	crop
	SV *	round

SV *
Rmpc_set_ldc (op, crop, round)
	mpc_t *	op
	SV *	crop
	SV *	round

SV *
_have_Complex_h ()

SV *
_mpfr_buildopt_tls_p ()

SV *
get_xs_version ()

void
CLONE (x, ...)
	SV *	x
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	CLONE(x);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

BOOT:

  {
  MY_CXT_INIT;
  MY_CXT._perl_default_prec_re = 53;
  MY_CXT._perl_default_prec_im = 53;
  MY_CXT._perl_default_rounding_mode = 0;
  }

