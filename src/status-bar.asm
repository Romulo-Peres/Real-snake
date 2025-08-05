draw_game_status:
    call draw_game_status_panel

    mov di, complete_score_label
    mov si, score_label
    call strcat

    push ax

    mov di, [points]
    call itoa

    mov di, complete_score_label
    mov si, converted_value
    call strcat

    pop bx
    add ax, bx

    mov si, VIDEO_BUFFER_WIDTH
    sub si, ax
    and si, 0xFFFE

    mov di, complete_score_label
    mov dx, 0
    call write_horizontal_text_at

    cmp BYTE [game_paused], TRUE
    je .game_paused

    mov di, running_label
    mov si, VIDEO_BUFFER_WIDTH / 2 - running_label.len / 2
    mov dx, 0
    call write_horizontal_text_at

    jmp .end

    .game_paused:
        mov di, paused_label
        mov si, VIDEO_BUFFER_WIDTH / 2 - paused_label.len / 2
        mov dx, 0
        call write_horizontal_text_at

    .end:

        call clear_complete_score_label
        ret


draw_game_status_panel:
    mov di, buffer_width_sized_empty_string
    mov si, 0
    mov dx, 0
    call write_horizontal_text_at

    mov di, status_panel_horizontal_bar
    mov si, 0
    mov dx, 1
    call write_horizontal_text_at

    ret