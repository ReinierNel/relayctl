EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 1
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
L power:+5V #PWR0101
U 1 1 62177062
P 10500 750
F 0 "#PWR0101" H 10500 600 50  0001 C CNN
F 1 "+5V" H 10515 923 50  0000 C CNN
F 2 "" H 10500 750 50  0001 C CNN
F 3 "" H 10500 750 50  0001 C CNN
F 4 "V" H 10500 750 50  0001 C CNN "Spice_Primitive"
F 5 "dc 5 pulse(5 5)" H 10500 750 50  0001 C CNN "Spice_Model"
F 6 "Y" H 10500 750 50  0001 C CNN "Spice_Netlist_Enabled"
	1    10500 750 
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0102
U 1 1 62177888
P 10500 6250
F 0 "#PWR0102" H 10500 6000 50  0001 C CNN
F 1 "GND" H 10505 6077 50  0000 C CNN
F 2 "" H 10500 6250 50  0001 C CNN
F 3 "" H 10500 6250 50  0001 C CNN
	1    10500 6250
	1    0    0    -1  
$EndComp
Wire Wire Line
	6950 4800 6950 4950
Wire Wire Line
	6950 4950 10500 4950
$Comp
L Relay:RAYEX-L90S K0
U 1 1 6219FBD4
P 1500 1350
F 0 "K0" V 2000 1450 50  0000 L CNN
F 1 "RAYEX-L90S" V 1950 800 50  0000 L TNN
F 2 "Relay_THT:Relay_SPDT_RAYEX-L90S" H 1950 1300 50  0001 L CNN
F 3 "https://a3.sofastcdn.com/attachment/7jioKBjnRiiSrjrjknRiwS77gwbf3zmp/L90-SERIES.pdf" H 2150 1200 50  0001 L CNN
	1    1500 1350
	-1   0    0    1   
$EndComp
Wire Wire Line
	1700 1750 2050 1750
$Comp
L Transistor_BJT:BC548 Q0
U 1 1 6223DF52
P 2600 1400
F 0 "Q0" H 2500 1250 50  0000 L CNN
F 1 "BC548" H 2400 1150 50  0000 L CNN
F 2 "Package_TO_SOT_THT:TO-92_Inline" H 2800 1325 50  0001 L CIN
F 3 "http://www.fairchildsemi.com/ds/BC/BC547.pdf" H 2600 1400 50  0001 L CNN
	1    2600 1400
	-1   0    0    -1  
$EndComp
$Comp
L Device:LED D6
U 1 1 6223F4DE
P 3150 1600
F 0 "D6" V 3189 1483 50  0000 R CNN
F 1 "LED" V 3098 1483 50  0000 R CNN
F 2 "LED_THT:LED_D3.0mm" H 3150 1600 50  0001 C CNN
F 3 "~" H 3150 1600 50  0001 C CNN
	1    3150 1600
	0    -1   -1   0   
$EndComp
$Comp
L Device:R_US R0
U 1 1 62240770
P 3000 1400
F 0 "R0" V 3205 1400 50  0000 C CNN
F 1 "100 Ohm" V 3114 1400 50  0000 C CNN
F 2 "Resistor_THT:R_Axial_DIN0414_L11.9mm_D4.5mm_P15.24mm_Horizontal" V 3040 1390 50  0001 C CNN
F 3 "~" H 3000 1400 50  0001 C CNN
	1    3000 1400
	0    -1   -1   0   
$EndComp
Wire Wire Line
	2800 1400 2850 1400
Wire Wire Line
	3150 1400 3150 1450
Wire Wire Line
	3150 1750 2500 1750
Wire Wire Line
	2500 1600 2500 1750
Wire Wire Line
	1700 950  2050 950 
Wire Wire Line
	2500 1200 2500 1150
Wire Wire Line
	2050 1000 2050 950 
$Comp
L Diode:1N4001 D0
U 1 1 622362A5
P 2050 1150
F 0 "D0" V 1950 1000 50  0000 L CNN
F 1 "1N4001" H 2050 1300 50  0000 C TNN
F 2 "Diode_THT:D_DO-41_SOD81_P10.16mm_Horizontal" H 2050 975 50  0001 C CNN
F 3 "http://www.vishay.com/docs/88503/1n4001.pdf" H 2050 1150 50  0001 C CNN
	1    2050 1150
	0    1    1    0   
$EndComp
Wire Wire Line
	2050 1750 2050 1300
Wire Wire Line
	2050 1750 2300 1750
Wire Wire Line
	2300 1750 2300 1150
Wire Wire Line
	2300 1150 2500 1150
