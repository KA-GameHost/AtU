#include <stdio.h>

constexpr int value = 42;

int main(void)
{
    static_assert(value == 42);
    printf("PASS\n");
    return 0;
}
