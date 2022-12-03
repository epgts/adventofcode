.PHONY: all test clean

.SUFFIXES: .com.dbg .com

CC=		gcc

# ln o/tiny/cosmopolitan.a o/cosmopolitan.h o/tiny/libc/crt/crt.o o/tiny/ape/ape-no-modify-self.o o/tiny/ape/public/ape.lds dist
COSMO=		.o/cosmo
COSMO_CC=	${CC} -g -Os -static -nostdlib -nostdinc -fno-pie -no-pie -mno-red-zone -fno-omit-frame-pointer -pg -mnop-mcount -mno-tls-direct-seg-refs -gdwarf-4 -fuse-ld=bfd -Wl,-T,${COSMO}/ape.lds -Wl,--gc-sections -include ${COSMO}/cosmopolitan.h ${COSMO}/crt.o ${COSMO}/ape-no-modify-self.o ${COSMO}/cosmopolitan.a

SELF=	Makefile

all: elftool.com

test: all
	prove -r t

elftool.com.dbg: ${SELF}

%.com.dbg: %.c
	gcc -g -Os -static -nostdlib -nostdinc -fno-pie -no-pie -mno-red-zone -fno-omit-frame-pointer -pg -mnop-mcount -mno-tls-direct-seg-refs -gdwarf-4 -o $@ $< -fuse-ld=bfd -Wl,-T,${COSMO}/ape.lds -Wl,--gc-sections -include ${COSMO}/cosmopolitan.h ${COSMO}/crt.o ${COSMO}/ape-no-modify-self.o ${COSMO}/cosmopolitan.a

%.com: %.com.dbg
	objcopy -S -O binary $< $@
