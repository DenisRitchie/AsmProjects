;
; extern "C" int CH02_04_IntegerMulDiv(int32_t a, int32_t b, int32_t * prod, int32_t * quo, int32_t * rem);
;
; Returns: 0 = error (division equals zero), 1 = success
;
; Param 1: ecx 
; Param 2: edx
; Param 3: r8
; Param 4: r9
; Param 5: [rsp + 40]
; param 6: [rsp + 48]
;
; Partes de la multiplicación
; eax = Multiplicando
; eax = Producto
; [reg/mem] = Multiplicador
; mul <reg/mem>
;
; Partes de la división
; eax = Dividendo
; eax = Cociente
; edx = Residuo
; [reg/mem] = Divisor
; div <reg/mem>
;
; En asm los registros actuan como un doble puntero
; por ejemplo: "mov rbx, [rax]" rax devuelve la direccion de memoria y lo copia en rbx
; "mov [rbx], 15" se asigna el valor de 15 el dato al que apunto [rbx]
;
; https://www.youtube.com/watch?v=moV17KXCYXQ
;
.code
CH02_04_IntegerMulDiv proc
	; Make sure the divisor is not zero
	mov eax, edx          ; eax = b
	or  eax, eax          ; Logical OR sets status flags
	jz  InvalidDivisor    ; Jump if "b" is zero (ZF = 0)

	; Calculate product and save result
	imul  eax, ecx        ; eax = eax * a
	mov  [r8], eax        ; Save Product: *prod = eax

	; Calculate quotient(cociente) and remainder(resto), save results
	mov r10d, edx         ; r10d = b
	mov  eax, ecx         ;  eax = a
	; Convert DWord to QWord
	; mov the eax to edx:eax
	cdq                   ; edx:eax Contains 64-bit dividend
	; idiv <reg/mem> = edx:eax / <reg/mem> 
	idiv r10d             ; eax = quotient, edx = remainder

	mov  [r9], eax        ; Save quotient: *quo = eax
	mov   rax, [rsp + 40] ; rax = address of rem. int64_t *rax = rem
	mov [rax], edx        ; Save remainder: *rax = edx
	mov   eax, 1          ; Set success return code

InvalidDivisor:
	ret                   ; Return to caller
CH02_04_IntegerMulDiv endp
end
