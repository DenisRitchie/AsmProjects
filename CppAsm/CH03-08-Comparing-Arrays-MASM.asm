COMMENT @
    ; https://www.felixcloutier.com/x86/test

    extern "C" int64_t CH03_08_CompareArrays(
      const int32_t * __restrict ar1,
      const int32_t * __restrict ar2,
      const int64_t length) noexcept;

    Returns: [-1                  ] Value of 'length' is invalid
             [0 <= index <= length] Index offset first non-matching element
             [length              ] All element match

    rcx => ar1     => rsp + 24
    rdx => ar2     => rsp + 32
    r8  => length  => rsp + 40
@
.code
CH03_08_CompareArrays proc frame
; Save non-volatile registers
    push rsi
    .pushreg rsi
    push rdi
    .pushreg rdi
.endprolog

; Load arguments and validate 'length'
    mov rax, -1             ; rax = return code for invalid length
    test r8, r8             ; equals that and instruction
    jle @F                  ; jump if n <= 0

; Compare the arrays for equality
    mov rsi, rcx            ; rsi = ar1
    mov rdi, rdx            ; rdi = ar2
    mov rcx, r8             ; rcx = length
    mov rax, r8             ; rcx = length
    ;
    ; while (rcx != 0 && RFLAGS.ZF == 1)
    ; {
    ;   cmp [rdi], [rsi]
    ;   sub rdi, 8
    ;   sub rsi, 8
    ;   dec rcx
    ; }
    ; After the finish the loop, RFLAGS.ZF or will be 1 or 0
    ; Where "je @F" will analyze RFLAGS.ZF
    ; if RFLAGS.ZF equal one the arrays are equals, otherwise the arrays are differents
    ; 
    repe cmpsd              ; 
    je @F                   ; arrays are equal

; Calculate index of fist non-match
    sub rax, rcx            ; rax = index of mismatch + 1
    dec rax                 ; --rax

; Restore non-volatile registers and return
@@: pop rdi
    pop rsi
    ret
CH03_08_CompareArrays endp
end

