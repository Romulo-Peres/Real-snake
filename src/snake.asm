    org 0x0

    jmp snake_begin

    %include "includes/constants.asm"
    %include "src/positions-and-directions.asm"
    %include "src/video-helpers.asm"
    %include "src/place-element-at.asm"
    %include "src/collisions.asm"
    %include "src/sleep.asm"
    %include "src/input.asm"
    %include "src/generate_fruit.asm"
    %include "src/curve-ring-buffer.asm"
    %include "src/moves.asm"
    %include "src/setup.asm"

snake_begin:
    mov bx, 0xB800
    mov es, bx
    mov bx, 0x0
    
    call setup_snake

    mov bx, 80
    mov cx, 25
    call generate_fruit
game_loop:

    mov ax, on_left
    mov bx, on_up
    mov cx, on_right
    mov dx, on_down
    call keyboard_input

    cmp ax, 0x0

    je next_loop

    call ax
next_loop:
    call move

    call sleep

    jmp game_loop
