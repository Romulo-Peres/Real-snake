; ===== Labels =====
game_over_msg db "Game over", 0x0
game_over_msg_len equ $-game_over_msg
score_label db "Final Score: ", 0x0
score_label.len equ $-score_label
options_label db "[T] - try again, [Z] - exit game", 0x0
options_label.len equ $-options_label
complete_score_label times 5 dd 0x0

; ===== Box Structure =====
panel_horizontal_bar db "------------------------------------", 0x0
panel_horizontal_bar.len equ $-panel_horizontal_bar
panel_vertical_bar db "|||||||", 0x0
panel_vertical_bar.len equ $- panel_vertical_bar
empty_text_string times panel_horizontal_bar.len db ' '
db 0x0

; ===== Data Structure Specifics =====
read_ptr dw 0x0
write_ptr dw 0x0

; ===== Snake Properties =====
direction dw DIRECTION_RIGHT
head_x_pos dw HEAD_X_START_POS
head_y_pos dw HEAD_Y_START_POS
tail_x_pos dw TAIL_X_START_POS
tail_y_pos dw TAIL_Y_START_POS
tail_direction dw DIRECTION_RIGHT
pending_body dw 0x0
snake_speed db NORMAL_SPEED

; ===== Game Values =====
last_fruit_offset dw 0x0
user_points db '0', 0x0
game_over_flag dw 0x0
points dw 0x0


; ===== Data Convertion Specifics =====
converted_value db 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0
itoa_buffer dd 0x0
itoa_content_length dw 0x0