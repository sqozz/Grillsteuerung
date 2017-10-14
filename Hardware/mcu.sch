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
Sheet 3 4
Title ""
Date ""
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L Byteworker U4
U 1 1 57D7FFF3
P 5850 3700
F 0 "U4" H 5850 2600 60  0000 C CNN
F 1 "Byteworker" H 5850 5250 60  0000 C CNN
F 2 "byteworker:byteworker" H 7000 3150 60  0001 C CNN
F 3 "" H 7000 3150 60  0000 C CNN
	1    5850 3700
	1    0    0    -1  
$EndComp
Text HLabel 8300 2800 2    60   BiDi ~ 0
SDA_MCP45HV
Text HLabel 8300 3000 2    60   Input ~ 0
~FAN_Enable
$Comp
L +5V #PWR010
U 1 1 57D8B235
P 7300 3800
F 0 "#PWR010" H 7300 3650 50  0001 C CNN
F 1 "+5V" H 7300 3940 50  0000 C CNN
F 2 "" H 7300 3800 50  0000 C CNN
F 3 "" H 7300 3800 50  0000 C CNN
	1    7300 3800
	0    1    1    0   
$EndComp
$Comp
L R_Small R27
U 1 1 57D8B291
P 7750 2100
F 0 "R27" H 7780 2120 50  0000 L CNN
F 1 "1k" H 7780 2060 50  0000 L CNN
F 2 "Resistors_SMD:R_0603" H 7750 2100 50  0001 C CNN
F 3 "" H 7750 2100 50  0000 C CNN
	1    7750 2100
	-1   0    0    1   
$EndComp
$Comp
L R_Small R30
U 1 1 57D8B4B5
P 8050 2100
F 0 "R30" H 8080 2120 50  0000 L CNN
F 1 "1k" H 8080 2060 50  0000 L CNN
F 2 "Resistors_SMD:R_0603" H 8050 2100 50  0001 C CNN
F 3 "" H 8050 2100 50  0000 C CNN
	1    8050 2100
	-1   0    0    1   
$EndComp
Text HLabel 8300 2600 2    60   Output ~ 0
SCL_MCP45HV
$Comp
L +5V #PWR011
U 1 1 57D8B6EE
P 7900 1850
F 0 "#PWR011" H 7900 1700 50  0001 C CNN
F 1 "+5V" H 7900 1990 50  0000 C CNN
F 2 "" H 7900 1850 50  0000 C CNN
F 3 "" H 7900 1850 50  0000 C CNN
	1    7900 1850
	1    0    0    -1  
$EndComp
$Comp
L R_Small R28
U 1 1 57D8B93E
P 7950 3000
F 0 "R28" H 7980 3020 50  0000 L CNN
F 1 "0R" H 7980 2960 50  0000 L CNN
F 2 "Resistors_SMD:R_0603" H 7950 3000 50  0001 C CNN
F 3 "" H 7950 3000 50  0000 C CNN
	1    7950 3000
	0    1    1    0   
$EndComp
$Comp
L R_Small R29
U 1 1 57D8B9F1
P 7950 3200
F 0 "R29" H 7980 3220 50  0000 L CNN
F 1 "nb" H 7980 3160 50  0000 L CNN
F 2 "Resistors_SMD:R_0603" H 7950 3200 50  0001 C CNN
F 3 "" H 7950 3200 50  0000 C CNN
	1    7950 3200
	0    1    1    0   
$EndComp
$Comp
L GND #PWR012
U 1 1 57D8BCBE
P 7200 3300
F 0 "#PWR012" H 7200 3050 50  0001 C CNN
F 1 "GND" H 7200 3150 50  0000 C CNN
F 2 "" H 7200 3300 50  0000 C CNN
F 3 "" H 7200 3300 50  0000 C CNN
	1    7200 3300
	0    -1   -1   0   
$EndComp
$Comp
L +12V #PWR013
U 1 1 57D8BDF6
P 7300 3600
F 0 "#PWR013" H 7300 3450 50  0001 C CNN
F 1 "+12V" H 7300 3740 50  0000 C CNN
F 2 "" H 7300 3600 50  0000 C CNN
F 3 "" H 7300 3600 50  0000 C CNN
	1    7300 3600
	0    1    1    0   