Connection ~ 2050 1750
$Comp
L Relay:RAYEX-L90S K1
U 1 1 6233E5E9
P 1500 2500
F 0 "K1" V 2000 2600 50  0000 L CNN
F 1 "RAYEX-L90S" V 1950 2000 50  0000 L TNN
F 2 "Relay_THT:Relay_SPDT_RAYEX-L90S" H 1950 2450 50  0001 L CNN
F 3 "https://a3.sofastcdn.com/attachment/7jioKBjnRiiSrjrjknRiwS77gwbf3zmp/L90-SERIES.pdf" H 2150 2350 50  0001 L CNN
	1    1500 2500
	-1   0    0    1   
$EndComp
Wire Wire Line
	1700 2900 2050 2900
$Comp
L Transistor_BJT:BC548 Q1
U 1 1 6233E5F0
P 2600 2550
F 0 "Q1" H 2500 2400 50  0000 L CNN
F 1 "BC548" H 2400 2300 50  0000 L CNN
F 2 "Package_TO_SOT_THT:TO-92_Inline" H 2800 2475 50  0001 L CIN
F 3 "http://www.fairchildsemi.com/ds/BC/BC547.pdf" H 2600 2550 50  0001 L CNN
	1    2600 2550
	-1   0    0    -1  
$EndComp
$Comp
L Device:LED D7
U 1 1 6233E5F6
P 3150 2750
F 0 "D7" V 3189 2633 50  0000 R CNN
F 1 "LED" V 3098 2633 50  0000 R CNN
F 2 "LED_THT:LED_D3.0mm" H 3150 2750 50  0001 C CNN
F 3 "~" H 3150 2750 50  0001 C CNN
	1    3150 2750
	0    -1   -1   0   
$EndComp
Wire Wire Line
	2800 2550 2850 2550
Wire Wire Line
	3150 2550 3150 2600
Wire Wire Line
	3150 2900 2500 2900
Wire Wire Line
	2500 2750 2500 2900
Wire Wire Line
	2500 2350 2500 2300
$Comp
L Diode:1N4001 D1
U 1 1 6233E607
P 2050 2300
F 0 "D1" V 1950 2200 50  0000 L CNN
F 1 "1N4001" H 2050 2450 50  0000 C TNN
F 2 "Diode_THT:D_DO-41_SOD81_P10.16mm_Horizontal" H 2050 2125 50  0001 C CNN
F 3 "http://www.vishay.com/docs/88503/1n4001.pdf" H 2050 2300 50  0001 C CNN
	1    2050 2300
	0    1    1    0   
$EndComp
Wire Wire Line
	2050 2900 2050 2450
Wire Wire Line
	2050 2900 2300 2900
Wire Wire Line
	2300 2900 2300 2300
Wire Wire Line
	2300 2300 2500 2300
Connection ~ 2050 2900
$Comp
L Relay:RAYEX-L90S K2
U 1 1 6235F03B
P 1500 3600
F 0 "K2" V 2000 3700 50  0000 L CNN
F 1 "RAYEX-L90S" V 1950 3100 50  0000 L TNN
F 2 "Relay_THT:Relay_SPDT_RAYEX-L90S" H 1950 3550 50  0001 L CNN
F 3 "https://a3.sofastcdn.com/attachment/7jioKBjnRiiSrjrjknRiwS77gwbf3zmp/L90-SERIES.pdf" H 2150 3450 50  0001 L CNN
	1    1500 3600
	-1   0    0    1   
$EndComp
Wire Wire Line
	1700 4000 2050 4000
$Comp
L Transistor_BJT:BC548 Q2
U 1 1 6235F042
P 2600 3650
F 0 "Q2" H 2500 3500 50  0000 L CNN
F 1 "BC548" H 2550 3400 50  0000 C CNN
F 2 "Package_TO_SOT_THT:TO-92_Inline" H 2800 3575 50  0001 L CIN
F 3 "http://www.fairchildsemi.com/ds/BC/BC547.pdf" H 2600 3650 50  0001 L CNN
	1    2600 3650
	-1   0    0    -1  
$EndComp
$Comp
L Device:LED D8
U 1 1 6235F048
P 3150 3850
F 0 "D8" V 3189 3733 50  0000 R CNN
F 1 "LED" V 3098 3733 50  0000 R CNN
F 2 "LED_THT:LED_D3.0mm" H 3150 3850 50  0001 C CNN
F 3 "~" H 3150 3850 50  0001 C CNN
	1    3150 3850
	0    -1   -1   0   
$EndComp
$Comp
L Device:R_US R2
U 1 1 6235F04E
P 3000 3650
F 0 "R2" V 3200 3600 50  0000 L CNN
F 1 "100 Ohm" V 3100 3450 50  0000 L CNN
F 2 "Resistor_THT:R_Axial_DIN0414_L11.9mm_D4.5mm_P15.24mm_Horizontal" V 3040 3640 50  0001 C CNN
F 3 "~" H 3000 3650 50  0001 C CNN
	1    3000 3650
	0    -1   -1   0   
