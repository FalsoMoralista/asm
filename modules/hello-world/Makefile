obj-m += hello.o

KDIR = /usr/src/linux-headers-4.19.0-6-amd64

all:
	$(MAKE) -C $(KDIR) SUBDIRS=$(PWD) modules

clean:
	rm -rf *.o *.ko *.mod.* *.symvers *.order
