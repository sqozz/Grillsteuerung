#include <stdint.h>
#include "can/can.h"
#include "can/utils.h"
#include "byteworker.h"
#include "timer.h"
#include <stdbool.h>
#include <avr/io.h>
#include <avr/wdt.h>
#include <avr/interrupt.h>
#include <math.h>

#define SPI_MISO      B,0
#define SPI_MOSI      B,1
#define SPI_CLK       B,7
#define SPI_CS        D,6
#define drecks_pin    D,3

int16_t mcp3208_read_adc(uint8_t channel);
void spi_init_master(void);
void soft_reset(void);

const long double STEINHART_HART_COEF_A = 2.3067434E-4;
const long double STEINHART_HART_COEF_B = 2.3696596E-4;
const long double STEINHART_HART_COEF_C = 1.2636414E-7;
const int RESISTOR_VALUE = 200000;

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


void soft_reset(void) {
	wdt_enable(WDTO_15MS);
	while (1);
}
