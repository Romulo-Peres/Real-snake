    org 0x7C00

    jmp loader_begin

    %include "includes/constants.asm"
    %include "src/environment-setup.asm"

    BITS 16

loader_begin:

    ; set video mode
    mov ah, 0x0
    mov al, 0x3
    int 0x10

    ; set cursor type
    mov ah, 0x1
    mov cl, 0x0
    mov ch, 32
    int 0x10

    mov bx, GAME_SEGMENT
    mov es, bx
    mov bx, 0
	
    ; load the game from pendrive
    mov ah, 0x02
    mov al, 4
    mov ch, 0
    mov cl, 2
    mov dh, 0
    mov dl, 0x80
    int 0x13

    configure_stack_segment

    call configure_data_segment

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