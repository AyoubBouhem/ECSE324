			.text
			.global _start

_start:
			//r13 IS SP USING AN ALIAS, IT IS ALREADY SET TO THE BOTTOM OF THE STACK
			// WE ONLY HAVE TO WORRY ABOUT THE NUMBER OF ELEM WE ADD (PUSH) AND THEN HAVE TO SUBTRACT (POP)
			MOV R0, #3    // R0 IS the number to be pushed 
PUSH_METHOD:	
			STR R0, [SP, #-4]! //COMPILES TO PUSH ANYWAY
			STR R0, [SP, #-4]! //PUSH THE NUMBER 3, 3 TIMES
			STR R0, [SP, #-4]! //

POP_METHOD:
			LDR R0, [SP], #4
			LDR R1, [SP], #4
			LDR R2, [SP], #4

END:		B END               // infinite loop!
