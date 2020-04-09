
#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char** agrv){
    printf(1, "PID  PS_PRIORITY STIME   RETIME  RTIME\n");
    int first_pid = fork();
    if (first_pid == 0){
        int second_pid = fork();
        if (second_pid == 0){
            int third_pid = fork();
            if (third_pid == 0){
                set_cfs_priority(1);
                set_ps_priority(1);
                int i = 10000000;
                int dummy = 0;
                while(i--){
                    dummy+=i;
                    printf(1, "");
                }
                struct perf info;
                proc_info(&info);
                printf(1, "%d       %d      %d       %d         %d\n", getpid(), info.ps_priority, info.stime, info.retime, info.rtime);
                exit(0);
            }
            set_cfs_priority(2);
            set_ps_priority(5);
            int i = 10000000;
            int dummy = 0;
            while(i--){
                dummy+=i;
                printf(1, "");
            }
            struct perf info;
            proc_info(&info);
            int status;
            wait(&status);
            printf(1, "%d       %d      %d       %d         %d\n", getpid(), info.ps_priority, info.stime, info.retime, info.rtime);
            exit(0);
        }
        set_cfs_priority(3);
        set_ps_priority(10);
        int i = 10000000;
        int dummy = 0;
        while(i--){
            dummy+=i;
            printf(1, "");
        }
        struct perf info;
        proc_info(&info);
        int status;
        wait(&status);
        printf(1, "%d       %d      %d       %d       %d\n", getpid(), info.ps_priority, info.stime, info.retime, info.rtime);
        exit(0);
    }
    
    int status;
    wait(&status);
    exit(0);
    return 0;
    
}