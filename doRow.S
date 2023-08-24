    .arch armv7
    .cpu cortex-a53
    .equ 	NUL, 0

    .global asm_doRow
	.syntax unified

	// Set offsets for incoming parameters 5 and 6
	.equ	IARG6, 8
	.equ    IARG5, 4

    // !!! SET FP_OFFSET TO THE NUMBER OF (SAVED REGISTERS -1 * 4)
    .equ 	FP_OFFSET, 32	// (# of saved regs - 1) * 4

	// Add any local variables used


	// asm_doRow(belem *dest,    // r0
	//           belem *src,     // r1
	//           size_t curRow,  // r2
	//           size_t nRows,   // r3
	//           size_t nCols,   // fp + 4
	//	     int *newLife)   // fp + 8


asm_doRow:
    // ALLOCATED REGISTERS
    // r4 indexing outer loop
    // r5 int s; counter of number of neighbors
    // r6 inner loop #1 iterator
    // r7 inner loop #2 iterator
    // r8 temporary register usage
    // r9 the value at the current cell
    // r10 temporary register usage
	push {r4-r10, fp, lr} 	//TODO: Push any preserved registers
	add fp, sp, #FP_OFFSET
	sub sp, sp, #0

	push {r0-r3}           // Push r0, r1 to preserve registers
	mov r0, r3            // Load nRows into r0
	ldr r1, [fp, IARG5]    // Load nCols into r1
	bl  setNRowsNCols         // Call setNrowNcol
	pop {r0-r3}            // Pop r0, r1

	ldr r4, [fp, IARG5]    // Load nCols into r4
	sub r4, r4, #1          // Subtract nCols by 1

    // Outer loop                                                   // for (size_t x = 0; x < cols; x++) {
    .Lforouter:             // For branch

    push {r0-r3}           // Push r0, r1 to preserve register     // int s = 0 - src[getIndex(cols, row, x)];
    mov r0, r2            // Load curRow into r0
    mov r1, r4              // Copy r4 to r1
    bl nGetIndexRC          // Call nGetIndexRC
    mov r6, r0              // Store index temporarily
    pop {r0-r3}            // Pop r0, r1
    ldrb r9, [r1, r6]       // Set r9 to the value at index
    mov r10, #0             // Set r10 to zero temporarily
    sub r5, r10, r9         // Subtract r5 by 0


    // Inner Block
    push {r0-r3}           // Push r0, r1 to preserve registers    // s += src[getIndex(cols, getModVal(row+z, rows), getModVal(x+y, cols))];
    mov r0, r2           // Load curRow into r0
    add r0, r0, #-1          // Add curRow to offset (z)
    add r1, r4, #-1          // Set r1 to r4 (x) + r5 (y)
    bl nGetIndexRC          // Call nGetIndexRC
    mov r8, r0              // Store index temporariliy
    pop {r0-r3}            // Pop r0, r1
    ldrb r8, [r1, r8]       // Load value of src[r8] into r8
    add r5, r5, r8          // Add value to counter r5

    push {r0-r3}           // Push r0, r1 to preserve registers    // s += src[getIndex(cols, getModVal(row+z, rows), getModVal(x+y, cols))];
    mov r0, r2           // Load curRow into r0
    add r0, r0, #0          // Add curRow to offset (z)
    add r1, r4, #-1          // Set r1 to r4 (x) + r5 (y)
    bl nGetIndexRC          // Call nGetIndexRC
    mov r8, r0              // Store index temporariliy
    pop {r0-r3}            // Pop r0, r1
    ldrb r8, [r1, r8]       // Load value of src[r8] into r8
    add r5, r5, r8          // Add value to counter r5

    push {r0-r3}           // Push r0, r1 to preserve registers    // s += src[getIndex(cols, getModVal(row+z, rows), getModVal(x+y, cols))];
    mov r0, r2           // Load curRow into r0
    add r0, r0, #1          // Add curRow to offset (z)
    add r1, r4, #-1          // Set r1 to r4 (x) + r5 (y)
    bl nGetIndexRC          // Call nGetIndexRC
    mov r8, r0              // Store index temporariliy
    pop {r0-r3}            // Pop r0, r1
    ldrb r8, [r1, r8]       // Load value of src[r8] into r8
    add r5, r5, r8          // Add value to counter r5

    push {r0-r3}           // Push r0, r1 to preserve registers    // s += src[getIndex(cols, getModVal(row+z, rows), getModVal(x+y, cols))];
    mov r0, r2           // Load curRow into r0
    add r0, r0, #-1          // Add curRow to offset (z)
    add r1, r4, #0          // Set r1 to r4 (x) + r5 (y)
    bl nGetIndexRC          // Call nGetIndexRC
    mov r8, r0              // Store index temporariliy
    pop {r0-r3}            // Pop r0, r1
    ldrb r8, [r1, r8]       // Load value of src[r8] into r8
    add r5, r5, r8          // Add value to counter r5

    push {r0-r3}           // Push r0, r1 to preserve registers    // s += src[getIndex(cols, getModVal(row+z, rows), getModVal(x+y, cols))];
    mov r0, r2           // Load curRow into r0
    add r0, r0, #0          // Add curRow to offset (z)
    add r1, r4, #0          // Set r1 to r4 (x) + r5 (y)
    bl nGetIndexRC          // Call nGetIndexRC
    mov r8, r0              // Store index temporariliy
    pop {r0-r3}            // Pop r0, r1
    ldrb r8, [r1, r8]       // Load value of src[r8] into r8
    add r5, r5, r8          // Add value to counter r5

    push {r0-r3}           // Push r0, r1 to preserve registers    // s += src[getIndex(cols, getModVal(row+z, rows), getModVal(x+y, cols))];
    mov r0, r2           // Load curRow into r0
    add r0, r0, #1          // Add curRow to offset (z)
    add r1, r4, #0          // Set r1 to r4 (x) + r5 (y)
    bl nGetIndexRC          // Call nGetIndexRC
    mov r8, r0              // Store index temporariliy
    pop {r0-r3}            // Pop r0, r1
    ldrb r8, [r1, r8]       // Load value of src[r8] into r8
    add r5, r5, r8          // Add value to counter r5

    push {r0-r3}           // Push r0, r1 to preserve registers    // s += src[getIndex(cols, getModVal(row+z, rows), getModVal(x+y, cols))];
    mov r0, r2           // Load curRow into r0
    add r0, r0, #-1          // Add curRow to offset (z)
    add r1, r4, #1          // Set r1 to r4 (x) + r5 (y)
    bl nGetIndexRC          // Call nGetIndexRC
    mov r8, r0              // Store index temporariliy
    pop {r0-r3}            // Pop r0, r1
    ldrb r8, [r1, r8]       // Load value of src[r8] into r8
    add r5, r5, r8          // Add value to counter r5

    push {r0-r3}           // Push r0, r1 to preserve registers    // s += src[getIndex(cols, getModVal(row+z, rows), getModVal(x+y, cols))];
    mov r0, r2           // Load curRow into r0
    add r0, r0, #0          // Add curRow to offset (z)
    add r1, r4, #1          // Set r1 to r4 (x) + r5 (y)
    bl nGetIndexRC          // Call nGetIndexRC
    mov r8, r0              // Store index temporariliy
    pop {r0-r3}            // Pop r0, r1
    ldrb r8, [r1, r8]       // Load value of src[r8] into r8
    add r5, r5, r8          // Add value to counter r5

    push {r0-r3}           // Push r0, r1 to preserve registers    // s += src[getIndex(cols, getModVal(row+z, rows), getModVal(x+y, cols))];
    mov r0, r2           // Load curRow into r0
    add r0, r0, #1          // Add curRow to offset (z)
    add r1, r4, #1          // Set r1 to r4 (x) + r5 (y)
    bl nGetIndexRC          // Call nGetIndexRC
    mov r8, r0              // Store index temporariliy
    pop {r0-r3}            // Pop r0, r1
    ldrb r8, [r1, r8]       // Load value of src[r8] into r8
    add r5, r5, r8          // Add value to counter r5



    push {r0-r3}           // Push r0, r1 to preserve registers    // dest[getIndex(cols, row, x)] = 0;
    mov r0, r2            // Load curRow into r0
    mov r1, r4              // Set r1 to r4 (x)
    bl nGetIndexRC          // Call nGetIndexRC
    mov r8, r0              // Store index temporarily
    pop {r0-r3}            // Pop r0, r1
    mov r10, #0             // Set r10 to #0 temporaraliy
    strb r10, [r0, r8]      // Set index to 0

    cmp r5, #3              // If r5 is three, it is alive
    beq .Lyes               // Branch alive
    cmp r5, #2              // If r5 is not 2, it is dead
    bne .Lno                // Branch dead
    cmp r9, #1              // r9 (current cell) also needs to be alive
    bne .Lno                // Branch dead

    .Lyes:                  // True
    push {r0-r3}           // Push r0, r1 to preserve registers    // dest[getIndex(cols, row, x)] = 1;
    mov r0, r2            // Load curRow into r0
    mov r1, r4              // Set r1 to r4 (x)
    bl nGetIndexRC          // Call nGetIndexRC
    mov r8, r0              // Store index temporarily
    pop {r0-r3}            // Pop r0, r1
    mov r10, #1             // Set r10 to #1 temporaraliy
    strb r10, [r0, r8]      // Set index to 0
    cmp r9, #0
    bne .Lno
    ldr r8, [fp, IARG6]
    ldr r10, [r8]
    add r10, r10, #1
    str r10, [r8]

    .Lno:                   // False

    // Loop conditionals
    sub r4, r4, #1          // Decrement index
    cmp r4, #0
    bge .Lforouter
    .Lendfr:

	sub sp, fp, #FP_OFFSET
	pop {r4-r10, fp, lr} //TODO: Pop preserved registers
	bx lr