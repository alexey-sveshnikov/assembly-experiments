sort: main.asm
	nasm -f elf64 -F stabs main.asm
	ld -o sort main.o
	./sort

.PHONY: sort
