#include <avr/io.h>
#include <util/delay.h>

#include "i2c.h"

#define I2C_DELAY_SHORT _delay_loop_2(8)
#define I2C_DELAY_LONG _delay_loop_2(16)


void I2cInit()
{
	RESET(SDA_PIN);
	RESET(SCL_PIN);
	
	I2C_SDA_HIGH;
	I2C_SCL_HIGH;
		
}

void I2cStart()
{
	I2C_SCL_HIGH;
	I2C_DELAY_LONG;
	
	I2C_SDA_LOW;
	I2C_DELAY_LONG;
}

void I2cStop()
{
	 I2C_SDA_LOW;
	 I2C_DELAY_LONG;
	 I2C_SCL_HIGH;
	 I2C_DELAY_SHORT;
	 I2C_SDA_HIGH;
	 I2C_DELAY_LONG;
}

uint8_t I2cWriteByte(uint8_t data)
{
	 
	 for(uint8_t i=0;i<8;i++)
	 {
		I2C_SCL_LOW;
		I2C_DELAY_SHORT;
		
		if(data & 0x80) {
			I2C_SDA_HIGH;
		}
		else {
			I2C_SDA_LOW;	
		}
		I2C_DELAY_LONG;
		
		I2C_SCL_HIGH;
		I2C_DELAY_LONG;
		
		while ( !(IS_SET(SCL_PIN)) ) {;}
		
		data *= 2; // shift one bit to the left
	}
	
	//ACK Bit
	I2C_SCL_LOW;
	I2C_DELAY_SHORT;
		
	I2C_SDA_HIGH;		
	I2C_DELAY_LONG;
		
	I2C_SCL_HIGH;
	I2C_DELAY_LONG;	
	
	uint8_t ack = !(IS_SET(SDA_PIN));
	
	I2C_SCL_LOW;
	I2C_DELAY_LONG;
	
	return ack;
	 
}
 

