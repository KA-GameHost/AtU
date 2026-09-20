#include <stdio.h>
#include <stddef.h>

int main(void)
{
#ifdef nullptr
    printf("PASS\n");
#else
    printf("INFO\n");
#endif

    return 0;
}
