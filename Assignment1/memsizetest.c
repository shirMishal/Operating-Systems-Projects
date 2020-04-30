#include "types.h"
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
 	// Print how much memory the process is using.
	printf(1,"%s %d%s\n", "The process is using:", memsize(), "B");
 	// Allocate more memory by using malloc (array containing 20 KB).
	printf(1,"%s\n", "Allocating more memory");
	char *str;
    str = (char *) malloc(2000);
 	// Print how much memory the process using now after the allocation.
    printf(1,"%s %d%s\n", "The process is using:", memsize(), "B");
 	// Free the array that was allocated in 2.
	printf(1,"%s\n", "Freeing memory");
	free(str);
 	// Print how much memory the process is using.
    printf(1,"%s %d%s\n", "The process is using:", memsize(), "B");
  	exit(0);
}
