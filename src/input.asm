; @params
; ax - on left handler
; bx - on up handler
; cx - on right handler
; dx - on down handler
;
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

last_input_loop:

    ; check if there is something on input buffer
    mov ah, 0x1
    int 0x16

    jz uppercase_check

    mov [bp-1], al

    ; read char from input buffer
    mov ah, 0x0
    int 0x16

    jmp last_input_loop

uppercase_check:
    mov al, [bp-1]

    ; check if the char is uppercase
    cmp al, 0x61
    jl is_uppercase

    ; if not, make it uppercase
    sub al, 0x20
is_uppercase:
    cmp al, 'A'

    jne not_left

    mov ax, [bp-3]
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
    ; return 0x0 if invalid
    ; or no user input
    mov ax, 0x0
input_end:
    mov sp, bp
    pop bp

    ret