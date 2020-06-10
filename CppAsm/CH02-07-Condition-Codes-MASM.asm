;
; https://en.wikipedia.org/wiki/Talk:Low-level_programming_language
; 
; 
; extern "C" int32_t CH02_07_SignedMinA(int32_t a, int32_t b, int32_t c);
;
; Returns: min(a, b, c)
;
.code
CH02_07_SignedMinA proc
	mov eax, ecx         ; eax = ecx              --> eax = a
	cmp eax, edx         ; cmp(eax, b)            --> cmp(a, b)
	jle @F               ; jump if a <= b
	mov eax, edx         ; eax = edx              --> eax = b

@@: cmp eax, r8d         ; cmp(eax, r8d)          --> cmp(min(a, b), c)
	jle @F               ; jump if min(a, b) <= c
	mov eax, r8d         ; eax = r8d              --> eax = min(a, b, c)

@@: ret
CH02_07_SignedMinA endp

;
; extern "C" int32_t CH02_07_SignedMaxA(int32_t a, int32_t b, int32_t c);
;
; Returns: max(a, b, c)
; 
CH02_07_SignedMaxA proc
	mov eax, ecx         ; eax = a
	cmp eax, edx         ; cmp(eax, b)
	jge @F               ; jump if a >= b
	mov eax, edx         ; eax = b

@@: cmp eax, r8d         ; cmp(eax, c)
	jge @F               ; jump if max(a, b) >= c
	mov eax, r8d         ; eax = max(a, b, c)

@@: ret
CH02_07_SignedMaxA endp

;
; extern "C" int32_t CH02_07_SignedMinB(int32_t a, int32_t b, int32_t c);
;
; Returns: min(a, b, c)
;
CH02_07_SignedMinB proc
	cmp   ecx, edx       ; cmp(a, b)
	cmovg ecx, edx       ; ecx = a if a > b
	cmp   ecx, r8d       ; cmp(ecx, c)
	cmovg ecx, r8d       ; ecx = c if ecx > c
	mov   eax, ecx       ; eax = ecx
	ret
CH02_07_SignedMinB endp

;
; extern "C" int32_t CH02_07_SignedMaxB(int32_t a, int32_t b, int32_t c);
;
; Returns: max(a, b, c)
;
CH02_07_SignedMaxB proc
	cmp   ecx, edx       ; cmp(a, b)
	cmovl ecx, edx       ; ecx = a if a < b
	cmp   ecx, r8d       ; cmp(ecx, c)
	cmovl ecx, r8d       ; ecx = c if ecx < c
	mov   eax, ecx       ; eax = ecx
	ret
CH02_07_SignedMaxB endp
end
