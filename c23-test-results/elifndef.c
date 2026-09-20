#include <stdio.h>

#if 0
#elifndef THIS_MACRO_DOES_NOT_EXIST
int main(void)
{
    printf("PASS\n");
    return 0;
}
#else
#error "elifndef not supported"
#endif