$EndComp
Wire Wire Line
	2800 3650 2850 3650
Wire Wire Line
	3150 3650 3150 3700
Wire Wire Line
	3150 4000 2500 4000
Wire Wire Line
	2500 3850 2500 4000
Wire Wire Line
	2500 3450 2500 3400
$Comp
L Diode:1N4001 D2
U 1 1 6235F059
P 2050 3400
F 0 "D2" V 1950 3300 50  0000 L CNN
F 1 "1N4001" H 2050 3500 50  0000 C CNN
F 2 "Diode_THT:D_DO-41_SOD81_P10.16mm_Horizontal" H 2050 3225 50  0001 C CNN
F 3 "http://www.vishay.com/docs/88503/1n4001.pdf" H 2050 3400 50  0001 C CNN
	1    2050 3400
	0    1    1    0   
$EndComp
Wire Wire Line
	2050 4000 2050 3550
Wire Wire Line
	2050 4000 2300 4000
Wire Wire Line
	2300 4000 2300 3400
Wire Wire Line
	2300 3400 2500 3400
Connection ~ 2050 4000
$Comp
L Relay:RAYEX-L90S K3
U 1 1 6236922B
P 1500 4700
F 0 "K3" V 2000 4850 50  0000 L CNN
F 1 "RAYEX-L90S" V 1950 4200 50  0000 L TNN
F 2 "Relay_THT:Relay_SPDT_RAYEX-L90S" H 1950 4650 50  0001 L CNN
F 3 "https://a3.sofastcdn.com/attachment/7jioKBjnRiiSrjrjknRiwS77gwbf3zmp/L90-SERIES.pdf" H 2150 4550 50  0001 L CNN
	1    1500 4700
	-1   0    0    1   
$EndComp
Wire Wire Line
	1700 5100 2050 5100
$Comp
L Transistor_BJT:BC548 Q3
U 1 1 62369232
P 2600 4750
F 0 "Q3" H 2500 4600 50  0000 L CNN
F 1 "BC548" H 2550 4500 50  0000 C CNN
F 2 "Package_TO_SOT_THT:TO-92_Inline" H 2800 4675 50  0001 L CIN
F 3 "http://www.fairchildsemi.com/ds/BC/BC547.pdf" H 2600 4750 50  0001 L CNN
	1    2600 4750
	-1   0    0    -1  
$EndComp
$Comp
L Device:LED D9
U 1 1 62369238
P 3150 4950
F 0 "D9" V 3189 4833 50  0000 R CNN
F 1 "LED" V 3098 4833 50  0000 R CNN
F 2 "LED_THT:LED_D3.0mm" H 3150 4950 50  0001 C CNN
F 3 "~" H 3150 4950 50  0001 C CNN
	1    3150 4950
	0    -1   -1   0   
$EndComp
$Comp
L Device:R_US R3
U 1 1 6236923E
P 3000 4750
F 0 "R3" V 3205 4750 50  0000 C CNN
F 1 "100 Ohm" V 3114 4750 50  0000 C CNN
F 2 "Resistor_THT:R_Axial_DIN0414_L11.9mm_D4.5mm_P15.24mm_Horizontal" V 3040 4740 50  0001 C CNN
F 3 "~" H 3000 4750 50  0001 C CNN
	1    3000 4750
	0    -1   -1   0   
$EndComp
Wire Wire Line
	2800 4750 2850 4750
Wire Wire Line
	3150 4750 3150 4800
Wire Wire Line
	3150 5100 2500 5100
Wire Wire Line
	2500 4950 2500 5100
Wire Wire Line
	1700 4300 2050 4300
Wire Wire Line
	2500 4550 2500 4500
Wire Wire Line
	2050 4350 2050 4300
$Comp
L Diode:1N4001 D3
U 1 1 6236924B
P 2050 4500
F 0 "D3" V 1950 4400 50  0000 L CNN
F 1 "1N4001" H 2050 4600 50  0000 C CNN
F 2 "Diode_THT:D_DO-41_SOD81_P10.16mm_Horizontal" H 2050 4325 50  0001 C CNN
F 3 "http://www.vishay.com/docs/88503/1n4001.pdf" H 2050 4500 50  0001 C CNN
	1    2050 4500
	0    1    1    0   
$EndComp
Wire Wire Line
	2050 5100 2050 4650
Wire Wire Line
	2050 5100 2300 5100
Wire Wire Line
	2300 5100 2300 4500