$EndComp
NoConn ~ 7000 4000
$Comp
L Led_Small D1
U 1 1 57D8BE75
P 7300 4400
F 0 "D1" H 7250 4525 50  0000 L CNN
F 1 "Led_Status" H 7125 4300 50  0000 L CNN
F 2 "LEDs:LED_D3.0mm" V 7300 4400 50  0001 C CNN
F 3 "" V 7300 4400 50  0000 C CNN
	1    7300 4400
	1    0    0    -1  
$EndComp
$Comp
L Led_Small D2
U 1 1 57D8BF20
P 7300 4600
F 0 "D2" H 7250 4725 50  0000 L CNN
F 1 "Led_OK" H 7125 4500 50  0000 L CNN
F 2 "LEDs:LED_D3.0mm" V 7300 4600 50  0001 C CNN
F 3 "" V 7300 4600 50  0000 C CNN
	1    7300 4600
	1    0    0    -1  
$EndComp
$Comp
L R_Small R25
U 1 1 57D8BF95
P 7650 4400
F 0 "R25" H 7680 4420 50  0000 L CNN
F 1 "1k" H 7680 4360 50  0000 L CNN
F 2 "Resistors_SMD:R_0603" H 7650 4400 50  0001 C CNN
F 3 "" H 7650 4400 50  0000 C CNN
	1    7650 4400
	0    1    1    0   
$EndComp
$Comp
L R_Small R26
U 1 1 57D8BFFE
P 7650 4600
F 0 "R26" H 7680 4620 50  0000 L CNN
F 1 "1k" H 7680 4560 50  0000 L CNN
F 2 "Resistors_SMD:R_0603" H 7650 4600 50  0001 C CNN
F 3 "" H 7650 4600 50  0000 C CNN
	1    7650 4600
	0    1    1    0   
$EndComp
$Comp
L +12V #PWR014
U 1 1 57D8C090
P 7900 4500
F 0 "#PWR014" H 7900 4350 50  0001 C CNN
F 1 "+12V" H 7900 4640 50  0000 C CNN
F 2 "" H 7900 4500 50  0000 C CNN
F 3 "" H 7900 4500 50  0000 C CNN
	1    7900 4500
	0    1    1    0   
$EndComp
Text HLabel 4300 3400 0    60   Output ~ 0
~CS
Text HLabel 4300 3600 0    60   Input ~ 0
MISO
Text HLabel 4300 3800 0    60   Output ~ 0
MOSI
Text HLabel 4300 4000 0    60   Output ~ 0
SPI_CLK
$Comp
L R_Small R22
U 1 1 57D8CB31
P 4500 3600
F 0 "R22" V 4600 3550 50  0000 L CNN
F 1 "100R" V 4450 3500 50  0000 L CNN
F 2 "Resistors_SMD:R_0603" H 4500 3600 50  0001 C CNN
F 3 "" H 4500 3600 50  0000 C CNN
	1    4500 3600
	0    1    1    0   
$EndComp
$Comp
L R_Small R23
U 1 1 57D8CCA5
P 4500 3800
F 0 "R23" V 4600 3750 50  0000 L CNN
F 1 "100R" V 4450 3700 50  0000 L CNN
F 2 "Resistors_SMD:R_0603" H 4500 3800 50  0001 C CNN
F 3 "" H 4500 3800 50  0000 C CNN
	1    4500 3800
	0    1    1    0   
$EndComp
$Comp
L R_Small R24
U 1 1 57D8CCE2
P 4500 4000
F 0 "R24" V 4600 3950 50  0000 L CNN
F 1 "100R" V 4450 3900 50  0000 L CNN
F 2 "Resistors_SMD:R_0603" H 4500 4000 50  0001 C CNN
F 3 "" H 4500 4000 50  0000 C CNN
	1    4500 4000
	0    1    1    0   
$EndComp
$Comp
L R_Small R21
U 1 1 57D8CD1C
P 4500 3400
F 0 "R21" V 4600 3350 50  0000 L CNN
F 1 "100R" V 4450 3300 50  0000 L CNN
F 2 "Resistors_SMD:R_0603" H 4500 3400 50  0001 C CNN
F 3 "" H 4500 3400 50  0000 C CNN
	1    4500 3400
	0    1    1    0   
