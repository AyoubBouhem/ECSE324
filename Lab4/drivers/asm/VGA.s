	.text

	.equ PIXEL_BUFF, 0xC8000000
	.equ CHAR_BUFF, 0xC9000000

	.equ H_PIXEL_RESOL, 320
	.equ V_PIXEL_RESOL, 240
	.equ H_CHARACTER_RESOL, 80
	.equ V_CHARACTER_RESOL, 60

	X .req R0
	Y .req R1
	C .req R2
	BASE .req R5
	OFST .req R6

	.global VGA_clear_charbuff_ASM
	.global VGA_clear_pixelbuff_ASM
	
	.global VGA_write_char_ASM //parameters x, y, char c
	.global VGA_write_byte_ASM //parameters x, y, char byte

	.global VGA_draw_point_ASM //parameters x, y, short colour

VGA_clear_charbuff_ASM:
	//loop through x 0-79 and y 0-59
		//add ADDRESS = CHAR_BUFF + x + y
		//set val at address = 0
	PUSH {R0-R10,LR}
	LDR BASE, =CHAR_BUFF
	MOV R2, #-1	//R2 is x
	MOV R3, #0	//R3 is y
	MOV R4, #0	//r4 is final character address
	MOV R7, #0	//holds 0

xCLoop:
	ADD R2, R2, #1	//add one to x
	CMP R2, #80 // x<=79
	BEQ outCX
	MOV R3, #0
yCLoop:	
	CMP R3, #60 //y<=59
	BEQ xCLoop
	//do things
	LSL OFST, R3, #7		//shift y left by 7bits to make room for x
	ORR OFST, OFST, R2
	ADD R4, BASE, OFST	//add offset to address

	STRB R7, [R4]		//store 0 at the address

	ADD R3, R3, #1 //y++
	B yCLoop
outCX:
	POP {R0-R10,LR}
	BX LR



VGA_clear_pixelbuff_ASM:
	//loop through x 0-319 and y 0-239
		//add ADDRESS = CHAR_BUFF + x + y +0
		//set val at address = 0
	PUSH {R0-R10,LR}
	LDR BASE, =PIXEL_BUFF	//R1 is base addres char buff
	MOV R2, #-1				//R2 is x
	MOV R3, #0				//R3 is y
	MOV R4, #0				//r4 is final character address
	MOV R9, #0				//holds 0

	LDR R7, =H_PIXEL_RESOL

xPLoop:
	ADD R2, R2, #1	//add one to x
	CMP R2, R7 // x<=319
	BEQ outPX
	MOV R3, #0
yPLoop:	
	CMP R3, #240 //y<=239
	BEQ xPLoop
	
	LSL OFST, R3, #10	//shift y left by 10bits to make room for x
	LSL R8, R2, #1		//shift x left by 1 bit to make room for 0 bit 
	ORR OFST, OFST, R8	//add shifted y and x,  to offset
	ADD R4, BASE, OFST	//add offset to address
	STRH R9, [R4]		//store 0 at the address
	
	ADD R3, R3, #1 //y++
	B yPLoop
outPX:
	POP {R0-R10,LR}
	BX LR


	
VGA_write_char_ASM:
	//parameters R0x, R1y, R2char c
	PUSH {R0-R10,LR}
	//check if coords are valid
	LDR R3, =H_CHARACTER_RESOL //80
	LDR R4, =V_CHARACTER_RESOL //60
	CMP X, R3			//check if x is too big
	BGE WRITE_CHAR_END
	CMP X, #0			//check if x is too small
	BLT WRITE_CHAR_END
	CMP Y, R4			//check if y is too big
	BGE WRITE_CHAR_END
	CMP Y, #0			//check if y is too small
	BLT WRITE_CHAR_END

	MOV R3, #0			//offset for x
	MOV R4, #7			//offset for y

	LDR BASE, =CHAR_BUFF
	LSL OFST, Y, #7		//shift y left by 7bits to make room for x
	ORR OFST, OFST, X
	ADD R4, BASE, OFST	//add offset to address

	STRB C, [R4]		//store c at the address
WRITE_CHAR_END:
	POP {R0-R10,LR}
	BX LR
	
//uses write char twice
VGA_write_byte_ASM:
	PUSH {R0-R10,LR}
	LDR R7, =HEX_CHAR
	MOV R3, R2
	LSR R2, R3, #4
	AND R2, R2, #15 		// Get the last 4 bits of the byte
	LDRB R2, [R7, R2]
	BL VGA_write_char_ASM
	AND R2, R3, #15 		// Get the first 4 bits of the byte
	ADD R0, R0, #1 			// Add 1 to x
	LDRB R2, [R7, R2]
	BL VGA_write_char_ASM

	POP {R0-R10,LR}
	BX LR
	
VGA_draw_point_ASM:
	PUSH {R0-R10,LR}
	LDR BASE, =PIXEL_BUFF
	MOV R6, R2			//store colour in r6

	LSL OFST, Y, #10	//shift y left by 10bits to make room for x
	LSL R8, X, #1		//shift x left by 1 bit to make room for 0 bit 
	ADD OFST, OFST, R8	//add shifted y and x,  to offset
	ADD R4, BASE, OFST	//add offset to address
	STRH R6, [R4]		//store colour at the address

	POP {R0-R10, LR}
	BX LR

//holds data to write in write byte
HEX_CHAR:
	.ascii "0123456789ABCDEF"

	.end