Wire Wire Line
	2300 4500 2500 4500
Connection ~ 2050 5100
$Comp
L Relay:RAYEX-L90S K4
U 1 1 62369256
P 1500 5850
F 0 "K4" V 2000 6000 50  0000 L CNN
F 1 "RAYEX-L90S" V 1950 5350 50  0000 L TNN
F 2 "Relay_THT:Relay_SPDT_RAYEX-L90S" H 1950 5800 50  0001 L CNN
F 3 "https://a3.sofastcdn.com/attachment/7jioKBjnRiiSrjrjknRiwS77gwbf3zmp/L90-SERIES.pdf" H 2150 5700 50  0001 L CNN
	1    1500 5850
	-1   0    0    1   
$EndComp
Wire Wire Line
	1700 6250 2050 6250
$Comp
L Transistor_BJT:BC548 Q4
U 1 1 6236925D
P 2600 5900
F 0 "Q4" H 2500 5750 50  0000 L CNN
F 1 "BC548" H 2550 5650 50  0000 C CNN
F 2 "Package_TO_SOT_THT:TO-92_Inline" H 2800 5825 50  0001 L CIN
F 3 "http://www.fairchildsemi.com/ds/BC/BC547.pdf" H 2600 5900 50  0001 L CNN
	1    2600 5900
	-1   0    0    -1  
$EndComp
$Comp
L Device:LED D10
U 1 1 62369263
P 3150 6100
F 0 "D10" V 3189 5982 50  0000 R CNN
F 1 "LED" V 3098 5982 50  0000 R CNN
F 2 "LED_THT:LED_D3.0mm" H 3150 6100 50  0001 C CNN
F 3 "~" H 3150 6100 50  0001 C CNN
	1    3150 6100
	0    -1   -1   0   
$EndComp
$Comp
L Device:R_US R4
U 1 1 62369269
P 3000 5900
F 0 "R4" V 3205 5900 50  0000 C CNN
F 1 "100 Ohm" V 3114 5900 50  0000 C CNN
F 2 "Resistor_THT:R_Axial_DIN0414_L11.9mm_D4.5mm_P15.24mm_Horizontal" V 3040 5890 50  0001 C CNN
F 3 "~" H 3000 5900 50  0001 C CNN
	1    3000 5900
	0    -1   -1   0   
$EndComp
Wire Wire Line
	2800 5900 2850 5900
Wire Wire Line
	3150 5900 3150 5950
Wire Wire Line
	3150 6250 2500 6250
Wire Wire Line
	2500 6100 2500 6250
Wire Wire Line
	2500 5700 2500 5650
$Comp
L Diode:1N4001 D4
U 1 1 62369274
P 2050 5650
F 0 "D4" V 1950 5550 50  0000 L CNN
F 1 "1N4001" H 2050 5750 50  0000 C CNN
F 2 "Diode_THT:D_DO-41_SOD81_P10.16mm_Horizontal" H 2050 5475 50  0001 C CNN
F 3 "http://www.vishay.com/docs/88503/1n4001.pdf" H 2050 5650 50  0001 C CNN
	1    2050 5650
	0    1    1    0   
$EndComp
Wire Wire Line
	2050 6250 2050 5800
Wire Wire Line
	2050 6250 2300 6250
Wire Wire Line
	2300 6250 2300 5650
Wire Wire Line
	2300 5650 2500 5650
Connection ~ 2050 6250
$Comp
L Relay:RAYEX-L90S K5
U 1 1 6236927F
P 1500 6950
F 0 "K5" V 2000 7100 50  0000 L CNN
F 1 "RAYEX-L90S" V 1950 6450 50  0000 L TNN
F 2 "Relay_THT:Relay_SPDT_RAYEX-L90S" H 1950 6900 50  0001 L CNN
F 3 "https://a3.sofastcdn.com/attachment/7jioKBjnRiiSrjrjknRiwS77gwbf3zmp/L90-SERIES.pdf" H 2150 6800 50  0001 L CNN
	1    1500 6950
	-1   0    0    1   
$EndComp
Wire Wire Line
	1700 7350 2050 7350
$Comp
L Transistor_BJT:BC548 Q5
U 1 1 62369286
P 2600 7000
F 0 "Q5" H 2500 6850 50  0000 L CNN
F 1 "BC548" H 2550 6750 50  0000 C CNN
F 2 "Package_TO_SOT_THT:TO-92_Inline" H 2800 6925 50  0001 L CIN
F 3 "http://www.fairchildsemi.com/ds/BC/BC547.pdf" H 2600 7000 50  0001 L CNN
	1    2600 7000
	-1   0    0    -1  
