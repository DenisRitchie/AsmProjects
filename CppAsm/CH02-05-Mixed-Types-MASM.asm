
extern WriteConsoleA: proc
extern GetStdHandle: proc

.data
	message      db "Este es un mensaje desde lenguaje ensamblador"
	message_size equ $ - message

;
; extern "C" int64_t CH02_05_IntegerMul(int8_t a, int16_t b, int32_t c, int64_t d, int8_t e, int16_t f, int32_t g, int64_t h);
;
; Param a: cl
; Param b: dx
; Param c: r8d
; Param d: r9
; Param e: byte ptr [rsp + 40]
; Param f: word ptr [rsp + 48]
; Param g: dword ptr [rsp + 56]
; Param h: qword ptr [rsp + 64]
;
.code
CH02_05_IntegerMul proc
	; Calculate: a * b * c * d
	movsx  rax, cl                    ; rax = sign_extend(a)
	movsx  rdx, dx		              ; rdx = sign_extend(b)
	imul   rax, rdx                   ; rax = rax * rdx --> rax = a * b
	movsxd rcx, r8d                   ; rcx = sign_extend(c)
	imul   rcx, r9                    ; rcx = rcx * d --> rcx = c * d
	imul   rax, rcx                   ; rax = rax * rcx --> rax = a * b * c * d
	
	; Calculate: e * f * g * h
	movsx  rcx, byte ptr [rsp + 40]   ; rcx = sign_extend(e)
	movsx  rdx, word ptr [rsp + 48]   ; rdx = sign_extend(f)
	imul   rcx, rdx                   ; rcx = rcx * rdx --> rcx = e * f
	movsxd rdx, dword ptr [rsp + 56]  ; rdx = sign_extend(g)
	imul   rdx, qword ptr [rsp + 64]  ; rdx = rdx * h --> rdx = g * h
	imul   rcx, rdx                   ; rcx = rcx * rdx --> rcx = e * f * g * h

	; Compute the final product
	imul rax, rcx                     ; rax = final product -> a * b * c * d * e * f * g * h
	ret
CH02_05_IntegerMul endp

;
; extern "C" int32_t CH02_05_UnsignedIntegerDiv(uint8_t a, uint16_t b, uint32_t c, uint64_t d, uint8_t e, uint16_t f, uint32_t g, uint64_t h, uint64_t * quo, uint64_t * rem);
;
; Param a: cl
; Param b: dx
; Param c: r8d
; Param d: r9
; Param e: byte ptr [rsp + 40]
; Param f: word ptr [rsp + 48]
; Param g: dword ptr [rsp + 56]
; Param h: qword ptr [rsp + 64]
; Param quo: [rsp + 72] 
; Param rem: [rsp + 80]
;
CH02_05_UnsignedIntegerDiv proc
	; Calculate: a + b + c + d
	movzx rax, cl          ;     rax = zero_extend(a)
	movzx rdx, dx          ;     rdx = zero_extend(b)
	add   rax, rdx         ;     rax = rax + rdx --> rax = a + b
	mov   r8d, r8d         ;      r8 = zero_extend(c) ## TODO: Verificar si: (mov r8d, r8d) es un error
	add    r8, r9          ;      r8 = r8 + r9 --> r8 = c + d
	add   rax, r8          ;     rax = rax + r8 --> rax = a + b + c + d
	xor   rdx, rdx         ; rdx:rax = a + b + c + d --> used by (div <reg/mem>) exec rdx:rax / <reg/mem>

	; Calculate: e + f + g + h
	movzx   r8, byte ptr [rsp + 40]  ;  r8 = zero_extend(e)
	movzx   r9, word ptr [rsp + 48]  ;  r9 = zero_extend(f)
	add     r8, r9                   ;  r8 = r8 + r9 --> r8 = e + f
	mov   r10d, dword ptr [rsp + 56] ; r10 = zero_extend(g)
	add    r10, qword ptr [rsp + 64] ; r10 = r10 + qword ptr [rsp + 64] --> r10 = g + h
	add     r8, r10                  ; r8 = r8 + r10 --> r8 = e + f + g + h
	jnz  DivOk                       ; Jump if divisor is not zero
	xor    eax, eax                  ; Set error return code
	jmp   Done

	; Calculate: (a + b + c + d) * (e + f + g + h)
DivOk:
	div    r8                   ; Unsigned divide rdx:rax / r8
	mov   rcx, [rsp + 72]       ; Copy address of quo
	mov [rcx], rax              ; Save quotient: *quo = rax
	mov   rcx, [rsp + 80]       ; Copy addres of rem
	mov [rcx], rdx              ; Save remainder: *rem = rdx
	mov   eax, 1                ; Set success return code

Done:
	ret
CH02_05_UnsignedIntegerDiv endp


;
; extern "C" void CH02_05_Test_Movzx_And_Movzx(
;	 int8_t  _1,   int8_t  _2,   int8_t  _3,
;   uint8_t  _4,  uint8_t  _5,  uint8_t  _6,
;   int16_t  _7,  int16_t  _8,  int16_t  _9,
;  uint16_t _10, uint16_t _11, uint16_t _12);
; 
; Function Stack Frame
; https://en.wikibooks.org/wiki/X86_Disassembly/Functions_and_Stack_Frames
; 
; 
CH02_05_Test_Movzx_And_Movzx proc
	; TODO: Despues de aprender Stack Frame, volver acá y terminar de escribir esta función

	push rbp                          ; Save base pointer
	mov  rbp, rsp                     ; Set base pointer like the new stack top frame
	sub  rsp, 12                      ; alloc: sizeof(qword) + sizeof(dword)

	mov  ecx, -11                     ; STD_OUTPUT_HANDLE
	call GetStdHandle                 ; GetStdHandle(STD_OUTPUT_HANDLE)
	
	mov  qword ptr [rbp - 8], 0       ; _Reserved_ lpReserved
	lea   r9, dword ptr [rbp - 12] 	  ; _Out_opt_ lpNumberOfCharsWritten
	mov  r8d, message_size            ; _In_ nNumberOfCharsToWrite
	lea  rdx, offset message          ; _In_reads_(nNumberOfCharsToWrite) lpBuffer
	mov  rcx, rax                     ; _In_ hConsoleOutput
	call WriteConsoleA                ; WriteConsoleA(hConsoleOutput, lpBuffer, nNumberOfCharsToWrite, lpNumberOfCharsWritten, lpReserved)
	
	mov  eax, dword ptr [rbp - 12]    ; eax = lpNumberOfCharsWritten

	mov rsp, rbp                      ; Restore stack pointer
	pop rbp                           ; Restore base pointer
	ret
CH02_05_Test_Movzx_And_Movzx endp
end
