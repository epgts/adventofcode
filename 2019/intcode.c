#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "day2.h"

/* Add together numbers read from two positions and stores the result in a third */
/* position.  The three integers immediately after the opcode tell you these three */
/* positions - the first two indicate the positions from which you should read the */
/* input values, and the third indicates the position at which the output should be */
/* stored. */
static int
add(int* buf, int index)
{
     int addr1 = buf[index++];
     int addr2 = buf[index++];
     int result_addr = buf[index++];
     buf[result_addr] = buf[addr1] + buf[addr2];
     return index;
}

/* Opcode 2 works exactly like opcode 1, except it multiplies the two inputs */
/* instead of adding them.  Again, the three integers after the opcode indicate */
/* where the inputs and outputs are, not their values. */
static int
mult(int* buf, int index)
{
     int addr1 = buf[index++];
     int addr2 = buf[index++];
     int result_addr = buf[index++];
     buf[result_addr] = buf[addr1] * buf[addr2];
     return index;
}

/* Halt execution by returning -1. */
static int
halt(int* _, int _i)
{
     return -1;
}

typedef int (*instruction_t)(int*, int);
instruction_t opcodes[100] = {
     NULL,
     &add,
     &mult,
};

static void
interpret(int *buf, size_t len)
{
     for (int index = 0; index < len && index >= 0;) {
          index = opcodes[buf[index]](buf, index + 1);
     }
}

static int
fix1201(int *buf, size_t len)
{
     buf[1] = 12;
     buf[2] = 2;
     interpret(buf, len);
     return buf[0];
}

static int
fix1201_find(const int *const input, size_t len)
{
     if (input[0] == 19690720) {
          return 100 * input[1] + input[2];
     }
     // we don't care to free this
     int *buf = malloc(len * sizeof *buf);
     for (int noun = 0; noun <= 99; noun++) {
          for (int verb = 0; verb <= 99; verb++) {
               memcpy(buf, input, len * sizeof *buf);
               buf[1] = noun;
               buf[2] = verb;
               interpret(buf, len);
               if (buf[0] == 19690720) {
                    return 100 * noun + verb;
               }
          }
     }
     return -1;
}

int
main(int argc, char **argv)
{
     opcodes[99] = &halt;
     if (0) {
          printf("%d\n", fix1201(DAY2, DAY2_LEN));
     } else {
          printf("%d\n", fix1201_find(DAY2, DAY2_LEN));
     }
     return 0;
}
