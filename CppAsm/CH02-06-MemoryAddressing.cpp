#include <__msvc_all_public_headers.hpp>
#include <__msvc_system_error_abi.hpp>

using namespace std;

extern "C" int32_t g_NumFibVals;
extern "C" int32_t g_FibValsSum;

extern "C" int32_t CH02_06_MemoryAddressing(
  const int32_t i,
  int32_t * __restrict v1,
  int32_t * __restrict v2,
  int32_t * __restrict v3,
  int32_t * __restrict v4);

void CH02_06_MemoryAddressing_Test()
{
  constexpr int32_t w = 5;
  constexpr char nl = '\n';
  constexpr const char *delim = ", ";

  g_FibValsSum = 0;

  for (int32_t i = -1; i < g_NumFibVals + 1; ++i)
  {
    int32_t v1 = -1, v2 = -1, v3 = -1, v4 = -1;
    int32_t rc = CH02_06_MemoryAddressing(i, &v1, &v2, &v3, &v4);

    cout << "I = " << setw(w - 1) << i << delim;
    cout << "RC = " << setw(w - 1) << rc << delim;
    cout << "V1 = " << setw(w - 1) << v1 << delim;
    cout << "V2 = " << setw(w - 1) << v2 << delim;
    cout << "V3 = " << setw(w - 1) << v3 << delim;
    cout << "V4 = " << setw(w - 1) << v4 << delim;
    cout << nl;
  }

  cout << "FibValsSum = " << g_FibValsSum << nl;
}


