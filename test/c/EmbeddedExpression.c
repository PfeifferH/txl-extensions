#include <stdio.h>
int main() {
   
    printf("Start\n");

    int x = 6 + 7;

    if (x < 0) {
        x = 0;
    }
    if (x > 8 - 5) {
        x = 8 - 5;
    }

    printf("%d\n", x);

    printf("End\n");

    return 0;
}