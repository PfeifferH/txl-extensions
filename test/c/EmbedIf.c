#include <stdio.h>
int main() {
    int x = 1;

    printf("Start\n");

    if (x == 1) {
        printf("Begin Embed\n");
        int y = 0;
        printf("End Embed\n");
    }

    printf("End\n");
}