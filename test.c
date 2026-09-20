#include <stdio.h>

static_assert(sizeof(double) == 8);

int main(void)
{
    printf("static_assert: OK\n");
    return 0;
}