; @params
; di - number to be converted to string
itoa:
    push ax
    push si
    push es
    push di
    push dx
    mov ax, di

    .conversion_loop:
        cmp ax, 10
        jl .last_number

        xor dx, dx
        mov di, 10
        div di

        add dl, '0'

        mov di, itoa_buffer
        add di, [itoa_content_length]

        mov [di], dl

        inc WORD [itoa_content_length]

        jmp .conversion_loop

    .last_number: 
        add al, '0'
        mov di, itoa_buffer
        add di, [itoa_content_length]

        mov [di], al

        mov si, converted_value

    .copy_loop:
        cmp di, itoa_buffer
        jl .end

        mov al, [di]
        mov [si], al
        inc si

        dec di

        jmp .copy_loop

    .end:
        mov BYTE [si], 0x0
        mov WORD [itoa_content_length], 0x0

        pop dx
        pop di
        pop es
        pop si
        pop ax

    ret