$EndComp
$Comp
L Device:LED D11
U 1 1 6236928C
P 3150 7200
F 0 "D11" V 3189 7082 50  0000 R CNN
F 1 "LED" V 3098 7082 50  0000 R CNN
F 2 "LED_THT:LED_D3.0mm" H 3150 7200 50  0001 C CNN
F 3 "~" H 3150 7200 50  0001 C CNN
	1    3150 7200
	0    -1   -1   0   
$EndComp
$Comp
L Device:R_US R5
U 1 1 62369292
P 3000 7000
F 0 "R5" V 3205 7000 50  0000 C CNN
F 1 "100 Ohm" V 3114 7000 50  0000 C CNN
F 2 "Resistor_THT:R_Axial_DIN0414_L11.9mm_D4.5mm_P15.24mm_Horizontal" V 3040 6990 50  0001 C CNN
F 3 "~" H 3000 7000 50  0001 C CNN
	1    3000 7000
	0    -1   -1   0   
$EndComp
Wire Wire Line
	2800 7000 2850 7000
Wire Wire Line
	3150 7000 3150 7050
Wire Wire Line
	3150 7350 2500 7350
Wire Wire Line
	2500 7200 2500 7350
Wire Wire Line
	2500 6800 2500 6750
$Comp
L Diode:1N4001 D5
U 1 1 6236929D
P 2050 6750
F 0 "D5" V 1950 6650 50  0000 L CNN
F 1 "1N4001" H 2050 6850 50  0000 C CNN
F 2 "Diode_THT:D_DO-41_SOD81_P10.16mm_Horizontal" H 2050 6575 50  0001 C CNN
F 3 "http://www.vishay.com/docs/88503/1n4001.pdf" H 2050 6750 50  0001 C CNN
	1    2050 6750
	0    1    1    0   
$EndComp
Wire Wire Line
	2050 7350 2050 6900
Wire Wire Line
	2050 7350 2300 7350
Wire Wire Line
	2300 7350 2300 6750
Wire Wire Line
	2300 6750 2500 6750
Connection ~ 2050 7350
Wire Wire Line
	10500 750  9450 750 
Wire Wire Line
	2050 750  2050 950 
Connection ~ 2050 950 
Wire Wire Line
	1700 2100 2050 2100
Wire Wire Line
	2050 2100 2050 2150
Wire Wire Line
	1700 3200 2050 3200
Wire Wire Line
	2050 3200 2050 3250
Wire Wire Line
	1700 5450 2050 5450
Wire Wire Line
	2050 5450 2050 5500
Wire Wire Line
	1700 6550 2050 6550
Wire Wire Line
	2050 6550 2050 6600
Wire Wire Line
	2050 750  900  750 
Wire Wire Line
	900  1950 2050 1950
Wire Wire Line
	2050 1950 2050 2100
Connection ~ 2050 750 
Connection ~ 2050 2100
Wire Wire Line
	900  1950 900  3050
Wire Wire Line
	900  3050 2050 3050
Wire Wire Line
	2050 3050 2050 3200
Connection ~ 2050 3200
Wire Wire Line
	900  3050 900  4150
Wire Wire Line
	900  4150 2050 4150
Wire Wire Line
	2050 4150 2050 4300
Connection ~ 900  3050
Connection ~ 2050 4300
Wire Wire Line
	2050 5300 2050 5450
Connection ~ 900  4150
Connection ~ 2050 5450
Wire Wire Line
	900  6400 2050 6400
Wire Wire Line
	2050 6400 2050 6550
Connection ~ 2050 6550
Wire Wire Line
	3150 1750 4300 1750
Wire Wire Line
	4300 1750 4300 2900
Connection ~ 3150 1750
Wire Wire Line
	3150 2900 4300 2900
Connection ~ 3150 2900
Connection ~ 4300 2900
Wire Wire Line
	4300 2900 4300 4000
Wire Wire Line
	3150 4000 4300 4000
Connection ~ 3150 4000
Connection ~ 4300 4000
Wire Wire Line
	4300 4000 4300 5100
Wire Wire Line
	3150 5100 4300 5100
Connection ~ 3150 5100
Connection ~ 4300 5100
Connection ~ 3150 6250
Wire Wire Line
	3150 6250 4300 6250
Wire Wire Line
	3150 7350 4300 7350
Wire Wire Line
	4300 5100 4300 6250
Connection ~ 3150 7350
Connection ~ 4300 6250
Wire Wire Line
	4300 6250 4300 7350
Wire Wire Line
	10500 4950 10500 6200
Wire Wire Line
	10500 6200 6650 6200
Wire Wire Line
	6650 6200 6650 7350
Wire Wire Line
	6650 7350 4300 7350
Connection ~ 10500 6200
Wire Wire Line
	10500 6200 10500 6250
