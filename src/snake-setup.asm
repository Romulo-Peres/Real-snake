setup_snake:
    mov bx, 0xB800
    mov es, bx
    mov bx, TAIL_Y_START_POS * (VIDEO_BUFFER_WIDTH * 2)
    add bx, TAIL_X_START_POS * 2

    mov al, SNAKE_HEAD_CHAR
    mov ah, 0x02

    mov [es:bx], ax

    mov al, SNAKE_BODY_CHAR
    mov ah, 0x02

    mov dx, 0

    .setup_loop:
        mov [es:bx], ax
        add bx, 0x2
        inc dx
    
        cmp dx, 0x5
        jl .setup_loop

    ret