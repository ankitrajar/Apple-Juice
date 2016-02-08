#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/vmalloc.h>
#include <linux/slab.h>
// It have the kmalloc function.
#include <unistd.h>

int main(int argc, char** argv)
{
	int kernelspace_flag;
	int sleep_time;
	printf("Welcome to RAM Stresser!!!\n");
	printf("Usage:ram_stresser <kernelspace_flag.Optional.Default:0> <chunk_size in mb(optional.Default:20mb)> <sleep_time(optional. Default:10sec)>\n");
	printf("     If kernelspace_flag is not passed as 1 then target is userspace.");
    unsigned long mem;
    
    if(argc==1) {
        mem = 1024*1024*20; //20 mb
    	kernelspace_flag = 0;
    	sleep_time=20; }
    else if(argc==2) {
        mem = 1024*1024*20; //20 mb
    	kernelspace_flag = (unsigned) atoi(argv[1]);
    	sleep_time=20; }
    else if(argc==3) {
    	kernelspace_flag = (unsigned) atoi(argv[1]);
        mem = 1024*1024* (unsigned) atol(argv[2]);
    	sleep_time=20; }
    else if(argc==4) {
    	kernelspace_flag = (unsigned) atoi(argv[1]);
        mem = 1024*1024* (unsigned) atol(argv[2]);
    	sleep_time = (unsigned) atoi(argv[3]); }
    else
    {
        printf("Usage:ram_stresser <kernelspace_flag> <chunk_size in mb(optional.Default:20mb)>\n Please refer Usage.\n Exiting...");
        exit(1);
    }
    printf("Proceeding to Stress Testing.\n");
    printf("Parameters Used.\n");
    printf("kernelspace_flag:%u\n chunk_size:%lu mb \n Sleep for:%u sec\n",kernelspace_flag,mem,sleep_time);
    char* ptr = malloc(mem);
    while(1)
    {
        memset(ptr, 0, mem);
        #ifdef UNIX
            sleep(sleep_time);
        #else
            sleep(sleep_time*1000);
        #endif
    }
}