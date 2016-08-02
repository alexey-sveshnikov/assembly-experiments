global quicksort
global partition
extern print_int
extern dump_array

%macro SAVE_REGS 0
    push rsi
    push rdi
    push rax
    push r8
    push rcx
%endmacro

%macro RESTORE_REGS 0
    pop rcx
    pop r8
    pop rax
    pop rdi
    pop rsi
%endmacro

%macro PRINT 1+
    SAVE_REGS
    jmp %%endstr
%%str:  db %1
%%endstr:
    mov     rax, 1
    mov     rdi, 1
    mov     rsi, %%str
    mov     rdx, %%endstr-%%str
    syscall
    RESTORE_REGS
%endmacro

%macro PRINTLN 1
    PRINT %1, 10
%endmacro

%macro PRINT_INT 1
    SAVE_REGS

    mov rdi, %1
    call print_int

    RESTORE_REGS
%endmacro

section .text

; System V calling convention for x86-64:
;       Arguments: rdi, rsi, rdx, rcx, r8, r9, xmm0–7
;       RV: rax
;       Preserved across function calls registers: rbp, rbx, r12-r15


; Performs quicksort on array
;     rdi - array refernece (4-byte signed ints)
;     rsi - array size
quicksort:
    ; r11 - pivot element position
    push rsi
    push rdi
    push rax
    push r8
    push rcx

    call partition

    mov r11, rax

    pop rcx
    pop r8
    pop rax
    pop rdi
    pop rsi

    cmp r11, 1
    jle .skip_left_branch

    push rsi
    push rdi
    push rax
    push r8
    push rcx
    push r11

    mov rsi, r11
    inc rsi
    call partition

    mov r11, rax

    pop r11
    pop rcx
    pop r8
    pop rax
    pop rdi
    pop rsi

.skip_left_branch:

    ret


; Performs partition
; arguments:
;     rdi - array reference
;     rsi - array size
; returns:
;     rax - pivot element position
;
partition:
    mov r12, rsi             ; save original array size
    mov rax, rsi
    shr rax, 1               ; have pivot element starting index
    mov r8d, [rdi + rax*4]   ; and pivot value in r8d

    mov rcx, 0               ; left boundary (array index)
                             ; (right boundary is in rsi)

    ; Check if the array is empty
    test rsi, rsi
    jnz not_empty
    xor rax, rax
    ret
not_empty:

    PRINT "-----------", 10, "Starting partition for array: ", 10

    SAVE_REGS
    call dump_array
    RESTORE_REGS

    PRINT "Pivotal element is: "
    SAVE_REGS
    mov rdi, r8
    call print_int
    RESTORE_REGS


.outer_loop:
    ;PRINTLN "--- New partition cycle"

; Find the first element from right boundary that lower than pivot element
.move_right_boundary:
    dec rsi                  ; we start from decreasing to imeediately get array offsets instead of size

    ;PRINT "Moving right boundary, current element is: "

    ;SAVE_REGS
    ;mov rdi, [rdi+rsi*4]
    ;call print_int
    ;RESTORE_REGS

    cmp [rdi + rsi*4], r8d   ; move boundary until current element is greater or equal to pivot one
    jge .move_right_boundary

    ;PRINT "Right boundary @ lower element, going futher. Curr. element: "
    ;PRINT_INT [rdi + rcx*4]

; Same for left boundary
.move_left_boundary:
    ;PRINT "Moving left boundary, current element is: "
    ;PRINT_INT [rdi + rcx*4]

    cmp [rdi + rcx*4], r8d
    jg .left_boundary_moving_finished

    inc rcx

    cmp rcx, rsi
    jge .finish

    jmp .move_left_boundary

.left_boundary_moving_finished:

    ;PRINT "Left boundary @ higher element, going futher. Curr. element: "
    ;PRINT_INT [rdi + rcx*4]

    ;PRINTLN "Swapping"

    mov r10d, [rdi + rcx*4]
    mov r11d, [rdi + rsi*4]
    mov [rdi + rcx*4], r11d
    mov [rdi + rsi*4], r10d
    jmp .outer_loop

.finish:

    PRINTLN "Exiting from partition, array is:"

    SAVE_REGS
    mov rsi, r12
    call dump_array
    RESTORE_REGS


    PRINTLN "Partition point is: "
    SAVE_REGS
    mov rdi, rcx
    call print_int
    RESTORE_REGS

    ret
