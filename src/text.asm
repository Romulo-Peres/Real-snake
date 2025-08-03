; @params
; di - pointer to null-terminated string
; si - x position
; dx - y position
write_horizontal_text_at:
    push di
    push si
    push dx

    mov bx, 0xB800
    mov es, bx

    call _calculate_absolute_x_and_y
    mov bx, ax

    .writing_loop:
        mov al, [di]
        mov ah, 0x0F

        mov [es:bx], ax

        add bx, 2

        inc di

        cmp BYTE [di], 0x0

        jne .writing_loop

    .end:
        pop dx
        pop si
        pop di

    ret

; @params
; di - pointer to null-terminated string
; si - x position
; dx - y position
write_vertical_text_at:
    push di
    push si
    push dx

    mov bx, 0xB800
    mov es, bx

    call _calculate_absolute_x_and_y
    mov bx, ax

    .writing_loop:
        mov al, [di]
        mov ah, 0x0F

        mov [es:bx], ax

        add bx, VIDEO_BUFFER_WIDTH * 2

        inc di

        cmp BYTE [di], 0x0

        jne .writing_loop

    .end:
        pop dx
        pop si
        pop di

    ret

; @params
; si - x position
; dx - y position
; 
; @returns
; ax - offset to be added to the video buffer base address
_calculate_absolute_x_and_y:
    push si
    push dx
    push cx
    push bx

    mov ax, dx
    mov cx, VIDEO_BUFFER_WIDTH * 2
    imul cx

    mov bx, ax

    mov ax, si
    mov cx, 0x2
    imul cx

    add ax, bx

    pop bx
    pop cx
    pop dx
    pop si

    ret