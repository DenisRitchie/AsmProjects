#include <__msvc_all_public_headers.hpp>

using namespace std;

struct TestStruct
{
  int8_t Val8;
  int8_t Pad8;
  int16_t Val16;
  int32_t Val32;
  int64_t Val64;
};

extern "C" int64_t CH03_05_CalcTestStructSum(const struct TestStruct *__restrict ts) noexcept;

constexpr int64_t CalcTestStructSumCpp(const struct TestStruct *__restrict ts) noexcept
{
  return static_cast<int64_t>(ts->Val8) + ts->Val16 + ts->Val32 + ts->Val64;
}

auto CH03_05_CalcTestStructSum_Test() noexcept -> void
{
  constexpr TestStruct ts =
  {
    .Val8 = -100,
    .Val16 = 2'000,
    .Val32 = -300'000,
    .Val64 = 40'000'000'000
  };

  constexpr int64_t sum1 = CalcTestStructSumCpp(&ts);
  const int64_t sum2 = CH03_05_CalcTestStructSum(&ts);

  cout << "Ts.Val8  = " << static_cast<int32_t>(ts.Val8) << endl;
  cout << "Ts.Val16 = " << ts.Val16 << endl;
  cout << "Ts.Val32 = " << ts.Val32 << endl;
  cout << "Ts.Val64 = " << ts.Val64 << endl;
  cout << endl;
  cout << "Sum1 = " << sum1 << endl;
  cout << "Sum2 = " << sum2 << endl;
}


