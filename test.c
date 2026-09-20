#include <stdio.h>

int main(void)
{
    int *value = nullptr;

    if (value == nullptr)
    {
        printf("C23 nullptr: OK\n");
    }

    return 0;
}