#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "INLINE.h"
#include <stdio.h>
#include <gmp.h>
#include <mpfr.h>
#include <mpc.h>

#ifdef _MSC_VER
#pragma warning(disable:4700 4715 4716)
#endif

#if defined USE_64_BIT_INT || defined USE_LONG_DOUBLE
#ifndef _MSC_VER
#include <inttypes.h>
#endif
#endif

#ifdef OLDPERL
#define SvUOK SvIsUV
#endif

mpc_rnd_t _perl_default_rounding_mode = MPC_RNDNN;

void Rmpc_set_default_rounding_mode(SV * round) {
     _perl_default_rounding_mode = SvUV(round);    
}

SV * Rmpc_get_default_rounding_mode() {
     return newSViv(_perl_default_rounding_mode);
}

void Rmpc_set_default_prec(SV * prec) {
     mpc_set_default_prec(SvUV(prec));
} 

SV * Rmpc_get_default_prec() {
     return newSVuv(mpc_get_default_prec());
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
     Inline_Stack_Vars;
     mp_prec_t re, im;
     mpc_get_prec2(&re, &im, *x);
     Inline_Stack_Reset;
     Inline_Stack_Push(sv_2mortal(newSVuv(re)));
     Inline_Stack_Push(sv_2mortal(newSVuv(im)));
     Inline_Stack_Done;
     Inline_Stack_Return(2);
}

SV * Rmpc_get_im_prec(mpc_t * x) {
     return newSVuv(mpfr_get_prec(MPC_IM(*x)));
}

SV * Rmpc_get_re_prec(mpc_t * x) {
     return newSVuv(mpfr_get_prec(MPC_RE(*x)));
}

void RMPC_RE(mpfr_t * fr, mpc_t * x, SV * round) {
     mp_prec_t precision = mpfr_get_prec(MPC_RE(*x));
     mpfr_set_prec(*fr, precision);
     mpfr_set(*fr, MPC_RE(*x), SvUV(round) & 3);
}

void RMPC_IM(mpfr_t * fr, mpc_t * x, SV * round) {
     mp_prec_t precision = mpfr_get_prec(MPC_IM(*x));
     mpfr_set_prec(*fr, precision);
     mpfr_set(*fr, MPC_IM(*x), SvUV(round) / 16);
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

SV * Rmpc_init() {
     mpc_t * mpc_t_obj;
     SV * obj_ref, * obj;

     New(1, mpc_t_obj, 1, mpc_t);
     if(mpc_t_obj == NULL) croak("Failed to allocate memory in Rmpc_init function");
     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, "Math::MPC");
     mpc_init(*mpc_t_obj);

     sv_setiv(obj, INT2PTR(IV,mpc_t_obj));
     SvREADONLY_on(obj);
     return obj_ref;
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
     if(mpc_t_obj == NULL) croak("Failed to allocate memory in Rmpc_init2 function");
     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, "Math::MPC");
     mpc_init3 (*mpc_t_obj, SvUV(prec_r), SvUV(prec_i));

     sv_setiv(obj, INT2PTR(IV,mpc_t_obj));
     SvREADONLY_on(obj);
     return obj_ref;
}

SV * Rmpc_init_nobless() {
     mpc_t * mpc_t_obj;
     SV * obj_ref, * obj;

     New(1, mpc_t_obj, 1, mpc_t);
     if(mpc_t_obj == NULL) croak("Failed to allocate memory in Rmpc_init_nobless function");
     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, NULL);
     mpc_init(*mpc_t_obj);

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
     if(mpc_t_obj == NULL) croak("Failed to allocate memory in Rmpc_init2_nobless function");
     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, NULL);
     mpc_init3 (*mpc_t_obj, SvUV(prec_r), SvUV(prec_i));

     sv_setiv(obj, INT2PTR(IV,mpc_t_obj));
     SvREADONLY_on(obj);
     return obj_ref;
}

void Rmpc_init_set(mpc_t * q, SV * round) {
     Inline_Stack_Vars;
     mpc_t * mpc_t_obj;
     SV * obj_ref, * obj;
     int ret;

     Inline_Stack_Reset;

     New(1, mpc_t_obj, 1, mpc_t);
     if(mpc_t_obj == NULL) croak("Failed to allocate memory in Rmpc_init_set function");
     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, "Math::MPC");
     ret = mpc_init_set(*mpc_t_obj, *q, SvUV(round));

     sv_setiv(obj, INT2PTR(IV,mpc_t_obj));
     SvREADONLY_on(obj);
     Inline_Stack_Push(sv_2mortal(obj_ref));
     Inline_Stack_Push(sv_2mortal(newSViv(ret)));
     Inline_Stack_Done;
     Inline_Stack_Return(2);
}

void Rmpc_init_set_ui(SV * q, SV * round) {
     Inline_Stack_Vars;
     mpc_t * mpc_t_obj;
     SV * obj_ref, * obj;
     int ret;

     Inline_Stack_Reset;

     New(1, mpc_t_obj, 1, mpc_t);
     if(mpc_t_obj == NULL) croak("Failed to allocate memory in Rmpc_init_set_ui function");
     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, "Math::MPC");
     mpc_init(*mpc_t_obj);
     ret = mpc_set_ui(*mpc_t_obj, SvUV(q), SvUV(round));

     sv_setiv(obj, INT2PTR(IV,mpc_t_obj));
     SvREADONLY_on(obj);
     Inline_Stack_Push(sv_2mortal(obj_ref));
     Inline_Stack_Push(sv_2mortal(newSViv(ret)));
     Inline_Stack_Done;
     Inline_Stack_Return(2);
}

void Rmpc_init_set_ui_ui(SV * q_r, SV * q_i, SV * round) {
     Inline_Stack_Vars;
     mpc_t * mpc_t_obj;
     SV * obj_ref, * obj;
     int ret;

     Inline_Stack_Reset;

     New(1, mpc_t_obj, 1, mpc_t);
     if(mpc_t_obj == NULL) croak("Failed to allocate memory in Rmpc_init_set_ui_ui function");
     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, "Math::MPC");
     ret = mpc_init_set_ui_ui(*mpc_t_obj, SvUV(q_r), SvUV(q_i), SvUV(round));

     sv_setiv(obj, INT2PTR(IV,mpc_t_obj));
     SvREADONLY_on(obj);
     Inline_Stack_Push(sv_2mortal(obj_ref));
     Inline_Stack_Push(sv_2mortal(newSViv(ret)));
     Inline_Stack_Done;
     Inline_Stack_Return(2);
}

void Rmpc_init_set_si_si(SV * q_r, SV * q_i, SV * round) {
     Inline_Stack_Vars;
     mpc_t * mpc_t_obj;
     SV * obj_ref, * obj;
     int ret;

     Inline_Stack_Reset;

     New(1, mpc_t_obj, 1, mpc_t);
     if(mpc_t_obj == NULL) croak("Failed to allocate memory in Rmpc_init_set_si_si function");
     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, "Math::MPC");
     ret = mpc_init_set_si_si(*mpc_t_obj, SvIV(q_r), SvIV(q_i), SvUV(round));

     sv_setiv(obj, INT2PTR(IV,mpc_t_obj));
     SvREADONLY_on(obj);
     Inline_Stack_Push(sv_2mortal(obj_ref));
     Inline_Stack_Push(sv_2mortal(newSViv(ret)));
     Inline_Stack_Done;
     Inline_Stack_Return(2);
}

void Rmpc_init_set_ui_fr(SV * q_r, mpfr_t * q_i, SV * round) {
     Inline_Stack_Vars;
     mpc_t * mpc_t_obj;
     SV * obj_ref, * obj;
     int ret;

     Inline_Stack_Reset;

     New(1, mpc_t_obj, 1, mpc_t);
     if(mpc_t_obj == NULL) croak("Failed to allocate memory in Rmpc_init_set_ui_fr function");
     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, "Math::MPC");
     ret = mpc_init_set_ui_fr(*mpc_t_obj, SvUV(q_r), * q_i, SvUV(round));

     sv_setiv(obj, INT2PTR(IV,mpc_t_obj));
     SvREADONLY_on(obj);
     Inline_Stack_Push(sv_2mortal(obj_ref));
     Inline_Stack_Push(sv_2mortal(newSViv(ret)));
     Inline_Stack_Done;
     Inline_Stack_Return(2);
}

void Rmpc_init_set_nobless(mpc_t * q, SV * round) {
     Inline_Stack_Vars;
     mpc_t * mpc_t_obj;
     SV * obj_ref, * obj;
     int ret;

     Inline_Stack_Reset;

     New(1, mpc_t_obj, 1, mpc_t);
     if(mpc_t_obj == NULL) croak("Failed to allocate memory in Rmpc_init_set_nobless function");
     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, NULL);
     ret = mpc_init_set(*mpc_t_obj, *q, SvUV(round));

     sv_setiv(obj, INT2PTR(IV,mpc_t_obj));
     SvREADONLY_on(obj);
     Inline_Stack_Push(sv_2mortal(obj_ref));
     Inline_Stack_Push(sv_2mortal(newSViv(ret)));
     Inline_Stack_Done;
     Inline_Stack_Return(2);
}

void Rmpc_init_set_ui_nobless(SV * q, SV * round) {
     Inline_Stack_Vars;
     mpc_t * mpc_t_obj;
     SV * obj_ref, * obj;
     int ret;

     Inline_Stack_Reset;

     New(1, mpc_t_obj, 1, mpc_t);
     if(mpc_t_obj == NULL) croak("Failed to allocate memory in Rmpc_init_set_ui_nobless function");
     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, NULL);
     mpc_init(*mpc_t_obj);
     ret = mpc_set_ui(*mpc_t_obj, SvUV(q), SvUV(round));

     sv_setiv(obj, INT2PTR(IV,mpc_t_obj));
     SvREADONLY_on(obj);
     Inline_Stack_Push(sv_2mortal(obj_ref));
     Inline_Stack_Push(sv_2mortal(newSViv(ret)));
     Inline_Stack_Done;
     Inline_Stack_Return(2);
}

