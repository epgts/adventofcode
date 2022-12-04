.DELETE_ON_ERROR:
.PHONY: all test clean
.SUFFIXES: .com.dbg .com

CC=		gcc

OBJDIR=		.o
# ln o/tiny/cosmopolitan.a o/cosmopolitan.h o/tiny/libc/crt/crt.o o/tiny/ape/ape-no-modify-self.o o/tiny/ape/public/ape.lds dist
COSMO=		${OBJDIR}/cosmo

# TODO Split this up between compile and link.  I thought I knew what was what
# but was surprised to find some must be used in BOTH!
COSMO_CC=	${CC} -c -g -Os -nostdinc -fno-pie -no-pie -mno-red-zone -fno-omit-frame-pointer -pg -mnop-mcount -mno-tls-direct-seg-refs -gdwarf-4 -include ${COSMO}/cosmopolitan.h
COSMO_LD=	sh -c '${CC} -g -Os -static -nostdlib -fno-pie -no-pie -mno-red-zone -fno-omit-frame-pointer -pg -mnop-mcount -mno-tls-direct-seg-refs -gdwarf-4 "$$@" -fuse-ld=bfd -Wl,-T,${COSMO}/ape.lds -Wl,--gc-sections ${COSMO}/crt.o ${COSMO}/ape-no-modify-self.o ${COSMO}/cosmopolitan.a' argv0

SELF=	GNUmakefile

all: ${OBJDIR}/elftool.com ${OBJDIR}/rps.com

test: all
	OBJDIR=${OBJDIR} prove -r t

ELFTOOL_OBJ=	${OBJDIR}/elftool.o ${OBJDIR}/io.o
${OBJDIR}/elftool.com.dbg: ${ELFTOOL_OBJ}
	${COSMO_LD} -o ${OBJDIR}/elftool.com.dbg ${ELFTOOL_OBJ}

RPS_OBJ=	${OBJDIR}/rps.o ${OBJDIR}/io.o
${OBJDIR}/rps.com.dbg: ${RPS_OBJ}
	${COSMO_LD} -o ${OBJDIR}/rps.com.dbg ${RPS_OBJ}

${OBJDIR}/elftool.o: io.h
${OBJDIR}/rps.o: io.h

${OBJDIR}/%.o: %.c ${SELF}
	${COSMO_CC} -o $@ $<

${OBJDIR}/%.com: ${OBJDIR}/%.com.dbg
	objcopy -S -O binary $< $@
