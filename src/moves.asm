    %include "includes/constants.asm"

move:
    mov ax, [direction]
    cmp ax, DIRECTION_RIGHT

    jne not_direction_right

    mov bx, 0x2
    call load_position

    call pos_to_video_pos

    mov dx, SNAKE_BODY_CHAR
    call place_element_at

    ; move the head to right
    add bx, 0x2

    mov dx, SNAKE_HEAD_CHAR
    call place_element_at

    call video_pos_to_pos

    mov [head_x_pos], bx

    jmp move_end
not_direction_right:
    mov ax, [direction]
    cmp ax, DIRECTION_DOWN

    jne not_direction_down

    mov bx, 0x2
    call load_position

    call pos_to_video_pos

    mov dx, SNAKE_BODY_CHAR
    call place_element_at

    add cx, 0x2

    mov dx, SNAKE_HEAD_CHAR
    call place_element_at

    call video_pos_to_pos

    mov [head_y_pos], cx

    jmp move_end
not_direction_down:
    mov ax, [direction]
    cmp ax, DIRECTION_UP

    jne not_direction_up

    mov bx, 0x2
    call load_position
    
    call pos_to_video_pos

    mov dx, SNAKE_BODY_CHAR
    call place_element_at

    sub cx, 0x2

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
    mov bx, 0x1
    call load_position

    call pos_to_video_pos

    mov dx, ' '
    call place_element_at

    mov ax, [tail_direction]

    cmp ax, DIRECTION_RIGHT

    jne not_tail_dir_right

    add bx, 0x2

    jmp remove_tail_end
not_tail_dir_right:
    cmp ax, DIRECTION_LEFT

    jne not_tail_dir_left

    sub bx, 0x2
    
    jmp remove_tail_end
not_tail_dir_left:
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

    ret

; @params
; bx - 0x1 for tail position, 0x2 for head position
load_position:
    cmp bx, 0x1

    jne not_tail

    mov bx, 0xB800
    mov es, bx
    mov bx, [tail_x_pos]
    mov cx, [tail_y_pos]

    jmp load_position_end
not_tail:
    mov bx, 0xB800
    mov es, bx
    mov bx, [head_x_pos]
    mov cx, [head_y_pos]
load_position_end:

    ret

; @params
; bx - head X position
; cx - head Y position
; dx - element
place_element_at:
    push ax
    push bx
    push cx
    push dx

    mov ax, VIDEO_BUFFER_WIDTH
    imul cx

    add bx, ax
    
    pop dx

    mov al, dl
    mov ah, 0x02
    mov [es:bx], ax

    pop cx
    pop bx
    pop ax
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

    direction dw DIRECTION_RIGHT
    head_x_pos dw HEAD_X_START_POS
    head_y_pos dw HEAD_Y_START_POS
    tail_x_pos dw TAIL_X_START_POS
    tail_y_pos dw TAIL_Y_START_POS
    tail_direction dw DIRECTION_RIGHT