void Rmpc_init_set_ui_ui_nobless(SV * q_r, SV * q_i, SV * round) {
     Inline_Stack_Vars;
     mpc_t * mpc_t_obj;
     SV * obj_ref, * obj;
     int ret;

     Inline_Stack_Reset;

     New(1, mpc_t_obj, 1, mpc_t);
     if(mpc_t_obj == NULL) croak("Failed to allocate memory in Rmpc_init_set_ui_ui_nobless function");
     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, NULL);
     ret = mpc_init_set_ui_ui(*mpc_t_obj, SvUV(q_r), SvUV(q_i), SvUV(round));

     sv_setiv(obj, INT2PTR(IV,mpc_t_obj));
     SvREADONLY_on(obj);
     Inline_Stack_Push(sv_2mortal(obj_ref));
     Inline_Stack_Push(sv_2mortal(newSViv(ret)));
     Inline_Stack_Done;
     Inline_Stack_Return(2);
}

void Rmpc_init_set_si_si_nobless(SV * q_r, SV * q_i, SV * round) {
     Inline_Stack_Vars;
     mpc_t * mpc_t_obj;
     SV * obj_ref, * obj;
     int ret;

     Inline_Stack_Reset;

     New(1, mpc_t_obj, 1, mpc_t);
     if(mpc_t_obj == NULL) croak("Failed to allocate memory in Rmpc_init_set_si_si_nobless function");
     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, NULL);
     ret = mpc_init_set_si_si(*mpc_t_obj, SvIV(q_r), SvIV(q_i), SvUV(round));

     sv_setiv(obj, INT2PTR(IV,mpc_t_obj));
     SvREADONLY_on(obj);
     Inline_Stack_Push(sv_2mortal(obj_ref));
     Inline_Stack_Push(sv_2mortal(newSViv(ret)));
     Inline_Stack_Done;
     Inline_Stack_Return(2);
}

void Rmpc_init_set_ui_fr_nobless(SV * q_r, mpfr_t * q_i, SV * round) {
     Inline_Stack_Vars;
     mpc_t * mpc_t_obj;
     SV * obj_ref, * obj;
     int ret;

     Inline_Stack_Reset;

     New(1, mpc_t_obj, 1, mpc_t);
     if(mpc_t_obj == NULL) croak("Failed to allocate memory in Rmpc_init_set_ui_fr_nobless function");
     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, NULL);
     ret = mpc_init_set_ui_fr(*mpc_t_obj, SvUV(q_r), * q_i, SvUV(round));

     sv_setiv(obj, INT2PTR(IV,mpc_t_obj));
     SvREADONLY_on(obj);
     Inline_Stack_Push(sv_2mortal(obj_ref));
     Inline_Stack_Push(sv_2mortal(newSViv(ret)));
     Inline_Stack_Done;
     Inline_Stack_Return(2);
}

SV * Rmpc_set(mpc_t * p, mpc_t * q, SV * round) {
     return newSViv(mpc_set(*p, *q, SvUV(round)));
}

SV * Rmpc_set_ui(mpc_t * p, SV * q, SV * round) {
     return newSViv(mpc_set_ui(*p, SvUV(q), SvUV(round)));
}

SV * Rmpc_set_si(mpc_t * p, SV * q, SV * round) {
     return newSViv(mpc_set_si(*p, SvIV(q), SvUV(round)));
}

SV * Rmpc_set_d(mpc_t * p, SV * q, SV * round) {
     return newSViv(mpc_set_d(*p, SvNV(q), SvUV(round)));
}

SV * Rmpc_set_ui_ui(mpc_t * p, SV * q_r, SV * q_i, SV * round) {
     return newSViv(mpc_set_ui_ui(*p, SvUV(q_r), SvUV(q_i), SvUV(round)));
}

SV * Rmpc_set_si_si(mpc_t * p, SV * q_r, SV * q_i, SV * round) {
     return newSViv(mpc_set_si_si(*p, SvIV(q_r), SvIV(q_i), SvUV(round)));
}

SV * Rmpc_set_d_d(mpc_t * p, SV * q_r, SV * q_i, SV * round) {
     return newSViv(mpc_set_d_d(*p, SvNV(q_r), SvNV(q_i), SvUV(round)));
}

SV * Rmpc_set_ui_fr(mpc_t * p, SV * q_r, mpfr_t * q_i, SV * round) {
     return newSViv(mpc_set_ui_fr(*p, SvUV(q_r), *q_i, SvUV(round)));
}

void Rmpc_set_uj_uj(mpc_t * a, SV * uj1, SV * uj2, SV * round) {
     mpfr_t temp;
     mpfr_init2(temp, mpfr_get_prec(MPC_IM(*a)));
#ifdef _MSC_VER
     mpfr_set_str(temp, SvPV_nolen(uj2), 10, SvUV(round) / 16);
#else
     mpfr_set_uj(temp, SvUV(uj2), SvUV(round) / 16);
#endif
     mpc_set_ui_fr(*a, 0, temp, SvUV(round));
     mpfr_set_prec(temp, mpfr_get_prec(MPC_RE(*a)));
#ifdef _MSC_VER
     mpfr_set_str(temp, SvPV_nolen(uj1), 10, SvUV(round) / 16);
#else
     mpfr_set_uj(temp, SvUV(uj1), SvUV(round) & 3);
#endif
     mpc_add_fr(*a, *a, temp, SvUV(round));
     mpfr_clear(temp);
}

void Rmpc_set_sj_sj(mpc_t * a, SV * sj1, SV * sj2, SV * round) {
     mpfr_t temp;
     mpfr_init2(temp, mpfr_get_prec(MPC_IM(*a)));
#ifdef _MSC_VER
     mpfr_set_str(temp, SvPV_nolen(sj2), 10, SvUV(round) / 16);
#else
     mpfr_set_sj(temp, SvIV(sj2), SvUV(round) / 16);
#endif
     mpc_set_ui_fr(*a, 0, temp, SvUV(round));
     mpfr_set_prec(temp, mpfr_get_prec(MPC_RE(*a)));
#ifdef _MSC_VER
     mpfr_set_str(temp, SvPV_nolen(sj1), 10, SvUV(round) / 16);
#else
     mpfr_set_sj(temp, SvIV(sj1), SvUV(round) & 3);
#endif
     mpc_add_fr(*a, *a, temp, SvUV(round));
     mpfr_clear(temp);
}

void Rmpc_set_ld_ld(mpc_t * a, SV * ld1, SV * ld2, SV * round) {
     mpfr_t temp;
     mpfr_init2(temp, mpfr_get_prec(MPC_IM(*a)));
     mpfr_set_ld(temp, SvNV(ld2), SvUV(round) / 16);
     mpc_set_ui_fr(*a, 0, temp, SvUV(round));
     mpfr_set_prec(temp, mpfr_get_prec(MPC_RE(*a)));
     mpfr_set_ld(temp, SvNV(ld1), SvUV(round) & 3);
     mpc_add_fr(*a, *a, temp, SvUV(round));
     mpfr_clear(temp);
}

void Rmpc_set_fr_fr(mpc_t * a, mpfr_t * fr1, mpfr_t * fr2, SV * round) {
     mpc_set_ui_fr(*a, 0, *fr2, SvUV(round));
     mpc_add_fr(*a, *a, *fr1, SvUV(round));
}

SV * Rmpc_add(mpc_t * a, mpc_t * b, mpc_t * c, SV * round) {
     return newSViv(mpc_add(*a, *b, *c, SvUV(round)));
}

SV * Rmpc_add_ui(mpc_t * a, mpc_t * b, SV * c, SV * round){
     return newSViv(mpc_add_ui(*a, *b, SvUV(c), SvUV(round)));
}

SV * Rmpc_add_fr(mpc_t * a, mpc_t * b, mpfr_t * c, SV * round){
     return newSViv(mpc_add_fr(*a, *b, *c, SvUV(round)));
}

SV * Rmpc_sub(mpc_t * a, mpc_t * b, mpc_t * c, SV * round) {
     return newSViv(mpc_sub(*a, *b, *c, SvUV(round)));
}

SV * Rmpc_sub_ui(mpc_t * a, mpc_t * b, SV * c, SV * round) {
     return newSViv(mpc_sub_ui(*a, *b, SvUV(c), SvUV(round)));
}

SV * Rmpc_ui_sub(mpc_t * a, SV * b, mpc_t * c, SV * round) {
     return newSViv(mpc_ui_sub(*a, SvUV(b), *c, SvUV(round)));
}

SV * Rmpc_ui_ui_sub(mpc_t * a, SV * b_r, SV * b_i, mpc_t * c, SV * round) {
     return newSViv(mpc_ui_ui_sub(*a, SvUV(b_r), SvUV(b_i), *c, SvUV(round)));
}

SV * Rmpc_mul(mpc_t * a, mpc_t * b, mpc_t * c, SV * round) {
     return newSViv(mpc_mul(*a, *b, *c, SvUV(round)));
}

SV * Rmpc_mul_ui(mpc_t * a, mpc_t * b, SV * c, SV * round){
     return newSViv(mpc_mul_ui(*a, *b, SvUV(c), SvUV(round)));
}

SV * Rmpc_mul_si(mpc_t * a, mpc_t * b, SV * c, SV * round){
     return newSViv(mpc_mul_si(*a, *b, SvIV(c), SvUV(round)));
}

SV * Rmpc_mul_fr(mpc_t * a, mpc_t * b, mpfr_t * c, SV * round){
     return newSViv(mpc_mul_fr(*a, *b, *c, SvUV(round)));
}

SV * Rmpc_mul_i(mpc_t * a, mpc_t * b, SV * sign, SV * round){
     return newSViv(mpc_mul_i(*a, *b, SvIV(sign), SvUV(round)));
}

