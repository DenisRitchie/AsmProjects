;
; extern "C" void CH03_03_CalcMatrixSquares(int32_t * dst, const int32_t * src, const int32_t nrows, const int32_t ncols);
;
; Calculates: dst[i][j] = src[j][i] * src[j][i]
;
.code
CH03_03_CalcMatrixSquares proc frame
; Function prolog
    push rsi        ; Save caller's rsi (Source Index)    
    .pushreg rsi    ;
    push rdi        ; Save caller's rdi (Destination Index)
    .pushreg rdi
.endprolog

; r9 Home        | rsp + 48 | r9d | ncols
; r8 Home        | rsp + 40 | r8d | nrows
; rdx Home       | rsp + 32 | rdx | src
; rcx Home       | rsp + 24 | rcx | dst
; Return Address | rsp + 16 |     | 
; Saved rsi      | rsp + 8  |     | 
; Saved rdi      | rsp + 0  | rsp | 
 
; Make sure nrows and ncols are valid
    cmp r8d, 0           ;
    jle InvalidCount     ; jump if nrows <= 0
    cmp r9d, 0           ;
    jle InvalidCount     ; jumo if ncols <= 0

; Initialize pointers to source and destination arrays
    mov    rsi, rdx      ; rsi = src
    mov    rdi, rcx      ; rdi = dst
    xor    rcx, rcx      ; rcx = i, use rcx as row index
    movsxd  r8, r8d      ;  r8 = nrows sign extended
    movsxd  r9, r9d      ;  r9 = ncols sign extended 

; Perfom the required calculations
Loop1:
    xor rdx, rdx         ; rdx = j, use rdx as column index
Loop2:
    mov   rax, rdx                       ; rax = j
    imul  rax, r9                        ; rax = j * ncols
    add   rax, rcx                       ; rax = j * ncols + i
    mov  r10d, dword ptr [rsi + rax * 4] ; r10d = src[j][i]
    imul r10d, r10d                      ; r10d = src[j][i] * src[j][i]
                                         ;
    mov   rax, rcx                       ; rax = i
    imul  rax, r9                        ; rax = i * ncols
    add   rax, rdx                       ; rax = i * ncols + j
    mov  dword ptr [rdi + rax * 4], r10d ; dst[i][j] = r10d
                                         ;
    inc   rdx                            ; ++j
    cmp   rdx, r9                        ;
    jl    Loop2                          ; jump if j < ncols
                                         ;
    inc   rcx                            ; ++i
    cmp   rcx, r8                        ;
    jl    Loop1                          ; jump if i < nrows

InvalidCount:
; Function epilog
    pop rdi
    pop rsi
    ret
CH03_03_CalcMatrixSquares endp
end

