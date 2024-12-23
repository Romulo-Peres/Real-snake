; @params
; al - the character
check_collision:
    cmp al, SNAKE_BODY_CHAR

    jne not_body_collision

    mov WORD [game_over_flag], 0x1
    
    jmp check_collision_end
not_body_collision:
    cmp al, FRUIT_CHAR

    jne not_fruit_collision

    mov bx, 80
    mov cx, 25
    call generate_fruit

    mov ah, 0x1

    jmp check_collision_end
not_fruit_collision:
    mov ah, 0x0
check_collision_end:
    ret