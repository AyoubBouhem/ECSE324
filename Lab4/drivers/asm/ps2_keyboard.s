	.text

	.global read_PS2_data_ASM
	.equ PS2_Data, 0xFF200100
	.equ PS2_Control, 0xFF200104

//checks rvalid buit in ps2 data register
//if valid, then data from the same register should be stored at the address in the char pointer arg
//subroutine returns 1 to denote valid data
//rvalid bit not set then just return 0
read_PS2_data_ASM:
	//ro is char pointer
	lDR R3, =PS2_Data
	LDR R4, [R3]
	MOV R1, #0x8000	//16th bit
	MOV R5, #0xFF	//last byte
	AND R2, R4, R1 	//r2 will be positive if rvalid is set to 1
	CMP R2, #0
	BEQ INVALID
	//read data
	AND R6, R4, R5	//and data with FF to get last 8 bits
	STRB R6, [R0]	//store data at char pointer
	
	MOV R0, #1	//return 1 to denote valid data
	BX LR
INVALID:
	MOV R0, #0	//return 0
	BX LR

	.end
