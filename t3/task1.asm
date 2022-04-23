section .text
	global sort
	extern printf

; struct node {
;     	int val;
;    	struct node* next;
; };

;; struct node* sort(int n, struct node* node);
; 	The function will link the nodes in the array
;	in ascending order and will return the address
;	of the new found head of the list
; @params:
;	n -> the number of nodes in the array
;	node -> a pointer to the beginning in the array
; @returns:
;	the address of the head of the sorted list

put_val:
	; update the minimum
	mov [ebp - 16], edi
	; put last idx of the array that is not sorted
	add [ebp - 12], dword 1

	; get  the index
	mov ecx, [ebp - 12]
	; have we met the final?
	cmp ecx, [ebp + 8]
	; go back and take the process
	jl main

	jmp exit
	
loop_min:
	pop ebx
	; in eax we will store the node
	mov eax, [ebx + 8 * ecx]

	; compare eax with minimum
	cmp eax, edi
	; if it is greater or equal we move on
	jge get_node
	
	
	; compare with the last minimum updated
	cmp eax, [ebp - 16]
	; if it s less move on
	jle get_node

	; otherwise updated the minimum value or index
	xor edi, edi
	mov edi, eax
	xor esi, esi
	mov esi, ecx
	jmp get_node


save:
	push ebx
	jmp loop_min

value_insert:
	; get the next element
	lea ebx, [ebx + 8 * esi]
	; save the sorted node adress
	mov [ebp - 8], ebx

	; now set the head of the list
	mov [ebp - 4], ebx
	jmp put_val

sort:
	enter 0, 0
	; Nu putem sa folosim variabile globale
	; Asa ca voi folosi ebp - 4 pt head
	; ebp - 8 pentru ultimul nod sortat(adresa)
	; ebp - 12 pentru ultimul index care reprezinta ultimul element nesortat
	; ebp - 16 pentru ultimul minim folosit
	sub esp, 16
	mov dword[ebp - 12], 0
	mov dword[ebp - 16], -1000

main:
	; minimum value to compare
	mov edi, 100000
	; index for the minimum value
	xor esi, esi
	xor ecx, ecx
	;get first node address
	mov ebx, [ebp + 12]
	jmp save


get_node:
	; increment the index
	inc ecx
	; compare with the number of values
   	cmp ecx, [ebp + 8]
	; if it is less go back and take again the process
	jl save
	; verify last index of the array that is not sorted
	mov eax, [ebp - 12]
	cmp eax, 0
	; jump to set the first element			
	je value_insert

	; take last node address
	mov ebx, [ebp - 8]
	
	; take the next address
	lea edx, [ebx + 4]

	; take the actual address
	mov ecx, [ebp + 12]

	; take the forward address
	lea eax, [ecx + 8 * esi]

	mov dword [edx], eax

	; save the last sorted node
	mov dword [ebp - 8], eax
	jmp put_val


exit:

	; save the head of the list
	mov eax, [ebp - 4]
	leave
	ret
