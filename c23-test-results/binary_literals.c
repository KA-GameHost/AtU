#include <stdio.h>

int main(void)
{
    int value = 0b101010;

    if (value != 42)
        return 1;

    printf("PASS\n");
    return 0;
}
