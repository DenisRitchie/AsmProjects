; extern "C" int CH02_03_IntegerShift(uint32_t a, uint32_t count, uint32_t * a_shl, uint32_t * a_shr);
;
; return  0 == error (count >= 32), 1 = success
;
; Param 1: ecx
; Param 2: edx
; Param 3: r8d
; Param 4: r9d
;
; https://stackoverflow.com/questions/20906639/difference-between-ja-and-jg-in-assembly
; https://en.wikibooks.org/wiki/X86_Assembly/X86_Architecture
; https://software.intel.com/content/www/us/en/develop/articles/introduction-to-x64-assembly.html
; https://en.wikibooks.org/wiki/X86_Assembly/Control_Flow
; http://www.godevtool.com/GoasmHelp/usflags.htm
; https://en.m.wikipedia.org/wiki/FLAGS_register
; cmp: realiza una comparación mediante una resta y modifica los flags como parte de sus resultados
; ja: evalua los flags: CF(Carry{Suma} or Borrow{Resta}) y ZF(Zero), para poder hacer el salto
; 

.code
CH02_03_IntegerShift proc
	xor eax, eax         ; Set return code in case of error
	cmp edx, 31          ; Compare count against 31 --> (edx - 31)
	ja  InvalidCount     ; Jump if Count(edx) > 31: ja -> CF = 0 y ZF = 0

	xchg ecx, edx        ; Exchange contents of ecx & edx
	mov  eax, edx        ; eax = a
	shl  eax, cl         ; eax = a << Count
	mov  [r8], eax       ; Save result: *a_shl = eax

	shr  edx, cl         ; edx = a >> Count
	mov  [r9], edx       ; Save result: *a_shr = edx

	mov eax, 1           ; Set success return code

InvalidCount:
	ret                  ; Return to caller 
CH02_03_IntegerShift endp
end
