section .text
	global intertwine

;; void intertwine(int *v1, int n1, int *v2, int n2, int *v);
;
;  Take the 2 arrays, v1 and v2 with varying lengths, n1 and n2,
;  and intertwine them
;  The resulting array is stored in v

intertwine:
	enter 0, 0

	;general index
	mov rbx, 0
iterate:
	; take the first value
	mov	rax, [rdi + 4 * rbx]
	; put it in v
	mov	[r8 + 8 * rbx], eax

	;take the second value
	mov	eax, [rdx + 4 * rbx]
	;put it in v
	mov	[r8 + 8 * rbx + 4], eax

	;check if we got to final of second array
	inc rbx
	cmp	rbx, rcx
	je 	full_v1

	;check if we got to first array
	cmp	rbx, rsi
	je	full_v2

	; go again and take values
	jmp iterate
full_v1:
	; check if we got to the final of v1
	; if yes, end the program
	cmp	rsi, rcx
	je 	finish

	mov	rdx, rbx
	; because we filled with n2 numbers(there will be n2 * 2 numbers)
	shl rdx, 1

take_v1:
	; take the next number
	mov	eax, [rdi + 4 * rbx]
	; put it in v
	mov	[r8 + 4 * rdx], eax

	;increment
	add	rdx, 1 
	add	rbx, 1
	
	; save rbx
	push rbx
	;check if we got to final of v1
	sub rbx, rsi
	cmp	rbx, 0
	pop rbx
	;if not take again the elements
	jne take_v1

	; finish the program
	jmp	finish

full_v2:
	; check if we got to the final of v2
	; if yes, end the program
	cmp	rsi, rcx
	je	finish

	; do the same thing
	mov	rdi, rbx
	shl rdi, 1
take_v2:
	;take the element
	mov	eax, [rdx + 4 * rbx]
	;put it in v
	mov	[r8 + 4 * rdi], eax

	add	rdi, 1
	add	rbx, 1

	push rbx
	sub rbx, rcx

	; check if we got to final of v2
	cmp	rbx, 0
	pop rbx
	jne take_v2

finish:
	leave
	ret
