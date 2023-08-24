#include "sim.h"

#define CIMP
extern void asm_doRow(belem *, belem *, size_t, size_t, size_t);

/**
 * gets x mod N (works for negative numbers as well! Use this instead of %)
 */
size_t getModVal(int x, size_t N){
     size_t adj = x/N;

     return((x+adj*N)%N);

}

/**
 * process one row of the board
 */
static void doRow(belem *dest, belem *src, size_t row, size_t rows, size_t cols){
    for (size_t x = 0; x < cols; x++) {
        int s = 0 - src[getIndex(cols, row, x)];
        for (int y = -1; y < 2; y++) {
            for (int z = -1; z < 2; z++) {
                s += src[getIndex(cols, getModVal(row+z, rows), getModVal(x+y, cols))];
            }
        }
        dest[getIndex(cols, row, x)] = 0;
        if (s == 3 || (s == 2 && src[getIndex(cols, row, x)] == 1)) {
            dest[getIndex(cols, row, x)] = 1;
        }
    }	
}


/**
 * perform a simulation for "steps" generations
 *
 * for steps
 *   calculate the next board
 *   swap current and next
 */
void simLoop(boards_t *self, unsigned int steps){
    for (size_t x = 0; x < steps; x++) {
        for (size_t y = 0; y < self->numRows; y++) {
            doRow(self->nextBuffer, self->currentBuffer, y, self->numRows, self->numCols);
        }
        swapBuffers(self);
    }
   self->gen += steps;
}

















