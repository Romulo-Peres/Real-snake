; @params
; bx - head X position
; cx - head Y position
; dx - element
;
; @returns
; al - the char that was replaced
place_element_at:
    push bx
    push cx
    push dx

    mov ax, VIDEO_BUFFER_WIDTH
    imul cx

    add bx, ax
    
    pop dx

    mov ax, [es:bx]
    push ax

    mov al, dl
    mov ah, 0x02
    mov [es:bx], ax

    pop ax
    pop cx
    pop bx
    ret