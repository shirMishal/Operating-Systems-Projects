
#include "types.h"
#include "stat.h"
#include "user.h"


int main(int argc, char** argv){
    if (argc < 2){
        exit(1);
    }
    int policy_type = atoi(argv[1]);
    int result = policy(policy_type);
    if (result < 0){
        printf(1, "Error replacing policy, no such a policy number (%d)", policy_type);
        exit(1);
    }
    char* policy_name = "";
    switch (policy_type){
        case 0:
            policy_name = "Default Policy";
            break;
        case 1:
            policy_name = "Priority Policy";
            break;
        case 2:
            policy_name = "CFS Policy";
            break;
    }
    printf(1, "Policy has been successfully changed to %s\n", policy_name);
    exit(0);

    return 0;
}