$ErrorActionPreference = "Continue"

$Root = Split-Path -Parent $MyInvocation.MyCommand.Path
$TestDir = Join-Path $Root "c23-test-results"
$Report = Join-Path $TestDir "report.md"

Remove-Item $TestDir -Recurse -Force -ErrorAction SilentlyContinue
New-Item $TestDir -ItemType Directory | Out-Null

$cl = Get-Command cl.exe -ErrorAction SilentlyContinue

if (-not $cl) {
    Write-Host "ERRO: cl.exe não encontrado."
    Write-Host "Execute este script a partir do Developer Command Prompt do Visual Studio."
    exit 1
}

$CompilerVersion = (& cl 2>&1 | Select-Object -First 2) -join " "

Write-Host ""
Write-Host "=============================================="
Write-Host " C23 COMPATIBILITY BATTERY"
Write-Host "=============================================="
Write-Host $CompilerVersion
Write-Host ""

$tests = @(
    @{
        Name = "static_assert"
        Code = @'
#include <stdio.h>

static_assert(sizeof(double) == 8);

int main(void)
{
    printf("PASS\n");
    return 0;
}
'@
    },

    @{
        Name = "typeof_unqual"
        Code = @'
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
'@
    },

    @{
        Name = "typeof"
        Code = @'
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
'@
    },

    @{
        Name = "nullptr"
        Code = @'
int main(void)
{
    int *p = nullptr;

    return p == nullptr ? 0 : 1;
}
'@
    },

    @{
        Name = "constexpr"
        Code = @'
#include <stdio.h>

constexpr int value = 42;

int main(void)
{
    static_assert(value == 42);
    printf("PASS\n");
    return 0;
}
'@
    },

    @{
        Name = "bitint"
        Code = @'
#include <stdio.h>

int main(void)
{
    _BitInt(16) value = 1234;

    if (value != 1234)
        return 1;

    printf("PASS\n");
    return 0;
}
'@
    },

    @{
        Name = "binary_literals"
        Code = @'
#include <stdio.h>

int main(void)
{
    int value = 0b101010;

    if (value != 42)
        return 1;

    printf("PASS\n");
    return 0;
}
'@
    },

    @{
        Name = "digit_separators"
        Code = @'
#include <stdio.h>

int main(void)
{
    int value = 1'000'000;

    if (value != 1000000)
        return 1;

    printf("PASS\n");
    return 0;
}
'@
    },

    @{
        Name = "attributes"
        Code = @'
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
'@
    },

    @{
        Name = "elifdef"
        Code = @'
#include <stdio.h>

#define TEST_DEFINED 1

#if 0
#elifdef TEST_DEFINED
int main(void)
{
    printf("PASS\n");
    return 0;
}
#else
#error "elifdef not supported"
#endif
'@
    },

    @{
        Name = "elifndef"
        Code = @'
#include <stdio.h>

#if 0
#elifndef THIS_MACRO_DOES_NOT_EXIST
int main(void)
{
    printf("PASS\n");
    return 0;
}
#else
#error "elifndef not supported"
#endif
'@
    },

    @{
        Name = "typeof_pointer"
        Code = @'
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
'@
    },

    @{
        Name = "typeof_unqual_pointer"
        Code = @'
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
'@
    },

    @{
        Name = "static_assert_message"
        Code = @'
#include <stdio.h>

static_assert(sizeof(int) >= 4, "int must be at least 32 bits");

int main(void)
{
    printf("PASS\n");
    return 0;
}
'@
    },

    @{
        Name = "bool"
        Code = @'
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
'@
    },

    @{
        Name = "nullptr_header"
        Code = @'
#include <stdio.h>
#include <stddef.h>

int main(void)
{
#ifdef nullptr
    printf("PASS\n");
#else
    printf("INFO\n");
#endif

    return 0;
}
'@
    }
)

$results = @()

foreach ($test in $tests) {

    $name = $test.Name
    $source = Join-Path $TestDir "$name.c"
    $exe = Join-Path $TestDir "$name.exe"
    $log = Join-Path $TestDir "$name.log"

    Set-Content -Path $source -Value $test.Code -Encoding UTF8

    Write-Host ("[{0,-25}] " -f $name) -NoNewline

    $output = & cl.exe /nologo /std:clatest $source "/Fe:$exe" 2>&1
    $exitCode = $LASTEXITCODE

    $output | Out-File $log -Encoding UTF8

    if ($exitCode -ne 0) {

        Write-Host "FAIL (compile)"

        $results += [PSCustomObject]@{
            Test = $name
            Compile = "FAIL"
            Run = "-"
            Result = "FAIL"
        }

        continue
    }

    & $exe *> $null
    $runCode = $LASTEXITCODE

    if ($runCode -eq 0) {

        Write-Host "PASS"

        $results += [PSCustomObject]@{
            Test = $name
            Compile = "PASS"
            Run = "PASS"
            Result = "PASS"
        }

    }
    else {

        Write-Host "FAIL (runtime)"

        $results += [PSCustomObject]@{
            Test = $name
            Compile = "PASS"
            Run = "FAIL"
            Result = "FAIL"
        }
    }
}

$pass = @($results | Where-Object Result -eq "PASS").Count
$fail = @($results | Where-Object Result -eq "FAIL").Count
$total = $results.Count

@"
# C23 Compatibility Test

## Compiler

$CompilerVersion

## Results

| Test | Compile | Runtime | Result |
|---|---|---|---|
$(
    ($results | ForEach-Object {
        "| $($_.Test) | $($_.Compile) | $($_.Run) | $($_.Result) |"
    }) -join "`n"
)

## Summary

- Total: $total
- PASS: $pass
- FAIL: $fail

"@ | Set-Content $Report -Encoding UTF8

Write-Host ""
Write-Host "=============================================="
Write-Host " RESULT: $pass PASS / $fail FAIL / $total TOTAL"
Write-Host "=============================================="
Write-Host ""
Write-Host "Relatorio:"
Write-Host $Report
Write-Host ""