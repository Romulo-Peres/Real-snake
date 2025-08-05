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
%include "src/data.asm"
%include "src/utilities/data-manipulation.asm"
%include "src/utilities/itoa.asm"
%include "src/utilities/strcat.asm"
%include "src/status-bar.asm"
%include "src/commands.asm"

snake_begin:
    mov bx, 0xB800
    mov es, bx
    mov bx, 0x0

    call draw_game_status
    call clear_ring_buffer
    call reset_positions_and_direction
    call setup_snake

    mov bx, 80
    mov cx, 25
    call generate_fruit

    .game_loop:
        call keyboard_input

        ; call the user input handler
        mov di, ax
        call handle_command

        ; check if it is game over
        cmp WORD [game_over_flag], 0x1
        jge .game_over

        cmp BYTE [game_paused], TRUE
        je .next_loop

        ; verify if there is some user input
        cmp ax, 0x0
        je .move_snake

        jmp .move_snake

    .game_over:
        cmp WORD [game_over_flag], 0x2
        je .next_loop

        mov ax, VIDEO_BUFFER_WIDTH
        mov bx, VIDEO_BUFFER_HEIGHT

        mov di, [points]
        call draw_game_over_message

        mov WORD [game_over_flag], 0x2
        jmp .next_loop

    .move_snake:
        call check_game_borders
        mov WORD [game_over_flag], ax

        cmp ax, 0x1
        je .next_loop
        call move

        cmp ax, 0x1
        jne .next_loop

        inc WORD [points]
        call draw_game_status


    .next_loop:
        mov dl, [snake_speed]
        call sleep
        
        jmp .game_loop

