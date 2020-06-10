#include <iostream>

// #pragma optimize("g", on)
// #pragma optimize("t", on)
// #pragma optimize("y", on)

using namespace std;

extern "C" int32_t CH02_01_IntegerAddSub(
  const int32_t a,
  const int32_t b,
  const int32_t c,
  const int32_t d) noexcept;

static auto PrintResult(
  const char *__restrict message,
  const int32_t a,
  const int32_t b,
  const int32_t c,
  const int32_t d,
  const int32_t result) noexcept -> void
{
  constexpr char nl = '\n';

  cout << message << nl;
  cout << "A = " << a << nl;
  cout << "B = " << b << nl;
  cout << "C = " << c << nl;
  cout << "D = " << d << nl;
  cout << "Result = " << result << nl;
  cout << nl;
}

auto CH02_01_IntegerAddSub_Test() noexcept -> void
{
  int32_t a, b, c, d, result;

  a = 10, b = 20, c = 30, d = 18;
  result = CH02_01_IntegerAddSub(a, b, c, d);
  PrintResult("Test 1", a, b, c, d, result);

  a = 101, b = 34, c = -190, d = 25;
  result = CH02_01_IntegerAddSub(a, b, c, d);
  PrintResult("Test 2", a, b, c, d, result);
}
