    %include "includes/constants.asm"

move:
    mov ax, [direction]
    cmp ax, DIRECTION_RIGHT

    jne not_direction_right

    call load_head_position

    call place_body

    ; move the head to right
    add bx, 0x2

    call place_head

    mov [head_x_pos], bx

    jmp move_end
not_direction_right:
    mov ax, [direction]
    cmp ax, DIRECTION_DOWN

    jne not_direction_down

    call load_head_position

    call place_body

    ; move the head to down
    add bx, VIDEO_BUFFER_WIDTH * 0x2

    call place_head

    mov [head_x_pos], bx

    jmp move_end
not_direction_down:
    mov ax, [direction]
    cmp ax, DIRECTION_UP

    jne not_direction_up

    call load_head_position

    call place_body

    ; move the head to up
    sub bx, VIDEO_BUFFER_WIDTH * 0x2

    call place_head

    mov [head_x_pos], bx

    jmp move_end
not_direction_up:
    call load_head_position

    call place_body

    ; move the head to left
    sub bx, 0x2

    call place_head
    
    mov [head_x_pos], bx
move_end:
    
    ret

load_head_position:
    mov bx, 0xB800
    mov es, bx
    mov bx, [head_x_pos]

place_head:
    push ax

    ; place the head
    mov al, SNAKE_HEAD_CHAR
    mov ah, 0x02
    mov [es:bx], ax

    pop ax
    ret

; @params
; bx - head position
place_body:
    push ax

    ; place a body char at the head's position
    mov al, SNAKE_BODY_CHAR
    mov ah, 0x2
    mov [es:bx], ax

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

    direction dw DIRECTION_RIGHT
    head_x_pos dw HEAD_X_START_POS
    head_y_pos dw 0x0
    tail_x_pos dw TAIL_X_START_POS
    tail_y_pos dw 0x0