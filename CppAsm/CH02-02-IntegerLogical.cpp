#include <iostream>
#include <iomanip>
#include <cstdint>

using namespace std;

extern "C" uint32_t g_val1 = 0;

extern "C" uint32_t CH02_02_IntegerLogical(
  const uint32_t a,
  const uint32_t b,
  const uint32_t c,
  const uint32_t d) noexcept;

uint32_t IntegerLogicalCpp(
  const uint32_t a,
  const uint32_t b,
  const uint32_t c,
  const uint32_t d) noexcept
{
  // Calculate (((a & b) | c) ^ d) + g_val1
  const uint32_t t1 = a & b;
  const uint32_t t2 = t1 | c;
  const uint32_t t3 = t2 ^ d;
  const uint32_t result = t3 + g_val1;
  return result;
}

void PrintResult(
  const char *__restrict message,
  const uint32_t a,
  const uint32_t b,
  const uint32_t c,
  const uint32_t d,
  const uint32_t val1,
  const uint32_t r1,
  const uint32_t r2) noexcept
{
  constexpr int32_t w = 8;
  constexpr char nl = '\n';

  cout << message << nl;
  cout << setfill('0');
  cout << "A    = 0x" << hex << setw(w) << a << " (" << dec << a << ")" << nl;
  cout << "B    = 0x" << hex << setw(w) << b << " (" << dec << b << ")" << nl;
  cout << "C    = 0x" << hex << setw(w) << c << " (" << dec << c << ")" << nl;
  cout << "D    = 0x" << hex << setw(w) << d << " (" << dec << d << ")" << nl;
  cout << "Val1 = 0x" << hex << setw(w) << val1 << " (" << dec << val1 << ")" << nl;
  cout << "R1   = 0x" << hex << setw(w) << r1 << " (" << dec << r1 << ")" << nl;
  cout << "R2   = 0x" << hex << setw(w) << r2 << " (" << dec << r2 << ")" << nl;
  cout << nl;

  if (r1 != r2)
    cout << "Compare failed" << nl;
}

auto CH02_02_IntegerLogical_Test() noexcept -> void
{
  uint32_t a, b, c, d, r1, r2 = 0;

  a = 0x00223344;
  b = 0x00775544;
  c = 0x00555555;
  d = 0x00998877;
  g_val1 = 7;
  r1 = IntegerLogicalCpp(a, b, c, d);
  r2 = CH02_02_IntegerLogical(a, b, c, d);
  PrintResult("Test 1", a, b, c, d, g_val1, r1, r2);

  a = 0x70987655;
  b = 0x55555555;
  c = 0xAAAAAAAA;
  d = 0x12345678;
  g_val1 = 23;
  r1 = IntegerLogicalCpp(a, b, c, d);
  r2 = CH02_02_IntegerLogical(a, b, c, d);
  PrintResult("Test 2", a, b, c, d, g_val1, r1, r2);
}
