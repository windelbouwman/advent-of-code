
#include <stdint.h>
#include <math.h>

typedef intptr_t slang_int_t;
typedef double slang_float_t;

slang_float_t aoclib_sqrt(slang_float_t value)
{
    return sqrt(value);
}

slang_int_t aoclib_round_up(slang_float_t value)
{
    return (slang_int_t)(ceil(value));
}

slang_int_t aoclib_round_down(slang_float_t value)
{
    return (slang_int_t)(floor(value));
}