$EndComp
$Comp
L SW_PUSH SW2
U 1 1 57D8D3D4
P 4100 1500
F 0 "SW2" H 4250 1610 50  0000 C CNN
F 1 "SW_INIT" H 4100 1420 50  0000 C CNN
F 2 "Buttons_Switches_ThroughHole:SW_Tactile_SPST_Angled" H 4100 1500 50  0001 C CNN
F 3 "" H 4100 1500 50  0000 C CNN
	1    4100 1500
	0    1    1    0   
$EndComp
$Comp
L SW_PUSH SW1
U 1 1 57D8D707
P 3900 1500
F 0 "SW1" H 4050 1610 50  0000 C CNN
F 1 "SW_NB" H 3900 1420 50  0000 C CNN
F 2 "Buttons_Switches_ThroughHole:SW_Tactile_SPST_Angled" H 3900 1500 50  0001 C CNN
F 3 "" H 3900 1500 50  0000 C CNN
	1    3900 1500
	0    -1   -1   0   
$EndComp
$Comp
L +5V #PWR015
U 1 1 57D8D83D
P 4000 1050
F 0 "#PWR015" H 4000 900 50  0001 C CNN
F 1 "+5V" H 4000 1190 50  0000 C CNN
F 2 "" H 4000 1050 50  0000 C CNN
F 3 "" H 4000 1050 50  0000 C CNN
	1    4000 1050
	1    0    0    -1  
$EndComp
$Comp
L R_Small R19
U 1 1 57D8DD4F
P 3700 1850
F 0 "R19" H 3730 1870 50  0000 L CNN
F 1 "1k" H 3730 1810 50  0000 L CNN
F 2 "Resistors_SMD:R_0603" H 3700 1850 50  0001 C CNN
F 3 "" H 3700 1850 50  0000 C CNN
	1    3700 1850
	0    1    1    0   
$EndComp
$Comp
L R_Small R20
U 1 1 57D8DDF2
P 4400 1850
F 0 "R20" H 4430 1870 50  0000 L CNN
F 1 "1k" H 4430 1810 50  0000 L CNN
F 2 "Resistors_SMD:R_0603" H 4400 1850 50  0001 C CNN
F 3 "" H 4400 1850 50  0000 C CNN
	1    4400 1850
	0    -1   -1   0   
$EndComp
$Comp
L C_Small C3
U 1 1 57D8DF3F
P 3700 2050
F 0 "C3" H 3710 2120 50  0000 L CNN
F 1 "10nF/10V" V 3850 1850 50  0000 L CNN
F 2 "Capacitors_SMD:C_0603" H 3700 2050 50  0001 C CNN
F 3 "" H 3700 2050 50  0000 C CNN
	1    3700 2050
	0    1    1    0   
$EndComp
$Comp
L C_Small C4
U 1 1 57D8DFEC
P 4400 2050
F 0 "C4" H 4410 2120 50  0000 L CNN
F 1 "10nF/10V" V 4350 1650 50  0000 L CNN
F 2 "Capacitors_SMD:C_0603" H 4400 2050 50  0001 C CNN
F 3 "" H 4400 2050 50  0000 C CNN
	1    4400 2050
	0    -1   -1   0   
$EndComp
$Comp
L GND #PWR016
U 1 1 57D8E08C
P 4650 1950
F 0 "#PWR016" H 4650 1700 50  0001 C CNN
F 1 "GND" H 4650 1800 50  0000 C CNN
F 2 "" H 4650 1950 50  0000 C CNN
F 3 "" H 4650 1950 50  0000 C CNN
	1    4650 1950
	0    -1   -1   0   
$EndComp
$Comp
L GND #PWR017
U 1 1 57D8E27F
P 3450 1950
F 0 "#PWR017" H 3450 1700 50  0001 C CNN
F 1 "GND" H 3450 1800 50  0000 C CNN
F 2 "" H 3450 1950 50  0000 C CNN
F 3 "" H 3450 1950 50  0000 C CNN
	1    3450 1950
	0    1    1    0   
$EndComp
NoConn ~ 4750 4600
NoConn ~ 5750 5050
NoConn ~ 5950 5050
$Comp
L CONN_01X06 P1
U 1 1 57D90207
P 1100 2700
F 0 "P1" H 1100 3050 50  0000 C CNN
F 1 "ISP_HEADER" V 1200 2700 50  0000 C CNN
F 2 "Pin_Headers:Pin_Header_Straight_2x03" H 1100 2700 50  0001 C CNN
F 3 "" H 1100 2700 50  0000 C CNN
	1    1100 2700
	-1   0    0    1   
