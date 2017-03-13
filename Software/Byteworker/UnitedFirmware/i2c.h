
#ifndef _I2C_H
#define _I2C_H

#include <stdint.h>
#include "byteworker.h"
#include "can/utils.h"

#define SCL_PIN    D,2
#define SDA_PIN    D,1

#define I2C_SDA_LOW  (SET_OUTPUT(SDA_PIN))
#define I2C_SDA_HIGH (SET_INPUT(SDA_PIN))

#define I2C_SCL_LOW  (SET_OUTPUT(SCL_PIN))
#define I2C_SCL_HIGH (SET_INPUT(SCL_PIN))


void I2cInit();	
void I2cStart();
void I2cStop();
uint8_t I2cWriteByte(uint8_t data);

#endif 
