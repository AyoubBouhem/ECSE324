			.text
			.global _start
_start:
			LDR R4, =RESULT     // R4 points to the result location
			LDR R2, [R4, #4]    // R2 holds the number of element in the list, N
			ADD R3, R4, #8      // R3 points to the first number initially (index)
			LDR R0, [R3]        // R0 holds the first number in the list initially (value)


SUM:		SUBS R2, R2, #1     // decrement the loop counter
			BEQ AVG             // end loop if counter has reached 0
			ADD R3, R3, #4      // R3 points to next number in the list (index)
			LDR R1, [R3]        // R1 holds the next number in the list (value)
			ADD R0, R0,R1          // add r1 to the total_sum register, r0
			B SUM				// branch back to the loop

//alternatively divide both by two until num elements is  = 1 (this way probably works better)
AVG:		LDR R6,[R4, #4] //N NUM OF NUMBERS
AVGLOOP:	LSR R6,R6,#1	//DIVIDE n BY 2
			LSR R0,R0,#1	//R0 IS TOTAL SUM
			CMP R6,#1
			BEQ RST			//R0 IS NOW AVERAGE
			B AVGLOOP

//LDR R2, back to N
//reset index (R3) and elem (R1)
RST:		LDR R2, [R4, #4]    // R2 holds the number of element in the list, N
			ADD R2,R2,#1
			ADD R3, R4, #8      // R3 points to the first number initially (index)
			LDR R5, [R3]        // R5 holds the first number in the list initially (value)

//subtract average (r5) from every element
SUBTRLOOP:	SUBS R2,R2,#1		//decrement the loop counter, SUBS updates comparison flags too
			BEQ END
			SUB R7,R5,R0	// R7 points to the number, subtract the contents of r0 (AVG) from the contents of r5 (CURRENT NUM)
			STR R7, [R3]
			ADD R3, R3, #4      // R3 points to next number in the list (index)
			LDR R5, [R3]        // R1 holds the next number in the list (value)
			B SUBTRLOOP			// branch back to loop

END:		B END               // infinite loop!

RESULT:		.word	0           // __not sure this is needed___ memory assigned for the result location
N:			.word	8           // number of samples in the list, must be power of 2
NUMBERS:	.word	4, 5, 3, 6  // list of signal samples, must be multiple of 2 of them
            .word	1, 9, 2, 3
