#include "types.h"
#include "stat.h"
#include "user.h"
#include "x86.h"

void action_handler(int signum){
    printf(1, "SIGNAL %d HANDLED\n", signum);
    return;
}

int main4(int argc, char** argv){
      int a, b, c,ret;
  a = 1; b = 2; c = 3;
  int i=1;
  printf(1,"a %d b %d c %d\n",a,b,c);
  ret = cas(&a,b,c);
  printf(1,"ret %d, a %d \n\n",ret, a);
  if(ret){
    printf(1,"Case %d Fail\n ",i);
    exit();
  }
  i++;
  a = 2; b = 2; c = 3;
  
  printf(1,"a %d b %d c %d\n",a,b,c);
  ret = cas(&a,b,c);
  printf(1,"ret %d, a %d \n\n",ret, a);
  if(!ret){
    printf(1,"Case %d Fail\n ",i);
    exit();
  }
  i++;
  a = 3; b = 2; c = 3;
  
  printf(1,"a %d b %d c %d\n",a,b,c);
  ret = cas(&a,b,c);
  printf(1,"ret %d, a %d \n\n",ret, a);
  if(ret){
    printf(1,"Case %d Fail\n ",i);
    exit();
  }
  i++;
  a = 3; b = 3; c = 30;
  
  printf(1,"a %d b %d c %d\n",a,b,c);
  ret = cas(&a,b,c);
  printf(1,"ret %d, a %d \n\n",ret, a);
  if(!ret){
    printf(1,"Case %d Fail\n ",i);
    exit();
  }
  i++;
  a = 2; b = 4; c = 3;
  
  printf(1,"a %d b %d c %d\n",a,b,c);
  ret = cas(&a,b,c);
  printf(1,"ret %d, a %d \n\n",ret, a);
  if(ret){
    printf(1,"Case i %d Fail\n ",i);
    exit();
  }
  i++;
   a = 3; b = 4; c = 30;
  
  printf(1,"a %d b %d c %d\n",a,b,c);
  ret = cas(&a,b,c);
  printf(1,"ret %d, a %d \n\n",ret, a);
  if(ret){
    printf(1,"Case %d Fail\n ",i);
    exit();
  }
  i++;
   a = 4; b = 4; c = 30;
  
  printf(1,"a %d b %d c %d\n",a,b,c);
  ret = cas(&a,b,c);
  printf(1,"ret %d, a %d \n\n",ret, a);
  if(!ret){
    printf(1,"Case %d Fail\n ",i);
    exit();
  }
  printf(1,"All Tests passed\n");
  exit();
}

int main(int argc, char** argv){
    for (int i = 0; i < 20; i++){
        int pid = fork();
        if (pid != 0){
            printf(1, "%d\n", pid);
        }
        else{
            break;
        }
    }
    exit();
}

int main1(int argc, char** argv){
    struct sigaction sigact = {action_handler, 0};
    sigaction(1, &sigact, null);
    kill(getpid(), 1);
    kill(getpid(), 9);

    for (int i = 0; i < 1000000; i++){
            if (i % 1000 == 0){
                printf(1, "hi\n");
            }
            printf(1, "");
        }
    return 0;
}

int main2(int argc, char** argv){
    struct sigaction sigact = {action_handler, 0};
    int pid = fork();
    if (pid == 0){
        printf(1, "childs here");
        sigaction(1, &sigact, null);
        sigaction(2, &sigact, null);
        sigaction(3, &sigact, null);
        for (int i = 0; i < 1000000; i++){
            if (i % 1000 == 0){
                printf(1, "hi\n");
            }
            printf(1, "");
        }
    }
    else{
        printf(1, "childs pid : %d\n", pid);
        sleep(100);
        printf(1, "sending signal %d to child\n", 1);
        kill(pid, 1);
        sleep(100);
        printf(1, "sending signal %d to child\n", 2);
        kill(pid, 2);
        sleep(100);
        printf(1, "sending signal %d to child\n", 3);
        kill(pid, 3);
        sleep(100);
        kill(pid, 9);

        wait();
        sleep(300);


    }
    exit();
}   
