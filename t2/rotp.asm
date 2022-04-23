section .text
    global rotp

; void rotp(char *ciphertext, char *plaintext, char *key, int len);
rotp:
    push    ebp
    mov     ebp, esp
    pusha

    mov     edx, [ebp + 8]  ; ciphertext    -> rezultatul functiei
    mov     esi, [ebp + 12] ; plaintext     -> mesajul său plaintext
    mov     edi, [ebp + 16] ; key           -> cheia inversată key
    mov     ecx, [ebp + 20] ; len           -> lungimea cheii si a mesajului plaintext

    ; Implment rotp

    mov ebx, 0 ; contor
loop_ex:
    ; iau un registru al de un byte si copiez in el cate o litera din mesajul plaintext
    mov al, byte[esi + ebx]

    ; decrementez lungimea stringului
    dec ecx

    ; operația XOR între mesajul său plaintext și cheia inversată key
    xor al, byte[ecx + edi]

    ; incrementez lungimea stringului
    inc ecx

    ; copiez in registrul de un byte al cate o litera din mesajul meu codat
    mov byte[edx + ebx], al

    ; incrementez contorul
    inc ebx

    ; sfarsitul buclei
    loop loop_ex

    popa
    leave
    ret