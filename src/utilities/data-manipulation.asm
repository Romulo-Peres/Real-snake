clear_complete_score_label:
    mov di, complete_score_label
    mov ax, 0

    .clear_loop:
        cmp ax, complete_score_label.len
        jge .end

        mov BYTE [di], 0
        
        inc ax
        inc di
        
        jmp .clear_loop

    .end:
        ret

reset_positions_and_direction:
    mov WORD [direction], DIRECTION_RIGHT
    mov WORD [head_x_pos], HEAD_X_START_POS
    mov WORD [head_y_pos], HEAD_Y_START_POS
    mov WORD [tail_x_pos], TAIL_X_START_POS
    mov WORD [tail_y_pos], TAIL_Y_START_POS
    mov WORD [tail_direction], DIRECTION_RIGHT

    ret