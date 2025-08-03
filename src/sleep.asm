%define FIRST_TIMER_COUNTER 1
%define TIMER_COUNTER_THRESHOLD 2

sleep:
    ; save used registers
    ; and allocate memory
    push bp
    push ax
    push cx
    push dx
    mov bp, sp
    sub sp, 0x1

    ; get timer counter
    mov ah, 0x0
    int 0x1A

    mov [bp-FIRST_TIMER_COUNTER], dl

    .loop:
        ; get timer counter
        mov ah, 0x0
        int 0x1A

        ; check if the new timer counter is greater
        ; than the first counter by TIMER_COUNTER_THRESHOLD
        mov al, [bp-FIRST_TIMER_COUNTER]
        sub dl, al

        cmp dl, TIMER_COUNTER_THRESHOLD

        jge .end

        jmp .loop

    .end:
        mov sp, bp
        pop dx
        pop cx
        pop ax
        pop bp

    ret