Connection ~ 4300 7350
Wire Wire Line
	3150 1400 5550 1400
Wire Wire Line
	5550 1400 5550 3000
Connection ~ 3150 1400
Wire Wire Line
	3150 2550 5450 2550
Wire Wire Line
	5450 2550 5450 3100
Connection ~ 3150 2550
Wire Wire Line
	3150 3650 5500 3650
Wire Wire Line
	5500 3650 5500 3700
Connection ~ 3150 3650
Wire Wire Line
	3150 4750 5200 4750
Wire Wire Line
	5200 4750 5200 3800
Connection ~ 3150 4750
Wire Wire Line
	3150 5900 5300 5900
Connection ~ 3150 5900
Wire Wire Line
	5400 4200 5400 7000
Connection ~ 3150 7000
$Comp
L Connector:Screw_Terminal_01x02 J5
U 1 1 621E5515
P 9450 1350
F 0 "J5" V 9368 1430 50  0000 C CNN
F 1 "Screw_Terminal_01x02" V 9413 1430 50  0001 L CNN
F 2 "TerminalBlock:TerminalBlock_Altech_AK300-2_P5.00mm" H 9450 1350 50  0001 C CNN
F 3 "~" H 9450 1350 50  0001 C CNN
	1    9450 1350
	0    1    1    0   
$EndComp
$Comp
L Connector:Screw_Terminal_01x02 J4
U 1 1 621E5179
P 9050 1350
F 0 "J4" V 8968 1430 50  0000 C CNN
F 1 "Screw_Terminal_01x02" V 9013 1430 50  0001 L CNN
F 2 "TerminalBlock:TerminalBlock_Altech_AK300-2_P5.00mm" H 9050 1350 50  0001 C CNN
F 3 "~" H 9050 1350 50  0001 C CNN
	1    9050 1350
	0    1    1    0   
$EndComp
$Comp
L Connector:Screw_Terminal_01x02 J3
U 1 1 621E4E53
P 8650 1350
F 0 "J3" V 8568 1430 50  0000 C CNN
F 1 "Screw_Terminal_01x02" V 8613 1430 50  0001 L CNN
F 2 "TerminalBlock:TerminalBlock_Altech_AK300-2_P5.00mm" H 8650 1350 50  0001 C CNN
F 3 "~" H 8650 1350 50  0001 C CNN
	1    8650 1350
	0    1    1    0   
$EndComp
$Comp
L Connector:Screw_Terminal_01x02 J2
U 1 1 621E4B66
P 8250 1350
F 0 "J2" V 8168 1430 50  0000 C CNN
F 1 "Screw_Terminal_01x02" V 8213 1430 50  0001 L CNN
F 2 "TerminalBlock:TerminalBlock_Altech_AK300-2_P5.00mm" H 8250 1350 50  0001 C CNN
F 3 "~" H 8250 1350 50  0001 C CNN
	1    8250 1350
	0    1    1    0   
$EndComp
Wire Wire Line
	7450 1150 7450 750 
Connection ~ 7450 750 
Wire Wire Line
	7850 1150 7850 750 
Connection ~ 7850 750 
Wire Wire Line
	7850 750  7450 750 
Wire Wire Line
	8250 1150 8250 750 
Connection ~ 8250 750 
Wire Wire Line
	8250 750  7850 750 
Wire Wire Line
	8650 1150 8650 750 
Connection ~ 8650 750 
Wire Wire Line
	8650 750  8250 750 
Wire Wire Line
	9050 1150 9050 750 
Connection ~ 9050 750 
Wire Wire Line
	9050 750  8650 750 
Wire Wire Line
	9450 1150 9450 750 
Connection ~ 9450 750 
Wire Wire Line
	9450 750  9050 750 
Wire Wire Line
	7350 1150 7200 1150
Wire Wire Line
	7200 1150 7200 1550
Wire Wire Line
	7200 1550 7700 1550
Wire Wire Line
	7700 1550 7700 3300
Wire Wire Line
	7750 1150 7600 1150
Wire Wire Line
	7600 1150 7600 1500
Wire Wire Line
	7600 1500 7750 1500
Wire Wire Line
	7750 1500 7750 3400
Wire Wire Line
	8150 1150 8000 1150
Wire Wire Line
	8000 1150 8000 1500
Wire Wire Line
	8000 1500 7800 1500
Wire Wire Line
	8550 1150 8400 1150
Wire Wire Line
	8400 1150 8400 1550
Wire Wire Line
	8400 1550 7850 1550
Wire Wire Line
	7850 1550 7850 4300
Wire Wire Line
	8800 5150 8800 1150
Wire Wire Line
	8800 1150 8950 1150
