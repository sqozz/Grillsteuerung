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

	uint8_t syned = 0;
	uint32_t stored_id = read_stored_id();
	uint32_t root_id = stored_id;

	if (old_id == -1) {
		synced = false;
	} else {
		synced = true;
	}

	can_t msg_rx;
	can_t msg_tx;
	msg_tx.id = 0x4C0;
	msg_tx.flags.extended = 0;
	msg_tx.flags.rtr = 0;
	msg_tx.length = 1;
	bw_can_init(500);

	timer_wait(500); //TODO: Still necessary or debug code?
	uint8_t enabled_sensors = 0;
	int8_t board = detect_board();
	uint32_t next_event_time = timer_get() + 200;

	if (board == PROBE_BOARD) {
		spi_init_master();
	}

	while (true) {
		msg_tx.data[0] = board;

		if (synced) {
			// Send resistor values of all enabled sensors
			// in an 200ms intervall
			if (timer_get() >= next_event_time) {
				if (board == PROBE_BOARD) { // This is a board with sensors connected
					for (uint8_t i = 0; i < 6; i++) {
						if ((1 << (i + 1)) & enabled_sensors) {
							send_resistor_value(i, root_id);
						};
					};
				} else if (board == FAN_BOARD) { // This is a board to controll the fan with
					msg_tx.id = board;
					msg_tx.data[0] = 0xFF;
					can_send_message(&msg_tx);
				} else { // This is a board with no purpose. No idea why i send this…
					msg_tx.id = 0x333;
					msg_tx.data[0] = 0xFF;
					can_send_message(&msg_tx);
				};
				next_event_time = timer_get() + 200;
			};
		}

		// If not synced or the sync button was pressed
		// request a new can root id.
		// This represents the first id which can be used
		// plus server-defined ammount of extra ids to use
		if (!synced || sync_button_pressed() == true) {
			// Sync initiated
			// TODO: let some LED blink to inform the user
			for (uint8_t i = 0; i <= 10; i++) {
				root_id = request_root_id();
				timer_wait(200);
				if (synced) {
					persist_id(uint32_t root_id);
					// Sync was sucessfull
					// TODO: stop the blinking LED to inform the user
					// maybe switch on a second one?
					break; // if id was received, break
				}; // if this fails, this loop gets toggled again in the next run
			};
		};

		// Prevent this thing to fail if the
		// timer is near overflow? Maybe? Somewhen™
		if (timer_get() & 1 << 31) {
			soft_reset();
		};

		// Receive can message if any in msg_rx buffer
		// TODO: add dynamic CAN ids
		while (can_get_message(&msg_rx)) {
			if (msg_rx.id == root_id) {
				command = msg_rx.data[7]; // MSB contains the command to execute
				switch (command) {
					case 0x00: // soft reset command
						soft_reset();
						break;
					case 0x01: // enable/disable channel command
						// TODO: Make this a function
						// What we expect is a message like this:
						// 1234#0x0y
						// where x is the probe number to acces
						// and   y is either 1 to enable or 0 disable the probe
						// TODO: Maybe some fallback for wrongly crafted messages?
						enabled_sensors &= ~(1 << msg_rx.data[0]);
						enabled_sensors |= msg_rx.data[1] << msg_rx.data[0];
						send_response(root_id, enabled_sensors << 8);
						break;
					case 0x02: // fan control message
						if (board != FAN_BOARD) {
							send_response(root_id, 0xff << 8);
						};
						break;
					default:
						break;
				}
			};
			if (msg_rx.id == 0x1337) { // Reset message to get µC into the can bootloader
				soft_reset();
			};
			if (msg_rx.id == 0x1234) { // Channel to enable/disable sensors
				// What we expect is a message like this:
				// 1234#0x0y
				// where x is the probe number to acces
				// and   y is either 1 to enable or 0 disable the probe
				// TODO: Maybe some fallback for wrongly crafted messages?
				enabled_sensors &= ~(1 << msg_rx.data[0]);
				enabled_sensors |= msg_rx.data[1] << msg_rx.data[0];
			};
			if (msg_rx.id == 0x0815) { // TODO: Do something with the fan
				return 0;
			};
		};
	};
};

void send_response(uint32_t root_id, uint32_t response[8]) {
	can_t msg_tx;
	msg_tx.data = response;
	msg_tx.id = root_id + 1; // Answer id is root_id + 1
	msg_tx.flags.extended = 0;
	msg_tx.flags.rtr = 0;
	msg_tx.length = 8;

	can_send_message(&msg_tx);
};

// Send the resistance of the temperature sensor over can
void send_resistor_value(uint8_t sensor, uint32_t root_id) {
	can_t msg_tx;
	msg_tx.id = root_id + sensor + 1; // Sensor start at 0. +1 makes sure to never send on the root_id
	msg_tx.flags.extended = 0;
	msg_tx.flags.rtr = 0;
	msg_tx.length = 4;

	// Some math magic
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

void persist_id(uint32_t board_id) {
	// TODO: Store board_id somewhere
}

uint32_t read_stored_id(void) {
	// Return oldId if stored somewhere
	// TODO: store this value somewhere
	return -1 // no id stored - request new one
}

uint8_t sync_button_pressed(void) {
	// Return true if button is pressed
	// TODO Implement readout of button
	return false
}

uint32_t request_root_id(void) {
	uint32_t requested_id = 0x00;
	// TODO: Implement actual can code to send a request message to master
	return requested_id
}

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


// Detects the current board by probing for the ADC on I2C
// Returns:
// -1 unknown board
//  1 probe board
//  0 fan control board
int8_t detect_board(void) {
	int8_t board = -1;
	uint8_t address = 0x78;
	board = I2cWriteByte(address);

	return board;
}


// Restart the µC
void soft_reset(void) {
	wdt_enable(WDTO_15MS);
	while (1);
}
