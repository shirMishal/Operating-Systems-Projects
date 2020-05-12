
#include "types.h"
#include "stat.h"
#include "user.h"

void action_handler(int signum){
    printf(1, "SIGNAL %d HANDLED\n", signum);
}

int main(int argc, char** argv){
    struct sigaction sigact = {action_handler, 0};
    int pid = fork();
    if (pid == 0){
        sigaction(1, &sigact, null);
        sigaction(2, &sigact, null);
        sigaction(3, &sigact, null);
        while(1){}
    }
    else{
        sleep(1000);
        printf(1, "sending signal %d to child\n", 1);
        kill(pid, 1);
        sleep(100);
        printf(1, "sending signal %d to child\n", 2);
        kill(pid, 2);
        sleep(100);
        printf(1, "sending signal %d to child\n", 3);
        kill(pid, 3);

        // sleep(10000);
        // kill(pid, 9);
        exit();
    }
}   
