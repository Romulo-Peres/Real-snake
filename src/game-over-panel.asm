; @params
; di - points
draw_game_over_message:
    push bp
    mov bp, sp
    sub sp, 2

    mov [bp-1], di

    call draw_game_over_panel

    mov di, game_over_msg
    mov si, VIDEO_BUFFER_WIDTH / 2 - game_over_msg_len / 2
    mov dx, VIDEO_BUFFER_HEIGHT / 2 - 2
    call write_horizontal_text_at

    mov di, complete_score_label
    mov si, score_label
    call strcat

    ; save the length of score_label
    push ax

    mov di, [bp-1]
    call itoa

    mov di, complete_score_label
    mov si, converted_value
    call strcat

    pop dx      ; restore the length of score_label 
    add ax, dx  ; add with the converted_value length
    
    ; divide the length of complete_score_label by 2
    xor dx, dx
    mov bx, 2
    div bx

    ; (VIDEO_BUFFER_WIDTH / 2) - (complete_score_label / 2)
    neg ax
    add ax, VIDEO_BUFFER_WIDTH / 2

    mov di, complete_score_label
    mov si, ax
    mov dx, VIDEO_BUFFER_HEIGHT / 2
    call write_horizontal_text_at

    mov di, options_label
    mov si, VIDEO_BUFFER_WIDTH / 2 - options_label.len / 2
    mov dx, VIDEO_BUFFER_HEIGHT / 2 + 2
    call write_horizontal_text_at

    mov sp, bp
    pop bp

    ret

_clear_game_over_panel_location:
    mov dx, 9
    
    .loop:
        mov si, VIDEO_BUFFER_WIDTH / 2 - panel_horizontal_bar.len / 2
        mov di, empty_text_string
        call write_horizontal_text_at

        inc dx

        cmp dx, 15
        jle .loop

    ret

draw_game_over_panel:
    call _clear_game_over_panel_location

    mov si, VIDEO_BUFFER_WIDTH / 2 - panel_horizontal_bar.len / 2
    mov dx, 9
    mov di, panel_vertical_bar
    call write_vertical_text_at

    mov si, VIDEO_BUFFER_WIDTH / 2 - panel_horizontal_bar.len / 2 + 35
    mov dx, 9
    mov di, panel_vertical_bar
    call write_vertical_text_at

    mov dx, 11
    mov si, VIDEO_BUFFER_WIDTH / 2 - panel_horizontal_bar.len / 2
    mov di, panel_horizontal_bar
    call write_horizontal_text_at

    mov dx, 15
    call write_horizontal_text_at

    mov dx, 9
    call write_horizontal_text_at

    ret
