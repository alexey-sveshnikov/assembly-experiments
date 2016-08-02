quicksort: run.c quicksort.o print.c
	gcc -std=c99 -o quicksort run.c print.c quicksort.o

quicksort.o: quicksort.asm
	nasm -f elf64 quicksort.asm


clean:
	rm quicksort quicksort.o

.PHONY: clean
