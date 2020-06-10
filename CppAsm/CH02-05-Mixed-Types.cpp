#include <Windows.h>
#include <iostream>
#include <cstdint>

using namespace std;

extern "C" int64_t CH02_05_IntegerMul(
  const int8_t  a,
  const int16_t b,
  const int32_t c,
  const int64_t d,
  const int8_t  e,
  const int16_t f,
  const int32_t g,
  const int64_t h) noexcept;

extern "C" int32_t CH02_05_UnsignedIntegerDiv(
  const uint8_t  a,
  const uint16_t b,
  const uint32_t c,
  const uint64_t d,
  const uint8_t  e,
  const uint16_t f,
  const uint32_t g,
  const uint64_t h,
  uint64_t * __restrict quo,
  uint64_t * __restrict rem) noexcept;

extern "C" void CH02_05_Test_Movzx_And_Movzx(
    /*int8_t  _1,   int8_t  _2,   int8_t  _3,
   uint8_t  _4,  uint8_t  _5,  uint8_t  _6,
   int16_t  _7,  int16_t  _8,  int16_t  _9,
  uint16_t _10, uint16_t _11, uint16_t _12*/);


void IntegerMul()
{
  constexpr int8_t  a = 2;
  constexpr int16_t b = -3;
  constexpr int32_t c = 8;
  constexpr int64_t d = 4;
  constexpr int8_t  e = 3;
  constexpr int16_t f = -7;
  constexpr int32_t g = -5;
  constexpr int64_t h = 10;

  // Calculate: a * b * c * d * e * f * g * h
  constexpr int64_t prod1 = static_cast<int64_t>(a) * b * c * d * e * f * g * h;
  int64_t prod2 = CH02_05_IntegerMul(a, b, c, d, e, f, g, h);

  cout << "\nResult for IntegerMul\n";
  cout << "A = " << static_cast<int32_t>(a) << ", B = " << b << ", C = " << c << ' ';
  cout << "D = " << d << ", E = " << static_cast<int32_t>(e) << ", F = " << f << ' ';
  cout << "G = " << g << ", H = " << h << '\n';

  cout << "Prod1: " << prod1 << '\n';
  cout << "Prod1: " << prod2 << '\n';
}

void UnsignedIntegerDiv()
{
  constexpr uint8_t  a = 12;
  constexpr uint16_t b = 17;
  constexpr uint32_t c = 71000000;
  constexpr uint64_t d = 90000000000;
  constexpr uint8_t  e = 101;
  constexpr uint16_t f = 37;
  constexpr uint32_t g = 25;
  constexpr uint64_t h = 5;

  constexpr uint64_t quo1 = (static_cast<int64_t>(a) + b + c + d) / (static_cast<int64_t>(e) + f + g + h);
  constexpr uint64_t rem1 = (static_cast<int64_t>(a) + b + c + d) % (static_cast<int64_t>(e) + f + g + h);

  uint64_t quo2, rem2;
  CH02_05_UnsignedIntegerDiv(a, b, c, d, e, f, g, h, &quo2, &rem2);

  cout << "\nResult for UnsignedIntegerDiv\n";
  cout << "A = " << static_cast<unsigned>(a) << ", B = " << b << ", C = " << c << ' ';
  cout << "D = " << d << ", E = " << static_cast<unsigned>(e) << ", F = " << f << ' ';
  cout << "G = " << g << ", H = " << h << '\n';
  cout << "Quo1 = " << quo1 << ", Rem1 = " << rem1 << '\n';
  cout << "Quo2 = " << quo2 << ", Rem2 = " << rem2 << '\n';
}

void UndertandingMovsxAndMovzx()
{
  constexpr int8_t
    _1 = -1,
    _2 = -2,
    _3 = 3;

  constexpr uint8_t
    _4 = 4,
    _5 = 5,
    _6 = 6;

  constexpr int16_t
    _7 = 16,
    _8 = -16,
    _9 = 8;

  constexpr uint16_t
    _10 = 127,
    _11 = 256,
    _12 = 512;

  // TODO: Despues de aprender Stack Frame, volver acá y terminar de escribir esta función
  CH02_05_Test_Movzx_And_Movzx(/*_1, _2, _3, _4, _5, _6, _7, _8, _9, _10, _11, _12*/);
}

auto TestWrite() noexcept -> void
{
  DWORD number_of_chars_written;

  constexpr const char message[] = "Message from Win32 Function";
  constexpr DWORD length = sizeof(message) / sizeof(char);

  WriteConsoleA(GetStdHandle(STD_OUTPUT_HANDLE),
                message,
                length,
                &number_of_chars_written,
                nullptr);

  cout << "\n\n number_of_chars_written: " << number_of_chars_written << endl;
}

auto CH02_05_Mixed_Types_Test() noexcept -> void
{
  TestWrite();
  IntegerMul();
  UnsignedIntegerDiv();
  UndertandingMovsxAndMovzx();
}





