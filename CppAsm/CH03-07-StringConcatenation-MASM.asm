COMMENT @
    ; https://www.felixcloutier.com/x86/scas:scasb:scasw:scasd
    ; https://www.felixcloutier.com/x86/rep:repe:repz:repne:repnz
    ; https://www.felixcloutier.com/x86/movs:movsb:movsw:movsd:movsq

    extern "C" size_t CH03_07_ConcatString(
      char *const dst,
      const size_t dst_size,
      const char *const *const src,
      const size_t src_n
    ) noexcept;

    Returns: |   -1   | Invalid "dst_size"
             | n >= 0 | Length of concatenated string

    ------------------------------------------------------------------------------
                                    PARAMETERS
    ------------------------------------------------------------------------------
    rcx = dst
    rdx = dst_size
    r8  = src
    r9  = src_n
@

.code
CH03_07_ConcatString proc frame
; Save non-volatile registers
    push rbx                          ; save caller's rbx
    .pushreg rbx                      ; 
    push rsi                          ; save caller's rsi
    .pushreg rsi                      ; 
    push rdi                          ; save caller's rdi
    .pushreg rdi                      ; 
    PX64_SIZE = 8                     ; Default x64 pointer size
.endprolog 

; Make sure dst_size and src_n are valid
    mov  rax, -1                      ; set error code
    test rdx, rdx                     ; test dst_size
    jz   InvalidArg                   ; jump if dst_size is 0
    test r9, r9                       ; test src_n
    jz   InvalidArg                   ; jump if src_n is 0

; Registers used processing loop below
; rbx = dst             rdx = dst_size
;  r8 = src              r9 = src_n
; r10 = dst_index       r11 = src_index
; rcx = string length
; rsi, rdi = pointers for scasb & movsb instructions

; Perform required initializations
    xor r10, r10                      ; dst_index = 0
    xor r11, r11                      ; src_index = 0
    mov rbx, rcx                      ;       rbx = dst
    mov byte ptr [rbx], 0             ;      *dst = '\0'

; Repeat loop until concatenation is finished
Loop1: mov rax, r8                        ; rax = src
       mov rdi, [rax + r11 * PX64_SIZE]   ; rdi = src[src_index] | used to count the length of the array
       mov rsi, rdi                       ; rsi = src[src_index] | array to copy

; Compute lenght of src[src_index]: strlen(src[src_index])
; 
; https://www.felixcloutier.com/x86/scas:scasb:scasw:scasd
; https://www.felixcloutier.com/x86/rep:repe:repz:repne:repnz
; 
; repne: Repeat String Operation While not Equal
;        * Repeat while rcx != 0 and RFLAG.ZF == 0 is true 
;
; scasb: Scan String Byte
;        * Lee el caracter de la dirección de memoria en "rdi"
;        * Compara el caracter leido con el contenido de "(r|e)ax | al"
;        * Modifica los flags al igual que cmp
;        * Avanza el puntero "rdi" a la siguente ubicación de memoria "rdi++"
;
; rcx = -1
; while (rcx != 0 && RFLAG.ZF == false)
; {
;   if ((eax - *rdi) == 0) {
;     RFLAG.ZF = true
;   }
;   ++rdi
;   --rcx          
; }
; 
; rcx = -(L + 2) where "L" is the actual length of src[src_index]
; the instruction "not" when inverting the value subtract a number from the value and 
; the instruction "dec" subtract another number of the length of the original value
;    
    xor eax, eax                      ; eax = 0
    mov rcx, -1                       ; rcx = -1
    repne scasb                       ; find '\0'
    not rcx                           ; ~rcx ó rcx ^= -1
    dec rcx                           ; rcx = len(src[src_index])

; Compute dst_index + src_len
    mov rax, r10                      ; rax = dst_index
    add rax, rcx                      ; dst_index + len(src[src_index])
    cmp rax, rdx                      ; is dst_index + src_len >= dst_size?
    jge Done                          ; jump if dst is too small

; Update dst_index
    mov rax, r10                      ; dst_index_old = dst_index
    add r10, rcx                      ; dst_index += len(src[src_index])

; Copy src[src_index] to &dst[dst_index] (rsi already containt src[src_index])
;
; https://www.felixcloutier.com/x86/movs:movsb:movsw:movsd:movsq
; 
; rep movsb: Repeat Move String Byte
; The rep movsb instruction copies the string pointed to by RSI to the memory location pointed to by RDI
; using the length specified in RCX 
;
; An inc rcx instruction is executed before the string copy to ensure that
; the end-of-string terminator '\0' is also transferred to dst
; 
; Register RDI is initialized to the correct offset
; in dst using a lea rdi, [rbx+rax] (Load Effective Address) instruction, which computes the address of
; the specified source operand (i.e., lea calculates RDI = RBX + RAX). 
; 
    inc rcx                           ; rcx = len(src[src_index]) + 1
    lea rdi, [rbx + rax]              ; rdi = &dst[dst_index_old]
    rep movsb                         ; perform string move

; Update src_index and repeat if not done
    inc r11                           ; ++src_index
    cmp r11, r9                       ; compare if r11 < r9
    jl Loop1                          ; jump if src_index < src_n

; Return length of concatenated string

Done: mov rax, r10                    ; rax = dst_index (final length)

; Restore  non-volatile registers and return
InvalidArg:
    pop rdi
    pop rsi
    pop rbx
    ret
CH03_07_ConcatString endp
end

