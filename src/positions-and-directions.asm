; @params
; bx - 0x1 for tail position, 0x2 for head position
;
; @returns 
; bx - the X axis position
; cx - the Y axis position
load_position:
    cmp bx, 0x1

    jne not_tail

    ; loading tail positions
    mov bx, [tail_x_pos]
    mov cx, [tail_y_pos]

    jmp load_position_end
not_tail:
    ; loading head positions
    mov bx, [head_x_pos]
    mov cx, [head_y_pos]
load_position_end:
    ret

on_left:
    cmp BYTE [direction], DIRECTION_RIGHT
    je on_left_return

    mov cx, DIRECTION_LEFT
    call _create_curve

    mov BYTE [direction], DIRECTION_LEFT
on_left_return:
    ret

on_up:
    cmp BYTE [direction], DIRECTION_DOWN
    je on_up_return

    mov cx, DIRECTION_UP
    call _create_curve

    mov BYTE [direction], DIRECTION_UP
on_up_return:
    ret

on_down:
    cmp BYTE [direction], DIRECTION_UP
    je on_down_return
    
    mov cx, DIRECTION_DOWN
    call _create_curve

    mov BYTE [direction], DIRECTION_DOWN
on_down_return:
    ret

on_right:
    cmp BYTE [direction], DIRECTION_LEFT
    je on_right_return
    
    mov cx, DIRECTION_RIGHT
    call _create_curve

    mov BYTE [direction], DIRECTION_RIGHT
on_right_return:
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

    cmp WORD [direction], DIRECTION_RIGHT
    jne not_going_right

    add ax, 0x1
    jmp check_horizontal_borders
not_going_right:
    cmp WORD [direction], DIRECTION_LEFT
    jne check_horizontal_borders
    sub ax, 0x1
check_horizontal_borders:
    cmp ax, VIDEO_BUFFER_WIDTH 
    jge border_game_over
    cmp ax, 0x0
    jl border_game_over

    mov ax, [head_y_pos]

    cmp WORD [direction], DIRECTION_UP
    jne not_going_up

    sub ax, 0x1
    jmp check_vertical_borders
not_going_up:
    cmp WORD [direction], DIRECTION_DOWN
    jne check_vertical_borders

    add ax, 0x1
check_vertical_borders:

    cmp ax, VIDEO_BUFFER_HEIGHT
    jge border_game_over
    cmp ax, 0x0
    jl border_game_over

    mov ax, 0x0
    jmp check_game_borders_end
border_game_over:
    mov ax, 0x1
check_game_borders_end:
    ret

    direction dw DIRECTION_RIGHT
    head_x_pos dw HEAD_X_START_POS
    head_y_pos dw HEAD_Y_START_POS
    tail_x_pos dw TAIL_X_START_POS
    tail_y_pos dw TAIL_Y_START_POS
    tail_direction dw DIRECTION_RIGHT