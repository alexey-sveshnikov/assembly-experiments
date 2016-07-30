; sorts array of size $rcx stored in $rax
bubblesort:

.while_unsorted:
    mov r8, 0    ; if true than there are any unsorted elements in the array
    mov r9, 0    ; elements counter

.for_each:
    mov rdi, [rax + r9*8]
    lea rbp, [rax + r9*8 + 8]
    cmp rdi, [rbp]
    jna .pair_sorted
    mov rdx, [rbp]
    mov [rbp], rdi
    mov [rax + r9*8], rdx
    mov       r8, 1
.pair_sorted:
    inc r9
    cmp r9, rcx
    jne .for_each

    test        r8, r8
    jnz .while_unsorted

    ret
