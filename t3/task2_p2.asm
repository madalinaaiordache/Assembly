section .text
	global par


finish:
    ; assume that stack is empty
    mov eax, 1
    ; check if stack is empty
    cmp esp, ebp
    je exit
    
    ; not good paranthesis
    jmp result_zero
    
jmp_character:

    ; if the last element is an open bracket is not correct
    cmp dword [esp], 1
    jne result_zero

    ; pop the last ')'
    pop ecx
	mov ecx, dword[ebp + 8]
	
    ; move forward
    inc edi
    jmp loop_string

result_zero:
    mov eax, 0
    jmp exit
;; int par(int str_length, char* str)
;
; check for balanced brackets in an expression
par:
    enter 0, 0

	; take the parameters
    mov ecx, dword[ebp + 8]
    mov edx, dword[ebp + 12]
	
	; make the values 0 because we will use it
	mov eax, 0
	mov edi, 0

loop_string:
	; check we didnt arrive at the end of the string
    cmp edi, ecx
    je finish

	; compare if we have an open bracket
    cmp byte [edx + edi], '('
    jne jmp_character

	; if it is, push the open bracket into the stack
    push 1
    inc edi
    jmp loop_string



exit:
    leave
    ret