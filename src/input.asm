; @params
; ax - on left handler
; bx - on up handler
; cx - on right handler
; dx - on down handler
; di - on reset
; si - on try again
; @returns 
; ax - the selected handler, 0x0 if invalid or no user input
keyboard_input:
    ; save registers and allocate memory
    push bp
    mov bp, sp
    sub sp, 3

    ; save the left handler on stack
    mov [bp-3], ax
    mov BYTE [bp-1], 0x0

    .get_last_input_loop:

        ; check if there is something on input buffer
        mov ah, 0x1
        int 0x16

        jz .check_uppercase

        mov [bp-1], al

        ; read char from input buffer
        mov ah, 0x0
        int 0x16

        jmp .get_last_input_loop

    .check_uppercase:
        mov al, [bp-1]

        cmp al, 0x61  ; check if the char is uppercase
        jl .decode_command

        ; if not, make it uppercase
        sub al, 0x20

    .decode_command:
        cmp al, 'A' ; check if it is Left command
        jne .left_command_else_block

        mov ax, [bp-3]
        jmp .end

    .left_command_else_block:
        cmp al, 'W' ; check if it is Up command
        jne .up_command_else_block

        mov ax, bx
        jmp .end

    .up_command_else_block:
        cmp al, 'D' ; check if it is Right command
        jne .right_command_else_block

        mov ax, cx
        jmp .end

    .right_command_else_block:
        cmp al, 'S' ; check if it is Down command
        jne .down_command_else_block

        mov ax, dx
        jmp .end

    .down_command_else_block:
        cmp al, 'Z' ; check if it is reset command
        jne .reset_command_else_block

        mov ax, di
        jmp .end

    .reset_command_else_block:
        cmp al, 'T' ; check if it is try again command
        jne .try_again_command_else_block

        mov ax, si
        jmp .end

    .try_again_command_else_block:
        ; return 0x0 if invalid or no user input is available
        mov ax, 0x0

    .end:
        mov sp, bp
        pop bp

    ret