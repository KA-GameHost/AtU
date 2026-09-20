#include <stdio.h>

int main(void)
{
    const int original = 42;

    typeof_unqual(original) copy = original;

    copy = 100;

    printf("original = %d\n", original);
    printf("copy     = %d\n", copy);

    return 0;
}