/*
* Check that gmp.h, mpfr.h, and mpc.h
* can be found by the compiler and
* that libpmc.a, libmpfr.a, and libgmp.a
* can be found by the linker
*/

#include <stdio.h>
#include <gmp.h>
#include <mpfr.h>
#include <mpc.h>

#ifdef _MSC_VER
void __GSHandlerCheck(void) {}
void __security_check_cookie(void) {}
void __security_cookie(void) {}
#endif

int main(void) {
   mpc_t x;
   mpc_init_set_ui_ui(x, 7, 5, MPC_RNDZU);
   mpc_clear(x);
   printf("DONE\n");
   return 0;
}

