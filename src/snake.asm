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
    %include "src/snake-setup.asm"
    %include "src/game-over-panel.asm"
    %include "src/text.asm"
    %include "src/environment-setup.asm"

snake_begin:
    mov bx, 0xB800
    mov es, bx
    mov bx, 0x0

    call clear_ring_buffer
    call reset_positions_and_direction
    call setup_snake

    mov bx, 80
    mov cx, 25
    call generate_fruit

    .game_loop:
        mov ax, on_left
        mov bx, on_up
        mov cx, on_right
        mov dx, on_down
        mov di, on_reset
        mov si, on_try_again
        call keyboard_input

        ; check if it is game over
        cmp WORD [game_over_flag], 0x1
        jge .game_over

        ; verify if there is some user input
        cmp ax, 0x0
        je .move_snake

        ; call the user input handler
        call ax

        jmp .move_snake

    .game_over:
        cmp WORD [game_over_flag], 0x2
        je .check_for_game_over_input

        mov ax, VIDEO_BUFFER_WIDTH
        mov bx, VIDEO_BUFFER_HEIGHT

        mov di, [points]
        call draw_game_over_message

        mov WORD [game_over_flag], 0x2

    .check_for_game_over_input:
        cmp ax, on_try_again
        jne .else_block

        jmp .execute_handler

    .else_block:
        cmp ax, on_reset
        jne .next_loop

    .execute_handler:
        call ax

    .move_snake:
        call check_game_borders
        mov WORD [game_over_flag], ax

        cmp ax, 0x1
        je .next_loop
        call move

        cmp ax, 0x1
        jne .next_loop
        inc WORD [points]

    .next_loop:
        call sleep
        jmp .game_loop

on_reset:
    cli
	mov ax, 0
	mov ds, ax
	mov word [0x472], 0
	jmp 0FFFFh:0000h

on_try_again:
    mov WORD [game_over_flag], 0x0

    configure_stack_segment
    call configure_data_segment

    call clear_video_buffer

    jmp GAME_SEGMENT:0x0


    game_over_flag dw 0x0
    points dw 0x0