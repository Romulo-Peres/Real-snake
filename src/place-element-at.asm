; @params
; bx - head X position
; cx - head Y position
; dx - element
place_element_at:
    push ax
    push bx
    push cx
    push dx

    mov ax, VIDEO_BUFFER_WIDTH
    imul cx

    add bx, ax
    
    pop dx

    mov al, dl
    mov ah, 0x02
    mov [es:bx], ax

    pop cx
    pop bx
    pop ax
    ret