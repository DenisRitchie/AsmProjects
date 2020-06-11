COMMENT @
    extern "C" int32_t CH03_09_ReverseArray(
        int32_t *const dst,
        const int32_t *const src,
        const size_t length) noexcept;

    Returns: 0 = invalid length and 1 = success

    rcx = dst
    rdx = src
    r8  = length
@
.code
CH03_09_ReverseArray proc frame
; Save non-volatile registers
    push rsi
    .pushreg rsi
    push rdi
    .pushreg rdi
.endprolog

; Make sure length is valid
    xor eax, eax                 ; eax = 0, error return code
    test r8, r8                  ; and r8d, r8d | activate the RFLAGS. Is length <= 0?
    jle InvalidArg               ; jump if length <= 0

; Initialize registers for reversal operation
    mov rsi, rdx                 ; rsi = src    
    mov rdi, rcx                 ; rdi = dst
    mov rcx, r8                  ; rcx = length
    lea rsi, [rsi + rcx * 4 - 4] ; rsi = &src[length - 1]

; Save caller's RFLAGS.DF, then set RFLAGS.DF to 1
; RFLAGS.DF controls how language assembler iterates through the memory.
; RFLAGS.DF = 0 does the "++" and the RFLAGS.DF = 1 does the "--" .
    pushfq                       ; save caller's RFLAGS.DF
    std                          ; set direction flag, RFLAGS.DF = 1

; Repeat loop until array reversal is complete
@@: lodsd                        ; eax = *rsi--
    mov [rdi], eax               ; *rdi = eax
    add rdi, 4                   ; rdi++
    dec rcx                      ; length--
    jnz @B                       ; jump if length == 0

; Restore caller's RFLAGS.DF and set return code
    popfq                        ; restore caller's RFLAGS.DF
    mov eax, 1                   ; set success return code

; Restore non-volatile registers and return
InvalidArg:
    pop rdi
    pop rsi
    ret
CH03_09_ReverseArray endp
end
