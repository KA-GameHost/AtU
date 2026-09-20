#include <stdio.h>

int main(void)
{
    int a = 42;
    typeof(a) b = 100;

    if (b != 100)
        return 1;

    printf("PASS\n");
    return 0;
}
