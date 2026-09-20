# C23 Compatibility Test

## Compiler

usage: cl [ option... ] filename... [ /link linkoption... ] Microsoft (R) C/C++ Optimizing Compiler Version 19.44.35229 for x64

## Results

| Test | Compile | Runtime | Result |
|---|---|---|---|
| static_assert | PASS | PASS | PASS |
| typeof_unqual | PASS | PASS | PASS |
| typeof | PASS | PASS | PASS |
| nullptr | FAIL | - | FAIL |
| constexpr | FAIL | - | FAIL |
| bitint | FAIL | - | FAIL |
| binary_literals | PASS | PASS | PASS |
| digit_separators | PASS | PASS | PASS |
| attributes | PASS | PASS | PASS |
| elifdef | PASS | PASS | PASS |
| elifndef | PASS | PASS | PASS |
| typeof_pointer | PASS | PASS | PASS |
| typeof_unqual_pointer | PASS | PASS | PASS |
| static_assert_message | PASS | PASS | PASS |
| bool | PASS | PASS | PASS |
| nullptr_header | PASS | PASS | PASS |

## Summary

- Total: 16
- PASS: 13
- FAIL: 3

