#include <stdio.h>

#include "./drivers/inc/LEDs.h"
#include "./drivers/inc/slider_switches.h"
#include "./drivers/inc/HEX_displays.h"
#include "./drivers/inc/pushbuttons.h"
#include "./drivers/inc/HPS_TIM.h"
#include "./drivers/inc/ISRs.h"
#include "./drivers/inc/address_map_arm.h"
#include "./drivers/inc/int_setup.h"

int main() {
	while (1) {
		int slider_switches = read_slider_switches_ASM();

		write_LEDs_ASM(slider_switches);

		if (0x200 & slider_switches) { //Only look at 10th switch
			HEX_clear_ASM(HEX0 | HEX1 | HEX2 | HEX3 | HEX4 | HEX5); //clear all displays
		} else {
			char val =  0xF & slider_switches; //Only care about first 4 switches, so and with 0xF to clear upper bits
			int pb = 0xF & read_PB_data_ASM(); //and only four switches
			
			//Convert to ascii format
			if (val < 10) { //ASCII Number
				val = val + 48;
			} else { //ASCII Letter
				val = val + 55;
			}

			HEX_write_ASM(pb, write_val); //Write specified value in specified location
		}
	}

	//Initialize first timer parameters
	/*HPS_TIM_config_t hps_tim;
	hps_tim.tim = TIM0;
	hps_tim.timeout = 1000000; //timer 1 timeout
	hps_tim.LD_en = 1;
	hps_tim.INT_en = 0;
	hps_tim.enable = 1;

	HPS_TIM_config_ASM(&hps_tim); //Config timer 1

	//Initialize second timer parameters
	HPS_TIM_config_t hps_tim_pb;
	hps_tim_pb.tim = TIM1;
	hps_tim_pb.timeout = 5000;
	hps_tim_pb.LD_en = 1;
	hps_tim_pb.INT_en = 0;
	hps_tim_pb.enable = 1;

	HPS_TIM_config_ASM(&hps_tim_pb); //config timer 2

	int push_buttons = 0;
	int ms_count = 0;
	int sec_count = 0;
	int min_count = 0;

	int timer_start = 0; //Bit that holds whether time is running

	while(1) {
		if (HPS_TIM_read_ASM(TIM0) && timer_start) {
			HPS_TIM_clear_INT_ASM(TIM0);
			ms_count += 10; //Timer is for 10 milliseconds

			//Ensure ms, sec and min are within their ranges
			if (ms_count >= 1000) {
				ms_count -= 1000;
				sec_count++;
				
				if (sec_count >= 60) {
					sec_count -= 60;
					min_count++;

					if (min_count >= 60) {
						min_count = 0;
					}
				}
			}

			//Get corecsponding digit and convert to ASCII
			HEX_write_ASM(HEX0, ((ms_count % 100) / 10) + 48);
			HEX_write_ASM(HEX1, (ms_count / 100) + 48);
			HEX_write_ASM(HEX2, (sec_count % 10) + 48);
			HEX_write_ASM(HEX3, (sec_count / 10) + 48);
			HEX_write_ASM(HEX4, (min_count % 10) + 48);
			HEX_write_ASM(HEX5, (min_count / 10) + 48);
		}

		if (HPS_TIM_read_ASM(TIM1)) { //Timer to read push buttons
			HPS_TIM_clear_INT_ASM(TIM1);
			int pb = 0xF & read_PB_data_ASM();

			if ((pb & 1) && (!timer_start)) { //Start timer
				timer_start = 1;
			} else if ((pb & 2) && (timer_start)) { //Stop timer
				timer_start = 0;
			} else if (pb & 4) { //Reset timer
				ms_count = 0;
				sec_count = 0;
				min_count = 0;

				timer_start = 0; //Stop timer
				
				//Set every number to 0
				HEX_write_ASM(HEX0 | HEX1 | HEX2 | HEX3 | HEX4 | HEX5, 48);
			}
		}
	}*/

	return 0;
}
