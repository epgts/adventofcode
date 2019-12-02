all: intcode.exe

day2.c: input/day2 GNUmakefile
	perl -lpe 'BEGIN { print "static int _DAY2[] = {" } s/$$/,/; END { print "};const int* const DAY2 = _DAY2; const int DAY2_LEN = sizeof _DAY2 / sizeof *_DAY2;" }' input/day2 > $@.tmp \
		&& mv -f $@.tmp $@

day2.h: GNUmakefile
	echo 'int *DAY2; int DAY2_LEN;' > $@

CC=	x86_64-w64-mingw32-gcc.exe
CFLAGS=	-O3 -Wall
day2.o: day2.c
intcode.o: intcode.c day2.h GNUmakefile
intcode.exe: intcode.o day2.o GNUmakefile
	${CC} -o $@ intcode.o day2.o

clean:
	rm -f day2.c day2.h day2.o intcode.o intcode.exe
.PHONY: all clean
