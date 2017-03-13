int16_t mcp3208_read_adc(uint8_t channel);
void send_resistor_value(uint8_t sensor);
void spi_init_master(void);
void soft_reset(void);

uint8_t i2c_set_wiper(uint8_t address, uint16_t resistance);
uint8_t i2c_send_data(uint8_t address, uint8_t data[], uint8_t data_length, bool send_stop);
uint8_t i2c_init_mcp(uint8_t address);

int8_t detect_board(void);
