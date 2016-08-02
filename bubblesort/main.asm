CPU IA64

%include "io.asm"
%include "bubblesort.asm"

%define SIZE 30

section .data
message_1 db 'Raw values:', 0xA
message_1_len equ $-message_1

message_2 db 'Sorted values:', 0xA
message_2_len equ $-message_2

section .bss
array   resq SIZE
textbuf resb 32
random_seed     resq 1

section .text
global _start

_start:
        call    random  ; don't start from hardcoded seed

        ; Initialize array with pseudo random numbers
        mov     rax, array
        call    init_array

        ; Display message and dump array
        mov     rcx, message_1
        mov     rdx, message_1_len
        call    print

        mov     rax, array
        call    dump_array

        call    print_nl

        ; Sort array
        mov     rax, array
        mov     rcx, SIZE
        call    bubblesort

        ; Display second message and dump array again
        mov     rcx, message_2
        mov     rdx, message_2_len
        call    print

        mov     rax, array
        call    dump_array

        call    exit


; Takes array ref from rax, initializes it by sequence of size 'SIZE'
init_array:
        mov     rcx, SIZE
        mov     rbx, rax
.loop:
        push    rcx
        call    random
        mov     [rbx], rax
        add     rbx, 8
        pop     rcx
        loop    .loop
        ret

; Takes array reference from rax, prints all elements
dump_array:
        mov     rcx, SIZE
.loop:
        push    rcx
        push    rax

        mov     rax, [rax]
        call    print_number

        pop     rax
        pop     rcx
        add     rax, 8
        loop    .loop
        ret

; Takes number from rax, converts it to string at [textbuf]
int2str:
        mov     rcx, NUM_DIGITS
.loop:
        xor     rdx, rdx
        mov     ebx, 10
        div     ebx
        add     rdx, '0'
        mov     byte [textbuf + rcx - 1], dl
        loop    .loop
        ret


; Generates random number and places it to rax
random:
        mov     rax, 1103515245
        mul     qword [random_seed]
        add     rax, 12345
        ;mov     edx, 2^32
        ;div     edx
        and     rax, 0xFFFF
        mov     [random_seed], rax
;        mov     rax, rdx
        ret

exit:
	mov	rax, 1
	mov	rbx, 0
	int     80h