SV * Rmpc_sqr(mpc_t * a, mpc_t * b, SV * round) {
     return newSViv(mpc_sqr(*a, *b, SvUV(round)));
}

SV * Rmpc_div(mpc_t * a, mpc_t * b, mpc_t * c, SV * round) {
     return newSViv(mpc_div(*a, *b, *c, SvUV(round)));
}

SV * Rmpc_div_ui(mpc_t * a, mpc_t * b, SV * c, SV * round){
     return newSViv(mpc_div_ui(*a, *b, SvUV(c), SvUV(round)));
}

SV * Rmpc_ui_div(mpc_t * a, SV * b, mpc_t * c, SV * round) {
     return newSViv(mpc_ui_div(*a, SvUV(b), *c, SvUV(round)));
}

SV * Rmpc_div_fr(mpc_t * a, mpc_t * b, mpfr_t * c, SV * round){
     return newSViv(mpc_div_fr(*a, *b, *c, SvUV(round)));
}

SV * Rmpc_sqrt(mpc_t * a, mpc_t * b, SV * round) {
     return newSViv(mpc_sqrt(*a, *b, SvUV(round)));
}

SV * Rmpc_neg(mpc_t * a, mpc_t * b, SV * round) {
     return newSViv(mpc_neg(*a, *b, SvUV(round)));
}

SV * Rmpc_abs(mpfr_t * a, mpc_t * b, SV * round) {
     return newSViv(mpc_abs(*a, *b, SvUV(round)));
}

SV * Rmpc_conj(mpc_t * a, mpc_t * b, SV * round) {
     return newSViv(mpc_conj(*a, *b, SvUV(round)));
}

SV * Rmpc_norm(mpfr_t * a, mpc_t * b, SV * round) {
     return newSViv(mpc_norm(*a, *b, SvUV(round)));
}

SV * Rmpc_mul_2exp(mpc_t * a, mpc_t * b, SV * c, SV * round) {
     return newSViv(mpc_mul_2exp(*a, *b, SvUV(c), SvUV(round)));
}

SV * Rmpc_div_2exp(mpc_t * a, mpc_t * b, SV * c, SV * round) {
     return newSViv(mpc_div_2exp(*a, *b, SvUV(c), SvUV(round)));
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

void Rmpc_exp(mpc_t * a, mpc_t * b, SV * round) {
     mpc_exp(*a, *b, SvUV(round));
}

SV * _Rmpc_out_str(FILE * stream, SV * base, SV * dig, mpc_t * p, SV * round) {
     size_t ret;
     if(SvIV(base) < 2 || SvIV(base) > 36) croak("2nd argument supplied to Rmpc_out_str is out of allowable range (must be between 2 and 36 inclusive)");
     ret = mpc_out_str(stream, (int)SvIV(base), (size_t)SvUV(dig), *p, SvUV(round));
     fflush(stream);
     return newSVuv(ret);
}

SV * _Rmpc_out_strS(FILE * stream, SV * base, SV * dig, mpc_t * p, SV * round, SV * suff) {
     size_t ret;
     if(SvIV(base) < 2 || SvIV(base) > 36) croak("2nd argument supplied to Rmpc_out_str is out of allowable range (must be between 2 and 36 inclusive)");
     ret = mpc_out_str(stream, (int)SvIV(base), (size_t)SvUV(dig), *p, SvUV(round));
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
     ret = mpc_out_str(stream, (int)SvIV(base), (size_t)SvUV(dig), *p, SvUV(round));
     fflush(stream);
     return newSVuv(ret);
}

SV * _Rmpc_out_strPS(SV * pre, FILE * stream, SV * base, SV * dig, mpc_t * p, SV * round, SV * suff) {
     size_t ret;
     if(SvIV(base) < 2 || SvIV(base) > 36) croak("3rd argument supplied to Rmpc_out_str is out of allowable range (must be between 2 and 36 inclusive)");
     fprintf(stream, "%s", SvPV_nolen(pre));
     fflush(stream);
     ret = mpc_out_str(stream, (int)SvIV(base), (size_t)SvUV(dig), *p, SvUV(round));
     fflush(stream);
     fprintf(stream, "%s", SvPV_nolen(suff));
     fflush(stream);
     return newSVuv(ret);
}


SV * Rmpc_inp_str(mpc_t * p, FILE * stream, SV * base, SV * round) {
     size_t ret;
     if(SvIV(base) < 2 || SvIV(base) > 36) croak("3rd argument supplied to TRmpfr_inp_str is out of allowable range (must be between 2 and 36 inclusive)");
     ret = mpc_inp_str(*p, stream, (int)SvIV(base), SvUV(round));
     fflush(stream);
     return newSVuv(ret);
}

void Rmpc_random(mpc_t * p) {
     mpc_random(*p);
}

void Rmpc_random2(mpc_t * p, SV * s, SV * exp) {
     mpc_random2(*p, SvIV(s), SvUV(exp));
}

void Rmpc_sin(mpc_t * rop, mpc_t * op, SV * round) {
     mpc_sin(*rop, *op, SvUV(round));
}

SV * overload_true(mpc_t *a, SV *second, SV * third) {
     if(
       ( mpfr_nan_p(MPC_RE(*a)) || !mpfr_cmp_ui(MPC_RE(*a), 0) ) &&
       ( mpfr_nan_p(MPC_IM(*a)) || !mpfr_cmp_ui(MPC_IM(*a), 0) )
       ) return newSVuv(0);
     return newSVuv(1);
}

SV * overload_mul(mpc_t * a, SV * b, SV * third) {
     mpc_t * mpc_t_obj;
     mpfr_t temp;
     SV * obj_ref, * obj;

     New(1, mpc_t_obj, 1, mpc_t);
     if(mpc_t_obj == NULL) croak("Failed to allocate memory in overload_mul function");
     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, "Math::MPC");
     mpc_init(*mpc_t_obj);
     sv_setiv(obj, INT2PTR(IV,mpc_t_obj));
     SvREADONLY_on(obj);

#ifdef USE_64_BIT_INT

     if(SvUOK(b)) {
       mpfr_init2(temp, mpc_get_default_prec());
#ifdef _MSC_VER
       mpfr_set_str(temp, SvPV_nolen(b), 10, _perl_default_rounding_mode & 3);
#else
       mpfr_set_uj(temp, SvUV(b), _perl_default_rounding_mode & 3);
#endif
       mpc_mul_fr(*mpc_t_obj, *a, temp, _perl_default_rounding_mode);
       mpfr_clear(temp);
       return obj_ref;
     }

     if(SvIOK(b)) {
       mpfr_init2(temp, mpc_get_default_prec());
#ifdef _MSC_VER
       mpfr_set_str(temp, SvPV_nolen(b), 10, _perl_default_rounding_mode & 3);
#else
       mpfr_set_sj(temp, SvIV(b), _perl_default_rounding_mode & 3);
#endif
       mpc_mul_fr(*mpc_t_obj, *a, temp, _perl_default_rounding_mode);
       mpfr_clear(temp);
       return obj_ref;
     }

#else
     if(SvUOK(b)) {
       mpc_mul_ui(*mpc_t_obj, *a, SvUV(b), _perl_default_rounding_mode);
       return obj_ref;
       }

     if(SvIOK(b)) {
       mpc_mul_si(*mpc_t_obj, *a, SvIV(b), _perl_default_rounding_mode);
       return obj_ref;
     }
#endif

     if(SvNOK(b)) {
#ifdef USE_LONG_DOUBLE
       mpfr_init2(temp, mpc_get_default_prec());
       mpfr_set_ld(temp, SvNV(b), _perl_default_rounding_mode & 3);
       mpc_mul_fr(*mpc_t_obj, *a, temp, _perl_default_rounding_mode);
       mpfr_clear(temp);
#else
       mpc_set_d(*mpc_t_obj, SvNV(b), _perl_default_rounding_mode);
       mpc_mul(*mpc_t_obj, *mpc_t_obj, *a, _perl_default_rounding_mode);
#endif

     return obj_ref;
     }

     if(SvPOK(b)) {
       mpfr_init2(temp, mpc_get_default_prec());
       if(mpfr_set_str(temp, SvPV_nolen(b), 0, _perl_default_rounding_mode & 3))
         croak("Invalid string supplied to Math::MPC::overload_mul");
       mpc_mul_fr(*mpc_t_obj, *a, temp, _perl_default_rounding_mode);
       mpfr_clear(temp);
       return obj_ref;
     }

     if(sv_isobject(b)) {
       if(strEQ(HvNAME(SvSTASH(SvRV(b))), "Math::MPC")) {
         mpc_mul(*mpc_t_obj, *a, *(INT2PTR(mpc_t *, SvIV(SvRV(b)))), _perl_default_rounding_mode);
         return obj_ref;
         }
       }

     croak("Invalid argument supplied to Math::MPC::overload_mul");
}

SV * overload_add(mpc_t* a, SV * b, SV * third) {
     mpc_t * mpc_t_obj;
     mpfr_t temp;
     SV * obj_ref, * obj;

     New(1, mpc_t_obj, 1, mpc_t);
     if(mpc_t_obj == NULL) croak("Failed to allocate memory in overload_add function");
     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, "Math::MPC");
     mpc_init(*mpc_t_obj);
     sv_setiv(obj, INT2PTR(IV,mpc_t_obj));
     SvREADONLY_on(obj);

#ifdef USE_64_BIT_INT

     if(SvUOK(b)) {
       mpfr_init2(temp, mpc_get_default_prec());
#ifdef _MSC_VER
       mpfr_set_str(temp, SvPV_nolen(b), 10, _perl_default_rounding_mode & 3);
#else
       mpfr_set_uj(temp, SvUV(b), _perl_default_rounding_mode & 3);
#endif
       mpc_add_fr(*mpc_t_obj, *a, temp, _perl_default_rounding_mode);
       mpfr_clear(temp);
       return obj_ref;
     }

     if(SvIOK(b)) {
       mpfr_init2(temp, mpc_get_default_prec());
#ifdef _MSC_VER
       mpfr_set_str(temp, SvPV_nolen(b), 10, _perl_default_rounding_mode & 3);
#else
       mpfr_set_sj(temp, SvIV(b), _perl_default_rounding_mode & 3);
#endif
       mpc_add_fr(*mpc_t_obj, *a, temp, _perl_default_rounding_mode);
       mpfr_clear(temp);
       return obj_ref;
     }

