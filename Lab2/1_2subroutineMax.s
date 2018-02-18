			.text
			.global _start

_start:
			LDR R0, =ARRAY		// R0 points to ARRAY
			LDR R1, N    		// R1 holds the number of elements in the list
			PUSH {R0, R1, LR}	// Push parameters and LR (link register)
			BL loopMaxVal		// call subroutine
			LDR R0, [SP, #4]	//get return value from stack
			STR R0, MAXVAL		//store result in memory
			LDR LR, [SP, #8]	//restore LR
			ADD SP, SP, #12		//remove params from stack

stop:		B stop				//infinite loop

loopMaxVal: PUSH {R0-R3}		// callee-save the registers on the stack to restore later
			LDR R1, [SP, #20]	//load N from the stack (5th elem fom top)
			LDR R2, [SP, #16]	//load ARRAY from stack (4th elem)
			MOV R0, #0			//clear r0

LOOP:		LDR R3, [R2], #4	// get next value from array
			CMP R0, R3 			// performs r0-r3, check if greater than the max
			BGE DECRLP          // if r0>=r3, branch back to loop
			MOV R0, R3          // if r3>r0, update the current max
DECRLP:		SUBS R1, R1, #1     // decrement N, the loop counter
			BGT LOOP            // loop if counter has not reached 0
			STR R0, [SP, #20]	//store max on stack, replacing N
			POP {R0-R3}			//restore the registers
			BX LR

ARRAY:		.word	4, 5, 3, 6,	1, 8, 2
N:			.word	7           // number of entries in the list
MAXVAL:		.word	0           // memory assigned for the result location
