#include <iostream>
#include <iomanip>
#include <stdlib.h>
#include <string.h>
#include <random>
#include <intrin.h>

using namespace std;

// __pragma(intrinsic(memset))

/***********************************************************************************

https://www.felixcloutier.com/x86/rep:repe:repz:repne:repnz

rdi -> Source
rcx -> Count
rax -> Value

-----

mov rdi, <address>       ; Source Address
mov ecx, <mem/reg>       ; Counting Register
mov eax, <mem/reg>       ; Value
rep stos dword ptr [rdi] ;

-----

Repetir:  dword ptr [rdi] = eax
Mientras: ecx != 0
Asignar:  "eax" en cada iteración

-----

while (ecx != 0) dword ptr [rdi] = eax

-----

memset(rdi, eax, ecx)

movsxd rax, dword ptr [ncols]          ; sign extend
shl    rax, 2                          ; rax = rax * 4 | ncols * sizeof(int32_t)
mov    qword ptr [rbp + <index>], rax  ; saved the rax value
mov    rdi, qword ptr [col_sums]       ; rdi = &col_sums
xor    eax, eax                        ; eax = 0
mov    rcx, qword ptr [rbp + <index>]  ; read the value saved: ncols * sizeof(int32_t)
rep stos byte ptr [rdi]                ; while (rcx != 0) *rdi++ = eax

***********************************************************************************/

extern "C" int32_t CH03_04_CalcMatrixRowColSums(
  int32_t * __restrict row_sums,
  int32_t * __restrict col_sums,
  const int32_t * __restrict values,
  const int32_t nrows,
  const int32_t ncols
) noexcept;

static auto Init(
  int32_t *__restrict values,
  const int32_t nrows,
  const int32_t ncols
) noexcept -> void
{
  random_device device;
  uniform_int_distribution<> distribution{ 1, 200 };
  default_random_engine random_engine{ device() };

  const int32_t length = nrows * ncols;

  for (int32_t i = 0; i < length; ++i)
    values[i] = distribution(random_engine);
}

static auto PrintResult(
  const char *__restrict message,
  const int32_t *__restrict row_sums,
  const int32_t *__restrict col_sums,
  const int32_t *__restrict values,
  const int32_t nrows,
  const int32_t ncols
) noexcept -> void
{
  constexpr int32_t w = 6;
  constexpr char nl = '\n';

  cout << message;
  cout << "-----------------------------------------\n";

  for (int32_t row = 0; row < nrows; ++row)
  {
    for (int32_t col = 0; col < ncols; ++col)
      cout << setw(w) << values[row * ncols + col];

    cout << " " << setw(w) << row_sums[row] << nl;
  }

  cout << nl;

  for (int32_t index = 0; index < ncols; ++index)
    cout << setw(w) << col_sums[index];

  cout << nl;
}

static int32_t CalcMatrixRowColSumsCpp(
  int32_t *__restrict row_sums,
  int32_t *__restrict col_sums,
  const int32_t *__restrict values,
  const int32_t nrows,
  const int32_t ncols
) noexcept
{
  int32_t rc = 0;

  if (nrows > 0 && ncols > 0)
  {
    memset(col_sums, 0, ncols * sizeof(int32_t));

    for (int32_t row = 0; row < nrows; ++row)
    {
      row_sums[row] = 0;
      const int32_t index = row * ncols;

      for (int32_t col = 0; col < ncols; ++col)
      {
        int32_t temp = values[index + col];
        row_sums[row] += temp;
        col_sums[col] += temp;
      }
    }

    rc = 1;
  }

  return rc;
}

auto CH03_04_CalcMatrixRowColSums_Test() noexcept -> void
{
  #define values_addr reinterpret_cast<int32_t*>(values)

  constexpr int32_t nrows = 7;
  constexpr int32_t ncols = 5;

  int32_t values[nrows][ncols];
  Init(values_addr, nrows, ncols);

  int32_t row_sums1[nrows], col_sums1[ncols];
  int32_t row_sums2[nrows], col_sums2[ncols];

  constexpr const char *msg1 = "\nResults using CalcMatrixRowColSumsCpp\n";
  constexpr const char *msg2 = "\nResults using CH03_04_CalcMatrixRowColSums\n";

  const int32_t rc1 = CalcMatrixRowColSumsCpp(row_sums1, col_sums1, values_addr, nrows, ncols);
  const int32_t rc2 = CH03_04_CalcMatrixRowColSums(row_sums2, col_sums2, values_addr, nrows, ncols);

  if (rc1 == 0)
    cout << "CalcMatrixRowColSumsCpp failed\n";
  else
    PrintResult(msg1, row_sums1, col_sums1, values_addr, nrows, ncols);

  if (rc2 == 0)
    cout << "CH03_04_CalcMatrixRowColSums failed\n";
  else
    PrintResult(msg2, row_sums2, col_sums2, values_addr, nrows, ncols);

  #undef values_addr
}
