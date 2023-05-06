#include "s7.h"
#include <stdio.h>

s7_scheme *sc = NULL;

#define tmscm_install_typed_procedure(name, type, func) \
  s7_set##type##_function (sc, s7_name_to_value(sc, name), func)

static s7_int plus_one(s7_int x) {return(x + 1);}


int main(int argc, char **argv)
{
    sc = s7_init();
    tmscm_install_typed_procedure("+", _d_d, plus_one);
    s7_pointer retval = s7_eval_c_string(sc, "(+ 1 2)");
    int res = s7_integer(retval);
    printf("retval is %p, %d\n", retval, res);
    return retval==NULL;
}