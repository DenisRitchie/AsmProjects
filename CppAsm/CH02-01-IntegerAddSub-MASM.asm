; https://docs.microsoft.com/en-us/cpp/build/x64-calling-convention?view=vs-2019
; extern "C" int IntegerAddSub_(int a, int b, int c, int d);
; param 1: ecx
; param 2: edx
; param 3: r8d
; param 4: r9d
.code
CH02_01_IntegerAddSub proc
	; Calculate a + b + c - d
	mov eax, ecx   ; eax = a
	add eax, edx   ; eax = a + b
	add eax, r8d   ; eax = a + b + c
	sub eax, r9d   ; eax = a + b + c - d
	ret            ; return eax
CH02_01_IntegerAddSub endp
end