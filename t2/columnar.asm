section .data
    extern len_cheie, len_haystack
    index: resd 0

section .text
    global columnar_transposition

;; void columnar_transposition(int key[], char *haystack, char *ciphertext);
columnar_transposition:
    push    ebp
    mov     ebp, esp
    pusha 

    mov edi, [ebp + 8]   ;key
    mov esi, [ebp + 12]  ;haystack
    mov ebx, [ebp + 16]  ;ciphertext
   
    mov dword[index], 0
    ; contor i pentru first_loop
    mov eax, 0 
    xor edx, edx
first_loop:
    ; compar i cu lungimea cheii
    cmp eax, [len_cheie] 
    jge finish

    ; contor j pentru second_loop
    mov ecx, 0 
second_loop:
    ; mut key[i] in registrul edx
    mov edx, dword[edi + 4 * eax] 

    ; mut valorile pe stiva
    push eax
    push edx

    mov eax, ecx

    ; ma mut la urmatorul element
    ; len_cheie = lungimea cheii
    mul dword[len_cheie]

    ; scot valoarea de pe stiva
    pop edx

    ; ajung pe pozitia dorita
    add edx, eax

    ; scot valoarea de pe stiva
    pop eax

    ; verific sa nu depaseasca dimensiunile matricei
    ; len_haystack = lungimea plaintextului

    cmp edx, [len_haystack]
    jge add_i

    ; mut valorile pe stiva
    push eax
    push ecx

    xor eax, eax

    ; mut caracterul in subregistrul al
    mov al, byte[esi + edx] 

    ; mut contorul j pentru second_loop
    mov ecx, dword[index]

    mov byte[ebx + ecx], al

    ; incrementez
    add dword[index], 1

    ; scot valoarile de pe stiva
    pop ecx
    pop eax

    ; incrementez contorul
    inc ecx

    jmp second_loop
add_i:
    ; incrementez contorul
    inc eax
    jmp first_loop
finish:
    popa
    leave
    ret