Wire Wire Line
	9200 5100 9200 1150
Wire Wire Line
	9200 1150 9350 1150
$Comp
L Device:R_US R1
U 1 1 6233E5FC
P 3000 2550
F 0 "R1" V 3200 2600 50  0000 R TNN
F 1 "100 Ohm" V 3150 2550 50  0000 C BNN
F 2 "Resistor_THT:R_Axial_DIN0414_L11.9mm_D4.5mm_P15.24mm_Horizontal" V 3040 2540 50  0001 C CNN
F 3 "~" H 3000 2550 50  0001 C CNN
	1    3000 2550
	0    -1   -1   0   
$EndComp
Connection ~ 10500 4950
Connection ~ 10500 750 
Wire Wire Line
	10500 3400 10500 4950
Wire Wire Line
	10500 750  10500 3300
Wire Wire Line
	2050 750  6550 750 
Connection ~ 6550 750 
Wire Wire Line
	6550 750  7450 750 
$Comp
L Connector:Screw_Terminal_01x02 J1
U 1 1 621E47EA
P 7850 1350
F 0 "J1" V 7768 1430 50  0000 C CNN
F 1 "Screw_Terminal_01x02" V 7813 1430 50  0001 L CNN
F 2 "TerminalBlock:TerminalBlock_Altech_AK300-2_P5.00mm" H 7850 1350 50  0001 C CNN
F 3 "~" H 7850 1350 50  0001 C CNN
	1    7850 1350
	0    1    1    0   
$EndComp
$Comp
L Connector:Screw_Terminal_01x02 J0
U 1 1 621E1181
P 7450 1350
F 0 "J0" V 7368 1430 50  0000 C CNN
F 1 "Screw_Terminal_01x02" V 7413 1430 50  0001 L CNN
F 2 "TerminalBlock:TerminalBlock_Altech_AK300-2_P5.00mm" H 7450 1350 50  0001 C CNN
F 3 "~" H 7450 1350 50  0001 C CNN
	1    7450 1350
	0    1    1    0   
$EndComp
$Comp
L Connector:Screw_Terminal_01x02 J6
U 1 1 621F78E7
P 9900 3400
F 0 "J6" H 9818 3167 50  0000 C CNN
F 1 "Screw_Terminal_01x02" V 9863 3480 50  0001 L CNN
F 2 "TerminalBlock_RND:TerminalBlock_RND_205-00241_1x02_P10.16mm_Horizontal" H 9900 3400 50  0001 C CNN
F 3 "~" H 9900 3400 50  0001 C CNN
	1    9900 3400
	-1   0    0    1   
$EndComp
Wire Wire Line
	10500 3300 10100 3300
Wire Wire Line
	10500 3400 10100 3400
$Comp
L Connector:Screw_Terminal_01x02 J9
U 1 1 621B74B6
P 650 2500
F 0 "J9" H 568 2267 50  0000 C CNN
F 1 "Screw_Terminal_01x02" V 613 2580 50  0001 L CNN
F 2 "TerminalBlock_RND:TerminalBlock_RND_205-00241_1x02_P10.16mm_Horizontal" H 650 2500 50  0001 C CNN
F 3 "~" H 650 2500 50  0001 C CNN
	1    650  2500
	-1   0    0    -1  
$EndComp
$Comp
L Connector:Screw_Terminal_01x02 J10
U 1 1 621BF32D
P 650 3550
F 0 "J10" H 568 3317 50  0000 C CNN
F 1 "Screw_Terminal_01x02" V 613 3630 50  0001 L CNN
F 2 "TerminalBlock_RND:TerminalBlock_RND_205-00241_1x02_P10.16mm_Horizontal" H 650 3550 50  0001 C CNN
F 3 "~" H 650 3550 50  0001 C CNN
	1    650  3550
	-1   0    0    -1  
$EndComp
$Comp
L Connector:Screw_Terminal_01x02 J12
U 1 1 621D06D1
P 650 5800
F 0 "J12" H 568 5567 50  0000 C CNN
F 1 "Screw_Terminal_01x02" V 613 5880 50  0001 L CNN
F 2 "TerminalBlock_RND:TerminalBlock_RND_205-00241_1x02_P10.16mm_Horizontal" H 650 5800 50  0001 C CNN
F 3 "~" H 650 5800 50  0001 C CNN
	1    650  5800
	-1   0    0    -1  
$EndComp
$Comp
L Connector:Screw_Terminal_01x02 J13
U 1 1 621D7ECF
P 650 6900
F 0 "J13" H 568 6667 50  0000 C CNN
F 1 "Screw_Terminal_01x02" V 613 6980 50  0001 L CNN
F 2 "TerminalBlock_RND:TerminalBlock_RND_205-00241_1x02_P10.16mm_Horizontal" H 650 6900 50  0001 C CNN
F 3 "~" H 650 6900 50  0001 C CNN
	1    650  6900
	-1   0    0    -1  
