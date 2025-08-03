%define FIRST_TIMER_COUNTER 1
%define TIMER_THRESHOLD 2

; @params
; dx - timer threshold
sleep:
    ; save used registers
    ; and allocate memory
    push bp
    push ax
    push cx
    push dx
    mov bp, sp
    sub sp, 0x2

    mov [bp-TIMER_THRESHOLD], dl

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

        mov al, [bp-TIMER_THRESHOLD]

        cmp dl, al

        jge .end

        jmp .loop

    .end:
        mov sp, bp
        pop dx
        pop cx
        pop ax
        pop bp

    ret
