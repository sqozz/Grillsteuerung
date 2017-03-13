#include "i2c.h"
#include "can/can.h"
#include "can/utils.h"
#include "byteworker.h"
#include "timer.h"
#include "MCP4551.h"
#include <stdbool.h>
#include <stdint.h>
#include <avr/io.h>
#include <avr/wdt.h>
#include <avr/interrupt.h>
#include <math.h>

#include "unifiedFirmware.h"

#define PROBE_BOARD 1
#define FAN_BOARD 0


#define SPI_MISO      B,0
#define SPI_MOSI      B,1
#define SPI_CLK       B,7
#define SPI_CS        D,6
#define drecks_pin    D,3

#define ENABLE_FAN    C,7

int main(void) {
	timer_init();
	sei();


	can_t msg_rx;
	can_t msg_tx;
	msg_tx.id = 0x4C0;
	msg_tx.flags.extended = 0;
	msg_tx.flags.rtr = 0;
	msg_tx.length = 1;
	bw_can_init(500);

	timer_wait(500);
	uint8_t enabled_sensors = 0;
	int8_t board = detect_board();
	uint32_t next_event = timer_get() + 200;
	if (board == PROBE_BOARD) {
		spi_init_master();
	}

	while (true) {
		msg_tx.data[0] = board;

		if (timer_get() >= next_event) {
			if (board == PROBE_BOARD) {
				for (uint8_t i = 0; i < 6; i++) {
					if ((1 << (i + 1)) & enabled_sensors) {
						send_resistor_value(i);
					}
				}
			} else if (board == FAN_BOARD) {
				msg_tx.id = board;
				msg_tx.data[0] = 0xFF;
				can_send_message(&msg_tx);
			} else {
				msg_tx.id = 0x333;
				msg_tx.data[0] = 0xFF;
				can_send_message(&msg_tx);
			}
			next_event = timer_get() + 200;
		}

		if (timer_get() & 1 << 31) {
			soft_reset();
		}

		while (can_get_message(&msg_rx)) {
			if (msg_rx.id == 0x1337) {
				soft_reset();
			};
			if (msg_rx.id == 0x1234) {
				enabled_sensors &= ~(1 << msg_rx.data[0]);
				enabled_sensors |= msg_rx.data[1] << msg_rx.data[0];
			}
		};
	};
}

void send_resistor_value(uint8_t sensor) {
	can_t msg_tx;
	msg_tx.id = 0x004 + sensor;
	msg_tx.flags.extended = 0;
	msg_tx.flags.rtr = 0;
	msg_tx.length = 4;

	uint32_t adc_value = 0;
	adc_value = mcp3208_read_adc(sensor);
	uint32_t r2 = 0;
	float vin = 0;
	vin = (adc_value * 5.0) / 4096.0;
	r2 = (vin/(5-vin)) * 10000;

	for (uint8_t i = 0; i < 4; i++) {
		msg_tx.data[i] = (r2 >> 8 * (3 - i));
	}

	can_send_message(&msg_tx);
}

/*
int main(void) {
	timer_init();
	uint32_t old_timestamp = timer_get();

	can_t msg_rx;
	can_t msg_tx;
	msg_tx.id = 0x4C0;
	msg_tx.flags.extended = 0;
	msg_tx.flags.rtr = 0;
	msg_tx.length = 2;
	bw_can_init(500);

	sei();
	timer_wait(1000);

	spi_init_master();

	int16_t adc_value;
	int16_t temp = 0, R;

	while (true) {

		timer_wait(100);
		adc_value = mcp3208_read_adc(0);

		R = log(1 / (1024 / adc_value - 1) * RESISTOR_VALUE);
		temp = (1 / (STEINHART_HART_COEF_A + STEINHART_HART_COEF_B * R + STEINHART_HART_COEF_C * R * R * R)) - 273.25;
		msg_tx.id = 0x4C0;
		msg_tx.data[0] = temp >> 8;
		msg_tx.data[1] = temp & 0xFF;
		can_send_message(&msg_tx);

		msg_tx.id = 0x1B1;
		msg_tx.data[0] = adc_value >> 8;
		msg_tx.data[1] = adc_value & 0xFF;
		can_send_message(&msg_tx);


		//mcp3208_read_adc(6, msg_tx.data);
		//can_send_message(&msg_tx);


		// soft reset by can message
		while (can_get_message(&msg_rx)) {
			if (msg_rx.id == 0x1337) {
				soft_reset();
			};
		};
	};
};

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

		while (can_get_message(&msg_rx)) {
			if (msg_rx.id == 0x1337) {
				soft_reset();
			};
		};
	};
};
*/

// code for probe boards
void spi_init_master(void) {
	SET_OUTPUT(drecks_pin);
	SET_INPUT(SPI_MISO);
	SET_OUTPUT(SPI_MOSI);
	SET_OUTPUT(SPI_CLK);
	SET(SPI_CS);
	SET_OUTPUT(SPI_CS);

	for (uint8_t i = 0; i <= 10; i++) {
		timer_wait(123);
		SET(SPI_CLK);
		timer_wait(123);
		RESET(SPI_CLK);
	}


	SPCR = (1<<SPE) | (1<<MSTR) | (1<<SPR0) | (1<<SPR1);
}

int16_t mcp3208_read_adc(uint8_t channel) {
	int16_t return_value;
	uint8_t data;
	data = 1 << 2; //start bit
	data |= 1 << 1; //single ended
	data |= (channel & 0x7) >> 2; //first bit of desired channel

	RESET(SPI_CS);

	SPDR = data;
	while(!(SPSR & (1<<SPIF)));
	data = SPDR;

	data = 0x0;
	data |= channel << 6;
	SPDR = data;
	while(!(SPSR & (1<<SPIF)));
	return_value = (SPDR & 0x0F) << 8;

	SPDR = 0x0;
	while(!(SPSR & (1<<SPIF)));
	return_value |= SPDR;

	SET(SPI_CS);
	return return_value;
}
// end code for probe boards


// code for fan control boards
uint8_t i2c_set_wiper(uint8_t address, uint16_t resistance) {
	uint8_t ack;
	uint8_t data[2];

	data[0] = ((resistance >> 8 & 0x01) | MCP4551_CMD_WRITE);
	data[1] = (resistance & 0xFF);
	ack = i2c_send_data(address, data, 2, true);

	return ack;
}

uint8_t i2c_send_data(uint8_t address, uint8_t data[], uint8_t data_length, bool send_stop) {
	uint8_t ack;

	ack = i2c_init_mcp(address);
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

uint8_t i2c_init_mcp(uint8_t address) {
	uint8_t ack;

	I2cStart();
	ack = I2cWriteByte(address);

	return ack;
};
// end code for fan control boards


// -1 unknown board
//  1 probe board
//  0 fan control board
int8_t detect_board(void) {
	int8_t board = -1;
	uint8_t address = 0x78;
	board = I2cWriteByte(address);

	return board;
}



void soft_reset(void) {
	wdt_enable(WDTO_15MS);
	while (1);
}
