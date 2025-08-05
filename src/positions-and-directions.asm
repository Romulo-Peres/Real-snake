; @params
; bx - 0x1 for tail position, 0x2 for head position
;
; @returns 
; bx - the X axis position
; cx - the Y axis position
load_position:
    cmp bx, 0x1 ; check if it is to load the head position
    jne .head_position_else_block

    ; loading tail positions
    mov bx, [tail_x_pos]
    mov cx, [tail_y_pos]

    jmp .end
    
    .head_position_else_block:
        ; loading head positions
        mov bx, [head_x_pos]
        mov cx, [head_y_pos]

    .end:
        ret


; @params
; cx - direction
_create_curve:
    mov ax, [head_x_pos]
    mov bx, [head_y_pos]
    call create_curve

    ret

load_head_position_and_place_body_char:
    ; load head position
    mov bx, 0x2
    call load_position
    
    call pos_to_video_pos

    ; move a snake body char at current head position
    mov dx, SNAKE_BODY_CHAR
    call place_element_at

    ret

check_game_borders:
    mov ax, [head_x_pos]

    cmp WORD [direction], DIRECTION_RIGHT ; check if the snake is going to the right
    jne .right_direction_else_block

    add ax, 0x1
    jmp .check_horizontal_borders

    .right_direction_else_block:
        cmp WORD [direction], DIRECTION_LEFT ; check if the snake is going to the left
        jne .check_horizontal_borders
        sub ax, 0x1

    .check_horizontal_borders:
        cmp ax, VIDEO_BUFFER_WIDTH 
        jge .border_game_over
        cmp ax, 0x0
        jl .border_game_over

        mov ax, [head_y_pos]

        cmp WORD [direction], DIRECTION_UP ; check if the snake is going up
        jne .up_direction_else_block

        sub ax, 0x1
        jmp .check_vertical_borders
    
    .up_direction_else_block:
        cmp WORD [direction], DIRECTION_DOWN ; check if the snake is going down
        jne .check_vertical_borders

        add ax, 0x1
    
    .check_vertical_borders:
        cmp ax, VIDEO_BUFFER_HEIGHT
        jge .border_game_over
        cmp ax, 0x2
        jl .border_game_over

        mov ax, 0x0
        jmp .end

    .border_game_over:
        mov ax, 0x1
    
    .end:
        ret