#else

     if(SvUOK(b)) {
       mpc_add_ui(*mpc_t_obj, *a, SvUV(b), _perl_default_rounding_mode);
       return obj_ref;
       }

     if(SvIOK(b)) {
       if(SvIV(b) >= 0) {
         mpc_add_ui(*mpc_t_obj, *a, SvUV(b), _perl_default_rounding_mode);
         return obj_ref;
         }
       mpc_sub_ui(*mpc_t_obj, *a, SvIV(b) * -1, _perl_default_rounding_mode);
       return obj_ref;
       }

#endif

     if(SvNOK(b)) {
#ifdef USE_LONG_DOUBLE
       mpfr_init2(temp, mpc_get_default_prec());
       mpfr_set_ld(temp, SvNV(b), _perl_default_rounding_mode & 3);
       mpc_add_fr(*mpc_t_obj, *a, temp, _perl_default_rounding_mode);
       mpfr_clear(temp);
#else
       mpc_set_d(*mpc_t_obj, SvNV(b), _perl_default_rounding_mode);
       mpc_add(*mpc_t_obj, *mpc_t_obj, *a, _perl_default_rounding_mode);
#endif

     return obj_ref;
     }

     if(SvPOK(b)) {
       mpfr_init2(temp, mpc_get_default_prec());
       if(mpfr_set_str(temp, SvPV_nolen(b), 0, _perl_default_rounding_mode & 3))
         croak("Invalid string supplied to Math::MPC::overload_add");
       mpc_add_fr(*mpc_t_obj, *a, temp, _perl_default_rounding_mode);
       mpfr_clear(temp);
       return obj_ref;
     }

     if(sv_isobject(b)) {
       if(strEQ(HvNAME(SvSTASH(SvRV(b))), "Math::MPC")) {
         mpc_add(*mpc_t_obj, *a, *(INT2PTR(mpc_t *, SvIV(SvRV(b)))), _perl_default_rounding_mode);
         return obj_ref;
         }
       }

     croak("Invalid argument supplied to Math::MPC::overload_add");
}

SV * overload_sub(mpc_t * a, SV * b, SV * third) {
     mpc_t * mpc_t_obj;
     mpfr_t temp;
     SV * obj_ref, * obj;

     New(1, mpc_t_obj, 1, mpc_t);
     if(mpc_t_obj == NULL) croak("Failed to allocate memory in overload_sub function");
     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, "Math::MPC");
     mpc_init(*mpc_t_obj);
     sv_setiv(obj, INT2PTR(IV,mpc_t_obj));
     SvREADONLY_on(obj);

#ifdef USE_64_BIT_INT
     if(SvUOK(b)) {
       mpfr_init2(temp, mpc_get_default_prec());
#ifdef _MSC_VER
       mpfr_set_str(temp, SvPV_nolen(b), 10, _perl_default_rounding_mode & 3);
#else
       mpfr_set_uj(temp, SvUV(b), _perl_default_rounding_mode & 3);
#endif
       mpc_set_ui_ui(*mpc_t_obj, 0, 0, _perl_default_rounding_mode);
       mpc_add_fr(*mpc_t_obj, *mpc_t_obj, temp, _perl_default_rounding_mode);
       if(third == &PL_sv_yes) mpc_sub(*mpc_t_obj, *mpc_t_obj, *a, _perl_default_rounding_mode);
       else mpc_sub(*mpc_t_obj, *a, *mpc_t_obj, _perl_default_rounding_mode);
       mpfr_clear(temp);
       return obj_ref;
       }

     if(SvIOK(b)) {
       mpfr_init2(temp, mpc_get_default_prec());
#ifdef _MSC_VER
       mpfr_set_str(temp, SvPV_nolen(b), 10, _perl_default_rounding_mode & 3);
#else
       mpfr_set_sj(temp, SvIV(b), _perl_default_rounding_mode & 3);
#endif
       mpc_set_ui_ui(*mpc_t_obj, 0, 0, _perl_default_rounding_mode);
       mpc_add_fr(*mpc_t_obj, *mpc_t_obj, temp, _perl_default_rounding_mode);
       if(third == &PL_sv_yes) mpc_sub(*mpc_t_obj, *mpc_t_obj, *a, _perl_default_rounding_mode);
       else mpc_sub(*mpc_t_obj, *a, *mpc_t_obj, _perl_default_rounding_mode);
       mpfr_clear(temp);
       return obj_ref;
       }
#else
     if(SvUOK(b)) {
       if(third == &PL_sv_yes) mpc_ui_sub(*mpc_t_obj, SvUV(b), *a, _perl_default_rounding_mode);
       else mpc_sub_ui(*mpc_t_obj, *a, SvUV(b), _perl_default_rounding_mode);
       return obj_ref;
       }

     if(SvIOK(b)) {
       if(SvIV(b) >= 0) {
         if(third == &PL_sv_yes) mpc_ui_sub(*mpc_t_obj, SvUV(b), *a, _perl_default_rounding_mode);
         else mpc_sub_ui(*mpc_t_obj, *a, SvUV(b), _perl_default_rounding_mode);
         return obj_ref;
         }
       mpc_add_ui(*mpc_t_obj, *a, SvIV(b) * -1, _perl_default_rounding_mode);
       if(third == &PL_sv_yes) mpc_neg(*mpc_t_obj, *mpc_t_obj, _perl_default_rounding_mode);
       return obj_ref;
       }
#endif

     if(SvNOK(b)) {
#ifdef USE_LONG_DOUBLE
       mpfr_init2(temp, mpc_get_default_prec());
       mpfr_set_ld(temp, SvNV(b), _perl_default_rounding_mode & 3);
       mpc_set_ui_ui(*mpc_t_obj, 0, 0, _perl_default_rounding_mode);
       mpc_add_fr(*mpc_t_obj, *mpc_t_obj, temp, _perl_default_rounding_mode);
#else
       mpc_set_d(*mpc_t_obj, SvNV(b), _perl_default_rounding_mode);
#endif
       if(third == &PL_sv_yes) mpc_sub(*mpc_t_obj, *mpc_t_obj, *a, _perl_default_rounding_mode);
       else mpc_sub(*mpc_t_obj, *a, *mpc_t_obj, _perl_default_rounding_mode);
       return obj_ref;
       }

     if(SvPOK(b)) {
       mpfr_init2(temp, mpc_get_default_prec());
       if(mpfr_set_str(temp, SvPV_nolen(b), 0, _perl_default_rounding_mode & 3))
         croak("Invalid string supplied to Math::MPC::overload_sub");
       mpc_set_ui_ui(*mpc_t_obj, 0, 0, _perl_default_rounding_mode);
       mpc_add_fr(*mpc_t_obj, *mpc_t_obj, temp, _perl_default_rounding_mode);
       if(third == &PL_sv_yes) mpc_sub(*mpc_t_obj, *mpc_t_obj, *a, _perl_default_rounding_mode);
       else mpc_sub(*mpc_t_obj, *a, *mpc_t_obj, _perl_default_rounding_mode);
       mpfr_clear(temp);
       return obj_ref;
       }

     if(sv_isobject(b)) {
       if(strEQ(HvNAME(SvSTASH(SvRV(b))), "Math::MPC")) {
         mpc_sub(*mpc_t_obj, *a, *(INT2PTR(mpc_t *, SvIV(SvRV(b)))), _perl_default_rounding_mode);
         return obj_ref;
         }
       }

     croak("Invalid argument supplied to Math::MPC::overload_sub function");

}

SV * overload_div(mpc_t * a, SV * b, SV * third) {
     mpc_t * mpc_t_obj;
     mpfr_t temp;
     SV * obj_ref, * obj;

     New(1, mpc_t_obj, 1, mpc_t);
     if(mpc_t_obj == NULL) croak("Failed to allocate memory in overload_div function");
     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, "Math::MPC");
     mpc_init(*mpc_t_obj);
     sv_setiv(obj, INT2PTR(IV,mpc_t_obj));
     SvREADONLY_on(obj);

#ifdef USE_64_BIT_INT
     if(SvUOK(b)) {
       mpfr_init2(temp, mpc_get_default_prec());
#ifdef _MSC_VER
       mpfr_set_str(temp, SvPV_nolen(b), 10, _perl_default_rounding_mode & 3);
#else
       mpfr_set_uj(temp, SvUV(b), _perl_default_rounding_mode & 3);
#endif
       mpc_set_ui_ui(*mpc_t_obj, 0, 0, _perl_default_rounding_mode);
       mpc_add_fr(*mpc_t_obj, *mpc_t_obj, temp, _perl_default_rounding_mode);
       if(third == &PL_sv_yes) mpc_div(*mpc_t_obj, *mpc_t_obj, *a, _perl_default_rounding_mode);
       else mpc_div(*mpc_t_obj, *a, *mpc_t_obj, _perl_default_rounding_mode);
       mpfr_clear(temp);
       return obj_ref;
       }

     if(SvIOK(b)) {
       mpfr_init2(temp, mpc_get_default_prec());
#ifdef _MSC_VER
       mpfr_set_str(temp, SvPV_nolen(b), 10, _perl_default_rounding_mode & 3);
#else
       mpfr_set_sj(temp, SvIV(b), _perl_default_rounding_mode & 3);
#endif
       mpc_set_ui_ui(*mpc_t_obj, 0, 0, _perl_default_rounding_mode);
       mpc_add_fr(*mpc_t_obj, *mpc_t_obj, temp, _perl_default_rounding_mode);
       if(third == &PL_sv_yes) mpc_div(*mpc_t_obj, *mpc_t_obj, *a, _perl_default_rounding_mode);
       else mpc_div(*mpc_t_obj, *a, *mpc_t_obj, _perl_default_rounding_mode);
       mpfr_clear(temp);
       return obj_ref;
       }
