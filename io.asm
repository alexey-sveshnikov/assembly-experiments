%define NUM_DIGITS 15

section .data

newline: db 0Ah

section .text

print:
	mov	rax, 4
	mov	rbx, 1
        int     80h
        ret

print_nl:
        mov     rcx, newline
        mov     rdx, 1
        call    print
        ret

; Prints number stored in rax
print_number:
        call    int2str

        mov     rcx, textbuf
        mov     rdx, NUM_DIGITS
        call    print
        call    print_nl
        ret

