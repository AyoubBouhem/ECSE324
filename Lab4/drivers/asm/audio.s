	.text

	.global write_audio_data_ASM
	.equ Control,	0xFF203040
	.equ Fifospace,	0xFF203044
	.equ Leftdata,	0xFF203048
	.equ Rightdata,	0xFF20304C


write_audio_data_ASM:
		 LDR R2, =Fifospace
		 LDR R3, [R2]
         MOV R4, R3, LSR #16     //R4 holds the value of the wsrc and wslc

		 LDRB R5, [R4]		    // value at WSRC

		 MOV R4, R4, LSR #8		//shift by 8 bits to get rid of wsrc

		 LDRB R6, [R4]         //value at WSLC

		 CMP R5,#1              //check is there is space in wsrc
         BLT full           
         CMP R6,#1              //check if there is space in wslc 
         BLT full           


		 LDR R7,=Leftdata		//get the address for the left channel outgoing data
         LDR R8,=Rightdata		//get the address for the right channel outgoing data
         STR R0,[R7]			//store the value in the outgoing register
         STR R0,[R8]			//store the value in the outgoing register
         MOV R0, #1				//return 1 for successful
		 B END
		 
full:
		MOV R0, #0				//return 0 for failed
END:	BX LR



//100hz = 100/sec
//codec samples at 48K/sec


//eg 100 samples/sec, 2Hz = 2/sec
//two full complete wave cycles in 100 samples
//so 50 per cycle
//25 samples are 1, 25 samples are 0


//so 48k /100 = 480
//so 240 samples high and 240 low
