		.text
		.global _start

_start:		LDR R0, =N     // R0 points to N
			LDR R1, [R0]    // R1 holds the number of element in the list
			ADD R1,R1,#1	//TO MAKE THE LOOP EASIER
			ADD R2, R0, #4      // R2 points to the first number initially (index)
			LDR R3, [R2]        // R3 holds the first number in the array initially (value)
			MOV R4, #0			//R4 is our sorted boolean, 0 false, 1 true
			MOV R5, #2			//COUNTER FOR INNER LOOP, STARTS AT 2, GOES TO N
			B OUTER
			

OUTER:		CMP R4, #1
			BEQ END 		//THIS MEANS THAT R4 IS 1, SO END LOOP
			MOV R4,#1		//SET R4 (SORTED) TO 1, TRUE

			ADD R2, R0, #4      // RESET R2 points to the first number initially (index)
			LDR R3, [R2]        // RESET R3 holds the first number in the array initially (value)
			MOV R5, #2			//RESET COUNTER FOR INNER LOOP, STARTS AT 2, GOES TO N

			B INNER

INNER:		CMP R5, R1		//R5 IS INNER INDEX (i), R1 IS N
			BEQ OUTER		//WHEN i IS N, GO TO OUTER
			ADD R5,R5,#1	//INCREMENT INNER LOOP COUNTER
			ADD R2,R2,#4	//ADVANCE R2 TO THE NEXT NUMBER
			MOV R6, R2		//R6 POINTER TO A i
			SUB R7, R6,#4	//R7 POINTER TO A i-1 (aka r2 -4 to get to previous elem)
			LDR R8, [R6]	//R8 value at Ai
			LDR R9, [R7]	//R9 valuE at Ai-1
			CMP R8,R9		//IF A[i] < A[i-1], SWAP
			BLE SWAP		// SWAP
			B INNER			// ELSE GO AROUND AGAIN
			
SWAP:		MOV R4, #0		//SET SORTED FALSE, 0
			STR R8, [R7]
			STR R9,	[R6]		//R9 IS VALUE OF Ai-1 
			
			B INNER			//AFTER SWAP GO Back to inner

END:		B END               // infinite loop!

N:		.word	8           // number of samples in the list, must be power of 2
ARRAY:	.word	4, 5, 3, 6  // list of signal samples, must be multiple of 2 of them
        .word	1, 8, 2, 1
