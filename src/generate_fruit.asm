%include "includes/constants.asm"

; @params
; bx - video buffer width
; cx - video buffer height
generate_fruit:

    ; save registers
    push bp
    push bx
    push cx
    push ax
    push dx
    push es
    mov bp, sp

    push cx

    ; get system timer counter
    mov ah, 0x0
    int 0x1A

    ; use the first two bits of the higher
    ; part of the timer counter to increase entropy
    and dh, 0x3

    ; add value to offset
    add [last_fruit_offset], dx

    pop cx

    ; calculate the video buffer size
    mov ax, bx
    imul cx

    ; calculate last_fruit_offset % video buffer size
    mov bx, ax
    mov ax, [last_fruit_offset]
    idiv bx

    ; save the new offset
    mov [last_fruit_offset], dx

    ; multiply the offset by 2 to
    ; match the video buffer addresses
    mov ax, dx
    mov dx, 0x2
    imul dx

    cmp ax, VIDEO_BUFFER_WIDTH * 4
    jg .no_conflict_with_status_bar

    mov ax, VIDEO_BUFFER_WIDTH * 4 + 10

    .no_conflict_with_status_bar:
    ; apply a mask to make odd offsets impossible
    and ax, 0xFFFE

    ; load the address to insert the fruit
    mov bx, 0xB800
    mov es, bx
    mov bx, ax

    .availability_loop:
        mov ax, [es:bx]
    
        cmp al, SNAKE_BODY_CHAR
        je .position_not_available
        cmp al, SNAKE_HEAD_CHAR
        je .position_not_available
    
        ; craft the fruit char
        mov al, FRUIT_CHAR
        mov ah, 0x04

        mov [es:bx], ax

        jmp .loop_end
    
    .position_not_available:
        add bx, 0x2
        add WORD [last_fruit_offset], 0x1
        jmp .availability_loop

    .loop_end:
        pop es
        pop dx
        pop ax
        pop cx
        pop bx
        pop bp
    
    ret


