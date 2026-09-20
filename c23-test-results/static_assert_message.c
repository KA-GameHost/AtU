#include <stdio.h>

static_assert(sizeof(int) >= 4, "int must be at least 32 bits");

int main(void)
{
    printf("PASS\n");
    return 0;
}
