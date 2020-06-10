#include <__msvc_all_public_headers.hpp>

using namespace std;

extern "C" int32_t CH03_01_CalcArraySum(
  const int32_t * __restrict ar,
  const int32_t n);

constexpr int32_t CalcArraySumCpp(const int32_t *__restrict ar, const int32_t n) noexcept
{
  int32_t sum = 0;

  for (int32_t i = 0; i < n; ++i)
    sum += *ar++;

  return sum;
}

void CH03_01_CalcArraySum_Test()
{
  constexpr const int32_t values[] = { 3, 17, -13, 25, -2, 9, -6, 12, 88, -19 };
  constexpr int32_t n = sizeof(values) / sizeof(int32_t);

  cout << "Elements of array values\n";

  for (int32_t i = 0; i < n; ++i)
    cout << "values[" << i << "] = " << values[i] << '\n';
  cout.put('\n');

  constexpr int32_t sum1 = CalcArraySumCpp(values, n);
  const int32_t sum2 = CH03_01_CalcArraySum(values, n);

  cout << "Sum1 = " << sum1 << '\n';
  cout << "Sum2 = " << sum2 << '\n';
}
