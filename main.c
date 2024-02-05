#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>
extern void _printf(char*, ...);
extern void _fprintf(int, char*, ...);
extern void _sprintf(char*, char*, ...);

extern void _scanf(char*, ...);
extern void _fscanf(int, char*, ...);
extern void _sscanf(char* ,char*, ...);
//
//
// Функции реализованы для %c %s %d %i %u %x %X %o
//
//
int main(){
    //int input = open("input.txt",  O_RDONLY);
    //int output = open("output.txt",  O_WRONLY);
    int a;
    int b;

    _printf("Enter two decimals: ");
    _scanf("%d%d", &a, &b);
    _printf("%d %d\n", a+b, a-b);

    _printf("%c %s %% %u %d %i %o %x %X\n", 'a', "Hello", 55, -12, 0, 01234, 0xdead, 0xbeef);

    //проверять тут





    //close(input);
    //close(output);
    return 0;
}