$EndComp
$Comp
L +5V #PWR018
U 1 1 57D9050A
P 1550 2300
F 0 "#PWR018" H 1550 2150 50  0001 C CNN
F 1 "+5V" H 1550 2440 50  0000 C CNN
F 2 "" H 1550 2300 50  0000 C CNN
F 3 "" H 1550 2300 50  0000 C CNN
	1    1550 2300
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR019
U 1 1 57D906A4
P 1350 2300
F 0 "#PWR019" H 1350 2050 50  0001 C CNN
F 1 "GND" H 1350 2150 50  0000 C CNN
F 2 "" H 1350 2300 50  0000 C CNN
F 3 "" H 1350 2300 50  0000 C CNN
	1    1350 2300
	-1   0    0    1   
$EndComp
$Comp
L R_Small R34
U 1 1 57D950BF
P 8150 3400
F 0 "R34" H 8180 3420 50  0000 L CNN
F 1 "1k" H 8180 3360 50  0000 L CNN
F 2 "Resistors_SMD:R_0603" H 8150 3400 50  0001 C CNN
F 3 "" H 8150 3400 50  0000 C CNN
	1    8150 3400
	-1   0    0    1   
$EndComp
$Comp
L GND #PWR020
U 1 1 57D9528F
P 8350 3550
F 0 "#PWR020" H 8350 3300 50  0001 C CNN
F 1 "GND" H 8350 3400 50  0000 C CNN
F 2 "" H 8350 3550 50  0000 C CNN
F 3 "" H 8350 3550 50  0000 C CNN
	1    8350 3550
	0    -1   -1   0   
$EndComp
$Comp
L R_Small R35
U 1 1 57DC12C1
P 4350 4300
F 0 "R35" H 4380 4320 50  0000 L CNN
F 1 "240R" H 4380 4260 50  0000 L CNN
F 2 "Resistors_SMD:R_0603_HandSoldering" H 4350 4300 50  0001 C CNN
F 3 "" H 4350 4300 50  0000 C CNN
	1    4350 4300
	0    1    1    0   
$EndComp
$Comp
L SUB-D9 X2
U 1 1 57DC6A71
P 2350 3650
F 0 "X2" H 2350 4200 60  0000 C CNN
F 1 "SUB-D9" V 2500 3650 60  0000 C CNN
F 2 "subd9:DB9M_CI" H 2300 3650 60  0001 C CNN
F 3 "" H 2300 3650 60  0000 C CNN
	1    2350 3650
	-1   0    0    1   
$EndComp
NoConn ~ 2600 3200
$Comp
L GND #PWR021
U 1 1 57DC738F
P 3350 3900
F 0 "#PWR021" H 3350 3650 50  0001 C CNN
F 1 "GND" H 3350 3750 50  0000 C CNN
F 2 "" H 3350 3900 50  0000 C CNN
F 3 "" H 3350 3900 50  0000 C CNN
	1    3350 3900
	0    -1   -1   0   
$EndComp
$Comp
L +12V #PWR022
U 1 1 57DC86A0
P 2950 3300
F 0 "#PWR022" H 2950 3150 50  0001 C CNN
F 1 "+12V" H 2950 3440 50  0000 C CNN
F 2 "" H 2950 3300 50  0000 C CNN
F 3 "" H 2950 3300 50  0000 C CNN
	1    2950 3300
	0    1    1    0   
$EndComp
NoConn ~ 2600 3400
NoConn ~ 2600 3600
NoConn ~ 2600 3800
NoConn ~ 2600 4100
$Comp
L +24V #PWR023
U 1 1 57DC97CF
P 2950 3800
F 0 "#PWR023" H 2950 3650 50  0001 C CNN
F 1 "+24V" H 2950 3940 50  0000 C CNN
F 2 "" H 2950 3800 50  0000 C CNN
F 3 "" H 2950 3800 50  0000 C CNN
	1    2950 3800
	0    1    1    0   
