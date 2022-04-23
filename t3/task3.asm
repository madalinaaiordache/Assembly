global get_words
global compare_func
global sort


section .data
	delimitators: db " ,.", 10, 0

section .text
	global get_words
	global fnc_compare
	global sort
	extern strtok
	extern strcpy
	extern strlen
	extern strcmp
	extern qsort
section .text

; fnc_compare(const void *a, const void *b)
fnc_compare:
    enter 0, 0
    ; before modifying registers, we need to save
    ; all registers
    push ebx
    push ecx
    push edx
    push esi
    push edi


    ; take the first number
    mov edi, dword[ebp + 8]
    ; take the second number
    mov esi, dword[ebp + 12]

    ; because the values a and b are just adresses
    ; we need to take just the values 
    mov edi, dword[edi]
    mov esi, dword[esi]

    ;we need to call strlen, so firstly save the registers
    push ebx
    push ecx
    push edx
    push esi
    push edi

    ; push the number
    push edi
    ; call function
    call strlen
    pop edi

    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    
    ; now we have in ebx for a the length
    mov ebx, eax

    ;we do the same for b
     ; we need to call strlen, so firstly save the registers
    push ebx
    push ecx
    push edx
    push esi
    push edi

    ; push the number
    push esi
    ; call function
    call strlen
    pop esi

    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx

    ;now we have in eax the length for b
    ; make the difference
    sub ebx, eax
    mov eax, ebx

    cmp eax, 0
    jne finishf

    ; because the length is same, we need to clarify 
    push esi
    push edi
    call strcmp
    add esp, 8


finishf:
    ; get parameters back without eax
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    leave
    ret
;; sort(char **words, int number_of_words, int size)
;  functia va trebui sa apeleze qsort pentru soratrea cuvintelor 
;  dupa lungime si apoi lexicografix
sort:
    enter 0, 0
    ; before modifying registers, we need to save
    ; all registers
    push eax
    push ebx
    push ecx
    push edx
    push esi

    ; save the first paramter, words
    mov esi, dword[ebp + 8]
    ; save the second paramtere, number of words
    mov edx, dword[ebp + 12]
    ; save the third paramter, size
    mov ecx, dword[ebp + 16]


    ;push the function compare
    push fnc_compare
    ; push the size
    push ecx
    ; push the nr of words
    push edx
    ; push the words
    push esi
    ; call qsort
    call qsort
    ; make the stack back to original
    add esp, 16

    ; get parameters back
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax

    leave
    ret

;; get_words(char *s, char **words, int number_of_words)
;  separa stringul s in cuvinte si salveaza cuvintele in words
;  number_of_words reprezinta numarul de cuvinte
get_words:
    enter 0, 0

    ; before modifying registers, we need to save
    ; all registers
    push eax
    push ebx
    push ecx
    push edx
    push esi
    
    ; keep first parameter: s
    mov esi, dword[ebp + 8]
    ; keep second paramter, words
    mov ebx, dword[ebp + 12]
    ; keep third paramter, number of words
    mov edx, dword[ebp + 16]

    ; now, function strtok takes firstly as parameters
    ; the string and delimitator

    push delimitators
    push esi
    call strtok
    ; pop the parameters
    add esp, 8

    ; because we called the function
    ; maybe the paramters were altered
    ; copy them back
    ; keep first parameter: s
    mov esi, dword[ebp + 8]
    ; keep second paramter, words
    mov ebx, dword[ebp + 12]
    ; keep third paramter, number of words
    mov edx, dword[ebp + 16]

    ; make a general counter
    xor ecx, ecx
find_words:

    ; now we need to copy the word in the words array
    ; take the first address for the first word
    push edx
    mov edx, [ebx + 4 * ecx]
    
    ; now we need to call the function strcpy to
    ; copy the string in words
    ; save all important registers
    push eax
    push ebx
    push ecx
    push edx
    push esi

    ; call strcpy
    push eax
    push edx
    call strcpy
    add esp, 8

    ; pop all paramters
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax

    ; get back number of words
    add esp, 4
    mov edx, dword[ebp + 16]
    
    ; now we need to call strtok again
    ; save all registers
    push ebx
    push ecx
    push edx
    push esi

    ; call strtok
    push delimitators
    push 0
    call strtok
    pop ebx
    pop ebx

    ; pop all registers
    pop esi
    pop edx
    pop ecx
    pop ebx

    ; increment
    inc ecx
    cmp ecx, edx
    jl find_words

finish:
    ; get parameters back
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    leave
    ret
