CC=avr-gcc
CFLAGS += -Os -mmcu=atmega16m1 -DF_CPU=16000000UL -std=c99 -Wall #-pedantic

TARGET=byteworker
SOURCE=$(wildcard *.c)
DEPS=
LIBS=can/libcan.a
LDFLAG=-Lcan -lcan

OBJS=$(SOURCE:.c=.o)

$(TARGET): $(OBJS) $(DEPS)
	@printf "LINKING \033\13301;33m-\033\13301;37m %-20s\n\033\13300;39m" $@
	@$(CC) $(CFLAGS) $(LDFLAG) -o $(TARGET).elf $(OBJS) $(LIBS)

	@printf "MAKING HEX \033\13301;33m-\033\13301;37m %-20s\n\033\13300;39m" $@
	@avr-objcopy -O ihex $(TARGET).elf $(TARGET).hex
	@avr-objcopy -O binary $(TARGET).elf $(TARGET).bin

%.o: %.c $(DEPS)
	@printf "CC \033\13301;33m-\033\13301;37m %-20s\n\033\13300;39m" $@
	@$(CC) -c $(CFLAGS) -o $@ $< $(INCLUDES)

flash:
	avrdude -c mcprog -p m16m1 -x clockrate=125000  -U flash:w:$(TARGET).hex

clean:
	rm *.o
	rm *.elf
	rm *.hex

.PHONY: doc clean