$EndComp
$Comp
L PWR_FLAG #FLG024
U 1 1 57DC99A4
P 2900 3750
F 0 "#FLG024" H 2900 3845 50  0001 C CNN
F 1 "PWR_FLAG" H 2900 3930 50  0000 C CNN
F 2 "" H 2900 3750 50  0000 C CNN
F 3 "" H 2900 3750 50  0000 C CNN
	1    2900 3750
	1    0    0    -1  
$EndComp
$Comp
L Jumper_NO_Small JP1
U 1 1 57DFF081
P 4100 4300
F 0 "JP1" H 4100 4350 50  0000 C CNN
F 1 "Jumper_NO_Small" H 4110 4240 50  0001 C CNN
F 2 "Pin_Headers:Pin_Header_Straight_1x02" H 4100 4300 50  0001 C CNN
F 3 "" H 4100 4300 50  0000 C CNN
	1    4100 4300
	1    0    0    -1  
$EndComp
$Comp
L +5V #PWR025
U 1 1 57ED14DF
P 2700 1050
F 0 "#PWR025" H 2700 900 50  0001 C CNN
F 1 "+5V" H 2700 1190 50  0000 C CNN
F 2 "" H 2700 1050 50  0000 C CNN
F 3 "" H 2700 1050 50  0000 C CNN
	1    2700 1050
	1    0    0    -1  
$EndComp
$Comp
L R_Small R36
U 1 1 57ED151C
P 2700 1350
F 0 "R36" H 2730 1370 50  0000 L CNN
F 1 "n.b." H 2730 1310 50  0000 L CNN
F 2 "Resistors_SMD:R_0603" H 2700 1350 50  0001 C CNN
F 3 "" H 2700 1350 50  0000 C CNN
	1    2700 1350
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR026
U 1 1 57ED16E7
P 2350 1850
F 0 "#PWR026" H 2350 1600 50  0001 C CNN
F 1 "GND" H 2350 1700 50  0000 C CNN
F 2 "" H 2350 1850 50  0000 C CNN
F 3 "" H 2350 1850 50  0000 C CNN
	1    2350 1850
	0    1    1    0   
$EndComp
Wire Wire Line
	7000 3800 7300 3800
Wire Wire Line
	7750 2000 7750 1900
Wire Wire Line
	7750 1900 8050 1900
Wire Wire Line
	8050 1900 8050 2000
Connection ~ 7900 1900
Wire Wire Line
	7900 1850 7900 1900
Wire Wire Line
	7000 2600 8300 2600
Wire Wire Line
	8050 2200 8050 2600
Connection ~ 8050 2600
Wire Wire Line
	7000 2800 8300 2800
Wire Wire Line
	7750 2200 7750 2800
Connection ~ 7750 2800
Wire Wire Line
	7600 4200 7000 4200
Wire Wire Line
	7000 3000 7850 3000
Wire Wire Line
	8050 3000 8300 3000
Wire Wire Line
	7850 3200 7600 3200
Wire Wire Line
	7600 3200 7600 4200
Wire Wire Line
	8050 3200 8150 3200
Connection ~ 8150 3000
Wire Wire Line
	7000 3200 7100 3200
Wire Wire Line
	7100 3200 7100 3400
Wire Wire Line
	7100 3300 7200 3300
Wire Wire Line
	7100 3400 7000 3400
Connection ~ 7100 3300
Wire Wire Line
	7300 3600 7000 3600
Wire Wire Line
	7000 4600 7200 4600
Wire Wire Line
	7000 4400 7200 4400
Wire Wire Line
	7400 4400 7550 4400
Wire Wire Line
	7400 4600 7550 4600
Wire Wire Line
	7850 4400 7850 4600
Wire Wire Line
	7850 4500 7900 4500
Wire Wire Line
	7750 4400 7850 4400
Wire Wire Line
	7850 4600 7750 4600
Connection ~ 7850 4500
Wire Wire Line
	4300 3400 4400 3400
Wire Wire Line
	4300 3600 4400 3600
Wire Wire Line
	4300 3800 4400 3800
Wire Wire Line
	4300 4000 4400 4000
Wire Wire Line
	4600 4000 4750 4000
Wire Wire Line
	4750 3800 4600 3800
Wire Wire Line
	4600 3600 4750 3600
Wire Wire Line
	4750 3400 4600 3400
Wire Wire Line
	3900 1200 3900 1100
Wire Wire Line
	3900 1100 4100 1100
