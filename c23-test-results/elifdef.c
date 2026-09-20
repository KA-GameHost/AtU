#include <stdio.h>

#define TEST_DEFINED 1

#if 0
#elifdef TEST_DEFINED
int main(void)
{
    printf("PASS\n");
    return 0;
}
#else
#error "elifdef not supported"
#endif
