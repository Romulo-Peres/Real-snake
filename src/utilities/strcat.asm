; @params
; di - destiny
; si - source
;
; @returns
; ax - the amount of bytes copied
strcat:
    push di
    push si
    push bx

    xor ax, ax

    .find_null_byte_loop:
        cmp BYTE [di], 0x0
        je .copy_loop

        inc di
        jmp .find_null_byte_loop


    .copy_loop:
        mov bl, [si]
        cmp bl, 0x0
        je .end

        mov [di], bl

        inc di
        inc si
        inc ax

        jmp .copy_loop

    .end:
        mov BYTE [di], 0x0

        pop bx
        pop si
        pop di

    ret

