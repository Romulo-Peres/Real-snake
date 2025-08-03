%include "includes/constants.asm"

; @returns
; ax - 0x1 if the snake ate a fruit, 0 otherwise
move:
    mov ax, [direction]
    cmp ax, DIRECTION_RIGHT  ; checking if the snake is going right

    jne .right_direction_else_block

    call load_head_position_and_place_body_char

    ; move the head to right
    add bx, 0x2

    ; move a snake head char at the new head position
    mov dx, SNAKE_HEAD_CHAR
    call place_element_at
    push ax

    call video_pos_to_pos

    ; save the new X position
    mov [head_x_pos], bx

    jmp .after_move

    .right_direction_else_block:
        cmp ax, DIRECTION_DOWN ; checking if the snake is going down
        jne .down_direction_else_block

        call load_head_position_and_place_body_char

        add cx, 0x2

        ; move a snake head char at the new head position
        mov dx, SNAKE_HEAD_CHAR
        call place_element_at
        push ax

        call video_pos_to_pos

        mov [head_y_pos], cx

        jmp .after_move

    .down_direction_else_block:
        ; checking if the snake is going up
        cmp ax, DIRECTION_UP
        jne .up_direction_else_block

        call load_head_position_and_place_body_char

        sub cx, 0x2

        ; move a snake head char at the new head position
        mov dx, SNAKE_HEAD_CHAR
        call place_element_at
        push ax

        call video_pos_to_pos

        mov [head_y_pos], cx

        jmp .after_move

    .up_direction_else_block:
        mov bx, 0x2
        call load_position

        call pos_to_video_pos

        mov dx, SNAKE_BODY_CHAR
        call place_element_at

        ; move the head to left
        sub bx, 0x2

        mov dx, SNAKE_HEAD_CHAR
        call place_element_at
        push ax

        call video_pos_to_pos
    
        mov [head_x_pos], bx
    
    .after_move:
        pop ax
        call check_collision

        ; verify if the snake ate a fruit  
        cmp ah, 0x1
        jne .remove_snake_tail

        ; add the growth factor
        add WORD [pending_body], FRUIT_GROWTH_FACTOR
        dec WORD [pending_body]

        mov ax, 0x1

        jmp .end

    .remove_snake_tail:
        ; confirm whether the growth factor is no longer present
        cmp WORD [pending_body], 0x0
        jne .decrement_pending_body

        call remove_tail

        mov ax, 0x0

        jmp .end

    .decrement_pending_body:
        dec WORD [pending_body]
    
    .end:
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
    jne .tail_going_right_else_block

    add bx, 0x2

    jmp .remove_tail_end

    .tail_going_right_else_block:
        cmp ax, DIRECTION_LEFT  ; check if the tail is going left
        jne .tail_going_left_else_block

        sub bx, 0x2
    
        jmp .remove_tail_end
    
    .tail_going_left_else_block:
        cmp ax, DIRECTION_DOWN  ; check if the tail is going down
        jne .tail_going_down_else_block

        add cx, 0x2
    
        jmp .remove_tail_end

    .tail_going_down_else_block:
        sub cx, 0x2

    .remove_tail_end:
        call video_pos_to_pos

        mov [tail_x_pos], bx
        mov [tail_y_pos], cx

        ; check if the current tail position is
        ; where the head made a curve in the past
        mov ax, bx
        mov bx, cx
        call check_curve

        cmp ah, 0x1
        jne .return

        ; save the new direction
        mov ah, 0x0
        mov [tail_direction], ax

    .return:
        ret

