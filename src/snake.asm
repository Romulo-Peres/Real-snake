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
    %include "src/game-over-panel.asm"
    %include "src/text.asm"

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
    mov di, on_reset
    call keyboard_input

    ; check if it is game over
    cmp WORD [game_over_flag], 0x1
    jge game_over

    ; verify if there is some user input
    cmp ax, 0x0
    je move_snake

    ; call the user input handler
    call ax

    jmp move_snake
game_over:
    cmp WORD [game_over_flag], 0x2
    je check_input_for_reset

    mov ax, VIDEO_BUFFER_WIDTH
    mov bx, VIDEO_BUFFER_HEIGHT

    mov di, [points]
    call draw_game_over_message

    mov WORD [game_over_flag], 0x2

check_input_for_reset:
    ; only execute user input handler
    ; if the input is to reset the processor
    cmp ax, di
    jne next_loop

    call ax ; reset the processor
move_snake:
    call check_game_borders
    mov WORD [game_over_flag], ax

    cmp ax, 0x1
    je next_loop
    call move

    cmp ax, 0x1
    jne next_loop
    inc WORD [points]
next_loop:
    call sleep
    jmp game_loop

on_reset:
    cli
	mov ax, 0
	mov ds, ax
	mov word [0x472], 0
	jmp 0FFFFh:0000h


    game_over_flag dw 0x0
    points dw 0x0