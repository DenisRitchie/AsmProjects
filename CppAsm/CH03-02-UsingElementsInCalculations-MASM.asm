; 
; https://docs.microsoft.com/en-us/cpp/build/prolog-and-epilog?view=vs-2019
; https://docs.microsoft.com/en-us/cpp/assembler/masm/masm-for-x64-ml64-exe?view=vs-2019
; https://docs.microsoft.com/en-us/cpp/assembler/masm/proc?view=vs-2019
; https://docs.microsoft.com/en-us/cpp/assembler/masm/dot-setframe?view=vs-2019
; https://docs.microsoft.com/en-us/cpp/assembler/masm/dot-pushframe?view=vs-2019
; https://docs.microsoft.com/en-us/cpp/assembler/masm/dot-pushreg?view=vs-2019
; https://docs.microsoft.com/en-us/cpp/assembler/masm/dot-allocstack?view=vs-2019
; https://docs.microsoft.com/en-us/cpp/assembler/masm/dot-endprolog?view=vs-2019
; https://stackoverflow.com/questions/3699283/what-is-stack-frame-in-assembly
;
; extern "C" int64_t CH03_02_CalcArrayValues(int64_t * dst, const int32_t * src, const int32_t a, const int16_t b, const int32_t n);
;
; Calculation: dst[i] = src[i] * a + b
;
; Returns: Sum of the elements in array dst.
;
.code
; ----------------------- Begin Proc -----------------------
CH03_02_CalcArrayValues proc frame
; Function prolog
	push rsi       ; Save volatile index register rsi (source index)
	.pushreg rsi   ; Push 8 bytes to the stack from rsp 
	push rdi       ; Save volatile index register rdi (destination index)
	.pushreg rdi   ; Push 8 bytes to the stack from rsp
.endprolog

; dword n 	     | 	   | rsp + 56
; word  b	     | r9w | rsp + 48
; dword a	     | r8d | rsp + 40
; dword src	     | rdx | rsp + 32
; qword dst      | rcx | rsp + 24
; Return Address |     | rsp + 16
; Saved rsi      | 	   | rsp + 8
; Saved rdi      | 	   | rsp + 0

; Initialize sum to zero and make sure 'n' is valid
	xor rax, rax             ; sum = 0
	mov r11d, [rsp + 56]     ; r11d = n
	cmp r11d, 0              ; 
	jle InvalidCount         ; jump if r11d <= 0

; Initialize source and destination pointers
	mov rsi, rdx             ; rsi = ptr to array src
	mov rdi, rcx             ; rdi = ptr to array dst

; Load expression constants and array index
	movsxd r8, r8d           ; r8 = a (sign extended)
	movsx  r9, r9w           ; r9 = b (sign extended)
	xor    edx, edx          ; edx = array index i

; Repeat until done
@@:	movsxd rcx, dword ptr [rsi + rdx * 4] ; rcx = src[i] (sign extended)
	imul   rcx, r8                        ; rcx = src[i] * a
	add    rcx, r9                        ; rcx = src[i] * a + b
	mov    qword ptr [rdi + rdx * 8], rcx ; dst[i] = rcx
										  ;
	add    rax, rcx                       ; update running sum
										  ;
	inc    edx                            ; edx = i + 1
	cmp    edx, r11d                      ; is i >= n?
	jl     @B                             ; jump if i < n

InvalidCount:
; Function epilog
	pop rdi        ; Restore caller's rdi
	pop rsi        ; Restore caller's rsi
	ret
CH03_02_CalcArrayValues endp
; ----------------------- End Proc -----------------------

end
