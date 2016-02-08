obj-m += ./hello_world.o
obj-m += ./mem_allocate.o
obj-m += ./ram_stresser.o

all:
	make -C /lib/modules/2.6.32-38-generic/build M=$(PWD) modules
clean:
	make -C /lib/modules/2.6.32-38-generic/build M=$(PWD) clean
