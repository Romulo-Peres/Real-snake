    %include "includes/constants.asm"

move:

    ret

on_left:
    cmp BYTE [direction], DIRECTION_RIGHT
    je on_left_return

    mov BYTE [direction], DIRECTION_LEFT
on_left_return:

    ret

on_up:
    cmp BYTE [direction], DIRECTION_DOWN
    je on_up_return

    mov BYTE [direction], DIRECTION_UP
on_up_return:

    ret

on_down:
    cmp BYTE [direction], DIRECTION_UP
    je on_down_return
    
    mov BYTE [direction], DIRECTION_DOWN
on_down_return:

    ret

on_right:
    cmp BYTE [direction], DIRECTION_LEFT
    je on_right_return
    
    mov BYTE [direction], DIRECTION_RIGHT
on_right_return:

    ret

    direction db DIRECTION_RIGHT