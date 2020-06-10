// https://stackoverflow.com/questions/43769467/x86-assembly-pointers
// https://www.cs.uaf.edu/courses/cs301/2014-fall/notes/pointer-arithmetic/

#include <iostream>
#include <Windows.h>

using namespace std;

void TestInlineAsm()
{
#ifndef _AMD64_
  int  a = 10; // memory
  int *b = &a; // memory
  int  c;      // memory
  int *ptr_c;  // memory
  
  /*
  mov  register, register     ; copy one register to another
  mov  register, memory       ; load value from memory into register
  mov  memory,   register     ; store value from register into memory
  mov  register, immediate    ; move immediate value (constant) into register
  mov  memory,   immediate    ; store immediate value (constant) in memory
  */

  __asm
  {
    mov eax, dword ptr [b]   ; eax = b donde eax apunta a la misma dirección que tiene b
    mov ebx, eax             ; ebx = eax donde ebx ahora tambien apuntara a la direccion de memoria que apunta eax
    mov eax, dword ptr [eax] ; eax = *eax ahora eax tiene el valor del puntero al que apunta
    mov c, eax               ; c = eax donde c = 10
    mov [ebx], 20            ;  *ebx = 20 donde ebx tiene la dirección de a
  }

  printf_s("A = %d, C = %d\n", a, c);

  __asm
  {
    lea eax, [c]   ; eax   = &c 
    mov ptr_c, eax ; ptr_c = eax  
  }

  *ptr_c = 30;
  printf_s("Ptr_C = %d, C = %d\n", *ptr_c, c);

  char  text[] = "-> %s %s\n";
  char    hi[] = "Hello";
  char earth[] = "World";
  
  __asm
  {
    lea eax, earth
    push eax
    lea eax, hi
    push eax
    lea eax, text
    push eax
    call dword ptr printf_s
    pop ebx
    pop ebx
    pop ebx
  }
#endif // !_AMD64_
}

