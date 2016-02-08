#include <linux/module.h>

#include <linux/kernel.h>

#include <linux/vmalloc.h>

#include <linux/slab.h>

#include <linux/string.h>

#include <linux/delay.h>
#define BIGNUMBER 600000
#define COUNTER 100000
#define START 1
MODULE_LICENSE("GPL");

MODULE_DESCRIPTION("Trying to increase ram used by kernel space.");

MODULE_AUTHOR("Parmil Kumar");

int * bigchunk;

int init_module() {

    printk(KERN_INFO "initialize kernel module: test_mem\n");

    printk(KERN_INFO "allocate memory using kmalloc with GFP_KERNEL for first node\n");
    printk(KERN_INFO "Allocating %d bytes of memory",BIGNUMBER);
    bigchunk = kzalloc(BIGNUMBER, GFP_ATOMIC);
    int i;
    i=START;
    while(i<COUNTER)
	{
    memset(bigchunk,0,BIGNUMBER);
	mdelay(100);
    i++;
	}
    printk(KERN_INFO "\n");
    return 0;

}

 

void cleanup_module() {


    printk(KERN_INFO "Freeing bigchunk");

    kfree(bigchunk);

}
