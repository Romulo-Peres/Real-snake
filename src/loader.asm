    org 0x7C00

    %include "includes/constants.asm"

    BITS 16

    ; set video mode
    mov ah, 0x0
    mov al, 0x3
    int 0x10

    mov bx, GAME_SEGMENT
    mov es, bx
    mov bx, 0
	
    ; load the game from pendrive
    mov ah, 0x02
    mov al, 3
    mov ch, 0
    mov cl, 2
    mov dh, 0
    mov dl, 0x80
    int 0x13

    ; setting up the stack segment
    mov bx, STACK_BASE_ADDR
    mov ss, bx
    mov sp, STACK_POINTER_ADDR
    mov bp, sp

    mov bx, GAME_SEGMENT
    mov ds, bx
    
    ; make the processor execute the game
    jmp GAME_SEGMENT:0x0

times 446 - ($ - $$) db 0x0

    ; these instructions represent a hardcoded bootable
    ; FAT16 partition inside the image, it is necessary to make
    ; the BIOS load the instructions correctly
    add byte [bx+si],0x1
    add [0x300],ax
    add [bx+si],ax
    or [bx+si],al
    add [bp+di],al

times 510 - ($ - $$) db 0x0
dw 0xAA55