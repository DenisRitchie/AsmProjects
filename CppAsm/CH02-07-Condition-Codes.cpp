#include <__msvc_all_public_headers.hpp>
#include <__msvc_system_error_abi.hpp>

using namespace std;

extern "C" int32_t CH02_07_SignedMinA(const int32_t a, const int32_t b, const int32_t c) noexcept;
extern "C" int32_t CH02_07_SignedMaxA(const int32_t a, const int32_t b, const int32_t c) noexcept;
extern "C" int32_t CH02_07_SignedMinB(const int32_t a, const int32_t b, const int32_t c) noexcept;
extern "C" int32_t CH02_07_SignedMaxB(const int32_t a, const int32_t b, const int32_t c) noexcept;

void PrintResult(
  const char *__restrict message,
  const int32_t a,
  const int32_t b,
  const int32_t c,
  const int32_t result) noexcept
{
  constexpr int32_t w = 4;

  cout << message << "(";
  cout << setw(w) << a << ", ";
  cout << setw(w) << b << ", ";
  cout << setw(w) << c << ") = ";
  cout << setw(w) << result << '\n';
}

void CH02_07_SignedMinMax_Test() noexcept
{
  int32_t a, b, c;
  int32_t smin_a, smax_a, smin_b, smax_b;

  // SignedMin Examples
  a = 2, b = 15, c = 8;
  smin_a = CH02_07_SignedMinA(a, b, c);
  smin_b = CH02_07_SignedMinB(a, b, c);
  PrintResult("SignedMinA", a, b, c, smin_a);
  PrintResult("SignedMinB", a, b, c, smin_b);
  cout.put('\n');

  a = -3, b = -22, c = 28;
  smin_a = CH02_07_SignedMinA(a, b, c);
  smin_b = CH02_07_SignedMinB(a, b, c);
  PrintResult("SignedMinA", a, b, c, smin_a);
  PrintResult("SignedMinB", a, b, c, smin_b);
  cout.put('\n');

  a = 17, b = 37, c = -11;
  smin_a = CH02_07_SignedMinA(a, b, c);
  smin_b = CH02_07_SignedMinB(a, b, c);
  PrintResult("SignedMinA", a, b, c, smin_a);
  PrintResult("SignedMinB", a, b, c, smin_b);
  cout.put('\n');

  // SignedMax Examples
  a = 10, b = 5, c = 3;
  smax_a = CH02_07_SignedMaxA(a, b, c);
  smax_b = CH02_07_SignedMaxB(a, b, c);
  PrintResult("SignedMaxA", a, b, c, smax_a);
  PrintResult("SignedMaxB", a, b, c, smax_b);
  cout.put('\n');

  a = -3, b = 28, c = 15;
  smax_a = CH02_07_SignedMaxA(a, b, c);
  smax_b = CH02_07_SignedMaxB(a, b, c);
  PrintResult("SignedMaxA", a, b, c, smax_a);
  PrintResult("SignedMaxB", a, b, c, smax_b);
  cout.put('\n');

  a = -25, -37, -17;
  smax_a = CH02_07_SignedMaxA(a, b, c);
  smax_b = CH02_07_SignedMaxB(a, b, c);
  PrintResult("SignedMaxA", a, b, c, smax_a);
  PrintResult("SignedMaxB", a, b, c, smax_b);
  cout.put('\n');
}

