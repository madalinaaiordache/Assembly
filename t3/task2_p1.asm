section .text
	global cmmmc

;; int cmmmc(int a, int b)
;
;; calculate least common multiple fow 2 numbers, a and b

substract:
	; now we gona find the cmmdc between those two
    cmp ebx, 0
	; check if the second number is zero
    je finish

	; make the remaining value zero before assigned to i
	mov edx, 0
	; find the quotient
    div ebx

	; swap values
	; mov the second number in eax
    mov eax, ebx
	; mov in the place of the second number the quotient
    mov ebx, edx

	; go back to algorithm
    jmp substract

cmmmc:
    enter 0, 0

	; take the first value
	mov eax, dword[ebp + 8]
	; take the second value
	mov ebx, dword[ebp + 12]

algorithm:
	; compare the two values
    cmp eax, ebx
	; if the first one is bigger go to algorithm
    jg substract

	; swap values
	mov edx, eax
	mov eax, ebx
	mov ebx, edx
	jmp substract

finish:
	; save the cmmdc
    mov ecx, eax
	; take the first number
    mov eax, dword[ebp + 8]

	;multiple with the second one
    mul dword[ebp + 12]
	; make the quotient 0
    xor edx, edx

	; div with cmmdc because the formula is cmmc = A * B / cmmdc
    div ecx

    leave
    ret