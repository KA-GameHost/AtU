#include <stdio.h>

int main(void)
{
    int value = 1'000'000;

    if (value != 1000000)
        return 1;

    printf("PASS\n");
    return 0;
}
