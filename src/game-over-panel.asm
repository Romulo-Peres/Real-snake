; @params
; di - points
draw_game_over_message:
    push bp
    mov bp, sp
    sub sp, 2

    mov [bp-1], di

    call draw_game_over_panel

    mov di, game_over_msg
    mov si, VIDEO_BUFFER_WIDTH / 2 - game_over_msg.len / 2
    mov dx, VIDEO_BUFFER_HEIGHT / 2 - 2
    call write_horizontal_text_at

    mov di, score_label
    mov si, VIDEO_BUFFER_WIDTH / 2 - score_label.len / 2
    mov dx, VIDEO_BUFFER_HEIGHT / 2
    call write_horizontal_text_at

    mov dl, [bp-1]
    add dl, '0'

    mov [user_points], dl

    mov di, user_points
    mov si, VIDEO_BUFFER_WIDTH / 2 - score_label.len / 2 + score_label.len
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

game_over_msg db "Game over", 0x0
game_over_msg.len equ $-game_over_msg
score_label db "Final Score:", 0x0
score_label.len equ $-score_label
options_label db "[T] - try again, [Z] - exit game", 0x0
options_label.len equ $-options_label
panel_horizontal_bar db "------------------------------------", 0x0
panel_horizontal_bar.len equ $-panel_horizontal_bar
empty_text_string times panel_horizontal_bar.len db ' '
db 0x0
panel_vertical_bar db "|||||||", 0x0
panel_vertical_bar.len equ $- panel_vertical_bar
user_points db '0', 0x0
