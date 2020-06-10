; Contador de ubicación actual "$"
; https://stackoverflow.com/a/41332233/9277781
; https://www.plantation-productions.com/Webster/www.artofasm.com/DOS/ch08/CH08-1.html#HEADING1-58
; 

; Simple lookup table (.const section data is read only)
; extern "C" int32_t g_NumFibVals, g_FibValsSum;
.const
	FibVals dword 0, 1, 1, 2, 3, 5, 8, 13
			dword 21, 34, 55, 89, 144, 233, 377, 610, 987, 1597

	g_NumFibVals dword ($ - FibVals) / sizeof dword
	public g_NumFibVals

; Data section (data is read/write)
.data
	g_FibValsSum dword ?  ; Value to demo RIP-relative addressing
	public g_FibValsSum

;
; extern "C" int32_t CH02_06_MemoryAddressing(int32_t i, int32_t * v1, int32_t * v2, int32_t * v3, int32_t * v4);
;
; Returns: 0 = error (invalid table index), 1 = success
;
.code
CH02_06_MemoryAddressing proc
; Make sure "i" is valid
	cmp ecx, 0                     ; cmp(i  0)
	jl  InvalidIndex               ; jump if i < 0
	cmp ecx, [g_NumFibVals]        ; cmp (i, g_NumFibVals)
	jge InvalidIndex               ; jump if i >= g_NumFibVals

; Sign extend i for use in address calculations
	movsxd rcx, ecx                ; Sign extend i
	mov    [rsp + 8], rcx          ; Save copy of i (in rcx home area)
	
; Example #1 - base register
	mov r11, offset FibVals        ; r11 = FibVals
	shl rcx, 2                     ; rcx = rcx * 4                  --> rcx = i * 4
	add r11, rcx                   ; r11 = r11 + rcx * (shl rcx, 2) --> r11 = FibVals + i * 4 
	mov eax, [r11]                 ; eax = *r11                     --> eax = FibVals[i]
	mov [rdx], eax                 ; Save to v1: *rdx = eax         --> *v1 = eax 

; Example #2 - base register + index register
	mov r11, offset FibVals        ; r11 = FibVals
	mov rcx, [rsp + 8]             ; rcx = i
	shl rcx, 2                     ; rcx = i * 4
	mov eax, [r11 + rcx]           ; eax = FibVals[i]
	mov [r8], eax                  ; Save to v2                     --> *v2 = eax
								   
; Example #3 - base register + index register * scale factor
	mov r11, offset FibVals        ; r11 = FibVals
	mov rcx, [rsp + 8]             ; rcx = i
	mov eax, [r11 + rcx * 4]       ; eax = FibVals[i]
	mov [r9], eax                  ; Save to v3                     --> *v3 = eax
								   
; Example #4 - base register + index register * scale factor + displacement
	mov r11, offset FibVals - 42   ; r11 = FibVals - 42
	mov rcx, [rsp + 8]             ; rcx = i
	mov eax, [r11 + rcx * 4 + 42]  ; eax = FibVals[i]
	mov r10, [rsp + 40]            ; r10 = ptr to v4
	mov [r10], eax                 ; Save to v4                     --> *v4 = eax

; Example #5 - RIP relative
	add [g_FibValsSum], eax        ; Update sum
	mov eax, 1                     ; Set succes code
	ret

InvalidIndex:
	xor eax, eax         ; Set error code: eax = 0
	ret
CH02_06_MemoryAddressing  endp
end



