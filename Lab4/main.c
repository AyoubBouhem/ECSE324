#include <stdio.h>

#include "./drivers/inc/slider_switches.h"
#include "./drivers/inc/pushbuttons.h"
#include "./drivers/inc/VGA.h"
#include "./drivers/inc/ps2_keyboard.h"
#include "./drivers/inc/audio.h"

void test_char() {
	int x,y;
	char c = 0;
	
	for (y=0; y<=59; y++) {
		for (x=0; x<=79; x++) {
			VGA_write_char_ASM(x, y, c++);
		}
	}
}

void test_byte() {
	int x,y;
	char c = 0;
	
	for (y=0; y<=59; y++) {
		for (x=0; x<=79; x+=3) {
			VGA_write_byte_ASM(x, y, c++);
		}
	}
}

void test_pixel() {
	int x,y;
	unsigned short colour = 0;
	
	for (y=0; y<=239; y++) {
		for (x=0; x<=319; x++) {
			VGA_draw_point_ASM(x,y,colour++);
		}
	}
}

void vga() {
	while (1) {
		if (read_PB_data_ASM() == 1){
			if(read_slider_switches_ASM() == 0) {
				test_char();
			}
			else {
				test_byte();
			}
		}
		else if (read_PB_data_ASM() == 2) {
			test_pixel();
		}
		else if (read_PB_data_ASM() == 4) {
			VGA_clear_charbuff_ASM();
		}
		else if (read_PB_data_ASM() == 8) {
			VGA_clear_pixelbuff_ASM();
		}
	}
}

void ps2keyboard() {
	char value;
	int x = 0;
	int y = 0;
	int max_x = 78;
	int max_y = 59;

	VGA_clear_charbuff_ASM();
	
	while(1) {
		if (read_PS2_data_ASM(&value)) {
			VGA_write_byte_ASM(x, y, value);
			x += 3;
			if (x > max_x) {
				x = 0;
				y += 1;
				if (y > max_y) {
					y = 0;
					VGA_clear_charbuff_ASM();
				}
			}			
		}
	}
}

void audio(){
	int i = 0;
	while(1){
		//100Hz at 48K samples/sec
		for(i=0;i<240;i++){
			if(write_audio_data_ASM(0x00FFFFFF) !=1){
				i--;
			}
		}
		for(i=0;i<240;i++){
			if(write_audio_data_ASM(0x00000000) !=1){
				i--;
			}
		}
	}
}

int main() {
	//VGA_clear_charbuff_ASM();
	//test_char();
	//test_byte();
	//VGA_clear_pixelbuff_ASM();
	//test_pixel();
	//vga();
	//ps2keyboard();
	audio();
	return 0;
}
