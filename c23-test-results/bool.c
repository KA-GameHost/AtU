#include <stdio.h>
#include <stdbool.h>

int main(void)
{
    bool value = true;

    if (!value)
        return 1;

    printf("PASS\n");
    return 0;
}
