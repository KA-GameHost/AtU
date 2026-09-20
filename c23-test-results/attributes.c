#include <stdio.h>

[[deprecated]]
static void old_function(void)
{
}

int main(void)
{
    old_function();
    printf("PASS\n");
    return 0;
}
