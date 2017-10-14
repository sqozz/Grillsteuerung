EESchema Schematic File Version 2
LIBS:Lüftersteuerung-rescue
LIBS:power
LIBS:device
LIBS:transistors
LIBS:conn
LIBS:linear
LIBS:regul
LIBS:74xx
LIBS:cmos4000
LIBS:adc-dac
LIBS:memory
LIBS:xilinx
LIBS:microcontrollers
LIBS:dsp
LIBS:microchip
LIBS:analog_switches
LIBS:motorola
LIBS:texas
LIBS:intel
LIBS:audio
LIBS:interface
LIBS:digital-audio
LIBS:philips
LIBS:display
LIBS:cypress
LIBS:siliconi
LIBS:opto
LIBS:atmel
LIBS:contrib
LIBS:valves
LIBS:OKI-78SR-5
LIBS:mcp45hvx1
LIBS:Lüftersteuerung
LIBS:mate-n-lok
LIBS:tps793
LIBS:sub-d9
LIBS:byteworker
LIBS:mj-2508
LIBS:mcp3208
LIBS:Lüftersteuerung-cache
EELAYER 25 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 4
Title ""
Date ""
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Sheet
S 1650 4650 1250 1000
U 57C85C6C
F0 "Lüftersteuerung" 60
F1 "Lueftersteuerungsch.sch" 60
F2 "SCL_MCP45HV" I R 2900 4900 60 
F3 "SDA_MCP45HV" I R 2900 5050 60 
F4 "~FAN_Enable" I R 2900 5200 60 
$EndSheet
$Sheet
S 4150 1350 3100 2050
U 57D04F8F
F0 "MCU" 60
F1 "mcu.sch" 60
F2 "SDA_MCP45HV" B L 4150 3000 60 
F3 "~FAN_Enable" I L 4150 3200 60 
F4 "SCL_MCP45HV" O L 4150 2800 60 
F5 "~CS" O R 7250 2300 60 
F6 "MISO" I R 7250 2700 60 
F7 "MOSI" O R 7250 2500 60 
F8 "SPI_CLK" O R 7250 2900 60 
$EndSheet
$Sheet
S 9300 4350 1250 1100
U 57C85EB3
F0 "Sensoren" 60
F1 "Sensoren.sch" 60
F2 "~CS" I L 9300 4600 60 
F3 "MOSI" I L 9300 4750 60 
F4 "MISO" O L 9300 4900 60 
F5 "SPI_CLK" I L 9300 5050 60 
$EndSheet
Wire Wire Line
	4150 3200 3900 3200
Wire Wire Line
	3900 3200 3900 5200
Wire Wire Line
	3900 5200 2900 5200
Wire Wire Line
	2900 5050 3700 5050
Wire Wire Line
	3700 5050 3700 3000
Wire Wire Line
	3700 3000 4150 3000
Wire Wire Line
	4150 2800 3500 2800
Wire Wire Line
	3500 2800 3500 4900
Wire Wire Line
	3500 4900 2900 4900
Wire Wire Line
	7250 2300 9000 2300
Wire Wire Line
	9000 2300 9000 4600
Wire Wire Line
	9000 4600 9300 4600
Wire Wire Line
	7250 2500 8850 2500
Wire Wire Line
	8850 2500 8850 4750
Wire Wire Line
	8850 4750 9300 4750
Wire Wire Line
	7250 2700 8700 2700
Wire Wire Line
	8700 2700 8700 4900
Wire Wire Line
	8700 4900 9300 4900
Wire Wire Line
	7250 2900 8550 2900
Wire Wire Line
	8550 2900 8550 5050
Wire Wire Line
	8550 5050 9300 5050
$EndSCHEMATC
