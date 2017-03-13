#include "i2c.h"
#include <stdint.h>
#include <avr/io.h>
#include "can/can.h"
#include "byteworker.h"
#include "timer.h"
#include <stdbool.h>
#include "MCP4551.h"
#include <avr/wdt.h>

uint8_t set_wiper(uint8_t address, uint16_t resistance);
uint8_t send_data(uint8_t address, uint8_t data[], uint8_t data_length, bool send_stop);
uint8_t init_mcp(uint8_t address);
void soft_reset(void);

#define ENABLE_FAN    C,7

int main(void) {
	timer_init();
	uint32_t old_timestamp = timer_get();

	can_t msg_rx;
	bw_can_init(500);
	//I2cInit();

	sei();
	timer_wait(1000);
	SET_OUTPUT(ENABLE_FAN);
	SET(ENABLE_FAN);

	uint8_t address = 0x78;
	set_wiper(address, MCP4551_WIPER_B );

	uint16_t wiper_value = 0x63;

	while (true) {

		set_wiper(address, 0x63);

		/*
		if (timer_get() >= (old_timestamp + 10 * wiper_value)) {
			old_timestamp = timer_get();
			bw_led_toggle(0);

			if (wiper_value >= MCP4551_WIPER_A) {
				bw_led_set(1, 1);
				wiper_value = 0x63;
			} else {
				bw_led_set(1, 0);
				wiper_value++;
			}
			set_wiper(address, wiper_value);
		};
		*/


		while (can_get_message(&msg_rx)) {
			if (msg_rx.id == 0x1337) {
				soft_reset();
			};
		};
	};
};

uint8_t set_wiper(uint8_t address, uint16_t resistance) {
	uint8_t ack;
	uint8_t data[2];

	data[0] = ((resistance >> 8 & 0x01) | MCP4551_CMD_WRITE);
	data[1] = (resistance & 0xFF);
	ack = send_data(address, data, 2, true);

	return ack;
}

uint8_t send_data(uint8_t address, uint8_t data[], uint8_t data_length, bool send_stop) {
	uint8_t ack;

	ack = init_mcp(address);
	if (ack == 1) {
		for (uint8_t i = 0; i < data_length; i++) {
			ack = I2cWriteByte(data[i]);
		}
	
	}

	if (send_stop) {
		I2cStop();
	};

	return ack;
};

uint8_t init_mcp(uint8_t address) {
	uint8_t ack;

	I2cStart();
	ack = I2cWriteByte(address);

	return ack;
};

void soft_reset(void) {
	wdt_enable(WDTO_15MS);
	while (1);
}
