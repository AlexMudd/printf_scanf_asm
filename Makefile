all: 
	@echo 'build'
	@echo 'run'
	@echo 'clean'
	
build:
	@nasm -f elf64 printf.asm -o printf.o
	@nasm -f elf64 fprintf.asm -o fprintf.o
	@nasm -f elf64 sprintf.asm -o sprintf.o
	@nasm -f elf64 scanf.asm -o scanf.o
	@nasm -f elf64 fscanf.asm -o fscanf.o
	@nasm -f elf64 sscanf.asm -o sscanf.o
	@touch input.txt

	@gcc -no-pie main.c printf.o fprintf.o sprintf.o scanf.o fscanf.o sscanf.o -o program 

run:
	@./program

clean:
	@rm *.o
	@rm program
	@rm input.txt