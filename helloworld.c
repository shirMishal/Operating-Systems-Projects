
#include "types.h"
#include "stat.h"
#include "user.h"


int main(int argc, char** argv){
    int pid = fork();
    if (pid != 0){
        int exit_code;
        wait(&exit_code);
        printf(1, "This is the parent\n");
        printf(1, "exit code: %d\n", exit_code);
        exit(1);
    }
    else{
        printf(1, "This is the child\n");
        exit(11);
    }
    return 0;
}