#else
     if(SvUOK(b)) {
       if(third == &PL_sv_yes) mpc_ui_div(*mpc_t_obj, SvUV(b), *a, _perl_default_rounding_mode);
       else mpc_div_ui(*mpc_t_obj, *a, SvUV(b), _perl_default_rounding_mode);
       return obj_ref;
       }

     if(SvIOK(b)) {
       if(SvIV(b) >= 0) {
         if(third == &PL_sv_yes) mpc_ui_div(*mpc_t_obj, SvUV(b), *a, _perl_default_rounding_mode);
         else mpc_div_ui(*mpc_t_obj, *a, SvUV(b), _perl_default_rounding_mode);
         return obj_ref;
         }
       if(third == &PL_sv_yes) mpc_ui_div(*mpc_t_obj, SvIV(b) * -1, *a, _perl_default_rounding_mode);
       else mpc_div_ui(*mpc_t_obj, *a, SvIV(b) * -1, _perl_default_rounding_mode);
       mpc_neg(*mpc_t_obj, *mpc_t_obj, _perl_default_rounding_mode);
       return obj_ref;
       }
#endif

     if(SvNOK(b)) {
#ifdef USE_LONG_DOUBLE
       mpfr_init2(temp, mpc_get_default_prec());
       mpfr_set_ld(temp, SvNV(b), _perl_default_rounding_mode & 3);
       mpc_set_ui_ui(*mpc_t_obj, 0, 0, _perl_default_rounding_mode);
       mpc_add_fr(*mpc_t_obj, *mpc_t_obj, temp, _perl_default_rounding_mode);
#else
       mpc_set_d(*mpc_t_obj, SvNV(b), _perl_default_rounding_mode);
#endif
       if(third == &PL_sv_yes) mpc_div(*mpc_t_obj, *mpc_t_obj, *a, _perl_default_rounding_mode);
       else mpc_div(*mpc_t_obj, *a, *mpc_t_obj, _perl_default_rounding_mode);
       return obj_ref;
       }

     if(SvPOK(b)) {
       mpfr_init2(temp, mpc_get_default_prec());
       if(mpfr_set_str(temp, SvPV_nolen(b), 0, _perl_default_rounding_mode & 3))
         croak("Invalid string supplied to Math::MPC::overload_div");
       mpc_set_ui_ui(*mpc_t_obj, 0, 0, _perl_default_rounding_mode);
       mpc_add_fr(*mpc_t_obj, *mpc_t_obj, temp, _perl_default_rounding_mode);
       if(third == &PL_sv_yes) mpc_div(*mpc_t_obj, *mpc_t_obj, *a, _perl_default_rounding_mode);
       else mpc_div(*mpc_t_obj, *a, *mpc_t_obj, _perl_default_rounding_mode);
       mpfr_clear(temp);
       return obj_ref;
       }

     if(sv_isobject(b)) {
       if(strEQ(HvNAME(SvSTASH(SvRV(b))), "Math::MPC")) {
         mpc_div(*mpc_t_obj, *a, *(INT2PTR(mpc_t *, SvIV(SvRV(b)))), _perl_default_rounding_mode);
         return obj_ref;
         }
       }

     croak("Invalid argument supplied to Math::MPC::overload_div function");

}


SV * overload_div_eq(SV * a, SV * b, SV * third) {

     mpfr_t temp;

     SvREFCNT_inc(a);

#ifdef USE_64_BIT_INT
     if(SvUOK(b)) {
       mpfr_init2(temp, mpc_get_default_prec());
#ifdef _MSC_VER
       mpfr_set_str(temp, SvPV_nolen(b), 10, _perl_default_rounding_mode & 3);
#else
       mpfr_set_uj(temp, SvUV(b), _perl_default_rounding_mode & 3);
#endif
       mpc_div_fr(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), temp, _perl_default_rounding_mode);
       mpfr_clear(temp);
       return a;
       }

     if(SvIOK(b)) {
       mpfr_init2(temp, mpc_get_default_prec());
#ifdef _MSC_VER
       mpfr_set_str(temp, SvPV_nolen(b), 10, _perl_default_rounding_mode & 3);
#else
       mpfr_set_sj(temp, SvIV(b), _perl_default_rounding_mode & 3);
#endif
       mpc_div_fr(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), temp, _perl_default_rounding_mode);
       mpfr_clear(temp);
       return a;
       }
#else
     if(SvUOK(b)) {
       mpc_div_ui(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), SvUV(b), _perl_default_rounding_mode);
       return a;
       }

     if(SvIOK(b)) {
       if(SvIV(b) >= 0) {
         mpc_div_ui(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), SvUV(b), _perl_default_rounding_mode);
         return a;
         }
       mpc_div_ui(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), SvIV(b) * -1, _perl_default_rounding_mode);
       mpc_neg(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), _perl_default_rounding_mode);
       return a;
       }
#endif

     if(SvNOK(b)) {
       mpfr_init2(temp, mpc_get_default_prec());
#ifdef USE_LONG_DOUBLE
       mpfr_set_ld(temp, SvNV(b), _perl_default_rounding_mode & 3);
#else
       mpfr_set_d(temp, SvNV(b), _perl_default_rounding_mode & 3);
#endif
       mpc_div_fr(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), temp, _perl_default_rounding_mode);
       mpfr_clear(temp);
       return a;
       }

     if(SvPOK(b)) {
       mpfr_init2(temp, mpc_get_default_prec());
       if(mpfr_set_str(temp, SvPV_nolen(b), 0, _perl_default_rounding_mode & 3)) {
         SvREFCNT_dec(a);
         croak("Invalid string supplied to Math::MPC::overload_div_eq");
         } 
       mpc_div_fr(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), temp, _perl_default_rounding_mode);
       mpfr_clear(temp);
       return a;
       }

     if(sv_isobject(b)) {
       if(strEQ(HvNAME(SvSTASH(SvRV(b))), "Math::MPC")) {
         mpc_div(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(b)))), _perl_default_rounding_mode);
         return a;
         }
       }

     SvREFCNT_dec(a);
     croak("Invalid argument supplied to Math::MPC::overload_div_eq function");

}

SV * overload_sub_eq(SV * a, SV * b, SV * third) {

     mpfr_t temp;
     mpc_t t;

     SvREFCNT_inc(a);

#ifdef USE_64_BIT_INT
     if(SvUOK(b)) {
       mpfr_init2(temp, mpc_get_default_prec());
#ifdef _MSC_VER
       mpfr_set_str(temp, SvPV_nolen(b), 10, _perl_default_rounding_mode & 3);
#else
       mpfr_set_uj(temp, SvUV(b), _perl_default_rounding_mode & 3);
#endif
       mpc_init_set_ui_ui(t, 0, 0, _perl_default_rounding_mode);
       mpc_add_fr(t, t, temp, _perl_default_rounding_mode);
       mpfr_clear(temp);
       mpc_sub(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), t, _perl_default_rounding_mode);
       mpc_clear(t);
       return a;
       }

     if(SvIOK(b)) {
       mpfr_init2(temp, mpc_get_default_prec());
#ifdef _MSC_VER
       mpfr_set_str(temp, SvPV_nolen(b), 10, _perl_default_rounding_mode & 3);
#else
       mpfr_set_sj(temp, SvIV(b), _perl_default_rounding_mode & 3);
#endif
       mpc_init_set_ui_ui(t, 0, 0, _perl_default_rounding_mode);
       mpc_add_fr(t, t, temp, _perl_default_rounding_mode);
       mpfr_clear(temp);
       mpc_sub(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), t, _perl_default_rounding_mode);
       mpc_clear(t);
       return a;
       }
#else
     if(SvUOK(b)) {
       mpc_sub_ui(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), SvUV(b), _perl_default_rounding_mode);
       return a;
       }

     if(SvIOK(b)) {
       if(SvIV(b) >= 0) {
         mpc_sub_ui(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), SvUV(b), _perl_default_rounding_mode);
         return a;
         }
       mpc_add_ui(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), SvIV(b) * -1, _perl_default_rounding_mode);
       return a;
       }
#endif

     if(SvNOK(b)) {

       mpfr_init2(temp, mpc_get_default_prec());
       mpc_init_set_ui_ui(t, 0, 0, _perl_default_rounding_mode);

#ifdef USE_LONG_DOUBLE
       mpfr_set_ld(temp, SvNV(b), _perl_default_rounding_mode & 3);
#else
       mpfr_set_d(temp, SvNV(b), _perl_default_rounding_mode & 3);
#endif
       mpc_add_fr(t, t, temp, _perl_default_rounding_mode);
       mpfr_clear(temp);
       mpc_sub(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), t, _perl_default_rounding_mode);
       mpc_clear(t);
       return a;
       }

     if(SvPOK(b)) {
       mpfr_init2(temp, mpc_get_default_prec());
       if(mpfr_set_str(temp, SvPV_nolen(b), 0, _perl_default_rounding_mode & 3)) {
         SvREFCNT_dec(a);
         croak("Invalid string supplied to Math::MPC::overload_sub_eq");
         }
       mpc_init_set_ui_ui(t, 0, 0, _perl_default_rounding_mode);
       mpc_add_fr(t, t, temp, _perl_default_rounding_mode);
       mpfr_clear(temp);
       mpc_sub(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), t, _perl_default_rounding_mode);
       mpc_clear(t);
       return a;
       }

     if(sv_isobject(b)) {
       if(strEQ(HvNAME(SvSTASH(SvRV(b))), "Math::MPC")) {
         mpc_sub(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(b)))), _perl_default_rounding_mode);
         return a;
         }
       }

     SvREFCNT_dec(a);
     croak("Invalid argument supplied to Math::MPC::overload_sub_eq function");

}

