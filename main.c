#include <stdio.h>
#include <malloc.h>

int main() {
    int n;
    scanf("%d", &n);
    int *arr = malloc(n * sizeof(int));
    int sumOfOdd = 0;
    for (int i = 0; i < n; ++i) {
        scanf("%d", &arr[i]);
        if (i % 2 == 0) {
            sumOfOdd += arr[i];
        }
    }
    int m = 0;
    for (int i = 0; i < n; ++i) {
        if (arr[i] < sumOfOdd) {
            ++m;
        }
    }
    int *b = malloc(m * sizeof(int));
    int j = 0;
    for (int i = 0; i < n; ++i) {
        if (arr[i] < sumOfOdd) {
            b[j] = arr[i];
            printf("%d ", b[j]);
            ++j;
        }
    }
    free(b);
    free(arr);
}
