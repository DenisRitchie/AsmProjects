COMMENT @
    ; https://docs.microsoft.com/en-us/cpp/c-runtime-library/crt-library-features?view=vs-2019
    ; https://docs.microsoft.com/en-us/cpp/c-runtime-library/reference/set-se-translator?view=vs-2019
    ; https://docs.microsoft.com/en-us/cpp/standard-library/cpp-standard-library-header-files?view=vs-2019
    ; https://docs.microsoft.com/en-us/cpp/c-runtime-library/run-time-routines-by-category?view=vs-2019
@

includelib libcmt.lib                      ; Statically links the native CRT startup into your code.
includelib libvcruntime.lib                ; Statically linked into your code.
includelib libucrt.lib                     ; Statically links the UCRT into your code.
includelib legacy_stdio_definitions.lib    ; 

extern printf_s: proc
extern scanf_s:  proc

.data
    write_number_1 db "Escriba un número:", 13, 10, "-> ", 0
    write_number_2 db "Escriba otro número:", 13, 10, "-> ", 0
    read_number    db "%d", 0
    output_result  db "La suma es: %d", 13, 10, 0

.data?
    num1 dword ?
    num2 dword ?
    sum  dword ?

.code
main proc
    enter 32d, 0 
    
    call sum_two_numbers

    leave
    xor rax, rax
    ret
main endp

sum_two_numbers proc
    enter 32d, 0
    
    mov rcx, offset write_number_1
    call printf_s
    
    mov rcx, offset read_number
    mov rdx, offset num1
    call scanf_s

    mov rcx, offset write_number_2
    call printf_s

    mov rcx, offset read_number
    mov rdx, offset num2
    call scanf_s

    mov edx, num1
    add edx, num2

    mov rcx, offset output_result
    call printf_s

    leave
    ret
sum_two_numbers endp

end
