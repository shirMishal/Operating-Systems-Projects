
#include "types.h"
#include "stat.h"
#include "user.h"

void action_handler(int signum){
    printf(1, "SIGNAL %d HANDLED\n", signum);
}

int flag = 0;

void userHandler(int signum){
    printf(1,"IN HANDLER\n");
    flag=1;
}

void userHandlerTest(void){
    printf(1,"starting userHandlerTest\n");
    printf(1,"flag is now %d\n",flag);
    sa.sa_handler = &userHandler;
    sa.sigmask = 0;
    sigaction(20,&sa,0);
    printf(1,"sending signal\n");
    kill(getpid(),20);
    while(flag == 0){
        printf(1,"LOOP\n");
        
    }
    printf(1,"flag is now %d\n",flag);
    printf(1,"userHandlerTest done\n");
}


int main1(int argc, char** argv){
    // struct sigaction sigact = {action_handler, 0};
    int pid = fork();
    if (pid == 0){
        // sigaction(1, &sigact, null);
        // sigaction(2, &sigact, null);
        // sigaction(3, &sigact, null);
        for (int i = 0; i < 10000000; i++){
            if (i % 1000 == 0){
                printf(1, "hi\n");
            }
            printf(1, "");
        }        
    }
    else{
        // printf(1, "%d\n", pid);
        // sleep(100);
        // printf(1, "sending signal %d to child\n", 1);
        // kill(pid, 1);
        // sleep(100);
        // printf(1, "sending signal %d to child\n", 2);
        // kill(pid, 2);
        // sleep(100);
        // printf(1, "sending signal %d to child\n", 3);
        // kill(pid, 3);
        sleep(300);
        kill(pid, 9);
        sleep(500);
        exit();
    }
    exit();
}   
