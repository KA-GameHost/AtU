#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>
#include <stddef.h>

/*
 * C23 FEATURE BATTERY
 *
 * Objetivo:
 * Verificar, de uma só vez, recursos relevantes do C23
 * disponíveis no compilador atual.
 *
 * NÃO é um teste de conformidade completa com C23.
 */

/* ---------------------------------------------------------
 * 1. static_assert
 * --------------------------------------------------------- */

static_assert(sizeof(int) >= 4);
static_assert(sizeof(double) == 8);


/* ---------------------------------------------------------
 * 2. typeof_unqual
 * --------------------------------------------------------- */

static void test_typeof_unqual(void)
{
    const int original = 42;

    typeof_unqual(original) copy = original;

    copy = 100;

    printf("[PASS] typeof_unqual\n");
}


/* ---------------------------------------------------------
 * 3. nullptr
 *
 * Não colocamos nullptr diretamente aqui porque já sabemos
 * que MSVC 19.44 e 19.51 rejeitam esse recurso.
 * --------------------------------------------------------- */


/* ---------------------------------------------------------
 * 4. constexpr
 *
 * C23 adiciona constexpr para objetos e funções em C.
 * --------------------------------------------------------- */

constexpr int c23_constant = 42;


/* ---------------------------------------------------------
 * 5. binary literals
 * --------------------------------------------------------- */

static const int binary_value = 0b101010;


/* ---------------------------------------------------------
 * 6. digit separators
 * --------------------------------------------------------- */

static const int separated_value = 1'000'000;


/* ---------------------------------------------------------
 * 7. typeof
 * --------------------------------------------------------- */

static void test_typeof(void)
{
    int value = 42;

    typeof(value) copy = value;

    copy = 123;

    printf("[PASS] typeof\n");
}


/* ---------------------------------------------------------
 * 8. _BitInt
 * --------------------------------------------------------- */

static void test_bitint(void)
{
    _BitInt(16) value = 1234;

    if (value == 1234)
    {
        printf("[PASS] _BitInt\n");
    }
}


/* ---------------------------------------------------------
 * 9. nullptr_t
 *
 * Só compilaremos esta parte se o compilador fornecer
 * nullptr_t.
 * --------------------------------------------------------- */

#ifdef __STDC_VERSION_NULLPTR_H__

#include <stddef.h>

static void test_nullptr_t(void)
{
    nullptr_t value = nullptr;

    if (value == nullptr)
    {
        printf("[PASS] nullptr_t\n");
    }
}

#endif


/* ---------------------------------------------------------
 * 10. main
 * --------------------------------------------------------- */

int main(void)
{
    printf("========================================\n");
    printf("C23 FEATURE BATTERY\n");
    printf("========================================\n");

#ifdef __STDC_VERSION__
    printf("__STDC_VERSION__ = %ld\n", (long)__STDC_VERSION__);
#else
    printf("__STDC_VERSION__ = not defined\n");
#endif

#ifdef __STDC__
    printf("__STDC__ = %d\n", __STDC__);
#else
    printf("__STDC__ = not defined\n");
#endif

    printf("\n");

    printf("[PASS] static_assert\n");

    test_typeof_unqual();

    test_typeof();

    test_bitint();

    printf("[PASS] constexpr\n");

    if (binary_value == 42)
    {
        printf("[PASS] binary literals\n");
    }

    if (separated_value == 1000000)
    {
        printf("[PASS] digit separators\n");
    }

#ifdef __STDC_VERSION_NULLPTR_H__
    test_nullptr_t();
#else
    printf("[INFO] nullptr_t header not detected\n");
#endif

    printf("\n");
    printf("========================================\n");
    printf("END\n");
    printf("========================================\n");

    return 0;
}