#include <iostream>
#include <iomanip>
#include <random>
#include <memory>

using namespace std;

extern "C" int64_t CH03_08_CompareArrays(
  const int32_t * __restrict ar1,
  const int32_t * __restrict ar2,
  const int64_t length) noexcept;

void Init(int32_t *const ar1, int32_t *const ar2, const size_t length) noexcept
{
  random_device seed_device;
  uniform_int_distribution<> range_distribution{ 1, 10'000 };
  default_random_engine random_engine{ seed_device() };

  for (size_t index = 0; index < length; ++index)
    ar1[index] = ar2[index] = range_distribution(random_engine);
}

void PrintResult(
  const char *__restrict message,
  const int64_t result1,
  const int64_t result2) noexcept
{
  cout << message << '\n';
  cout << "  expected = " << result1;
  cout << "  actual = " << result2 << "\n\n";
}

struct Good : public enable_shared_from_this<Good>
{
  shared_ptr<Good> GetThisPointer() noexcept
  {
    return shared_from_this();
  }

  void Print() const noexcept
  {
    printf_s("Hola esta es una llamada correcta");
  }
};

void CH03_08_CompareArrays_Test() noexcept
{
  // Allocate and initialize the test arrays
  constexpr int64_t length = 10'000;
  unique_ptr<int32_t[]> x{ new int32_t[length] };
  unique_ptr<int32_t[]> y{ new int32_t[length] };

  Init(x.get(), y.get(), length);

  cout << "Result for CH03_08_CompareArrays - array_size = " << length << "\n\n";

  int64_t result;

  // Test using invalid array size
  result = CH03_08_CompareArrays(x.get(), y.get(), -length);
  PrintResult("Test using invalid array size", -1, result);

  // Test using first element mismatch
  x[0] += 1;
  result = CH03_08_CompareArrays(x.get(), y.get(), length);
  x[0] -= 1;
  PrintResult("Test using first element mismatch", 0, result);

  // Test using middle element mismatch
  y[length / 2] -= 2;
  result = CH03_08_CompareArrays(x.get(), y.get(), length);
  y[length / 2] += 2;
  PrintResult("Test using middle element mismatch", length / 2, result);

  // Test using last element msmatch
  x[length - 1] *= 3;
  result = CH03_08_CompareArrays(x.get(), y.get(), length);
  x[length - 1] /= 3;
  PrintResult("Test using last element mismatch", length - 1, result);

  // Test with identical elements in each array
  result = CH03_08_CompareArrays(x.get(), y.get(), length);
  PrintResult("Test with identical elements in each array", length, result);
}