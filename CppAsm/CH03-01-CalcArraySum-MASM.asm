;
; extern "C" int32_t CH03_01_CalcArraySum(const int32_t * ar, const int32_t n);
;
; Returns: Sum of elements in array ar
;
.code
CH03_01_CalcArraySum proc
	; Initializate sum to zero
	xor eax, eax                ; sum = 0

	; Make sure 'n' is greater than zero
	cmp edx, 0
	jle InvalidCount            ; jump if n <= 0

	; Sum the elements of the array
	@@: add eax, [rcx]          ; add next element to total (sum += *ar)
		add rcx, 4              ; set pointer to next element (++ar)
		dec edx                 ; adjust counter (--n)
		jnz @B                  ; jump if n != 0, repeat it not done.

InvalidCount:
	ret
CH03_01_CalcArraySum endp
end
