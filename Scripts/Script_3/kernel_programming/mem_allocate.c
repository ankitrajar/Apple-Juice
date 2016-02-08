#include <linux/module.h>

#include <linux/kernel.h>

#include <linux/vmalloc.h>

#include <linux/slab.h>

 

MODULE_LICENSE("GPL");

MODULE_DESCRIPTION("hello");

MODULE_AUTHOR("Parmil Kumar");

 

struct Person {

    char name[30];

    unsigned int weight;

    unsigned char gender;

    struct list_head list; /* kernel's list structure */

};

 

struct Person personList;

 

int init_module() {

    struct Person *aNewPerson, *aPerson;

 

    printk(KERN_INFO "initialize kernel module: test_mem\n");

    INIT_LIST_HEAD(&personList.list);    //or LIST_HEAD(mylist); 

 

    printk(KERN_INFO "allocate memory using kmalloc with GFP_KERNEL for first node\n");

    aNewPerson = kmalloc(sizeof(*aNewPerson), GFP_KERNEL);

    strcpy(aNewPerson->name, "roman1");

    aNewPerson->weight = 130;

    aNewPerson->gender = 1;

    INIT_LIST_HEAD(&aNewPerson->list);

    list_add_tail(&(aNewPerson->list), &(personList.list));

    

    printk(KERN_INFO "allocate memory using kmalloc with GFP_ATOMIC for 2nd node\n");

    aNewPerson = kmalloc(sizeof(*aNewPerson), GFP_ATOMIC);

    strcpy(aNewPerson->name, "roman2");

    aNewPerson->weight = 130*2;

    aNewPerson->gender = 1;

    INIT_LIST_HEAD(&aNewPerson->list);

    list_add_tail(&(aNewPerson->list), &(personList.list)); 

 

        printk(KERN_INFO "allocate memory using vmalloc for 3rd node\n");

    aNewPerson = vmalloc(sizeof(*aNewPerson));

    strcpy(aNewPerson->name, "roman3");

    aNewPerson->weight = 130*3;

    aNewPerson->gender = 1;

    INIT_LIST_HEAD(&aNewPerson->list);

    list_add_tail(&(aNewPerson->list), &(personList.list));    

    

    printk(KERN_INFO "traversing the list using list_for_each_entry()\n");

    list_for_each_entry(aPerson, &personList.list, list) {

        //access the member from aPerson

        printk(KERN_INFO "Person: %s; weight: %d; gender: %s\n", aPerson->name, aPerson->weight, aPerson->gender==0?"Female":"Male");

    }

    printk(KERN_INFO "\n");

 

    return 0;

}

 

void cleanup_module() {

    struct Person *aPerson;

    printk(KERN_INFO "kernel module unloaded: test_mem\n");

    aPerson = list_first_entry(&personList.list, struct Person, list);

    printk(KERN_INFO "freeing node %s\n", aPerson->name);

    list_del(&aPerson->list);

    kfree(aPerson);

    aPerson = list_first_entry(&personList.list, struct Person, list);

    printk(KERN_INFO "freeing node %s\n", aPerson->name);

    list_del(&aPerson->list);

    kfree(aPerson);

    aPerson = list_first_entry(&personList.list, struct Person, list);

    printk(KERN_INFO "freeing node %s\n", aPerson->name);

    list_del(&aPerson->list);

    vfree(aPerson);

}