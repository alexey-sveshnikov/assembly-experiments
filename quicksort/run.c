#include <stdio.h>
#include <assert.h>
#include <stdlib.h>

#define SIZE 15

int partition(int*, size_t size);
int quicksort(int*, size_t size);
int dump_array(int*, size_t size);

//void dump_array(int *array, size_t size) {
//    for (int i=0; i<size; i++)
//        printf("\t%d\n", array[i]);
//}


int main (int argc, char** argv) {
    assert(sizeof(int) == 4);
    int data[SIZE] = {
        1,
        9,
        4,
        14,
        15,
        6,
        8,
        7,
        3,
        5,
        10,
        11,
        12,
        2,
        13,
    };
//    for (int i=0; i<SIZE; i++)
        //data[i] = SIZE-i;
 //       data[i] = rand();

//    printf("Before sorting:\n");
//   dump_array(data, SIZE);

    quicksort(data, SIZE);

    printf("After sorting:\n");
    dump_array(data, SIZE);

    //printf("Pivotal element: %d\n", data[position]);
    return 0;
}
