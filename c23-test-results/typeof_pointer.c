#include <stdio.h>

int main(void)
{
    int value = 42;
    int *ptr = &value;

    typeof(ptr) copy = ptr;

    if (*copy != 42)
        return 1;

    printf("PASS\n");
    return 0;
}