$EndComp
Wire Wire Line
	1300 2100 850  2100
Wire Wire Line
	1200 2900 850  2900
Wire Wire Line
	1300 3200 850  3200
Wire Wire Line
	1200 4000 850  4000
Wire Wire Line
	1300 4300 850  4300
Wire Wire Line
	1200 6250 850  6250
Wire Wire Line
	1200 7350 850  7350
Connection ~ 900  1950
$Comp
L Connector:Screw_Terminal_01x02 J8
U 1 1 62195B2B
P 650 1300
F 0 "J8" H 568 1067 50  0000 C CNN
F 1 "Screw_Terminal_01x02" V 613 1380 50  0001 L CNN
F 2 "TerminalBlock_RND:TerminalBlock_RND_205-00241_1x02_P10.16mm_Horizontal" H 650 1300 50  0001 C CNN
F 3 "~" H 650 1300 50  0001 C CNN
	1    650  1300
	-1   0    0    -1  
$EndComp
Wire Wire Line
	900  750  900  1950
Wire Wire Line
	850  1750 1200 1750
Wire Wire Line
	1300 950  850  950 
Wire Wire Line
	850  1300 850  950 
Wire Wire Line
	850  1400 850  1750
Wire Wire Line
	850  2600 850  2900
Wire Wire Line
	850  2100 850  2500
Wire Wire Line
	900  5300 2050 5300
Wire Wire Line
	1300 5450 850  5450
Wire Wire Line
	1200 5100 850  5100
$Comp
L Connector:Screw_Terminal_01x02 J11
U 1 1 621C697E
P 650 4650
F 0 "J11" H 568 4417 50  0000 C CNN
F 1 "Screw_Terminal_01x02" V 613 4730 50  0001 L CNN
F 2 "TerminalBlock_RND:TerminalBlock_RND_205-00241_1x02_P10.16mm_Horizontal" H 650 4650 50  0001 C CNN
F 3 "~" H 650 4650 50  0001 C CNN
	1    650  4650
	-1   0    0    -1  
$EndComp
Wire Wire Line
	850  7000 850  7350
Wire Wire Line
	850  6900 850  6550
Wire Wire Line
	850  6550 1300 6550
Wire Wire Line
	850  5900 850  6250
Wire Wire Line
	850  5800 850  5450
Wire Wire Line
	850  3650 850  4000
Wire Wire Line
	850  3550 850  3200
Wire Wire Line
	900  5300 900  6400
Connection ~ 900  5300
Wire Wire Line
	850  4650 850  4300
Wire Wire Line
	900  4150 900  5300
Wire Wire Line
	850  5100 850  4750
Wire Wire Line
	6550 2200 6550 750 
Wire Wire Line
	5650 4000 5850 4000
Wire Wire Line
	5500 3700 5850 3700
Wire Wire Line
	5450 3100 5850 3100
Wire Wire Line
	5550 3000 5850 3000
Wire Wire Line
	7450 3300 7700 3300
Wire Wire Line
	7450 3400 7750 3400
Wire Wire Line
	7450 4200 7800 4200
Wire Wire Line
	7450 4300 7850 4300
Wire Wire Line
	5650 5150 8800 5150
Wire Wire Line
	5750 5100 5750 4100
Wire Wire Line
	5750 4100 5850 4100
Wire Wire Line
	5750 5100 9200 5100
Wire Wire Line
	5200 3800 5850 3800
Wire Wire Line
	5300 5900 5300 3900
Wire Wire Line
	5300 3900 5850 3900
Wire Wire Line
	5400 7000 3150 7000
Wire Wire Line
	5650 4000 5650 5150
Wire Wire Line
	7800 1500 7800 4200
$Comp
L Connector:Raspberry_Pi_2_3 J7
U 1 1 621780D7
P 6650 3500
F 0 "J7" H 6650 4981 50  0000 C CNN
F 1 "Raspberry_Pi_2_3" H 6650 4890 50  0000 C CNN
F 2 "Connector_PinHeader_2.00mm:PinHeader_2x20_P2.00mm_Vertical" H 6650 3500 50  0001 C CNN
F 3 "https://www.raspberrypi.org/documentation/hardware/raspberrypi/schematics/rpi_SCH_3bplus_1p0_reduced.pdf" H 6650 3500 50  0001 C CNN
	1    6650 3500
	1    0    0    -1  
$EndComp
Wire Wire Line
	5850 4200 5400 4200
$EndSCHEMATC
