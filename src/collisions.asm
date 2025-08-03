; @params
; al - the character
check_collision:
    cmp al, SNAKE_BODY_CHAR  ; check for body collision

    jne .else_block

    ; is body collision, game over!
    mov WORD [game_over_flag], 0x1

    jmp .end
    
    .else_block:
        cmp al, FRUIT_CHAR  ; check if fruit collision
        jne .fruit_else_block

        ; generate new fruit
        mov bx, 80
        mov cx, 25
        call generate_fruit

        mov ah, 0x1
        jmp .end

    .fruit_else_block:
        mov ah, 0x0  ; no collision

    .end:
        ret