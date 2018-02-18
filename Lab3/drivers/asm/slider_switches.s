	.text
	.equ SW_BASE, 0xFF200040
	.global read_slider_switches_ASM

read_slider_switches_ASM:
//read the value at the memory location designeated for the slider swidh3es data into the R0 register, then branch to the link register
//do callee save if needed and respect arm calling convetnion
	LDR R1, = SW_BASE
	LDR R0, [R1]
	BX LR

	.end