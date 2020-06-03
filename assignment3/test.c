#include "types.h"
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
    int i = 0;
    uint c = 21;
    uint pointers[c];
    int pid = 0;
    // making sure I have more than 16 pages on RAM
    for (i = 0 ; i < c ; i++){
        pointers[i] = (uint)sbrk(4096);
        * (char *) pointers[i] = (char) ('a' + i);
    }

    pid = fork();

    if(pid == 0){
    printf(1,"SON : \n");
    for (i = 0 ; i < c ; i++){

        printf(1,"%c", *(char * )pointers[i]);

    }


    printf(1, " \n DONE \n");

    }
    

    if(pid != 0){
        wait();
    }

    if(pid != 0){
    printf(1,"FATHER : \n");
    for (i = 0 ; i < c ; i++){
    printf(1,"%c", *(char * )pointers[i]);

    }
    printf(1, " \n DONE \n");

    }


    exit();
}