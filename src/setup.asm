setup_snake:
    mov bx, 0xB800
    mov es, bx
    mov bx, TAIL_X_START_POS

    mov al, SNAKE_HEAD_CHAR
    mov ah, 0x02

    mov [es:HEAD_X_START_POS], ax

    mov al, SNAKE_BODY_CHAR
    mov ah, 0x02

setup_loop:
    mov [es:bx], ax
    add bx, 0x2
    
    cmp bx, HEAD_X_START_POS
    jl setup_loop

    ret