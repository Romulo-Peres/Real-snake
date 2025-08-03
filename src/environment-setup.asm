%macro configure_stack_segment 0
    mov bx, STACK_BASE_ADDR
    mov ss, bx
    mov sp, STACK_POINTER_ADDR
    mov bp, sp
%endmacro

configure_data_segment:
    mov bx, GAME_SEGMENT
    mov ds, bx
    
    ret