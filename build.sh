mkdir -p build
mkdir -p image

nasm src/loader.asm -o build/loader.o
nasm src/snake.asm -o build/snake.o

cat build/loader.o build/snake.o > image/image