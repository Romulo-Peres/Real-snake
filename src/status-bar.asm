; @params
; dl - countdown number
draw_status_bar:
    push dx

    call draw_status_bar_panel
    call draw_player_score

    pop dx
    call draw_pause_status

    ret

; @params
; dl - countdown number
draw_pause_status:
    push dx

    cmp dl, 0
    je .not_counting_down

    add dl, '0'
    mov [unpause_countdown], dl

    mov di, unpause_countdown
    mov si, VIDEO_BUFFER_WIDTH / 2
    mov dx, 0
    call write_horizontal_text_at

    jmp .end

    .not_counting_down:
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

    pop dx
    ret

draw_player_score:
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

    ret

draw_status_bar_panel:
    mov di, buffer_width_sized_empty_string
    mov si, 0
    mov dx, 0
    call write_horizontal_text_at

    mov di, status_panel_horizontal_bar
    mov si, 0
    mov dx, 1
    call write_horizontal_text_at

    ret