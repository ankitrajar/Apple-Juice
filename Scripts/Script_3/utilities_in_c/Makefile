obj-m += test_mem.o
all:
	make -C /lib/modules/2.6.32-38-generic/build M=$(PWD) modules
clean:
	make -C /lib/modules/2.6.32-38-generic/build M=$(PWD) clean