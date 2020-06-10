#include <__msvc_all_public_headers.hpp>
#include <iostream>
#include <iomanip>
#include <cassert>

using namespace std;

extern "C" int64_t CH03_02_CalcArrayValues(
  int64_t * __restrict dst,
  const int32_t * __restrict src,
  const int32_t a,
  const int16_t b,
  const int32_t n);

int64_t CalcArrayValuesCpp(
  int64_t *__restrict dst,
  const int32_t *__restrict src,
  const int32_t a,
  const int16_t b,
  const int32_t n) noexcept
{
  int64_t sum = 0;

  for (int32_t i = 0; i < n; ++i)
  {
    dst[i] = static_cast<int64_t>(src[i]) * a + b;
    sum += dst[i];
  }

  return sum;
}

/*
https://docs.microsoft.com/en-us/cpp/build/x64-software-conventions?view=vs-2019

You may have noticed that in all of the sample source code presented thus far, only a subset of the
general-purpose registers have been used. The reason for this is that the Visual C++ calling convention
designates each general-purpose register as either volatile or non-volatile. Functions are permitted to use
and alter the contents of any volatile register but cannot use a non-volatile register unless it preserves the
caller’s original value.

The Visual C++ calling convention designates
registers RAX, RCX, RDX, R8, R9, R10 and R11 as volatile
and the remaining general-purpose registers as non-volatile.
*/

void CH03_02_CalcArrayValues_Test()
{
  constexpr int32_t a = -6;
  constexpr int16_t b = -13;
  constexpr const int32_t src[] = { 26, 12, -53, 19, 14, 21, 31, -4, 12, -9, 41, 7 };
  constexpr int32_t length = _countof(src);

  int64_t dst1[length];
  int64_t dst2[length];

  const int64_t sum1 = CalcArrayValuesCpp(dst1, src, a, b, length);
  const int64_t sum2 = CH03_02_CalcArrayValues(dst2, src, a, b, length);

  cout << "A = " << a << '\n';
  cout << "B = " << b << '\n';
  cout << "N = " << length << '\n';
  cout.put('\n');

  for (int32_t i = 0; i < length; ++i)
  {
    cout << "I: " << setw(2) << i << "  ";
    cout << "Src: " << setw(6) << src[i] << "  ";
    cout << "Dst1: " << setw(6) << dst1[i] << "  ";
    cout << "Dst2: " << setw(6) << dst2[i] << '\n';
  }

  cout.put('\n');
  cout << "Sum1 = " << sum1 << '\n';
  cout << "Sum2 = " << sum2 << '\n';
}
