
#include "types.h"
#include "stat.h"
#include "user.h"


int main(int argc, char** argv){
    int pid = fork();
    if (pid == 0){
        while(1){
            printf(1, "h\n");
        }
    }
    else{
        printf(1, "%d", pid);
        sleep(100);
        kill(pid, 17);
        sleep(100);
        kill(pid, 19);
        exit();
    }
}   
