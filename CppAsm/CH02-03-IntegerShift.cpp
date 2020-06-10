#include <Windows.h>
#include <iostream>
#include <iomanip>
#include <bitset>

using namespace std;

extern "C" int32_t CH02_03_IntegerShift(
  const uint32_t a,
  const uint32_t count,
  uint32_t * __restrict a_shl,
  uint32_t * __restrict a_shr) noexcept;

static auto PrintResult(
  const char *__restrict message,
  const int32_t rc,
  const uint32_t a,
  const uint32_t count,
  const uint32_t a_shl,
  const uint32_t a_shr) noexcept -> void
{
  const bitset<32> a_bs(a);
  const bitset<32> a_shl_bs(a_shl);
  const bitset<32> a_shr_bs(a_shr);
  constexpr int32_t w = 10;
  constexpr char nl = '\n';

  cout << message << nl;
  cout << "Count = " << setw(w) << count << nl;
  cout << "    A = " << setw(w) << a << " (0b" << a_bs << ")" << nl;

  if (rc == 0)
    cout << "Invalid shift count" << nl;
  else
  {
    cout << "Shl = " << setw(w) << a_shl << " (0b" << a_shl_bs << ")" << nl;
    cout << "Shr = " << setw(w) << a_shr << " (0b" << a_shr_bs << ")" << nl;
  }

  cout << nl;
}

void CH02_03_IntegerShift_Test() noexcept
{
  int32_t rc;
  uint32_t a, count, a_shl, a_shr;

  a = 3119;
  count = 6;
  rc = CH02_03_IntegerShift(a, count, &a_shl, &a_shr);
  PrintResult("Test 1", rc, a, count, a_shl, a_shr);

  a = 0x00800080;
  count = 4;
  rc = CH02_03_IntegerShift(a, count, &a_shl, &a_shr);
  PrintResult("Test 2", rc, a, count, a_shl, a_shr);

  a = 0x80000001;
  count = 31;
  rc = CH02_03_IntegerShift(a, count, &a_shl, &a_shr);
  PrintResult("Test 3", rc, a, count, a_shl, a_shr);

  a = 0x55555555;
  count = 32;
  rc = CH02_03_IntegerShift(a, count, &a_shl, &a_shr);
  PrintResult("Test 4", rc, a, count, a_shl, a_shr);
}

