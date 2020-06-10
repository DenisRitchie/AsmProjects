; extern "C" uint32_t CH02_02_IntegerLogical(uint32_t a, uint32_t b, uint32_t c, uint32_t d);
; extern "C" uint32_t g_val1 = 0;
; param 1: ecx
; param 2: edx
; param 3: r8d
; param 4: r9d

extern g_val1: dword ; external double word (32bit) value

.code
CH02_02_IntegerLogical proc
	; Calculate (((a & b) | c) ^ d) + g_val1
	and ecx, edx       ; ecx = a & b                          -->   a = a & b
	or  ecx, r8d       ; ecx = (a & b) | c                    -->   a = a | c
	xor ecx, r9d       ; ecx = ((a & b) | c) ^ d              -->   a = a ^ d
	add ecx, [g_val1]  ; ecx = (((a & b) | c) ^ d) + g_val1	  -->   a = a + g_val1
	mov eax, ecx       ; eax = final result
	ret                ; return to caller
CH02_02_IntegerLogical endp
end
