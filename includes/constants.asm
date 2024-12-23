%define GAME_SEGMENT 0x100
%define STACK_BASE_ADDR 0xFF00
%define STACK_POINTER_ADDR 0xFFFF
%define FRUIT_CHAR '#'
%define SNAKE_BODY_CHAR '*'
%define SNAKE_HEAD_CHAR '@'
%define DIRECTION_LEFT 0x0
%define DIRECTION_UP 0x1
%define DIRECTION_RIGHT 0x2
%define DIRECTION_DOWN 0x3
%define FRUIT_GROWTH_FACTOR 0x5
%define RING_BUFFER_BASE 0x1038
%define RING_BUFFER_END 0x10CC
%define HEAD_X_START_POS 0x8
%define HEAD_Y_START_POS 0x3
%define TAIL_X_START_POS 0x3
%define TAIL_Y_START_POS 0x3
%define VIDEO_BUFFER_WIDTH 0x50
%define VIDEO_BUFFER_HEIGHT 0x19
%define MAX_RING_BUFFER_SIZE RING_BUFFER_END - RING_BUFFER_BASE