SV * overload_add_eq(SV * a, SV * b, SV * third) {
     mpfr_t temp;
     SvREFCNT_inc(a);

#ifdef USE_64_BIT_INT
     if(SvUOK(b)) {
       mpfr_init2(temp, mpc_get_default_prec());
#ifdef _MSC_VER
       mpfr_set_str(temp, SvPV_nolen(b), 10, _perl_default_rounding_mode & 3);
#else
       mpfr_set_uj(temp, SvUV(b), _perl_default_rounding_mode & 3);
#endif
       mpc_add_fr(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), temp, _perl_default_rounding_mode);
       mpfr_clear(temp);
       return a;
       }

     if(SvIOK(b)) {
       mpfr_init2(temp, mpc_get_default_prec());
 #ifdef _MSC_VER
       mpfr_set_str(temp, SvPV_nolen(b), 10, _perl_default_rounding_mode & 3);
#else
       mpfr_set_sj(temp, SvIV(b), _perl_default_rounding_mode & 3);
#endif
       mpc_add_fr(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), temp, _perl_default_rounding_mode);
       mpfr_clear(temp);
       return a;
       }
#else
     if(SvUOK(b)) {
       mpc_add_ui(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), SvUV(b), _perl_default_rounding_mode);
       return a;
       }

     if(SvIOK(b)) {
       if(SvIV(b) >= 0) {
         mpc_add_ui(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), SvUV(b), _perl_default_rounding_mode);
         return a;
         }
       mpc_sub_ui(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), SvIV(b) * -1, _perl_default_rounding_mode);
       return a;
       }
#endif

     if(SvNOK(b)) {
       mpfr_init2(temp, mpc_get_default_prec());

#ifdef USE_LONG_DOUBLE

       mpfr_set_ld(temp, SvNV(b), _perl_default_rounding_mode & 3);
#else
       mpfr_set_d(temp, SvNV(b), _perl_default_rounding_mode & 3);
#endif
       mpc_add_fr(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), temp, _perl_default_rounding_mode);
       mpfr_clear(temp);
       return a;
       }

     if(SvPOK(b)) {
       mpfr_init2(temp, mpc_get_default_prec());
       if(mpfr_set_str(temp, SvPV_nolen(b), 0, _perl_default_rounding_mode & 3)) {
         SvREFCNT_dec(a);
         croak("Invalid string supplied to Math::MPC::overload_add_eq");
         }
       mpc_add_fr(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), temp, _perl_default_rounding_mode);
       mpfr_clear(temp);
       return a;
       }

     if(sv_isobject(b)) {
       if(strEQ(HvNAME(SvSTASH(SvRV(b))), "Math::MPC")) {
         mpc_add(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(b)))), _perl_default_rounding_mode);
         return a;
         }
       }

     SvREFCNT_dec(a);
     croak("Invalid argument supplied to Math::MPC::overload_add_eq");
}

SV * overload_mul_eq(SV * a, SV * b, SV * third) {

     mpfr_t temp;

     SvREFCNT_inc(a);

#ifdef USE_64_BIT_INT
     if(SvUOK(b)) {
       mpfr_init2(temp, mpc_get_default_prec());
#ifdef _MSC_VER
       mpfr_set_str(temp, SvPV_nolen(b), 10, _perl_default_rounding_mode & 3);
#else
       mpfr_set_uj(temp, SvUV(b), _perl_default_rounding_mode & 3);
#endif
       mpc_mul_fr(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), temp, _perl_default_rounding_mode);
       mpfr_clear(temp);
       return a;
       }

     if(SvIOK(b)) {
       mpfr_init2(temp, mpc_get_default_prec());
#ifdef _MSC_VER
       mpfr_set_str(temp, SvPV_nolen(b), 10, _perl_default_rounding_mode & 3);
#else
       mpfr_set_sj(temp, SvIV(b), _perl_default_rounding_mode & 3);
#endif
       mpc_mul_fr(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), temp, _perl_default_rounding_mode);
       mpfr_clear(temp);
       return a;
       }
#else
     if(SvUOK(b)) {
       mpc_mul_ui(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), SvUV(b), _perl_default_rounding_mode);
       return a;
       }

     if(SvIOK(b)) {
       mpc_mul_si(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), SvUV(b), _perl_default_rounding_mode);
       return a;
       }

#endif

     if(SvNOK(b)) {
       mpfr_init2(temp, mpc_get_default_prec());

#ifdef USE_LONG_DOUBLE

       mpfr_set_ld(temp, SvNV(b), _perl_default_rounding_mode & 3);
#else
       mpfr_set_d(temp, SvNV(b), _perl_default_rounding_mode & 3);
#endif
       mpc_mul_fr(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), temp, _perl_default_rounding_mode);
       mpfr_clear(temp);
       return a;
       }

     if(SvPOK(b)) {
       mpfr_init2(temp, mpc_get_default_prec());
       if(mpfr_set_str(temp, SvPV_nolen(b), 0, _perl_default_rounding_mode & 3)) {
         SvREFCNT_dec(a);
         croak("Invalid string supplied to Math::MPC::overload_mul_eq");
         }
       mpc_mul_fr(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), temp, _perl_default_rounding_mode);
       mpfr_clear(temp);
       return a;
       }

     if(sv_isobject(b)) {
       if(strEQ(HvNAME(SvSTASH(SvRV(b))), "Math::MPC")) {
         mpc_mul(*(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(a)))), *(INT2PTR(mpc_t *, SvIV(SvRV(b)))), _perl_default_rounding_mode);
         return a;
         }
       }

     SvREFCNT_dec(a);
     croak("Invalid argument supplied to Math::MPC::overload_mul_eq");
}

SV * overload_equiv(mpc_t * a, SV * b, SV * third) {
     mpfr_t temp;
     mpc_t t;
     int ret;

#ifdef USE_64_BIT_INT
     if(SvUOK(b)) {
       mpfr_init2(temp, mpc_get_default_prec());
#ifdef _MSC_VER
       mpfr_set_str(temp, SvPV_nolen(b), 10, _perl_default_rounding_mode & 3);
#else
       mpfr_set_uj(temp, SvUV(b), _perl_default_rounding_mode & 3);
#endif
       mpc_init_set_ui_ui(t, 0, 0, _perl_default_rounding_mode);
       mpc_add_fr(t, t, temp, _perl_default_rounding_mode);
       mpfr_clear(temp);
       ret = mpc_cmp(*a, t);
       mpc_clear(t);
       if(ret == 0) return newSViv(1);
       return newSViv(0);
       }

     if(SvIOK(b)) {
       mpfr_init2(temp, mpc_get_default_prec());
#ifdef _MSC_VER
       mpfr_set_str(temp, SvPV_nolen(b), 10, _perl_default_rounding_mode & 3);
#else
       mpfr_set_sj(temp, SvIV(b), _perl_default_rounding_mode & 3);
#endif
       mpc_init_set_ui_ui(t, 0, 0, _perl_default_rounding_mode);
       mpc_add_fr(t, t, temp, _perl_default_rounding_mode);
       mpfr_clear(temp);
       ret = mpc_cmp(*a, t);
       mpc_clear(t);
       if(ret == 0) return newSViv(1);
       return newSViv(0);
       }
#else
     if(SvUOK(b)) {
       mpc_init(t);
       mpc_set_ui(t, SvUV(b), _perl_default_rounding_mode);
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
       mpfr_init2(temp, mpc_get_default_prec());
       mpfr_set_ld(temp, SvNV(b), _perl_default_rounding_mode & 3);
       mpc_init_set_ui_ui(t, 0, 0, _perl_default_rounding_mode);
       mpc_add_fr(t, t, temp, _perl_default_rounding_mode);
       mpfr_clear(temp);
       ret = mpc_cmp(*a, t);
       mpc_clear(t);
#else
       mpc_init(t);
       mpc_set_d(t, SvNV(b), _perl_default_rounding_mode);
       ret = mpc_cmp(*a, t);
       mpc_clear(t);
#endif
       if(ret == 0) return newSViv(1);
       return newSViv(0);
       }

     if(SvPOK(b)) {
       mpfr_init2(temp, mpc_get_default_prec());
       if(mpfr_set_str(temp, (char *)SvPV_nolen(b), 0, _perl_default_rounding_mode & 3))
         croak("Invalid string supplied to Math::MPC::overload_equiv");
       mpc_init_set_ui_ui(t, 0, 0, _perl_default_rounding_mode);
       mpc_add_fr(t, t, temp, _perl_default_rounding_mode);
       mpfr_clear(temp);
       ret = mpc_cmp(*a, t);
       mpc_clear(t);
       if(ret == 0) return newSViv(1);
       return newSViv(0);
       }

     if(sv_isobject(b)) {
       if(strEQ(HvNAME(SvSTASH(SvRV(b))), "Math::MPC")) {
         ret = mpc_cmp(*a, *(INT2PTR(mpc_t *, SvIV(SvRV(b)))));
         if(ret == 0) return newSViv(1);
         return newSViv(0);
         }
       }

     croak("Invalid argument supplied to Math::MPC::overload_equiv");
}

