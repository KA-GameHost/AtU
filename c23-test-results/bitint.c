#include <stdio.h>

int main(void)
{
    _BitInt(16) value = 1234;

    if (value != 1234)
        return 1;

    printf("PASS\n");
    return 0;
}
