#include <__msvc_all_public_headers.hpp>
#include <iostream>
#include <string>

using namespace std;

extern "C" size_t CH03_07_ConcatString(
  char *const dst,
  const size_t dst_size,
  const char *const *const src,
  const size_t src_n
) noexcept;

void PrintResult(
  const char *__restrict message,
  const char *const dst,
  const size_t dst_len,
  const char *const *__restrict src,
  const size_t src_n
) noexcept
{
  string s_test;
  constexpr char nl = '\n';

  cout << nl << "Test Case: " << message << nl;
  cout << "  Original Strings:" << nl;

  for (size_t i = 0; i < src_n; ++i)
  {
    const char *const s1 = (strlen(src[i]) == 0) ? "<empty string>" : src[i];
    cout << "   index: " << i << " " << s1 << nl;

    s_test.append(src[i]);
  }

  const char *const s2 = (strlen(dst) == 0) ? "<empty string>" : dst;

  cout << "  Concatenated Result" << nl;
  cout << "    " << s2 << nl;

  if (s_test != dst)
  {
    cout << "  Error - test string compare failed" << nl;
  }
}

void CH03_07_ConcatString_Test() noexcept
{
  // Destination buffer size OK
  constexpr const char *src1 [] = { "One ", "Two ", "Three ", "Four" };
  constexpr size_t src1_n = sizeof(src1) / sizeof(char *);
  constexpr size_t des1_size = 64;
  char des1[des1_size];
  const size_t des1_len = CH03_07_ConcatString(des1, des1_size, src1, src1_n);
  PrintResult("destination buffer size OK", des1, des1_len, src1, src1_n);

  // Destination buffer too small
  constexpr const char *src2[] = { "Red ", "Green ", "Blue ", "Yellow " };
  constexpr size_t src2_n = sizeof(src2) / sizeof(char *);
  constexpr size_t des2_size = 16;
  char des2[des2_size];
  const size_t des2_len = CH03_07_ConcatString(des2, des2_size, src2, src2_n);
  PrintResult("destination buffer too small", des2, des2_len, src2, src2_n);

  // Empty source string
  constexpr const char *src3[] = { "Plane ", "Car ", "", "Truck ", "Boat ", "Train ", "Bicycle " };
  constexpr size_t src3_n = sizeof(src3) / sizeof(char *);
  constexpr size_t des3_size = 128;
  char des3[des3_size];
  const size_t des3_len = CH03_07_ConcatString(des3, des3_size, src3, src3_n);
  PrintResult("empty source string", des3, des3_len, src3, src3_n);

  // All strings empty
  constexpr const char *src4[] = { "", "", "", "" };
  constexpr size_t src4_n = sizeof(src4) / sizeof(char *);
  constexpr size_t des4_size = 42;
  char des4[des4_size];
  const size_t des4_len = CH03_07_ConcatString(des4, des4_size, src4, src4_n);
  PrintResult("all strings empty", des4, des4_len, src4, src4_n);

  // Minimum des_size
  constexpr const char *src5[] = { "1", "22", "333", "4444" };
  constexpr size_t src5_n = sizeof(src5) / sizeof(char *);
  constexpr size_t des5_size = 11;
  char des5[des5_size];
  const size_t des5_len = CH03_07_ConcatString(des5, des5_size, src5, src5_n);
  PrintResult("minimum des_size", des5, des5_len, src5, src5_n);
}

