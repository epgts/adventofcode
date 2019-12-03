all: intcode.exe noop.exe

day2.c: input/day2 GNUmakefile
	(echo 'static int _DAY2[] = {'						\
	 && cat input/day2							\
	 && echo '};'								\
	 && echo 'int *DAY2 = _DAY2;'				\
	 && echo 'int DAY2_LEN = sizeof _DAY2 / sizeof *_DAY2;'		\
	)> $@.tmp								\
	&& mv -f $@.tmp $@

day2.h: GNUmakefile
	echo 'const int *const DAY2; const int DAY2_LEN;' > $@

# 113 - 119 ms
CC=	x86_64-w64-mingw32-gcc.exe
# 102 - 118 ms
CC=	gcc
CFLAGS=	-O3 -Wall
day2.o: day2.c

intcode.o: intcode.c day2.h GNUmakefile
intcode.exe: intcode.o day2.o GNUmakefile
	${CC} -o $@ intcode.o day2.o

noop.exe: noop.c
	${CC} -o $@ noop.c

test: all
	prove -r t

clean:
	rm -f day2.c day2.h day2.o intcode.o intcode.exe noop.exe
.PHONY: all test clean
