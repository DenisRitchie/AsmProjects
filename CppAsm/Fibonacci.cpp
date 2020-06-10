#include <__msvc_all_public_headers.hpp>

using namespace std;

extern "C" uint32_t Fibonacci(const uint32_t n);

void Fibonacci_Test()
{
  for (uint32_t i = 0; i < 201; ++i)
  {
    printf_s("[%u] = %u\n", i, Fibonacci(i));
  }
}