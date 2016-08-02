#include <stdio.h>

void print_int(int n) {
    printf("%d\n", n);
}

void dump_array(int *array, size_t size) {
    for (int i=0; i<size; i++)
        printf("%d ", array[i]);
    printf("\n");
}
