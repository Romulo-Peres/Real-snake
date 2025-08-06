; @params
; di - command
handle_command:
    cmp di, LEFT_COMMAND
    je .left_command

    cmp di, UP_COMMAND
    je .up_command

    cmp di, RIGHT_COMMAND
    je .right_command

    cmp di, DOWN_COMMAND
    je .down_command

    cmp di, PAUSE_COMMAND
    je .pause_command

    cmp di, TRY_AGAIN_COMMAND
    je .try_again_command

    cmp di, BOOST_COMMAND
    je .boost_command

    cmp di, RESET_COMMAND
    je .reset_command

    jmp .end

    .left_command:
        call on_left
        jmp .end

    .up_command:
        call on_up
        jmp .end

    .right_command:
        call on_right
        jmp .end

    .down_command:
        call on_down
        jmp .end

    .pause_command:
        call on_pause
        jmp .end

    .try_again_command:
        call on_try_again
        jmp .end

    .boost_command:
        call on_boost
        jmp .end

    .reset_command:
        call on_reset
        jmp .end

    .end:
        ret

on_reset:
    cli
	mov ax, 0
	mov ds, ax
	mov word [0x472], 0
	jmp 0FFFFh:0000h

on_try_again:
    mov WORD [game_over_flag], 0x0
    mov BYTE [game_paused], FALSE

    configure_stack_segment
    call configure_data_segment
    call clear_video_buffer
    mov WORD [points], 0x0
    mov BYTE [snake_speed], NORMAL_SPEED

    mov di, complete_final_score_label

    .clear_score_label_loop:
        cmp BYTE [di], 0x0
        je .restart_game

        mov BYTE [di], 0x0
        inc di

        jmp .clear_score_label_loop

    .restart_game:
        jmp GAME_SEGMENT:0x0


on_left:
    cmp BYTE [direction], DIRECTION_RIGHT
    je .end

    mov cx, DIRECTION_LEFT
    call _create_curve

    mov BYTE [direction], DIRECTION_LEFT

    .end:
        ret

on_up:
    cmp BYTE [direction], DIRECTION_DOWN
    je .end

    mov cx, DIRECTION_UP
    call _create_curve

    mov BYTE [direction], DIRECTION_UP
    
    .end:
        ret


on_right:
    cmp BYTE [direction], DIRECTION_LEFT
    je .end
    
    mov cx, DIRECTION_RIGHT
    call _create_curve

    mov BYTE [direction], DIRECTION_RIGHT

    .end:
        ret

on_pause:
    cmp BYTE [game_paused], TRUE
    jne .end

    mov dl, 3

    .countdown_loop: 
        cmp dl, 0
        je .end

        call draw_status_bar
        dec dl

        push dx

        mov dx, 7
        call sleep

        pop dx

        jmp .countdown_loop

    .end:
        xor BYTE [game_paused], TRUE

        mov dl, 0
        call draw_status_bar

    ret

on_boost:
    cmp BYTE [snake_speed], NORMAL_SPEED
    je .enable_boosting

    mov BYTE [snake_speed], NORMAL_SPEED
    jmp .end


    .enable_boosting:
        mov BYTE [snake_speed], BOOSTING

    .end:
        ret

on_down:
    cmp BYTE [direction], DIRECTION_UP
    je .end
    
    mov cx, DIRECTION_DOWN
    call _create_curve

    mov BYTE [direction], DIRECTION_DOWN
    
    .end:
        ret