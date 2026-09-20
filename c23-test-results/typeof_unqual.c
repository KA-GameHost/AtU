#include <stdio.h>

int main(void)
{
    const int a = 42;
    typeof_unqual(a) b = 100;

    if (b != 100)
        return 1;

    printf("PASS\n");
    return 0;
}
