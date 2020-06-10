#include <iostream>

using namespace std;

extern "C" int32_t CH02_04_IntegerMulDiv(
  const int32_t a,
  const int32_t b,
  int32_t * __restrict prod,
  int32_t * __restrict quo,
  int32_t * __restrict rem) noexcept;

static void PrintResult(
  const char *__restrict message,
  const int32_t rc,
  const int32_t a,
  const int32_t b,
  const int32_t p,
  const int32_t q,
  const int32_t r) noexcept
{
  constexpr char nl = '\n';

  cout << message << nl;
  cout << "A = " << a << ", B = " << b << ", RC = " << rc << nl;

  if (rc != 0)
    cout << "Prod = " << p << ", Quo = " << q << ", Rem = " << r << nl;
  else
    cout << "Prod = " << p << ", Quo = undefined, Rem = undefine" << nl;

  cout << nl;
}

auto CH02_04_IntegerMulDiv_Test() noexcept -> void
{
  int32_t rc, a, b, prod, quo, rem;

  a = 47;
  b = 13;
  prod = quo = rem = 0;
  rc = CH02_04_IntegerMulDiv(a, b, &prod, &quo, &rem);
  PrintResult("Test 1", rc, a, b, prod, quo, rem);

  a = -291;
  b = 7;
  prod = quo = rem = 0;
  rc = CH02_04_IntegerMulDiv(a, b, &prod, &quo, &rem);
  PrintResult("Test 1", rc, a, b, prod, quo, rem);

  a = 19;
  b = 0;
  prod = quo = rem = 0;
  rc = CH02_04_IntegerMulDiv(a, b, &prod, &quo, &rem);
  PrintResult("Test 1", rc, a, b, prod, quo, rem);

  a = 247;
  b = 85;
  prod = quo = rem = 0;
  rc = CH02_04_IntegerMulDiv(a, b, &prod, &quo, &rem);
  PrintResult("Test 1", rc, a, b, prod, quo, rem);
}
