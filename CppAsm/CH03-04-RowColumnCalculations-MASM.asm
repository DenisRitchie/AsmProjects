COMMENT @
----------------------------------------------------------------------------
                         IMPLEMENT EXTERN FUNCTION                         
----------------------------------------------------------------------------

    extern "C" int32_t CH03_04_CalcMatrixRowColSums(
            int32_t *__restrict row_sums,
            int32_t *__restrict col_sums,
      const int32_t *__restrict values,
      const int32_t             nrows,
      const int32_t             ncols
    ) noexcept;

    Returns: 
        0 = nrows <= 0 or ncols <= 0
        1 = success

----------------------------------------------------------------------------
                                STACK FRAME                                
----------------------------------------------------------------------------

            |----------------|----------|----------|-----------|
            |    Stack       |  Address | Register | Variables |
            |----------------|----------|----------|-----------|
HIGH MEMORY |       -        | RSP + 80 |          |           |
            |----------------|----------|----------|-----------|
            |       -        | RSP + 72 |          |           |
            |----------------|----------|----------|-----------|
            |       -        | RSP + 64 |          | ncols     |
            |----------------|----------|----------|-----------|
            | R9  Home       | RSP + 56 | R9       | nrows     |
            |----------------|----------|----------|-----------|
            | R8  Home       | RSP + 48 | R8       | values    |
            |----------------|----------|----------|-----------|
            | RDX Home       | RSP + 40 | RDX      | col_sums  |
            |----------------|----------|----------|-----------|
            | RCX Home       | RSP + 32 | RCX      | row_sums  |
            |----------------|----------|----------|-----------|
            | Return Address | RSP + 24 |          |           |
            |----------------|----------|----------|-----------|
            | Saved RBX      | RSP + 16 |          |           |
            |----------------|----------|----------|-----------|
            | Saved RSI      | RSP + 8  |          |           |
            |----------------|----------|----------|-----------|
 LOW MEMORY | Saved RDI      | RSP + 0  | RSP      |           |
            |----------------|----------|----------|-----------|
@
.code
CH03_04_CalcMatrixRowColSums proc frame
; Function prolog
    push rbx                            ; save caller's rbx
    .pushreg rbx                        ; 
    push rsi                            ; save caller's rsi 
    .pushreg rsi                        ; 
    push rdi                            ; save caller's rdi
    .pushreg rdi                        ; 
.endprolog                              ;

; Make sure nrows and ncols are valid
    xor eax, eax                        ; set error return code
                                        ; 
    cmp r9d, 0                          ; cmp(nrows, 0)
    jle InvalidArg                      ; jump if nrows <= 0
                                        ; 
    mov r10d, [rsp + 64]                ; r10d = ncols
                                        ;
    cmp r10d, 0                         ; cmp(ncols, 0)
    jle InvalidArg                      ; jump if ncols <= 0
                                
; Initialize elements of col_sums array to zero
    mov rbx, rcx                        ; temp save of row_sums
    mov rdi, rdx                        ; rdi = address of col_sums
    mov ecx, r10d                       ; ecx = ncols
    xor eax, eax                        ; eax = 0, fill value
    rep stosd                           ; fill array with zeros, rep stos dword ptr [rdi]

; The code below uses the following registers
; rcx = row_sums     |   rdx = col_sums
; r9d = nrows        |  r10d = ncols
; eax = row          |   ebx = col
; edi = row * ncols  |   esi = row * ncols + col
;  r8 = values       |  r11d = values[row][col]

; Initialize outer loop variables
    mov rcx, rbx                        ; rcx = row_sums
    xor eax, eax                        ; eax(row) = 0
                                        ; 
Loop1:                                  ; 
    mov dword ptr [rcx + rax * 4], 0    ; row_sums[rax(row)] = 0
    xor ebx, ebx                        ; ebx(col) = 0
    mov edi, eax                        ; edi = rax(row)
    imul edi, r10d                      ; edi(row) = edi * r10d(ncols)

; Inner loop
Loop2:                                  ; 
    mov esi, edi                        ; esi = edi(row * ncols)
    add esi, ebx                        ; esi = esi(row * ncols) + ebx(col)
    mov r11d, [r8 + rsi * 4]            ; r11d = values[row * ncols + col]
    add [rcx + rax * 4], r11d           ; row_sums[row] += values[row * ncols + col]
    add [rdx + rbx * 4], r11d           ; col_sums[col] += values[row * ncols + col]

; Is the inner loop finished?
    inc ebx                             ; ebx(col)++
    cmp ebx, r10d                       ; cmp(ebx(col), r10d(ncols)))
    jl Loop2                            ; jump if ebx(col) < r10d(ncols)
                                        
; Is the outer Loop finished?
    inc eax                             ; eax(row)++
    cmp eax, r9d                        ; cmp(eax(row), r9d(nrows))
    jl Loop1                            ; jump if eax(row) < r9d(nrows)
                                        ; 
    mov eax, 1                          ; set success return code

; Function epilog
InvalidArg:
    pop rdi                             ; restore non-volatile registers and return 
    pop rsi                             ; 
    pop rbx                             ; 
    ret                                 ; 
CH03_04_CalcMatrixRowColSums endp
end