SV * overload_not_equiv(mpc_t * a, SV * b, SV * third) {

     mpfr_t temp;
     mpc_t t;
     int ret;

#ifdef USE_64_BIT_INT
     if(SvUOK(b)) {
       mpfr_init2(temp, mpc_get_default_prec());
#ifdef _MSC_VER
       mpfr_set_str(temp, SvPV_nolen(b), 10, _perl_default_rounding_mode & 3);
#else
       mpfr_set_uj(temp, SvUV(b), _perl_default_rounding_mode & 3);
#endif
       mpc_init_set_ui_ui(t, 0, 0, _perl_default_rounding_mode);
       mpc_add_fr(t, t, temp, _perl_default_rounding_mode);
       mpfr_clear(temp);
       ret = mpc_cmp(*a, t);
       mpc_clear(t);
       if(ret == 0) return newSViv(0);
       return newSViv(1);
       }

     if(SvIOK(b)) {
       mpfr_init2(temp, mpc_get_default_prec());
#ifdef _MSC_VER
       mpfr_set_str(temp, SvPV_nolen(b), 10, _perl_default_rounding_mode & 3);
#else
       mpfr_set_sj(temp, SvIV(b), _perl_default_rounding_mode & 3);
#endif
       mpc_init_set_ui_ui(t, 0, 0, _perl_default_rounding_mode);
       mpc_add_fr(t, t, temp, _perl_default_rounding_mode);
       mpfr_clear(temp);
       ret = mpc_cmp(*a, t);
       mpc_clear(t);
       if(ret == 0) return newSViv(0);
       return newSViv(1);
       }
#else
     if(SvUOK(b)) {
       mpc_init(t);
       mpc_set_ui(t, SvUV(b), _perl_default_rounding_mode);
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
       mpfr_init2(temp, mpc_get_default_prec());
       mpfr_set_ld(temp, SvNV(b), _perl_default_rounding_mode & 3);
       mpc_init_set_ui_ui(t, 0, 0, _perl_default_rounding_mode);
       mpc_add_fr(t, t, temp, _perl_default_rounding_mode);
       mpfr_clear(temp);
       ret = mpc_cmp(*a, t);
       mpc_clear(t);
#else
       mpc_init(t);
       mpc_set_d(t, SvNV(b), _perl_default_rounding_mode);
       ret = mpc_cmp(*a, t);
       mpc_clear(t);
#endif
       if(ret == 0) return newSViv(0);
       return newSViv(1);
       }

     if(SvPOK(b)) {
       mpfr_init2(temp, mpc_get_default_prec());
       if(mpfr_set_str(temp, (char *)SvPV_nolen(b), 0, _perl_default_rounding_mode & 3))
         croak("Invalid string supplied to Math::MPC::overload_not_equiv");
       mpc_init_set_ui_ui(t, 0, 0, _perl_default_rounding_mode);
       mpc_add_fr(t, t, temp, _perl_default_rounding_mode);
       mpfr_clear(temp);
       ret = mpc_cmp(*a, t);
       mpc_clear(t);
       if(ret == 0) return newSViv(0);
       return newSViv(1);
       }

     if(sv_isobject(b)) {
       if(strEQ(HvNAME(SvSTASH(SvRV(b))), "Math::MPC")) {
         if(mpc_cmp(*a, *(INT2PTR(mpc_t *, SvIV(SvRV(b)))))) return newSViv(1);
         return newSViv(0);
         }
       }

     croak("Invalid argument supplied to Math::MPC::overload_not_equiv");
}

SV * overload_not(mpc_t * a, SV * second, SV * third) {
     if(mpc_cmp_si_si(*a, 0, 0)) return newSViv(0);
     return newSViv(1);
}

SV * overload_sqrt(mpc_t * p, SV * second, SV * third) {
     mpc_t * mpc_t_obj;
     SV * obj_ref, * obj;

     New(1, mpc_t_obj, 1, mpc_t);
     if(mpc_t_obj == NULL) croak("Failed to allocate memory in overload_sqrt function");
     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, "Math::MPC");
     mpc_init(*mpc_t_obj);

     mpc_sqrt(*mpc_t_obj, *p, _perl_default_rounding_mode);
     sv_setiv(obj, INT2PTR(IV,mpc_t_obj));
     SvREADONLY_on(obj);
     return obj_ref;
}

void overload_copy(mpc_t * p, SV * second, SV * third) {
     Inline_Stack_Vars;
     mpc_t * mpc_t_obj;
     SV * obj_ref, * obj;

     New(1, mpc_t_obj, 1, mpc_t);
     if(mpc_t_obj == NULL) croak("Failed to allocate memory in overload_copy function");
     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, "Math::MPC");

     mpc_init_set(*mpc_t_obj, *p, _perl_default_rounding_mode);
     sv_setiv(obj, INT2PTR(IV,mpc_t_obj));
     SvREADONLY_on(obj);
     Inline_Stack_Push(sv_2mortal(obj_ref));
     Inline_Stack_Done;
     Inline_Stack_Return(1);
}

SV * overload_abs(mpc_t * p, SV * second, SV * third) {
     mpfr_t * mpfr_t_obj;
     SV * obj_ref, * obj;

     New(1, mpfr_t_obj, 1, mpfr_t);
     if(mpfr_t_obj == NULL) croak("Failed to allocate memory in overload_abs function");
     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, "Math::MPFR");
     mpfr_init(*mpfr_t_obj);

     mpc_abs(*mpfr_t_obj, *p, _perl_default_rounding_mode);
     sv_setiv(obj, INT2PTR(IV,mpfr_t_obj));
     SvREADONLY_on(obj);
     return obj_ref;
}

SV * overload_exp(mpc_t * p, SV * second, SV * third) {
     mpc_t * mpc_t_obj;
     SV * obj_ref, * obj;

     New(1, mpc_t_obj, 1, mpc_t);
     if(mpc_t_obj == NULL) croak("Failed to allocate memory in overload_exp function");
     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, "Math::MPC");
     mpc_init(*mpc_t_obj);

     mpc_exp(*mpc_t_obj, *p, _perl_default_rounding_mode);
     sv_setiv(obj, INT2PTR(IV,mpc_t_obj));
     SvREADONLY_on(obj);
     return obj_ref;
}

SV * overload_sin(mpc_t * p, SV * second, SV * third) {
     mpc_t * mpc_t_obj;
     SV * obj_ref, * obj;

     New(1, mpc_t_obj, 1, mpc_t);
     if(mpc_t_obj == NULL) croak("Failed to allocate memory in overload_sin function");
     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, "Math::MPC");
     mpc_init(*mpc_t_obj);

     mpc_sin(*mpc_t_obj, *p, _perl_default_rounding_mode);
     sv_setiv(obj, INT2PTR(IV,mpc_t_obj));
     SvREADONLY_on(obj);
     return obj_ref;
}

void _get_r_string(mpc_t * p, SV * base, SV * n_digits, SV * round) {
     Inline_Stack_Vars;
     char * out;
     mp_exp_t ptr, *expptr;
     unsigned long b = SvUV(base);

     expptr = &ptr;

     if(b < 2 || b > 36) croak("Second argument supplied to r_string() is not in acceptable range");

     out = mpfr_get_str(0, expptr, b, SvUV(n_digits), MPC_RE(*p), SvUV(round) & 3);

     if(out == NULL) croak("An error occurred in _get_r_string()\n");

     Inline_Stack_Reset;
     Inline_Stack_Push(sv_2mortal(newSVpv(out, 0)));
     mpfr_free_str(out);
     Inline_Stack_Push(sv_2mortal(newSViv(ptr)));
     Inline_Stack_Done;
     Inline_Stack_Return(2);
}

void _get_i_string(mpc_t * p, SV * base, SV * n_digits, SV * round) {
     Inline_Stack_Vars;
     char * out;
     mp_exp_t ptr, *expptr;
     unsigned long b = SvUV(base);

     expptr = &ptr;

     if(b < 2 || b > 36) croak("Second argument supplied to i_string() is not in acceptable range");

     out = mpfr_get_str(0, expptr, b, SvUV(n_digits), MPC_IM(*p), SvUV(round) & 3);

     if(out == NULL) croak("An error occurred in _get_i_string()\n");

     Inline_Stack_Reset;
     Inline_Stack_Push(sv_2mortal(newSVpv(out, 0)));
     mpfr_free_str(out);
     Inline_Stack_Push(sv_2mortal(newSViv(ptr)));
     Inline_Stack_Done;
     Inline_Stack_Return(2);
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
     mpc_t * mpc_t_obj;
     mpfr_t temp;
     SV * obj_ref, * obj;

     New(1, mpc_t_obj, 1, mpc_t);
     if(mpc_t_obj == NULL) croak("Failed to allocate memory in _new_real function");
     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, "Math::MPC");
     mpc_init(*mpc_t_obj);

     sv_setiv(obj, INT2PTR(IV,mpc_t_obj));
     SvREADONLY_on(obj);

#ifdef USE_64_BIT_INT

     if(SvUOK(b)) {
       mpfr_init2(temp, mpc_get_default_prec());
#ifdef _MSC_VER
       mpfr_set_str(temp, SvPV_nolen(b), 10, _perl_default_rounding_mode & 3);
#else
       mpfr_set_uj(temp, SvUV(b), _perl_default_rounding_mode & 3);
#endif
       mpc_set_ui_ui(*mpc_t_obj, 0, 0, _perl_default_rounding_mode);
       mpc_add_fr(*mpc_t_obj, *mpc_t_obj, temp, _perl_default_rounding_mode);
       mpfr_clear(temp);
       return obj_ref;
     }

     if(SvIOK(b)) {
       mpfr_init2(temp, mpc_get_default_prec());
#ifdef _MSC_VER
       mpfr_set_str(temp, SvPV_nolen(b), 10, _perl_default_rounding_mode & 3);
#else
       mpfr_set_sj(temp, SvIV(b), _perl_default_rounding_mode & 3);
#endif
       mpc_set_ui_ui(*mpc_t_obj, 0, 0, _perl_default_rounding_mode);
       mpc_add_fr(*mpc_t_obj, *mpc_t_obj, temp, _perl_default_rounding_mode);
       mpfr_clear(temp);
       return obj_ref;
     }

#else
     if(SvUOK(b)) {
       mpc_set_ui(*mpc_t_obj, SvUV(b), _perl_default_rounding_mode);
       return obj_ref;
       }

     if(SvIOK(b)) {
       mpc_set_si(*mpc_t_obj, SvIV(b), _perl_default_rounding_mode);
       return obj_ref;
     }
