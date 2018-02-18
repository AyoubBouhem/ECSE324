			.text
			.global _start
_start:
			LDR 	R2,= NUMBER // load address of N into R2
			LDR 	R1, [R2]	//get value of N from address

			PUSH {LR}
			BL 		FIB
			//LDR 	LR, [SP],#4
			POP {LR}
			STR 	R5,[R2, #4]	//store R5 in Result
			B 		END

FIB:  		CMP 	R1,#2		//perform R1 (N) - 1, if N is greater than 1, 

			MOVLT 	R0,#1		//if R1 was less than 2, move 1 into R0

			BXLT 	LR			//and return to link register

			SUB 	R1,R1,#2	// sub 2 to get to N - 2

			PUSH {LR}
			BL 		FIB				//compute the left (n-2) side of the fib
			POP {LR}
			PUSH {R0}				//store intermediary value
			ADD 	R1, R1,#1		// add 1 to get to N-1
			PUSH {LR}
			BL 		FIB				//compute the right (n-1) side of the fib
			POP {LR}
			POP {R5}				//pop the existing fib number
			ADD 	R0,R0,R5		//add it to the fib number just calculated
			ADD 	R1,R1,#1		//go back up the tree
			BX 		LR

		

END:		B END
NUMBER:		.word 10
RESULT:		.word 0
			.end
