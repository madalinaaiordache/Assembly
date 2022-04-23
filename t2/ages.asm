; structura ce pastreaza elementele unei date
struc  my_date
    .day: resw 1
    .month: resw 1
    .year: resd 1
endstruc


section .data
    len DD 1
section .text
    global ages

; void ages(int len, struct my_date* present, struct my_date* dates, int* all_ages);
ages:
    push    ebp
    mov     ebp, esp
    pusha

    mov     edx, [ebp + 8]  ; len       -> nr de persoane din echipa
    mov     esi, [ebp + 12] ; present   -> data curenta
    mov     edi, [ebp + 16] ; dates     -> data nasterii
    mov     ecx, [ebp + 20] ; all_ages  -> rezultatul functiei

    mov [len], edx
    mov ebx, 0 ; contor

    ; implement ages
generate_age:
    ; diferenta anilor intre data curenta si data nasterii
    mov eax, [esi + my_date.year]
    sub eax, [edi + ebx * 8 + my_date.year]

    ; CAZUL 1 -> luna curenta mai mica decat luna nasterii

    ; mut in dx luna curenta
    mov dx, [esi + my_date.month]

    ; compar luna curenta cu luna in care s-a nascut
    cmp dx, [edi + ebx * 8 + my_date.month]

    ; daca luna curenta mai mica decat luna nasterii
    jl lower_month

    ; CAZUL 2 -> luna curenta este mai mare decat luna nasterii

    ; mut in dx luna curenta
    mov dx, [esi + my_date.month]

    ; compar luna curenta cu luna in care s-a nascut
    cmp dx, [edi + ebx * 8 + my_date.month]

    ; daca luna curenta este mai mare decat luna nasterii
    jg set_age
    
    ; CAZUL 3 -> ziua nasterii mai mica decat ziua curenta

    ; mut in dx ziua curenta
    mov dx, [esi + my_date.day]

    ; compar ziua curenta cu ziua in care s-a nascut
    cmp dx, [edi + ebx * 8 + my_date.day]

    ; daca ziua nasterii este mai mica decat ziua curenta
    jge set_age

    
born_after:
    ; verific daca diferenta anilor este 0
    cmp eax, 0
    je set_age

lower_month:
    ; scad 1 la diferenta dintre ani
    sub eax, 1

set_age:
    ; mut in rezultatul functiei diferenta anilor dintre present si dates
    ; rezultatul functiei -> all_ages = vector care cuprinde toate datele 
    ;                                   de naștere ale coechipierilor săi
    mov [ecx + 4 * ebx], eax

    ; incrementez contorul
    inc ebx
    cmp ebx, [len]
    jl generate_age

    popa
    leave
    ret