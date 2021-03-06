#include "types.h"
#include "stat.h"
#include "user.h"

int getNumberOfFreePages(){
    return get_number_of_free_pages();
}

int main23(int argc, char** argv){
    char buffer[4096];
    int pid = fork();
    if (pid == 0){
        buffer[0] = 'H';
        buffer[1] = 'E';
        buffer[2] = 0;
        printf(1, "%s\n", buffer);
        exit();
    }
    sleep(100);
    buffer[0] = 'H';
    buffer[1] = 'E';
    buffer[2] = 0;
    printf(1, "%s\n", buffer);
    wait();
    exit();
}
int main(int argc, char *argv[])
{   
    int PGSIZE = 4096;
    int n_of_allocations = 20;
    char * Fmem[1];
    Fmem[0] = malloc(n_of_allocations * PGSIZE);
    printf(1, "Allocation done\n");
    sleep(500);
    int i = 0;
    while (i <50) {
        *(Fmem[0] + PGSIZE * (i % n_of_allocations)) = 'c';
        i++;
    }
    printf(1, "Access done1\n");
    
    exit();
    return 0;
}
int
main56(void)
{
  int i = 0;
  uint c = 21;
  uint pointers[c];
   printf(1, "IN PARENT: BEFORE SBRK Number of occupied pages before fork %d\n" ,57344 - getNumberOfFreePages());
 
  // making sure I have more than 16 pages on RAM
  for (i = 0 ; i < c ; i++){
        printf(1, "%d\n", i);
        pointers[i] = (uint)sbrk(4096);
        * (char *) pointers[i] = (char) ('a' + i);
    }
    for (i = 0 ; i < c ; i++){  
        printf(1, "%c\n", *(char * )pointers[i]);
    }
  
  printf(1, "IN PARENT: Number of occupied pages before fork %d\n" ,57344 - getNumberOfFreePages());
  int pid;
  if( (pid = fork()) ==0){
      printf(1, "IN CHILD: Number of occupied pages after fork %d\n" ,57344 - getNumberOfFreePages());
      * (char *) pointers[0] = (char) ('b');
       printf(1,"IN CHILD pointers[0] %c\n", *(char * )pointers[0]);
      exit();
  }
  else{
     wait();
    printf(1, "IN PARENT: Number of occupied pages after fork %d\n" ,57344 - getNumberOfFreePages());
    printf(1,"IN PARENT pointers[0] %c\n", *(char * )pointers[0]);
  
  }
  exit();
}

int
main10(int argc, char *argv[])
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