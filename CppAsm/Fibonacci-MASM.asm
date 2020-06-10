;
; extern "C" uint32_t Fibonacci(uint32_t n);
;
; Returns: Fibonacci sequence number
;
; https://docs.microsoft.com/en-us/cpp/build/prolog-and-epilog?view=vs-2019
; https://en.wikipedia.org/wiki/Talk:Low-level_programming_language
;
.code
Fibonacci proc frame
	push rbx
	.pushreg rbx
.endprolog

	cmp ecx, 0              ; 
	ja @F                   ; jump if n > 0
	xor eax, eax            ; eax = 0
	jmp Exit				; return eax

@@: cmp ecx, 2              ; 
	ja @F                   ; jump if n > 2
	mov eax, 1              ; eax = 1
	jmp Exit                ; return eax

@@: mov edx, ecx            ; edx = n
	mov ebx, 1              ; ebx = 1
	mov ecx, 1              ; ecx = 1

	@@: xor eax, eax        ; eax = 0
	    add eax, ebx        ; eax = eax + ebx
		add eax, ecx        ; eax = eax + ecx
		cmp edx, 3          ;
		jbe @F              ; jump if edx <= 3
		mov ebx, ecx        ; ebx = ecx
		mov ecx, eax        ; ecx = eax
		dec edx             ; --edx / --n
		jmp @B

Exit:                       ; explicit exit label proc
@@:                         ; implicit exit label proc
	pop rbx
	ret                     ; return eax
Fibonacci endp
end
