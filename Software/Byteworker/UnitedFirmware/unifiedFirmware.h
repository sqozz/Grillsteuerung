int16_t mcp3208_read_adc(uint8_t channel);
void send_resistor_value(uint8_t sensor, uint32_t root_id);
void spi_init_master(void);
void soft_reset(void);

uint8_t i2c_set_wiper(uint8_t address, uint16_t resistance);
uint8_t i2c_send_data(uint8_t address, uint8_t data[], uint8_t data_length, bool send_stop);
uint8_t i2c_init_mcp(uint8_t address);

uint32_t read_stored_id(void);
void persist_id(uint32_t board_id);
uint8_t sync_button_pressed(void);

uint32_t request_root_id(void);
void send_response(uint32_t root_id, uint8_t response[], uint8_t length);

int8_t detect_board(void);
