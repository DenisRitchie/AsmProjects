#include <iostream>
#include <stdint.h>

using namespace std;

extern "C" uint64_t CH03_06_CountingCharacters(const char *__restrict string, const char character) noexcept;

void CH03_06_CountingCharacters_Test() noexcept
{
  constexpr char nl = '\n';
  constexpr const char *string0 = "Test String: ";
  constexpr const char *string1 = "  Search Char: ";
  constexpr const char *string2 = " Count: ";

  char character;
  const char *string;

  string = "Four score and seven seconds ago, ...";
  cout << nl << string0 << string << nl;

  character = 's';
  cout << string1 << character << string2 << CH03_06_CountingCharacters(string, character) << nl;
  character = 'o';
  cout << string1 << character << string2 << CH03_06_CountingCharacters(string, character) << nl;
  character = 'z';
  cout << string1 << character << string2 << CH03_06_CountingCharacters(string, character) << nl;
  character = 'F';
  cout << string1 << character << string2 << CH03_06_CountingCharacters(string, character) << nl;
  character = '.';
  cout << string1 << character << string2 << CH03_06_CountingCharacters(string, character) << nl;


  string = "Red Green Blue Cyan Magenta Yellow";
  cout << nl << string0 << string << nl;

  character = 'e';
  cout << string1 << character << string2 << CH03_06_CountingCharacters(string, character) << nl;
  character = 'w';
  cout << string1 << character << string2 << CH03_06_CountingCharacters(string, character) << nl;
  character = 'l';
  cout << string1 << character << string2 << CH03_06_CountingCharacters(string, character) << nl;
  character = 'Q';
  cout << string1 << character << string2 << CH03_06_CountingCharacters(string, character) << nl;
  character = 'n';
  cout << string1 << character << string2 << CH03_06_CountingCharacters(string, character) << nl;
}
