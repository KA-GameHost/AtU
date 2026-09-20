#include <stdio.h>

int value = 42;
int * const ptr = &value;

int main(void)
{
    typeof_unqual(ptr) copy = ptr;

    if (*copy != 42)
        return 1;

    printf("PASS\n");
    return 0;
}