Wire Wire Line
	4000 1100 4000 1050
Wire Wire Line
	4100 1100 4100 1200
Connection ~ 4000 1100
Wire Wire Line
	3500 1850 3600 1850
Wire Wire Line
	3500 2050 3600 2050
Wire Wire Line
	4600 2050 4500 2050
Wire Wire Line
	4600 1850 4500 1850
Wire Wire Line
	3800 1850 3900 1850
Wire Wire Line
	3900 1800 3900 3200
Wire Wire Line
	4600 1850 4600 2050
Wire Wire Line
	3450 1950 3500 1950
Wire Wire Line
	3500 1850 3500 2050
Connection ~ 3500 1950
Wire Wire Line
	4650 1950 4600 1950
Connection ~ 4600 1950
Wire Wire Line
	3900 2050 3800 2050
Wire Wire Line
	3900 3200 4750 3200
Connection ~ 3900 1850
Connection ~ 3900 2050
Wire Wire Line
	4300 1850 4100 1850
Connection ~ 4100 1850
Wire Wire Line
	4100 2050 4300 2050
Connection ~ 4100 2050
Wire Wire Line
	4100 1800 4100 2150
Wire Wire Line
	4100 2150 7100 2150
Wire Wire Line
	7100 2150 7100 2400
Wire Wire Line
	7100 2400 7000 2400
Wire Wire Line
	4750 2400 1800 2400
Wire Wire Line
	1800 2400 1800 2550
Wire Wire Line
	1800 2550 1300 2550
Wire Wire Line
	4750 2600 2200 2600
Wire Wire Line
	4750 2800 1850 2800
Wire Wire Line
	1850 2800 1850 2650
Wire Wire Line
	1850 2650 1300 2650
Wire Wire Line
	4750 3000 1650 3000
Wire Wire Line
	1650 3000 1650 2750
Wire Wire Line
	1650 2750 1300 2750
Wire Wire Line
	1300 2850 1550 2850
Wire Wire Line
	1550 2850 1550 2300
Wire Wire Line
	1350 2300 1350 2450
Wire Wire Line
	1350 2450 1300 2450
Wire Wire Line
	8150 3000 8150 3300
Connection ~ 8150 3200
Wire Wire Line
	8150 3500 8150 3550
Wire Wire Line
	8150 3550 8350 3550
Wire Wire Line
	3550 4200 4750 4200
Wire Wire Line
	3550 4200 3550 3500
Wire Wire Line
	3550 3500 2600 3500
Wire Wire Line
	3450 4400 4750 4400
Wire Wire Line
	3450 4400 3450 4000
Wire Wire Line
	3450 4000 2600 4000
Wire Wire Line
	2600 3900 3350 3900
Wire Wire Line
	2600 3300 2950 3300
Wire Wire Line
	2600 3700 2750 3700
Wire Wire Line
	2750 3700 2750 3800
Wire Wire Line
	2750 3800 2950 3800
Wire Wire Line
	2900 3750 2900 3800
Connection ~ 2900 3800
Wire Wire Line
	4200 4300 4250 4300
Wire Wire Line
	4000 4300 3950 4300
Wire Wire Line
	3950 4300 3950 4200
Connection ~ 3950 4200
Wire Wire Line
	4450 4300 4500 4300
Wire Wire Line
	4500 4300 4500 4400
Connection ~ 4500 4400
Wire Wire Line
	1300 2950 1550 2950
Wire Wire Line
	1550 2950 1550 2900
Wire Wire Line
	1550 2900 2200 2900
Wire Wire Line
	2200 2900 2200 2600
Wire Wire Line
	2700 1050 2700 1250
$Comp
L R_Small R2
U 1 1 57ED1B0B
P 2550 1850
F 0 "R2" H 2580 1870 50  0000 L CNN
F 1 "10k" H 2580 1810 50  0000 L CNN
F 2 "Resistors_SMD:R_0603" H 2550 1850 50  0001 C CNN
F 3 "" H 2550 1850 50  0000 C CNN
	1    2550 1850
	0    1    1    0   
$EndComp
Wire Wire Line
	2350 1850 2450 1850
Wire Wire Line
	2650 1850 2700 1850
Wire Wire Line
	2700 1450 2700 3000
Connection ~ 2700 3000
Connection ~ 2700 1850
$EndSCHEMATC
