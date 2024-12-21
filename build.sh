nasm src/loader.asm -o build/loader.o
nasm src/snake.asm -o build/snake.o

cp build/loader.o build/image
dd if=build/snake.o >> build/image