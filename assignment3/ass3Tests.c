
#include "types.h"
#include "stat.h"
#include "user.h"
void
test() {
  int i = 0;
  const int PGSIZE = 4096;
  const int MAXPAGES = 57334;
  uint size = 19;
  uint pointers[size];
  int pid = 0;
  int changes = 1;
  int midway = 9;
  int fp = get_number_of_free_pages();
  char* a;
  printf(1, "before fork1 - number of free pages before allocation: %d, number of allocated pages: %d\n", fp, MAXPAGES - fp);
  for (i = 0; i < midway; i++){
    pointers[i] = (uint)sbrk(PGSIZE);
    * (char *) pointers[i] = (char) ('A' + i);
    printf(1,"added %c at index %d\n", *(char * )pointers[i], i);
  }
  fp = get_number_of_free_pages();
  printf(1, "before fork1 - number of free pages after allocation: %d, number of allocated pages: %d\n", fp, MAXPAGES - fp);
  pid = fork();
  if(pid == 0){
    fp = get_number_of_free_pages();
    printf(1, "after fork1, son - number of free pages: %d, number of allocated pages: %d\n", fp, MAXPAGES - fp);
    for (i = 0 ; i < midway ; i++){
      printf(1,"%c", *(char * )pointers[i]);
    }
    fp = get_number_of_free_pages();
    printf(1, "\nson - done printing, changing array-number of free pages: %d, number of allocated pages: %d\n", fp, MAXPAGES - fp);
    for (i = 0 ; i < changes ; i++){
      * (char *) pointers[i] = (char) ('a' + i);
    }
    fp = get_number_of_free_pages();
    printf(1, "son - number of free pages after change: %d, number of allocated pages: %d, printing new array:\n", fp, MAXPAGES - fp);
    for (i = 0 ; i < midway ; i++){
      printf(1,"%c", *(char * )pointers[i]);
    }
    printf(1, "\nson is done\n");
    exit();
  }
  wait();
  fp = get_number_of_free_pages();
  printf(1, "after fork1, father - number of free pages: %d, number of allocated pages: %d\n", fp, MAXPAGES - fp);
  for (i = 0 ; i < midway ; i++){
    printf(1,"%c", *(char * )pointers[i]);
  }
  printf(1, "\nfather is done\n");
  //print_array();
  for (i = midway; i < size; i++){
    pointers[i] = (uint)sbrk(PGSIZE);
    * (char *) pointers[i] = (char) ('A' + i);
    printf(1,"added %c at index %d\n", *(char * )pointers[i], i);
  }
  fp = get_number_of_free_pages();
  printf(1, "before fork2 - number of free pages after allocation: %d, number of allocated pages: %d\n", fp, MAXPAGES - fp);
  for (i = 0 ; i < size ; i++){
    printf(1,"%c", *(char * )pointers[i]);
  }
  a = (char * )pointers[0];
  printf(1, "before fork2 - put char %c in ram\n", a);
  pid = fork();
  //print_array();
  if(pid == 0){
    fp = get_number_of_free_pages();
    printf(1, "after fork1, son - number of free pages: %d, number of allocated pages: %d\n", fp, MAXPAGES - fp);
    for (i = 0 ; i < size ; i++){
      printf(1,"%c", *(char * )pointers[i]);
    }
    fp = get_number_of_free_pages();
    printf(1, "\nson - done printing, changing array-number of free pages: %d, number of allocated pages: %d\n", fp, MAXPAGES - fp);
    for (i = 0 ; i < changes ; i++){
      * (char *) pointers[i] = (char) ('a' + i);
    }
    fp = get_number_of_free_pages();
    printf(1, "son - number of free pages after change: %d, number of allocated pages: %d, printing new array:\n", fp, MAXPAGES - fp);
    for (i = 0 ; i < size ; i++){
      printf(1,"%c", *(char * )pointers[i]);
    }
    printf(1, "\nson is done\n");
    exit();
  }
  wait();
  fp = get_number_of_free_pages();
  printf(1, "after fork1, father - number of free pages: %d, number of allocated pages: %d\n", fp, MAXPAGES - fp);
  for (i = 0 ; i < size ; i++){
    printf(1,"%c", *(char * )pointers[i]);
  }
  printf(1, "\nfather is done\n");
}


int
main(int argc, char *argv[])
{
  test();
  // int i = 0;
  // const int PGSIZE = 4096;
  // const int MAXPAGES = 57334;
  // uint size = 21;
  // uint pointers[size];
  // int pid = 0;
  // int changes = 1;
  // int fp = get_number_of_free_pages();
  // printf(1, "before fork1 - number of free pages before allocation: %d, number of allocated pages: %d\n", fp, MAXPAGES - fp);
  // for (i = 0; i < size; i++){
  //   pointers[i] = (uint)sbrk(PGSIZE);
  //   * (char *) pointers[i] = (char) ('A' + i);
  // }
  // fp = get_number_of_free_pages();
  // printf(1, "before fork1 - number of free pages after allocation: %d, number of allocated pages: %d\n", fp, MAXPAGES - fp);
  // pid = fork();
  // if(pid == 0){
  //   fp = get_number_of_free_pages();
  //   printf(1, "after fork1, son - number of free pages: %d, number of allocated pages: %d\n", fp, MAXPAGES - fp);
  //   for (i = 0 ; i < size ; i++){
  //     printf(1,"%c", *(char * )pointers[i]);
  //   }
  //   printf(1, "\nson - done printing, going to change array\n");
  //   for (i = 0 ; i < changes ; i++){
  //     * (char *) pointers[i] = (char) ('a' + i);
  //   }
  //   fp = get_number_of_free_pages();
  //   printf(1, "son - number of free pages after change: %d, number of allocated pages: %d, printing new array:\n", fp, MAXPAGES - fp);
  //   for (i = 0 ; i < size ; i++){
  //     printf(1,"%c", *(char * )pointers[i]);
  //   }
  //   printf(1, "\nson is done\n");
  // }

  // if(pid != 0){
  //   wait();
  //   fp = get_number_of_free_pages();
  //   printf(1, "after fork1, father - number of free pages: %d, number of allocated pages: %d\n", fp, MAXPAGES - fp);
  //   for (i = 0 ; i < size ; i++){
  //     printf(1,"%c", *(char * )pointers[i]);
  //   }
  //   printf(1, "\nfather is done\n");
  // }
   exit();
}
