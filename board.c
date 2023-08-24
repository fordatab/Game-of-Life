#include "life.h"
#include "board.h"


/**
 * create a new board
 *
 * - malloc a boards structure
 * - set the generation to 0
 * - open the file (if it doesn't exist, return a NULL pointer
 * - read the first line which is the number of rows
 * - read the second line which is the number of cols
 * - set the # of rows and # of cols in the boards structure
 * - malloc bufferA and bufferB 
 * - Set currentBuffer and nextBuffer
 * - clear both board buffers
 * - read the file until done.  each row contains a row and a columns separted by
 *   white space
 *     for each line, set the cell in the current buffer
 * - close the file
 * - return the boards pointer if successfull or NULL ptr otherwise
 */
boards_t* createBoard(char *initFileName){
    boards_t *board = (boards_t*) malloc(sizeof(boards_t));
    if (board == NULL) {
        return NULL;
    }
    board->gen = 0;
    FILE* file;
    if ((file = fopen(initFileName, "r")) == NULL) {
        return NULL;
    }
    fscanf(file, "%d\n", &(board->numRows));
    fscanf(file, "%d\n", &(board->numCols));
    board->bufferA = (belem*) calloc((board->numCols) * (board->numRows), sizeof(belem));
    if (board->bufferA == NULL) {
        return NULL;
    }
    board->bufferB = (belem*) calloc((board->numCols) * (board->numRows), sizeof(belem));
    if (board->bufferB == NULL) {
        return NULL;
    }
    board->currentBuffer = board->bufferA;
    board->nextBuffer = board->bufferB;
    int row = 0;
    int col = 0;
    while(fscanf(file, "%d %d\n", &row, &col) > 0) {
        board->currentBuffer[getIndex(board->numCols, row, col)] = 1;
    }
    fclose(file);
    return board;
}

/**
 * delete a board
 */
void deleteBoard(boards_t **bptrPtr){
    free((*bptrPtr)->bufferA);
    free((*bptrPtr)->bufferB);
    free(*bptrPtr);
    *bptrPtr = NULL;
}

/**
 * set all the belems in both buffers to 0
 */
void clearBoards(boards_t *self){
    for (size_t x = 0; x < (self->numCols) * (self->numRows); x++) {
        self->bufferA[x] = 0;
        self->bufferB[x] = 0;
    }

}

/**
 * swap the current and next buffers
 */
void swapBuffers(boards_t *self){
    belem *temp = self->currentBuffer;
    self->currentBuffer = self->nextBuffer;
    self->nextBuffer = temp;
}


/**
 * get a cell index
 */
size_t getIndex(size_t numCols, size_t row, size_t col){
    return row * numCols + col;
}
