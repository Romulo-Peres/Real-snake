    %include "includes/constants.asm"
    %define DIRECTION 1
    %define X_AXIS_POINT 2
    %define Y_AXIS_POINT 3

; @params
; ax - X axis point
; bx - Y axis point
; cx - new direction
create_curve:
    push bp
    push ax
    push bx
    push cx
    push dx
    push es
    mov bp, sp

    ; begin of ring buffer value crafting
    shl ax, 7
    shl bx, 2
    or ax, bx
    or ax, cx
    ; end of ring buffer value crafting

    ; load the address to insert the value
    mov bx, RING_BUFFER_BASE
    mov es, bx
    mov bx, [write_ptr]

    ; write the value into the ring buffer
    mov [es:bx], ax
    mov bx, [write_ptr]
    add bx, 0x2

    cmp bx, MAX_RING_BUFFER_SIZE

    jl overflow_end

overflow:
    mov bx, 0x0
overflow_end:
    mov [write_ptr], bx

    pop es
    pop dx
    pop cx
    pop bx
    pop ax
    pop bp

    ret

; @params
; ax - X axis point
; bx - Y axis point
;
; @returns
; ah - 0x1 if match, 0x0 otherwise
; al - the direction if the check matches
check_curve:
    ; save registers and allocate memory
    push bp
    push bx 
    push dx
    push es
    mov bp, sp
    sub sp, 3

    ; save X and Y axis points into stack
    mov [bp-X_AXIS_POINT], al
    mov [bp-Y_AXIS_POINT], bl

    ; check if both pointers are equal
    mov bx, [read_ptr]
    cmp bx, [write_ptr]
    je empty_buffer

    ; load address to read the next buffer value
    mov bx, RING_BUFFER_BASE
    mov es, bx
    mov bx, [read_ptr]

    mov ax, [es:bx]

    ; increment read pointer by 2
    add bx, 0x2

    cmp bx, MAX_RING_BUFFER_SIZE
    jl read_overflow_end

read_overflow:
    mov bx, 0x0
read_overflow_end:
    mov [read_ptr], bx

    ; unpack positions and direction
    ; from ring buffer value
    mov dx, ax
    and dx, 0b0011111111111100
    and ax, 0x3
    mov [bp-DIRECTION], al

    mov bl, [bp-Y_AXIS_POINT]
    mov al, [bp-X_AXIS_POINT]

    shl ax, 0x7
    shl bx, 0x2
    or ax, bx
    and ax, 0b0011111111111100

    ; verify if the buffer ring value and
    ; the given values match
    cmp ax, dx
    jne position_not_equal

    ; on success, ah == 0x1 and al is the direction
    mov ah, 0x1
    mov al, [bp-DIRECTION]

    jmp position_not_equal_end

position_not_equal:
empty_buffer:

    ; on error, ah == 0x0
    mov ax, 0x0

position_not_equal_end:
    ; restore all registers
    mov sp, bp
    pop es
    pop dx
    pop bx
    pop bp

    ret

    read_ptr dw 0x0
    write_ptr dw 0x0