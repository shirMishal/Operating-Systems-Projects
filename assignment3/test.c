#include "types.h"
#include "stat.h"
#include "user.h"

int getNumberOfFreePages(){
    return 1;
}

int
main(void)
{
  int i = 0;
  uint c = 21;
  uint pointers[c];
   printf(1, "IN PARENT: BEFORE SBRK Number of free pages before fork %d\n" ,getNumberOfFreePages());
 
  // making sure I have more than 16 pages on RAM
  for (i = 0 ; i < c ; i++){
        printf(1, "%d\n", i);
        pointers[i] = (uint)sbrk(4096);
        * (char *) pointers[i] = (char) ('a' + i);
    }
    for (i = 0 ; i < c ; i++){  
        printf(1, "%c\n", *(char * )pointers[i]);
    }
  
  printf(1, "IN PARENT: Number of free pages before fork %d\n" ,getNumberOfFreePages());
  int pid;
  if( (pid = fork()) ==0){
      printf(1, "IN CHILD: Number of free pages after fork %d\n" ,getNumberOfFreePages());
      * (char *) pointers[0] = (char) ('b');
       printf(1,"IN CHILD pointers[0] %c\n", *(char * )pointers[0]);
      exit();
  }
  else{
     wait();
    printf(1, "IN PARENT: Number of free pages before fork %d\n" ,getNumberOfFreePages());
    printf(1,"IN PARENT pointers[0] %c\n", *(char * )pointers[0]);
  
  }
  exit();
}

int
main1(int argc, char *argv[])
{
    int i = 0;
    uint c = 21;
    uint pointers[c];
    int pid = 0;
    // making sure I have more than 16 pages on RAM
    for (i = 0 ; i < c ; i++){
        printf(1, "%d\n", i);
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