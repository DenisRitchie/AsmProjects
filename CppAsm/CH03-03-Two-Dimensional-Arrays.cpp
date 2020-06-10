#include <__msvc_all_public_headers.hpp>
#include <__msvc_system_error_abi.hpp>

using namespace std;

extern "C" void CH03_03_CalcMatrixSquares(
  int32_t * __restrict dst,
  const int32_t * __restrict src,
  const int32_t nrows,
  const int32_t ncols) noexcept;

void CalcMatrixSquaresCpp(
  int32_t *__restrict dst,
  const int32_t *__restrict src,
  const int32_t nrows,
  const int32_t ncols) noexcept
{
  #define Index(x, y) (static_cast<int64_t>(x) * ncols + y)

  for (int32_t i = 0; i < nrows; ++i)
  {
    for (int32_t j = 0; j < ncols; ++j)
    {
      *(dst + Index(i, j)) = *(src + Index(j, i)) * *(src + Index(j, i));
    }
  }

  #undef Index
}

auto CH03_03_CalcMatrixSquares_Test() noexcept -> void
{
  constexpr int32_t nrows = 6;
  constexpr int32_t ncols = 3;
  constexpr const int32_t src[nrows][ncols] =
  {
    {  1,  2,  3 },
    {  4,  5,  6 },
    {  7,  8,  9 },
    { 10, 11, 12 },
    { 13, 14, 15 },
    { 16, 17, 18 }
  };

  int32_t dst2[nrows][ncols];
  int32_t dst1[nrows][ncols];

  CalcMatrixSquaresCpp(&dst1[0][0], &src[0][0], nrows, ncols);
  CH03_03_CalcMatrixSquares(&dst2[0][0], &src[0][0], nrows, ncols);

  for (int32_t i = 0; i < nrows; ++i)
  {
    for (int32_t j = 0; j < ncols; ++j)
    {
      cout << "dst1[" << setw(2) << i << "][" << setw(2) << j << "] = ";
      cout << setw(6) << dst1[i][j] << ' ';

      cout << "dst2[" << setw(2) << i << "][" << setw(2) << j << "] = ";
      cout << setw(6) << dst2[i][j] << ' ';

      cout << "src[" << setw(2) << i << "][" << setw(2) << j << "] = ";
      cout << setw(6) << src[i][j] << '\n';

      if (dst1[i][j] != dst2[i][j])
        cout << "Compare failed!\n";
    }
  }
}
