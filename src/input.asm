; @params
; ax - on left handler
; bx - on up handler
; cx - on right handler
; dx - on down handler
;
; @returns 
; ax - the selected handler, 0x0 if invalid input
keyboard_input:
    ; save registers and allocate memory
    push bp
    mov bp, sp
    sub sp, 2

    ; save the left handler on stack
    mov [bp-2], ax

    ; read char from input buffer
    mov ah, 0x0
    int 0x16

    ; check if the char is uppercase
    cmp al, 0x61
    jl is_uppercase

    ; if not, make it uppercase
    sub al, 0x20
is_uppercase:
    cmp al, 'A'

    jne not_left

    mov ax, [bp-2]
    jmp input_end
not_left:
    cmp al, 'W'

    jne not_up

    mov ax, bx
    jmp input_end
not_up:
    cmp al, 'D'

    jne not_right

    mov ax, cx
    jmp input_end
not_right:
    cmp al, 'S'

    jne not_down

    mov ax, dx
    jmp input_end
not_down:
    ; return 0x0 if invalid user input
    mov ax, 0x0
input_end:
    mov sp, bp
    pop bp

    ret