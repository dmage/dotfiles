#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>

int main() {
    struct timeval tv;
    if (gettimeofday(&tv, NULL) != 0) {
        perror("gettimeofday");
        exit(EXIT_FAILURE);
    }
    printf("%lld%06d\n", (long long)(tv.tv_sec), tv.tv_usec);
}

/*
#define _GNU_SOURCE
#include <unistd.h>
#include <sys/syscall.h>
#include <sys/types.h>

int main() {
        syscall(SYS_write, 1, "Hello, worldn", 13);

        pid_t tid = syscall(SYS_gettid);
        tid = syscall(SYS_tgkill, getpid(), tid);
}
*/
