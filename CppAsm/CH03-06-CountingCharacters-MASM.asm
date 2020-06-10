;
; extern "C" uint64_t CH03_06_CountingCharacters(const char *__restrict string, const char character) noexcept;
;
; Description: This function counts the numbers of occurrences
;              of character in a string.
;
; Returns:     Number of ocurrences found.
;
; Param1: rcx
; Param2: dl
;

.code
CH03_06_CountingCharacters proc frame
; Save non-volatile register
    push rsi                 ; save caller's rsi
    .pushreg rsi             ;
.endprolog

; Load parameters and initialize count registers
    mov rsi, rcx             ; rsi = string
    mov cl, dl               ; cl = character
    xor edx, edx             ; rdx = number of ocurrences
    xor r8d, r8d             ; r8 = 0 (required for add below)

; Repeat loop until the entire string has been scanned
@@: lodsb                    ; load next char into register al | al = byte ptr [rsi] | add rsi, sizeof byte
    or al, al                ; test for end-of-string
    jz @F                    ; jump if end-of-string found
    cmp al, cl               ; test current character
    sete r8b                 ; r8b = 1 if match, 0 otherwise
    add rdx, r8              ; update ocurrence count
    jmp @B                   ; jump to previous implicit label

@@: mov rax, rdx             ; rax = number of ocurrences

; Restore non-volatile register and return
    pop rsi
    ret
CH03_06_CountingCharacters endp
end
