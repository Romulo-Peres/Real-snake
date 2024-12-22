    %include "includes/constants.asm"

move:
    ; checking if the snake is going right
    mov ax, [direction]
    cmp ax, DIRECTION_RIGHT

    jne not_direction_right

    call load_head_position_and_place_body_char

    ; move the head to right
    add bx, 0x2

    ; move a snake head char at the new head position
    mov dx, SNAKE_HEAD_CHAR
    call place_element_at

    call video_pos_to_pos

    ; save the new X position
    mov [head_x_pos], bx

    jmp move_end
not_direction_right:
    ; checking if the snake is going down
    cmp ax, DIRECTION_DOWN

    jne not_direction_down

    call load_head_position_and_place_body_char

    add cx, 0x2

    ; move a snake head char at the new head position
    mov dx, SNAKE_HEAD_CHAR
    call place_element_at

    call video_pos_to_pos

    mov [head_y_pos], cx

    jmp move_end
not_direction_down:
    ; checking if the snake is going up
    cmp ax, DIRECTION_UP

    jne not_direction_up

    call load_head_position_and_place_body_char

    sub cx, 0x2

    ; move a snake head char at the new head position
    mov dx, SNAKE_HEAD_CHAR
    call place_element_at

    call video_pos_to_pos

    mov [head_y_pos], cx

    jmp move_end
not_direction_up:
    mov bx, 0x2
    call load_position

    call pos_to_video_pos

    mov dx, SNAKE_BODY_CHAR
    call place_element_at

    ; move the head to left
    sub bx, 0x2

    mov dx, SNAKE_HEAD_CHAR
    call place_element_at

    call video_pos_to_pos
    
    mov [head_x_pos], bx
move_end:    
    call remove_tail
    ret

remove_tail:
    ; load tail position
    mov bx, 0x1
    call load_position

    call pos_to_video_pos

    ; clear the tail
    mov dx, ' '
    call place_element_at

    mov ax, [tail_direction]

    ; check if the tail is going right
    cmp ax, DIRECTION_RIGHT
    jne not_tail_dir_right

    add bx, 0x2

    jmp remove_tail_end
not_tail_dir_right:
    ; check if the tail is going left
    cmp ax, DIRECTION_LEFT

    jne not_tail_dir_left

    sub bx, 0x2
    
    jmp remove_tail_end
not_tail_dir_left:
    ; check if the tail is going down
    cmp ax, DIRECTION_DOWN
    
    jne not_tail_dir_down

    add cx, 0x2
    
    jmp remove_tail_end
not_tail_dir_down:
    sub cx, 0x2
remove_tail_end:
    call video_pos_to_pos

    mov [tail_x_pos], bx
    mov [tail_y_pos], cx

    ; check if the current tail position is
    ; where the head made a curve in the past
    mov ax, bx
    mov bx, cx
    call check_curve

    cmp ah, 0x1
    jne remove_tail_return

    ; save the new direction
    mov ah, 0x0
    mov [tail_direction], ax

remove_tail_return:
    ret