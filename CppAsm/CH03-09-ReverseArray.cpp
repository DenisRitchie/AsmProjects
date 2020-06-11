#include <iostream>
#include <iomanip>
#include <random>
#include <algorithm>
#include <memory>
#include <array>

using namespace std;

class Random
{
public:
  explicit inline Random(const int32_t min, const int32_t max) noexcept
    : range_distribution{ min, max }
    , random_engine{ seed_device() }
  {
  }

  inline int32_t Next() const noexcept
  {
    return range_distribution(random_engine);
  }

  inline int32_t operator()() const noexcept
  {
    return Next();
  }

private:
  random_device seed_device;
  uniform_int_distribution<> range_distribution;
  mutable default_random_engine random_engine;
};

extern "C" int32_t CH03_09_ReverseArray(
  int32_t *const dst,
  const int32_t *const src,
  const size_t length) noexcept;

inline void Init(int32_t *const ar, const size_t length) noexcept
{
  generate_n(ar, length, Random{ 1, 1'000 });
}


void CH03_09_ReverseArray_Test() noexcept
{
  array<int32_t, 25> ar1, ar2;

  Init(ar1.data(), ar1.size());
  int32_t rc = CH03_09_ReverseArray(ar2.data(), ar1.data(), ar1.size());

  if (rc != 0)
  {
    cout << "\nResults for ReverseArray\n";

    constexpr int32_t w = 5;
    bool compare_error = false;

    for (int32_t index = 0; index < ar1.size() && !compare_error; ++index)
    {
      cout << "  Index: " << setw(w) << index;
      cout << "    ar2: " << setw(w) << ar2[index];
      cout << "    ar1: " << setw(w) << ar1[index] << endl;

      if (ar1[index] != ar2[ar1.size() - 1 - index])
        compare_error = true;
    }

    if (compare_error)
      cout << "ReverseArray compare error\n";
    else
      cout << "ReverseArray compare OK\n";
  }
  else
  {
    cout << "ReverseArray failed\n";
  }
}

