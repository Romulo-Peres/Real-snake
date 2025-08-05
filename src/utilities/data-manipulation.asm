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