#endif

     if(SvNOK(b)) {
#ifdef USE_LONG_DOUBLE
       mpfr_init2(temp, mpc_get_default_prec());
       mpfr_set_ld(temp, SvNV(b), _perl_default_rounding_mode & 3);
       mpc_set_ui_ui(*mpc_t_obj, 0, 0, _perl_default_rounding_mode);
       mpc_add_fr(*mpc_t_obj, *mpc_t_obj, temp, _perl_default_rounding_mode);
       mpfr_clear(temp);
#else
       mpc_set_d(*mpc_t_obj, SvNV(b), _perl_default_rounding_mode);
#endif

     return obj_ref;
     }

     if(SvPOK(b)) {
       mpfr_init2(temp, mpc_get_default_prec());
       if(mpfr_set_str(temp, SvPV_nolen(b), 0, _perl_default_rounding_mode & 3))
         croak("Invalid string supplied to Math::MPC::new");
       mpc_set_ui_ui(*mpc_t_obj, 0, 0, _perl_default_rounding_mode);
       mpc_add_fr(*mpc_t_obj, *mpc_t_obj, temp, _perl_default_rounding_mode);
       mpfr_clear(temp);
       return obj_ref;
     }

     if(sv_isobject(b)) {
       if(strEQ(HvNAME(SvSTASH(SvRV(b))), "Math::MPFR")) {
         mpc_set_ui_ui(*mpc_t_obj, 0, 0, _perl_default_rounding_mode);
         mpc_add_fr(*mpc_t_obj, *mpc_t_obj, *(INT2PTR(mpfr_t *, SvIV(SvRV(b)))), _perl_default_rounding_mode);
         return obj_ref;
       }
     }

     croak("Invalid argument supplied to Math::MPC::_new_real");
}

SV * _new_im(SV * b) {
     mpc_t * mpc_t_obj;
     mpfr_t temp;
     SV * obj_ref, * obj;

     New(1, mpc_t_obj, 1, mpc_t);
     if(mpc_t_obj == NULL) croak("Failed to allocate memory in Rmpc_init function");
     obj_ref = newSV(0);
     obj = newSVrv(obj_ref, "Math::MPC");
     mpc_init(*mpc_t_obj);

     sv_setiv(obj, INT2PTR(IV,mpc_t_obj));
     SvREADONLY_on(obj);

#ifdef USE_64_BIT_INT

     if(SvUOK(b)) {
       mpfr_init2(temp, mpc_get_default_prec());
#ifdef _MSC_VER
       mpfr_set_str(temp, SvPV_nolen(b), 10, _perl_default_rounding_mode & 3);
#else
       mpfr_set_uj(temp, SvUV(b), _perl_default_rounding_mode & 3);
#endif
       mpc_set_ui_fr(*mpc_t_obj, 0, temp, _perl_default_rounding_mode);
       mpfr_clear(temp);
       return obj_ref;
     }

     if(SvIOK(b)) {
       mpfr_init2(temp, mpc_get_default_prec());
#ifdef _MSC_VER
       mpfr_set_str(temp, SvPV_nolen(b), 10, _perl_default_rounding_mode & 3);
#else
       mpfr_set_sj(temp, SvIV(b), _perl_default_rounding_mode & 3);
#endif
       mpc_set_ui_fr(*mpc_t_obj, 0, temp, _perl_default_rounding_mode);
       mpfr_clear(temp);
       return obj_ref;
     }

#else
     if(SvUOK(b)) {
       mpc_set_ui_ui(*mpc_t_obj, 0, SvUV(b), _perl_default_rounding_mode);
       return obj_ref;
       }

     if(SvIOK(b)) {
       mpc_set_si_si(*mpc_t_obj, 0, SvIV(b), _perl_default_rounding_mode);
       return obj_ref;
     }
#endif

     if(SvNOK(b)) {
#ifdef USE_LONG_DOUBLE
       mpfr_init2(temp, mpc_get_default_prec());
       mpfr_set_ld(temp, SvNV(b), _perl_default_rounding_mode & 3);
       mpc_set_ui_fr(*mpc_t_obj, 0, temp, _perl_default_rounding_mode);
       mpfr_clear(temp);
#else
       mpc_set_d_d(*mpc_t_obj, 0, SvNV(b), _perl_default_rounding_mode);
#endif

     return obj_ref;
     }

     if(SvPOK(b)) {
       mpfr_init2(temp, mpc_get_default_prec());
       if(mpfr_set_str(temp, SvPV_nolen(b), 0, _perl_default_rounding_mode & 3))
         croak("Invalid string supplied to Math::MPC::new");
       mpc_set_ui_fr(*mpc_t_obj, 0, temp, _perl_default_rounding_mode);
       mpfr_clear(temp);
       return obj_ref;
     }

     if(sv_isobject(b)) {
       if(strEQ(HvNAME(SvSTASH(SvRV(b))), "Math::MPFR")) {
         mpc_set_ui_fr(*mpc_t_obj, 0, *(INT2PTR(mpfr_t *, SvIV(SvRV(b)))), _perl_default_rounding_mode);
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


MODULE = Math::MPC	PACKAGE = Math::MPC	

PROTOTYPES: DISABLE


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

SV *
Rmpc_get_default_prec ()

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
RMPC_RE (fr, x, round)
	mpfr_t *	fr
	mpc_t *	x
	SV *	round
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	RMPC_RE(fr, x, round);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

void
RMPC_IM (fr, x, round)
	mpfr_t *	fr
	mpc_t *	x
	SV *	round
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	RMPC_IM(fr, x, round);
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
Rmpc_init ()

SV *
Rmpc_init2 (prec)
	SV *	prec

SV *
Rmpc_init3 (prec_r, prec_i)
	SV *	prec_r
	SV *	prec_i

SV *
Rmpc_init_nobless ()

SV *
Rmpc_init2_nobless (prec)
	SV *	prec

SV *
Rmpc_init3_nobless (prec_r, prec_i)
	SV *	prec_r
	SV *	prec_i

void
Rmpc_init_set (q, round)
	mpc_t *	q
	SV *	round
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	Rmpc_init_set(q, round);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

void
Rmpc_init_set_ui (q, round)
	SV *	q
	SV *	round
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	Rmpc_init_set_ui(q, round);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

void
Rmpc_init_set_ui_ui (q_r, q_i, round)
	SV *	q_r
	SV *	q_i
	SV *	round
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	Rmpc_init_set_ui_ui(q_r, q_i, round);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

void
Rmpc_init_set_si_si (q_r, q_i, round)
	SV *	q_r
	SV *	q_i
	SV *	round
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	Rmpc_init_set_si_si(q_r, q_i, round);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

void
Rmpc_init_set_ui_fr (q_r, q_i, round)
	SV *	q_r
	mpfr_t *	q_i
	SV *	round
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	Rmpc_init_set_ui_fr(q_r, q_i, round);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

void
Rmpc_init_set_nobless (q, round)
	mpc_t *	q
	SV *	round
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	Rmpc_init_set_nobless(q, round);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

void
Rmpc_init_set_ui_nobless (q, round)
	SV *	q
	SV *	round
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	Rmpc_init_set_ui_nobless(q, round);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

void
Rmpc_init_set_ui_ui_nobless (q_r, q_i, round)
	SV *	q_r
	SV *	q_i
	SV *	round
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	Rmpc_init_set_ui_ui_nobless(q_r, q_i, round);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

void
Rmpc_init_set_si_si_nobless (q_r, q_i, round)
	SV *	q_r
	SV *	q_i
	SV *	round
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	Rmpc_init_set_si_si_nobless(q_r, q_i, round);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

void
Rmpc_init_set_ui_fr_nobless (q_r, q_i, round)
	SV *	q_r
	mpfr_t *	q_i
	SV *	round
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	Rmpc_init_set_ui_fr_nobless(q_r, q_i, round);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

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
Rmpc_set_d (p, q, round)
	mpc_t *	p
	SV *	q
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
Rmpc_set_ui_fr (p, q_r, q_i, round)
	mpc_t *	p
	SV *	q_r
	mpfr_t *	q_i
	SV *	round

void
Rmpc_set_uj_uj (a, uj1, uj2, round)
	mpc_t *	a
	SV *	uj1
	SV *	uj2
	SV *	round
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	Rmpc_set_uj_uj(a, uj1, uj2, round);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

void
Rmpc_set_sj_sj (a, sj1, sj2, round)
	mpc_t *	a
	SV *	sj1
	SV *	sj2
	SV *	round
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	Rmpc_set_sj_sj(a, sj1, sj2, round);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

void
Rmpc_set_ld_ld (a, ld1, ld2, round)
	mpc_t *	a
	SV *	ld1
	SV *	ld2
	SV *	round
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	Rmpc_set_ld_ld(a, ld1, ld2, round);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

void
Rmpc_set_fr_fr (a, fr1, fr2, round)
	mpc_t *	a
	mpfr_t *	fr1
	mpfr_t *	fr2
	SV *	round
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	Rmpc_set_fr_fr(a, fr1, fr2, round);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

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

void
Rmpc_exp (a, b, round)
	mpc_t *	a
	mpc_t *	b
	SV *	round
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	Rmpc_exp(a, b, round);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

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

void
Rmpc_random (p)
	mpc_t *	p
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	Rmpc_random(p);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

void
Rmpc_random2 (p, s, exp)
	mpc_t *	p
	SV *	s
	SV *	exp
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	Rmpc_random2(p, s, exp);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

void
Rmpc_sin (rop, op, round)
	mpc_t *	rop
	mpc_t *	op
	SV *	round
	PREINIT:
	I32* temp;
	PPCODE:
	temp = PL_markstack_ptr++;
	Rmpc_sin(rop, op, round);
	if (PL_markstack_ptr != temp) {
          /* truly void, because dXSARGS not invoked */
	  PL_markstack_ptr = temp;
	  XSRETURN_EMPTY; /* return empty stack */
        }
        /* must have used dXSARGS; list context implied */
	return; /* assume stack size is correct */

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
overload_sin (p, second, third)
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

