; @params
; bx - X axis
; cx - Y axis
pos_to_video_pos:
    push ax

    mov ax, bx
    mov bx, 0x2
    imul bx

    mov bx, ax

    mov ax, cx
    mov cx, 0x2
    imul cx

    mov cx, ax

    pop ax

    ret

; @params
; bx - X axis
; cx - Y axis
video_pos_to_pos:
    push ax
    push dx

    xor dx, dx

    mov ax, bx
    mov bx, 0x2
    idiv bx

    mov bx, ax

    xor dx, dx

    mov ax, cx
    mov cx, 0x2
    idiv cx

    mov cx, ax

    pop dx
    pop ax

    ret


clear_video_buffer:
    mov bx, 0xB800
    mov es, bx

    xor bx, bx

    .clear_loop:
        mov BYTE [es:bx], 0x0

        inc bx

        cmp bx, VIDEO_BUFFER_WIDTH * VIDEO_BUFFER_HEIGHT * 2
        jl .clear_loop

    ret