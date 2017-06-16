#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>

int main() {
    struct timeval tv;
    if (gettimeofday(&tv, NULL) != 0) {
        perror("gettimeofday");
        exit(EXIT_FAILURE);
    }
    printf("%lld%06ld\n", (long long)(tv.tv_sec), (long)(tv.tv_usec));
}
