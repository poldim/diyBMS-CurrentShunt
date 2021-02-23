EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 1
Title "DIYBMS Isolated Current Shunt"
Date "2021-02-22"
Rev "1"
Comp "Stuart Pittaway"
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L Analog_ADC:INA226 U3
U 1 1 6033803A
P 3630 1890
F 0 "U3" H 3630 2571 50  0000 C CNN
F 1 "INA228" H 3630 2480 50  0000 C CNN
F 2 "Package_SO:VSSOP-10_3x3mm_P0.5mm" H 4430 1440 50  0001 C CNN
F 3 "https://www.ti.com/lit/ds/symlink/ina228.pdf" H 3980 1790 50  0001 C CNN
F 4 "INA228" H 3630 1890 50  0001 C CNN "PartNumber"
	1    3630 1890
	1    0    0    -1  
$EndComp
$Comp
L MCU_Microchip_ATtiny:ATtiny1614-SS U2
U 1 1 6033859D
P 2020 4935
F 0 "U2" H 2020 5816 50  0000 C CNN
F 1 "ATtiny1614-SS" H 2020 5725 50  0000 C CNN
F 2 "Package_SO:SOIC-14_3.9x8.7mm_P1.27mm" H 2020 4935 50  0001 C CIN
F 3 "http://ww1.microchip.com/downloads/en/DeviceDoc/ATtiny1614-data-sheet-40001995A.pdf" H 2020 4935 50  0001 C CNN
F 4 "ATTINY1614-SSNR" H 2020 4935 50  0001 C CNN "PartNumber"
F 5 "C481364" H 2020 4935 50  0001 C CNN "LCSCStockCode"
	1    2020 4935
	1    0    0    -1  
$EndComp
$Comp
L Connector:Conn_01x01_Female J1
U 1 1 6033B58A
P 2040 1935
F 0 "J1" H 1932 1710 50  0000 C CNN
F 1 "Connection" H 2215 1800 50  0000 C CNN
F 2 "TestPoint:TestPoint_THTPad_2.5x2.5mm_Drill1.2mm" H 2040 1935 50  0001 C CNN
F 3 "~" H 2040 1935 50  0001 C CNN
	1    2040 1935
	-1   0    0    1   
$EndComp
$Comp
L Connector:Conn_01x01_Female J2
U 1 1 6033BFE9
P 2040 2240
F 0 "J2" H 1932 2015 50  0000 C CNN
F 1 "Connection" H 2195 2110 50  0000 C CNN
F 2 "TestPoint:TestPoint_THTPad_2.5x2.5mm_Drill1.2mm" H 2040 2240 50  0001 C CNN
F 3 "~" H 2040 2240 50  0001 C CNN
	1    2040 2240
	-1   0    0    1   
$EndComp
$Comp
L Device:R R1
U 1 1 6033CA17
P 2590 1935
F 0 "R1" V 2383 1935 50  0000 C CNN
F 1 "10R" V 2474 1935 50  0000 C CNN
F 2 "Resistor_SMD:R_0805_2012Metric" V 2520 1935 50  0001 C CNN
F 3 "~" H 2590 1935 50  0001 C CNN
F 4 "C17415" V 2590 1935 50  0001 C CNN "LCSCStockCode"
F 5 "" V 2590 1935 50  0001 C CNN "JLCPCBRotation"
F 6 "0805W8F100JT5E" H 2590 1935 50  0001 C CNN "PartNumber"
	1    2590 1935
	0    1    1    0   
$EndComp
$Comp
L Device:R R2
U 1 1 6033D0F2
P 2595 2240
F 0 "R2" V 2388 2240 50  0000 C CNN
F 1 "10R" V 2479 2240 50  0000 C CNN
F 2 "Resistor_SMD:R_0805_2012Metric" V 2525 2240 50  0001 C CNN
F 3 "~" H 2595 2240 50  0001 C CNN
F 4 "C17415" H 2595 2240 50  0001 C CNN "LCSCStockCode"
F 5 "0805W8F100JT5E" H 2595 2240 50  0001 C CNN "PartNumber"
	1    2595 2240
	0    1    1    0   
$EndComp
$Comp
L Device:C C1
U 1 1 6033D73E
P 4180 1205
F 0 "C1" H 4295 1251 50  0000 L CNN
F 1 "1uF" H 4295 1160 50  0000 L CNN
F 2 "Capacitor_SMD:C_0805_2012Metric" H 4218 1055 50  0001 C CNN
F 3 "~" H 4180 1205 50  0001 C CNN
F 4 "C28323" H 4180 1205 50  0001 C CNN "LCSCStockCode"
F 5 "CL21B105KBFNNNE" H 4180 1205 50  0001 C CNN "PartNumber"
	1    4180 1205
	1    0    0    -1  
$EndComp
$Comp
L Device:C C3
U 1 1 6033DA7C
P 4555 1205
F 0 "C3" H 4670 1251 50  0000 L CNN
F 1 "100nF" H 4670 1160 50  0000 L CNN
F 2 "Capacitor_SMD:C_0805_2012Metric" H 4593 1055 50  0001 C CNN
F 3 "" H 4555 1205 50  0001 C CNN
F 4 "C49678" H 4555 1205 50  0001 C CNN "LCSCStockCode"
F 5 "CC0805KRX7R9BB104" H 4555 1205 50  0001 C CNN "PartNumber"
	1    4555 1205
	1    0    0    -1  
$EndComp
Wire Wire Line
	2445 2240 2240 2240
Wire Wire Line
	2740 1935 3085 1935
Wire Wire Line
	3085 1935 3085 1990
Wire Wire Line
	3085 1990 3230 1990
Wire Wire Line
	3230 2090 3085 2090
Wire Wire Line
	3085 2090 3085 2240
Wire Wire Line
	3085 2240 2745 2240
Text Notes 675  1355 0    50   ~ 0
VIN- = Negative input to the device. \nhigh-side:connect to load side of sense resistor. \n\nVIN+ = Positive input to the device. \nhigh-side: connect to power supply side of sense resistor\n
Text Notes 655  2320 0    118  ~ 0
CHARGER/LOAD
Text Notes 1045 1995 0    118  ~ 0
BATTERY +
Wire Wire Line
	3630 1390 3630 1055
Wire Wire Line
	3630 1055 4180 1055
Wire Wire Line
	4555 1055 4375 1055
Connection ~ 4180 1055
Wire Wire Line
	4180 1355 4380 1355
$Comp
L power:GND #PWR05
U 1 1 60346015
P 4380 1355
F 0 "#PWR05" H 4380 1105 50  0001 C CNN
F 1 "GND" H 4385 1182 50  0000 C CNN
F 2 "" H 4380 1355 50  0001 C CNN
F 3 "" H 4380 1355 50  0001 C CNN
	1    4380 1355
	1    0    0    -1  
$EndComp
Connection ~ 4380 1355
Wire Wire Line
	4380 1355 4555 1355
$Comp
L power:GND #PWR02
U 1 1 60346651
P 3630 2390
F 0 "#PWR02" H 3630 2140 50  0001 C CNN
F 1 "GND" H 3635 2217 50  0000 C CNN
F 2 "" H 3630 2390 50  0001 C CNN
F 3 "" H 3630 2390 50  0001 C CNN
	1    3630 2390
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR03
U 1 1 6034693E
P 4130 1640
F 0 "#PWR03" H 4130 1390 50  0001 C CNN
F 1 "GND" H 4135 1467 50  0000 C CNN
F 2 "" H 4130 1640 50  0001 C CNN
F 3 "" H 4130 1640 50  0001 C CNN
	1    4130 1640
	1    0    0    -1  
$EndComp
Wire Wire Line
	4030 1590 4030 1640
Wire Wire Line
	4130 1640 4030 1640
Connection ~ 4030 1640
Wire Wire Line
	4030 1640 4030 1690
Wire Wire Line
	2240 1935 2370 1935
Wire Wire Line
	2370 1935 2370 1590
Wire Wire Line
	2370 1590 3230 1590
Connection ~ 2370 1935
Wire Wire Line
	2370 1935 2440 1935
$Comp
L Relay_SolidState:ASSR-1218 U1
U 1 1 60348748
P 4980 5005
F 0 "U1" H 4980 4688 50  0000 C CNN
F 1 "VO1400AEF" H 4980 4779 50  0000 C CNN
F 2 "Package_SO:SO-4_4.4x4.3mm_P2.54mm" H 4780 4805 50  0001 L CIN
F 3 "https://datasheet.lcsc.com/szlcsc/Vishay-Intertech-VO1400AEFTR_C142551.pdf" H 4980 5005 50  0001 L CNN
F 4 "VO1400AEF" H 4980 5005 50  0001 C CNN "PartNumber"
F 5 "C142551" H 4980 5005 50  0001 C CNN "LCSCStockCode"
	1    4980 5005
	1    0    0    -1  
$EndComp
Text Notes 5945 4737 2    47   ~ 0
SSR output over current/over voltage
$Comp
L power:+5V #PWR04
U 1 1 6034BFDE
P 4375 1055
F 0 "#PWR04" H 4375 905 50  0001 C CNN
F 1 "+5V" H 4390 1228 50  0000 C CNN
F 2 "" H 4375 1055 50  0001 C CNN
F 3 "" H 4375 1055 50  0001 C CNN
	1    4375 1055
	1    0    0    -1  
$EndComp
Connection ~ 4375 1055
Wire Wire Line
	4375 1055 4180 1055
$Comp
L Device:C C2
U 1 1 6034CB6F
P 2620 3910
F 0 "C2" H 2735 3956 50  0000 L CNN
F 1 "1uF" H 2735 3865 50  0000 L CNN
F 2 "Capacitor_SMD:C_0805_2012Metric" H 2658 3760 50  0001 C CNN
F 3 "~" H 2620 3910 50  0001 C CNN
F 4 "C28323" H 2620 3910 50  0001 C CNN "LCSCStockCode"
F 5 "CL21B105KBFNNNE" H 2620 3910 50  0001 C CNN "PartNumber"
	1    2620 3910
	1    0    0    -1  
$EndComp
$Comp
L Device:C C4
U 1 1 6034CB79
P 2995 3910
F 0 "C4" H 3110 3956 50  0000 L CNN
F 1 "100nF" H 3110 3865 50  0000 L CNN
F 2 "Capacitor_SMD:C_0805_2012Metric" H 3033 3760 50  0001 C CNN
F 3 "" H 2995 3910 50  0001 C CNN
F 4 "C49678" H 2995 3910 50  0001 C CNN "LCSCStockCode"
F 5 "CC0805KRX7R9BB104" H 2995 3910 50  0001 C CNN "PartNumber"
	1    2995 3910
	1    0    0    -1  
$EndComp
Wire Wire Line
	2995 3760 2815 3760
Connection ~ 2620 3760
Wire Wire Line
	2620 4060 2820 4060
$Comp
L power:GND #PWR07
U 1 1 6034CB87
P 2820 4060
F 0 "#PWR07" H 2820 3810 50  0001 C CNN
F 1 "GND" H 2945 3970 50  0000 C CNN
F 2 "" H 2820 4060 50  0001 C CNN
F 3 "" H 2820 4060 50  0001 C CNN
	1    2820 4060
	1    0    0    -1  
$EndComp
Connection ~ 2820 4060
Wire Wire Line
	2820 4060 2995 4060
$Comp
L power:+5V #PWR06
U 1 1 6034CB93
P 2815 3760
F 0 "#PWR06" H 2815 3610 50  0001 C CNN
F 1 "+5V" H 2830 3933 50  0000 C CNN
F 2 "" H 2815 3760 50  0001 C CNN
F 3 "" H 2815 3760 50  0001 C CNN
	1    2815 3760
	1    0    0    -1  
$EndComp
Connection ~ 2815 3760
Wire Wire Line
	2815 3760 2620 3760
Wire Wire Line
	2020 3760 2020 4235
Wire Wire Line
	2020 3760 2380 3760
$Comp
L power:GND #PWR01
U 1 1 603502E0
P 2020 5685
F 0 "#PWR01" H 2020 5435 50  0001 C CNN
F 1 "GND" H 2025 5512 50  0000 C CNN
F 2 "" H 2020 5685 50  0001 C CNN
F 3 "" H 2020 5685 50  0001 C CNN
	1    2020 5685
	1    0    0    -1  
$EndComp
Text GLabel 4380 1890 2    59   Input ~ 0
SDA
Text GLabel 4385 1990 2    59   Input ~ 0
SCL
Text GLabel 4380 2190 2    59   Input ~ 0
ALERT
Wire Wire Line
	4030 1890 4380 1890
Wire Wire Line
	4380 2190 4030 2190
Wire Wire Line
	4385 1990 4030 1990
Text GLabel 2620 4635 2    59   Input ~ 0
SDA
Text GLabel 2620 4735 2    59   Input ~ 0
SCL
Text GLabel 1420 4635 0    59   Input ~ 0
ALERT
$Comp
L Interface_UART:ADM2483xRW U4
U 1 1 6035C882
P 8475 5530
F 0 "U4" H 8440 4840 50  0000 L CNN
F 1 "ADM2483xRW" H 8440 4735 50  0000 L CNN
F 2 "Package_SO:SOIC-16W_7.5x10.3mm_P1.27mm" H 8475 4830 50  0001 C CNN
F 3 "https://www.analog.com/media/en/technical-documentation/data-sheets/adm2483.pdf" H 7725 5580 50  0001 C CNN
F 4 "ADM2483BRWZ-REEL" H 8475 5530 50  0001 C CNN "PartNumber"
F 5 "C9637" H 8475 5530 50  0001 C CNN "LCSCStockCode"
	1    8475 5530
	1    0    0    -1  
$EndComp
Text Notes 7450 1630 0    47   ~ 0
Note the "A" variant is important!
$Comp
L Device:R R3
U 1 1 60363112
P 7730 2055
F 0 "R3" V 7575 2060 50  0000 C CNN
F 1 "680k" V 7640 2055 50  0000 C CNN
F 2 "Resistor_SMD:R_0805_2012Metric" V 7660 2055 50  0001 C CNN
F 3 "~" H 7730 2055 50  0001 C CNN
F 4 "" V 7730 2055 50  0001 C CNN "JLC"
F 5 "0805W8F6803T5E" V 7730 2055 50  0001 C CNN "PartNumber"
F 6 "C17797" H 7730 2055 50  0001 C CNN "LCSCStockCode"
	1    7730 2055
	0    -1   -1   0   
$EndComp
$Comp
L Device:R R4
U 1 1 60363E02
P 7745 2545
F 0 "R4" H 7815 2591 50  0000 L CNN
F 1 "150k" H 7815 2500 50  0000 L CNN
F 2 "Resistor_SMD:R_0805_2012Metric" V 7675 2545 50  0001 C CNN
F 3 "~" H 7745 2545 50  0001 C CNN
F 4 "" H 7745 2545 50  0001 C CNN "JLC"
F 5 "0805W8F1503T5E" H 7745 2545 50  0001 C CNN "PartNumber"
F 6 "C17470" H 7745 2545 50  0001 C CNN "LCSCStockCode"
	1    7745 2545
	1    0    0    -1  
$EndComp
$Comp
L Connector:Screw_Terminal_01x02 J4
U 1 1 60366551
P 6790 1265
F 0 "J4" H 6790 1070 50  0000 C CNN
F 1 "ScrewTerminal" H 7270 1205 50  0000 C CNN
F 2 "CurrentShuntCircuit:Terminal-Block_3.81_2P-LCSC_C395878" H 6790 1265 50  0001 C CNN
F 3 "https://datasheet.lcsc.com/szlcsc/1912111437_DIBO-DB125-3-81-2P-GN_C395878.pdf" H 6790 1265 50  0001 C CNN
F 4 "C395878" H 6790 1265 50  0001 C CNN "LCSCStockCode"
	1    6790 1265
	-1   0    0    1   
$EndComp
$Comp
L power:GND #PWR08
U 1 1 6036808B
P 6990 1265
F 0 "#PWR08" H 6990 1015 50  0001 C CNN
F 1 "GND" H 6995 1092 50  0000 C CNN
F 2 "" H 6990 1265 50  0001 C CNN
F 3 "" H 6990 1265 50  0001 C CNN
	1    6990 1265
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR012
U 1 1 603685DD
P 7745 2795
F 0 "#PWR012" H 7745 2545 50  0001 C CNN
F 1 "GND" H 7750 2622 50  0000 C CNN
F 2 "" H 7745 2795 50  0001 C CNN
F 3 "" H 7745 2795 50  0001 C CNN
	1    7745 2795
	1    0    0    -1  
$EndComp
$Comp
L power:+BATT #PWR09
U 1 1 60368C54
P 7590 1165
F 0 "#PWR09" H 7590 1015 50  0001 C CNN
F 1 "+BATT" H 7605 1338 50  0000 C CNN
F 2 "" H 7590 1165 50  0001 C CNN
F 3 "" H 7590 1165 50  0001 C CNN
	1    7590 1165
	1    0    0    -1  
$EndComp
$Comp
L Device:Polyfuse F1
U 1 1 6036C4B0
P 7290 1165
F 0 "F1" V 7065 1165 50  0000 C CNN
F 1 "Through Hole PTC" V 7156 1165 50  0000 C CNN
F 2 "Fuse:Fuse_BelFuse_0ZRE0005FF_L8.3mm_W3.8mm" H 7340 965 50  0001 L CNN
F 3 "https://datasheet.lcsc.com/szlcsc/1912111437_Jinrui-Electronic-Materials-Co-JK250-120U_C369130.pdf" H 7290 1165 50  0001 C CNN
F 4 "C2680606" H 7290 1165 50  0001 C CNN "LCSCStockCode"
F 5 "JK250-100U" H 7290 1165 50  0001 C CNN "PartNumber"
	1    7290 1165
	0    1    1    0   
$EndComp
Wire Wire Line
	7440 1165 7590 1165
Wire Wire Line
	7140 1165 6990 1165
$Comp
L power:+BATT #PWR010
U 1 1 6036E410
P 6715 2055
F 0 "#PWR010" H 6715 1905 50  0001 C CNN
F 1 "+BATT" H 6730 2228 50  0000 C CNN
F 2 "" H 6715 2055 50  0001 C CNN
F 3 "" H 6715 2055 50  0001 C CNN
	1    6715 2055
	1    0    0    -1  
$EndComp
Wire Wire Line
	7230 2055 7475 2055
Wire Wire Line
	7880 2055 7975 2055
Wire Wire Line
	7975 1955 7475 1955
Wire Wire Line
	7475 1955 7475 2055
Connection ~ 7475 2055
Wire Wire Line
	7475 2055 7580 2055
Wire Wire Line
	7975 2255 7745 2255
Wire Wire Line
	7745 2255 7745 2395
Wire Wire Line
	7745 2795 7745 2695
$Comp
L Device:C C6
U 1 1 603749EE
P 7230 2205
F 0 "C6" H 7330 2205 50  0000 L CNN
F 1 "100nF 100V" H 7230 2110 50  0000 L CNN
F 2 "Capacitor_SMD:C_0805_2012Metric" H 7268 2055 50  0001 C CNN
F 3 "https://datasheet.lcsc.com/szlcsc/2008131833_KEMET-C0805C104K1RECAUTO_C696367.pdf" H 7230 2205 50  0001 C CNN
F 4 "" H 7230 2205 50  0001 C CNN "JLC"
F 5 "C0805C104K1RECAUTO" H 7230 2205 50  0001 C CNN "PartNumber"
F 6 "C696367" H 7230 2205 50  0001 C CNN "LCSCStockCode"
	1    7230 2205
	1    0    0    -1  
$EndComp
$Comp
L Device:C C5
U 1 1 6037567F
P 6915 2205
F 0 "C5" H 6710 2240 50  0000 L CNN
F 1 "1uF 100V" H 6435 2150 50  0000 L CNN
F 2 "Capacitor_SMD:C_1206_3216Metric" H 6953 2055 50  0001 C CNN
F 3 "https://datasheet.lcsc.com/szlcsc/Samsung-Electro-Mechanics-CL31B105KCHNNNE_C13832.pdf" H 6915 2205 50  0001 C CNN
F 4 "CL31B105KCHNNNE" H 6915 2205 50  0001 C CNN "PartNumber"
F 5 "" H 6915 2205 50  0001 C CNN "JLC"
F 6 "C13832" H 6915 2205 50  0001 C CNN "LCSCStockCode"
	1    6915 2205
	1    0    0    -1  
$EndComp
Wire Wire Line
	6715 2055 6915 2055
Wire Wire Line
	6915 2055 7230 2055
Connection ~ 6915 2055
Connection ~ 7230 2055
Wire Wire Line
	6915 2355 7065 2355
$Comp
L power:GND #PWR011
U 1 1 60379B5D
P 7065 2355
F 0 "#PWR011" H 7065 2105 50  0001 C CNN
F 1 "GND" H 7070 2182 50  0000 C CNN
F 2 "" H 7065 2355 50  0001 C CNN
F 3 "" H 7065 2355 50  0001 C CNN
	1    7065 2355
	1    0    0    -1  
$EndComp
Connection ~ 7065 2355
Wire Wire Line
	7065 2355 7230 2355
$Comp
L Device:C C7
U 1 1 6037A383
P 8905 1520
F 0 "C7" H 9020 1566 50  0000 L CNN
F 1 "1uF" H 9020 1475 50  0000 L CNN
F 2 "Capacitor_SMD:C_0805_2012Metric" H 8943 1370 50  0001 C CNN
F 3 "~" H 8905 1520 50  0001 C CNN
F 4 "" H 8905 1520 50  0001 C CNN "JLC"
F 5 "CL21B105KBFNNNE" H 8905 1520 50  0001 C CNN "PartNumber"
F 6 "C28323" H 8905 1520 50  0001 C CNN "LCSCStockCode"
	1    8905 1520
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR014
U 1 1 6037C285
P 8905 1670
F 0 "#PWR014" H 8905 1420 50  0001 C CNN
F 1 "GND" H 8910 1497 50  0000 C CNN
F 2 "" H 8905 1670 50  0001 C CNN
F 3 "" H 8905 1670 50  0001 C CNN
	1    8905 1670
	1    0    0    -1  
$EndComp
$Comp
L Device:C C8
U 1 1 6037C93B
P 9120 2205
F 0 "C8" H 9235 2251 50  0000 L CNN
F 1 "10nF" H 9235 2160 50  0000 L CNN
F 2 "Capacitor_SMD:C_0805_2012Metric" H 9158 2055 50  0001 C CNN
F 3 "~" H 9120 2205 50  0001 C CNN
F 4 "C1710" H 9120 2205 50  0001 C CNN "LCSCStockCode"
F 5 "CL21B103KBANNNC" H 9120 2205 50  0001 C CNN "PartNumber"
	1    9120 2205
	1    0    0    -1  
$EndComp
Wire Wire Line
	8775 2055 9120 2055
Wire Wire Line
	8775 2255 8880 2255
Wire Wire Line
	8880 2255 8880 2355
Wire Wire Line
	8880 2355 9120 2355
$Comp
L CurrentShuntLib:LM5009A U5
U 1 1 603867C3
P 8375 2155
F 0 "U5" H 8375 2622 50  0000 C CNN
F 1 "LM5009A" H 8375 2531 50  0000 C CNN
F 2 "Package_SO:MSOP-8_3x3mm_P0.65mm" H 8425 1705 50  0001 L CIN
F 3 "https://www.ti.com/lit/ds/symlink/lm5009a.pdf" H 8375 2155 50  0001 C CNN
F 4 "LM5009AMMX/NOPB" H 8375 2155 50  0001 C CNN "PartNumber"
F 5 "C477978" H 8375 2155 50  0001 C CNN "LCSCStockCode"
	1    8375 2155
	1    0    0    -1  
$EndComp
$Comp
L Device:D_Schottky D1
U 1 1 60388807
P 9640 2355
F 0 "D1" H 9640 2572 50  0000 C CNN
F 1 "400V 1A 1.3V @ 1A 150ns SMA" H 10145 2475 50  0000 C CNN
F 2 "Diode_SMD:D_SMA" H 9640 2355 50  0001 C CNN
F 3 "https://datasheet.lcsc.com/szlcsc/1810170425_Diodes-Incorporated-RS1G-13-F_C85103.pdf" H 9640 2355 50  0001 C CNN
F 4 "C85103" H 9640 2355 50  0001 C CNN "LCSCStockCode"
F 5 "RS1G-13-F" H 9640 2355 50  0001 C CNN "PartNumber"
	1    9640 2355
	1    0    0    -1  
$EndComp
Wire Wire Line
	8775 1955 8775 1370
Wire Wire Line
	8775 1370 8905 1370
Wire Wire Line
	9490 2355 9190 2355
Connection ~ 9120 2355
$Comp
L power:GND #PWR015
U 1 1 6038EB3D
P 9790 2355
F 0 "#PWR015" H 9790 2105 50  0001 C CNN
F 1 "GND" H 9935 2285 50  0000 C CNN
F 2 "" H 9790 2355 50  0001 C CNN
F 3 "" H 9790 2355 50  0001 C CNN
	1    9790 2355
	1    0    0    -1  
$EndComp
$Comp
L Device:R R5
U 1 1 6038F518
P 9350 2895
F 0 "R5" V 9557 2895 50  0000 C CNN
F 1 "470k" V 9466 2895 50  0000 C CNN
F 2 "Resistor_SMD:R_0805_2012Metric" V 9280 2895 50  0001 C CNN
F 3 "~" H 9350 2895 50  0001 C CNN
F 4 "C17709" H 9350 2895 50  0001 C CNN "LCSCStockCode"
F 5 "0805W8F4703T5E" H 9350 2895 50  0001 C CNN "PartNumber"
	1    9350 2895
	0    -1   -1   0   
$EndComp
$Comp
L Device:C C10
U 1 1 6038F94D
P 9805 2895
F 0 "C10" V 9945 2845 50  0000 L CNN
F 1 "3.3nF" V 10025 2830 50  0000 L CNN
F 2 "Capacitor_SMD:C_0805_2012Metric" H 9843 2745 50  0001 C CNN
F 3 "~" H 9805 2895 50  0001 C CNN
F 4 "C53175" H 9805 2895 50  0001 C CNN "LCSCStockCode"
F 5 "CL21B332KBANNNC" H 9805 2895 50  0001 C CNN "PartNumber"
	1    9805 2895
	0    1    1    0   
$EndComp
$Comp
L Device:C C9
U 1 1 60390805
P 9585 3175
F 0 "C9" H 9700 3221 50  0000 L CNN
F 1 "10nF" H 9700 3130 50  0000 L CNN
F 2 "Capacitor_SMD:C_0805_2012Metric" H 9623 3025 50  0001 C CNN
F 3 "~" H 9585 3175 50  0001 C CNN
F 4 "C1710" H 9585 3175 50  0001 C CNN "LCSCStockCode"
F 5 "CL21B103KBANNNC" H 9585 3175 50  0001 C CNN "PartNumber"
	1    9585 3175
	-1   0    0    1   
$EndComp
$Comp
L Device:L L1
U 1 1 60392A36
P 9465 2620
F 0 "L1" V 9655 2620 50  0000 C CNN
F 1 "1mH ±20% 250mA" V 9535 2320 50  0000 C CNN
F 2 "Inductor_SMD:L_TDK_SLF7045" H 9465 2620 50  0001 C CNN
F 3 "" H 9465 2620 50  0001 C CNN
F 4 "C91523" H 9465 2620 50  0001 C CNN "LCSCStockCode"
F 5 "SLF7045T-102MR14-PF" H 9465 2620 50  0001 C CNN "PartNumber"
	1    9465 2620
	0    -1   -1   0   
$EndComp
Wire Wire Line
	9190 2355 9190 2620
Wire Wire Line
	9190 2620 9200 2620
Connection ~ 9190 2355
Wire Wire Line
	9190 2355 9120 2355
Wire Wire Line
	9200 2895 9200 2620
Connection ~ 9200 2620
Wire Wire Line
	9200 2620 9315 2620
Wire Wire Line
	9500 2895 9585 2895
Wire Wire Line
	9585 3025 9585 2895
Connection ~ 9585 2895
Wire Wire Line
	9585 2895 9655 2895
Wire Wire Line
	8775 2455 8960 2455
Wire Wire Line
	8960 2455 8960 3345
Wire Wire Line
	8960 3345 9585 3345
Wire Wire Line
	9585 3345 9585 3325
Wire Wire Line
	9615 2620 9955 2620
Wire Wire Line
	9955 2620 9955 2895
$Comp
L Device:R R6
U 1 1 6039DE7D
P 10255 2770
F 0 "R6" H 10325 2816 50  0000 L CNN
F 1 "10k" H 10325 2725 50  0000 L CNN
F 2 "Resistor_SMD:R_0805_2012Metric" V 10185 2770 50  0001 C CNN
F 3 "~" H 10255 2770 50  0001 C CNN
F 4 "C17414" H 10255 2770 50  0001 C CNN "LCSCStockCode"
F 5 "0805W8F1002T5E" H 10255 2770 50  0001 C CNN "PartNumber"
	1    10255 2770
	1    0    0    -1  
$EndComp
$Comp
L Device:R R7
U 1 1 6039ECBB
P 10255 3220
F 0 "R7" H 10325 3266 50  0000 L CNN
F 1 "10k" H 10325 3175 50  0000 L CNN
F 2 "Resistor_SMD:R_0805_2012Metric" V 10185 3220 50  0001 C CNN
F 3 "~" H 10255 3220 50  0001 C CNN
F 4 "C17414" H 10255 3220 50  0001 C CNN "LCSCStockCode"
F 5 "0805W8F1002T5E" H 10255 3220 50  0001 C CNN "PartNumber"
	1    10255 3220
	1    0    0    -1  
$EndComp
Wire Wire Line
	10255 2620 9955 2620
Connection ~ 9955 2620
Wire Wire Line
	10255 2920 10255 2990
Wire Wire Line
	9585 3345 9975 3345
Wire Wire Line
	9975 3345 9975 2990
Wire Wire Line
	9975 2990 10255 2990
Connection ~ 9585 3345
Connection ~ 10255 2990
Wire Wire Line
	10255 2990 10255 3070
$Comp
L power:GND #PWR016
U 1 1 603A2E2F
P 10255 3470
F 0 "#PWR016" H 10255 3220 50  0001 C CNN
F 1 "GND" H 10260 3297 50  0000 C CNN
F 2 "" H 10255 3470 50  0001 C CNN
F 3 "" H 10255 3470 50  0001 C CNN
	1    10255 3470
	1    0    0    -1  
$EndComp
$Comp
L Device:C C11
U 1 1 603A3461
P 10850 2770
F 0 "C11" H 10965 2816 50  0000 L CNN
F 1 "47µF ±10% 16V Ceramic X5R" V 10595 2540 50  0000 L CNN
F 2 "Capacitor_SMD:C_1210_3225Metric" H 10888 2620 50  0001 C CNN
F 3 "https://search.murata.co.jp/Ceramy/image/img/A01X/G101/ENG/GRM32ER61C476KE15-01.pdf" H 10850 2770 50  0001 C CNN
F 4 "GRM32ER61C476KE15L" H 10850 2770 50  0001 C CNN "PartNumber"
F 5 "C77101" H 10850 2770 50  0001 C CNN "LCSCStockCode"
	1    10850 2770
	-1   0    0    1   
$EndComp
Wire Wire Line
	10255 2620 10850 2620
Connection ~ 10255 2620
Wire Wire Line
	10255 3370 10255 3425
Wire Wire Line
	10850 2920 10850 3425
Wire Wire Line
	10850 3425 10255 3425
Connection ~ 10255 3425
Wire Wire Line
	10255 3425 10255 3470
$Comp
L power:+5V #PWR017
U 1 1 603A9394
P 10995 2620
F 0 "#PWR017" H 10995 2470 50  0001 C CNN
F 1 "+5V" H 11010 2793 50  0000 C CNN
F 2 "" H 10995 2620 50  0001 C CNN
F 3 "" H 10995 2620 50  0001 C CNN
	1    10995 2620
	1    0    0    -1  
$EndComp
Wire Wire Line
	10995 2620 10850 2620
Connection ~ 10850 2620
$Comp
L power:GND #PWR013
U 1 1 603AC0DC
P 8375 2655
F 0 "#PWR013" H 8375 2405 50  0001 C CNN
F 1 "GND" H 8380 2482 50  0000 C CNN
F 2 "" H 8375 2655 50  0001 C CNN
F 3 "" H 8375 2655 50  0001 C CNN
	1    8375 2655
	1    0    0    -1  
$EndComp
Wire Notes Line
	5510 645  5480 645 
$Comp
L Device:R R8
U 1 1 603DF910
P 4430 4905
F 0 "R8" H 4500 4951 50  0000 L CNN
F 1 "330R" H 4500 4860 50  0000 L CNN
F 2 "Resistor_SMD:R_0805_2012Metric" V 4360 4905 50  0001 C CNN
F 3 "~" H 4430 4905 50  0001 C CNN
F 4 "C17630" H 4430 4905 50  0001 C CNN "LCSCStockCode"
F 5 "0805W8F3300T5E" H 4430 4905 50  0001 C CNN "PartNumber"
	1    4430 4905
	0    -1   -1   0   
$EndComp
Text GLabel 2060 6675 0    59   Input ~ 0
SDA
Text GLabel 2060 6575 0    59   Input ~ 0
SCL
$Comp
L power:+5V #PWR0101
U 1 1 603EBDDE
P 2500 6495
F 0 "#PWR0101" H 2500 6345 50  0001 C CNN
F 1 "+5V" H 2515 6668 50  0000 C CNN
F 2 "" H 2500 6495 50  0001 C CNN
F 3 "" H 2500 6495 50  0001 C CNN
	1    2500 6495
	1    0    0    -1  
$EndComp
$Comp
L Device:R R9
U 1 1 603EC275
P 2260 6575
F 0 "R9" H 2110 6505 50  0000 L CNN
F 1 "2k2" H 2075 6655 50  0000 L CNN
F 2 "Resistor_SMD:R_0805_2012Metric" V 2190 6575 50  0001 C CNN
F 3 "~" H 2260 6575 50  0001 C CNN
F 4 "C17520" H 2260 6575 50  0001 C CNN "LCSCStockCode"
F 5 "0805W8F2201T5E" H 2260 6575 50  0001 C CNN "PartNumber"
	1    2260 6575
	0    1    1    0   
$EndComp
$Comp
L Device:R R10
U 1 1 603ECB25
P 2260 6675
F 0 "R10" H 2315 6610 50  0000 L CNN
F 1 "2k2" H 2305 6755 50  0000 L CNN
F 2 "Resistor_SMD:R_0805_2012Metric" V 2190 6675 50  0001 C CNN
F 3 "~" H 2260 6675 50  0001 C CNN
F 4 "C17520" H 2260 6675 50  0001 C CNN "LCSCStockCode"
F 5 "0805W8F2201T5E" H 2260 6675 50  0001 C CNN "PartNumber"
	1    2260 6675
	0    1    1    0   
$EndComp
Wire Wire Line
	2410 6675 2500 6675
Wire Wire Line
	2500 6675 2500 6575
Wire Wire Line
	2410 6575 2500 6575
Connection ~ 2500 6575
Wire Wire Line
	2500 6575 2500 6495
Wire Wire Line
	2060 6575 2110 6575
Wire Wire Line
	2110 6675 2060 6675
$Comp
L power:+5V #PWR0102
U 1 1 603FB280
P 4105 5890
F 0 "#PWR0102" H 4105 5740 50  0001 C CNN
F 1 "+5V" H 4120 6063 50  0000 C CNN
F 2 "" H 4105 5890 50  0001 C CNN
F 3 "" H 4105 5890 50  0001 C CNN
	1    4105 5890
	1    0    0    -1  
$EndComp
Text GLabel 4105 5990 2    59   Input ~ 0
RESET
Text GLabel 2825 4535 2    59   Input ~ 0
RESET
Wire Wire Line
	2620 4535 2715 4535
$Comp
L Device:R R11
U 1 1 60402D64
P 2715 4385
F 0 "R11" H 2520 4390 50  0000 L CNN
F 1 "100K" H 2470 4325 50  0000 L CNN
F 2 "Resistor_SMD:R_0805_2012Metric" V 2645 4385 50  0001 C CNN
F 3 "~" H 2715 4385 50  0001 C CNN
F 4 "C17407" H 2715 4385 50  0001 C CNN "LCSCStockCode"
F 5 "0805W8F1003T5E" H 2715 4385 50  0001 C CNN "PartNumber"
	1    2715 4385
	-1   0    0    1   
$EndComp
Connection ~ 2715 4535
Wire Wire Line
	2715 4535 2825 4535
Wire Wire Line
	2380 3760 2380 4235
Wire Wire Line
	2380 4235 2715 4235
Connection ~ 2380 3760
Wire Wire Line
	2380 3760 2620 3760
Text GLabel 1420 4535 0    59   Input ~ 0
XDIR
Text GLabel 1420 4735 0    59   Input ~ 0
TXD
Text GLabel 1420 4835 0    59   Input ~ 0
RXD
$Comp
L Connector:Screw_Terminal_01x04 J5
U 1 1 6040F87C
P 9570 5370
F 0 "J5" H 9650 5362 50  0000 L CNN
F 1 "Screw_Terminal_01x04" H 9650 5271 50  0000 L CNN
F 2 "CurrentShuntCircuit:Terminal-Block_3.81_4P_LCSC_C395880" H 9570 5370 50  0001 C CNN
F 3 "~" H 9570 5370 50  0001 C CNN
F 4 "C395880" H 9570 5370 50  0001 C CNN "LCSCStockCode"
	1    9570 5370
	1    0    0    -1  
$EndComp
Wire Wire Line
	8675 4830 8845 4830
Wire Wire Line
	9370 4830 9370 5270
Wire Wire Line
	9075 5330 9235 5330
Wire Wire Line
	9235 5330 9235 5370
Wire Wire Line
	9235 5370 9370 5370
Wire Wire Line
	9370 5570 9370 6230
Wire Wire Line
	9370 6230 8675 6230
$Comp
L Device:R R12
U 1 1 60422214
P 9235 5520
F 0 "R12" V 9310 5455 50  0000 L CNN
F 1 "120R" V 9230 5420 50  0000 L CNN
F 2 "Resistor_SMD:R_0805_2012Metric" V 9165 5520 50  0001 C CNN
F 3 "~" H 9235 5520 50  0001 C CNN
F 4 "" H 9235 5520 50  0001 C CNN "LCSCStockCode"
F 5 "" H 9235 5520 50  0001 C CNN "PartNumber"
	1    9235 5520
	-1   0    0    1   
$EndComp
$Comp
L Jumper:SolderJumper_2_Bridged JP1
U 1 1 60423A0A
P 9235 5820
F 0 "JP1" V 9215 5985 50  0000 L CNN
F 1 "SolderJumper_2_Bridged" V 9285 5960 50  0000 L CNN
F 2 "Jumper:SolderJumper-2_P1.3mm_Bridged_Pad1.0x1.5mm" H 9235 5820 50  0001 C CNN
F 3 "~" H 9235 5820 50  0001 C CNN
	1    9235 5820
	0    1    1    0   
$EndComp
Connection ~ 9235 5370
Wire Wire Line
	9075 5530 9075 5970
Wire Wire Line
	9075 5970 9235 5970
Wire Wire Line
	9235 5970 9315 5970
Wire Wire Line
	9315 5970 9315 5470
Wire Wire Line
	9315 5470 9370 5470
Connection ~ 9235 5970
$Comp
L power:GND #PWR021
U 1 1 6042DC80
P 8275 6230
F 0 "#PWR021" H 8275 5980 50  0001 C CNN
F 1 "GND" H 8280 6057 50  0000 C CNN
F 2 "" H 8275 6230 50  0001 C CNN
F 3 "" H 8275 6230 50  0001 C CNN
	1    8275 6230
	1    0    0    -1  
$EndComp
Text GLabel 7460 5630 0    59   Input ~ 0
XDIR
Text GLabel 7875 5530 0    59   Input ~ 0
TXD
Text GLabel 7875 5730 0    59   Input ~ 0
RXD
$Comp
L Device:C C12
U 1 1 60437AD8
P 7545 4925
F 0 "C12" H 7660 4971 50  0000 L CNN
F 1 "100nF" H 7660 4880 50  0000 L CNN
F 2 "Capacitor_SMD:C_0805_2012Metric" H 7583 4775 50  0001 C CNN
F 3 "" H 7545 4925 50  0001 C CNN
F 4 "C49678" H 7545 4925 50  0001 C CNN "LCSCStockCode"
F 5 "CC0805KRX7R9BB104" H 7545 4925 50  0001 C CNN "PartNumber"
	1    7545 4925
	1    0    0    -1  
$EndComp
Wire Wire Line
	7545 4775 8015 4775
Wire Wire Line
	8275 4775 8275 4830
$Comp
L power:GND #PWR019
U 1 1 6043BCF1
P 7545 5075
F 0 "#PWR019" H 7545 4825 50  0001 C CNN
F 1 "GND" H 7550 4902 50  0000 C CNN
F 2 "" H 7545 5075 50  0001 C CNN
F 3 "" H 7545 5075 50  0001 C CNN
	1    7545 5075
	1    0    0    -1  
$EndComp
Wire Wire Line
	7875 5330 7460 5330
Wire Wire Line
	7460 5830 7875 5830
Wire Wire Line
	7460 5330 7460 5830
$Comp
L power:+5V #PWR020
U 1 1 604436FD
P 8015 4775
F 0 "#PWR020" H 8015 4625 50  0001 C CNN
F 1 "+5V" H 8030 4948 50  0000 C CNN
F 2 "" H 8015 4775 50  0001 C CNN
F 3 "" H 8015 4775 50  0001 C CNN
	1    8015 4775
	1    0    0    -1  
$EndComp
Connection ~ 8015 4775
Wire Wire Line
	8015 4775 8275 4775
$Comp
L Device:R R13
U 1 1 6044C50D
P 7575 6030
F 0 "R13" H 7380 6035 50  0000 L CNN
F 1 "10K" H 7330 5970 50  0000 L CNN
F 2 "Resistor_SMD:R_0805_2012Metric" V 7505 6030 50  0001 C CNN
F 3 "~" H 7575 6030 50  0001 C CNN
F 4 "C17414" H 7575 6030 50  0001 C CNN "LCSCStockCode"
F 5 "0805W8F1002T5E" H 7575 6030 50  0001 C CNN "PartNumber"
	1    7575 6030
	0    -1   -1   0   
$EndComp
Wire Wire Line
	7725 6030 7875 6030
$Comp
L power:+5V #PWR018
U 1 1 604541AD
P 7425 6030
F 0 "#PWR018" H 7425 5880 50  0001 C CNN
F 1 "+5V" H 7310 6080 50  0000 C CNN
F 2 "" H 7425 6030 50  0001 C CNN
F 3 "" H 7425 6030 50  0001 C CNN
	1    7425 6030
	1    0    0    -1  
$EndComp
$Comp
L Device:C C13
U 1 1 60455BA5
P 8845 4680
F 0 "C13" H 8960 4726 50  0000 L CNN
F 1 "100nF" H 8960 4635 50  0000 L CNN
F 2 "Capacitor_SMD:C_0805_2012Metric" H 8883 4530 50  0001 C CNN
F 3 "" H 8845 4680 50  0001 C CNN
F 4 "C49678" H 8845 4680 50  0001 C CNN "LCSCStockCode"
F 5 "CC0805KRX7R9BB104" H 8845 4680 50  0001 C CNN "PartNumber"
	1    8845 4680
	1    0    0    -1  
$EndComp
Connection ~ 8845 4830
Wire Wire Line
	8845 4830 9370 4830
Wire Wire Line
	8845 4480 8845 4530
Text GLabel 9050 6230 3    50   Input ~ 0
GND2
Text GLabel 8845 4480 0    50   Input ~ 0
GND2
$Comp
L Device:LED D2
U 1 1 6045D245
P 2775 6760
F 0 "D2" V 2814 6642 50  0000 R CNN
F 1 "GREEN" V 2723 6642 50  0000 R CNN
F 2 "LED_SMD:LED_0805_2012Metric" H 2775 6760 50  0001 C CNN
F 3 "~" H 2775 6760 50  0001 C CNN
F 4 "C2297" H 2775 6760 50  0001 C CNN "LCSCStockCode"
	1    2775 6760
	0    -1   -1   0   
$EndComp
$Comp
L Device:R R14
U 1 1 60468016
P 2775 6460
F 0 "R14" H 2580 6465 50  0000 L CNN
F 1 "330R" H 2530 6400 50  0000 L CNN
F 2 "Resistor_SMD:R_0805_2012Metric" V 2705 6460 50  0001 C CNN
F 3 "~" H 2775 6460 50  0001 C CNN
F 4 "C17630" H 2775 6460 50  0001 C CNN "LCSCStockCode"
F 5 "0805W8F3300T5E" H 2775 6460 50  0001 C CNN "PartNumber"
	1    2775 6460
	-1   0    0    1   
$EndComp
$Comp
L power:GND #PWR022
U 1 1 60469FB5
P 2775 6910
F 0 "#PWR022" H 2775 6660 50  0001 C CNN
F 1 "GND" H 2780 6737 50  0000 C CNN
F 2 "" H 2775 6910 50  0001 C CNN
F 3 "" H 2775 6910 50  0001 C CNN
	1    2775 6910
	1    0    0    -1  
$EndComp
Text GLabel 2620 5235 2    59   Input ~ 0
PA7
Text GLabel 2775 6310 1    59   Input ~ 0
PA7
$Comp
L Device:LED D3
U 1 1 60474258
P 3325 6755
F 0 "D3" V 3364 6637 50  0000 R CNN
F 1 "RED" V 3273 6637 50  0000 R CNN
F 2 "LED_SMD:LED_0805_2012Metric" H 3325 6755 50  0001 C CNN
F 3 "~" H 3325 6755 50  0001 C CNN
F 4 "C84256" H 3325 6755 50  0001 C CNN "LCSCStockCode"
	1    3325 6755
	0    -1   -1   0   
$EndComp
$Comp
L Device:R R15
U 1 1 60474264
P 3325 6455
F 0 "R15" H 3130 6460 50  0000 L CNN
F 1 "330R" H 3080 6395 50  0000 L CNN
F 2 "Resistor_SMD:R_0805_2012Metric" V 3255 6455 50  0001 C CNN
F 3 "~" H 3325 6455 50  0001 C CNN
F 4 "C17630" H 3325 6455 50  0001 C CNN "LCSCStockCode"
F 5 "0805W8F3300T5E" H 3325 6455 50  0001 C CNN "PartNumber"
	1    3325 6455
	-1   0    0    1   
$EndComp
$Comp
L power:GND #PWR0104
U 1 1 6047426E
P 3325 6905
F 0 "#PWR0104" H 3325 6655 50  0001 C CNN
F 1 "GND" H 3330 6732 50  0000 C CNN
F 2 "" H 3325 6905 50  0001 C CNN
F 3 "" H 3325 6905 50  0001 C CNN
	1    3325 6905
	1    0    0    -1  
$EndComp
Text GLabel 3325 6305 1    59   Input ~ 0
PA6
Text GLabel 2620 5135 2    59   Input ~ 0
PA6
Wire Wire Line
	4680 4905 4580 4905
$Comp
L power:GND #PWR0105
U 1 1 6048E3F5
P 4680 5105
F 0 "#PWR0105" H 4680 4855 50  0001 C CNN
F 1 "GND" H 4685 4932 50  0000 C CNN
F 2 "" H 4680 5105 50  0001 C CNN
F 3 "" H 4680 5105 50  0001 C CNN
	1    4680 5105
	1    0    0    -1  
$EndComp
Text GLabel 2620 5035 2    59   Input ~ 0
PA5
Text GLabel 4280 4905 0    59   Input ~ 0
PA5
$Comp
L Connector:Screw_Terminal_01x02 J6
U 1 1 6048F62B
P 5630 5005
F 0 "J6" H 5630 4810 50  0000 C CNN
F 1 "ScrewTerminal" H 5970 4940 50  0000 C CNN
F 2 "CurrentShuntCircuit:Terminal-Block_3.81_2P-LCSC_C395878" H 5630 5005 50  0001 C CNN
F 3 "https://datasheet.lcsc.com/szlcsc/1912111437_DIBO-DB125-3-81-2P-GN_C395878.pdf" H 5630 5005 50  0001 C CNN
F 4 "C395878" H 5630 5005 50  0001 C CNN "LCSCStockCode"
	1    5630 5005
	1    0    0    -1  
$EndComp
Wire Wire Line
	5280 4905 5430 4905
Wire Wire Line
	5430 4905 5430 5005
Wire Wire Line
	5430 5105 5280 5105
Text GLabel 2620 4835 2    59   Input ~ 0
PA3
Wire Wire Line
	2020 5685 2020 5635
Text GLabel 2620 4935 2    59   Input ~ 0
PA4
Text GLabel 4105 6990 2    59   Input ~ 0
PA4
$Comp
L Connector:Conn_01x12_Male J3
U 1 1 604C0657
P 3905 6390
F 0 "J3" H 3790 6700 50  0000 C CNN
F 1 "Debug/UPDI" V 3755 6230 50  0000 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x12_P2.54mm_Vertical" H 3905 6390 50  0001 C CNN
F 3 "~" H 3905 6390 50  0001 C CNN
F 4 "C50981" H 3905 6390 50  0001 C CNN "LCSCStockCode"
F 5 "" H 3905 6390 50  0001 C CNN "PartNumber"
	1    3905 6390
	1    0    0    -1  
$EndComp
Text GLabel 4105 6390 2    59   Input ~ 0
TXD
Text GLabel 4105 6490 2    59   Input ~ 0
RXD
$Comp
L power:GND #PWR026
U 1 1 604C270C
P 4450 6090
F 0 "#PWR026" H 4450 5840 50  0001 C CNN
F 1 "GND" H 4455 5917 50  0000 C CNN
F 2 "" H 4450 6090 50  0001 C CNN
F 3 "" H 4450 6090 50  0001 C CNN
	1    4450 6090
	1    0    0    -1  
$EndComp
Text GLabel 4105 6190 2    59   Input ~ 0
SCL
Text GLabel 4105 6290 2    59   Input ~ 0
SDA
Text Notes 7400 4235 0    118  ~ 0
RS485 Isolation
Text Notes 5770 785  0    118  ~ 0
Step Down Regulator (9 to 85V down to 5V)
Text Notes 865  3720 0    118  ~ 0
ATTINY1614
Text Notes 4540 4275 0    118  ~ 0
RELAY OUTPUT
Wire Wire Line
	4105 6090 4370 6090
Wire Notes Line
	11115 3785 5610 3785
Wire Notes Line
	5610 3785 5610 600 
Wire Notes Line
	6960 3880 6970 3880
Wire Notes Line
	6970 3880 6970 6430
Text Notes 4350 7015 0    50   ~ 0
Modbus Address
Text Notes 4450 6870 0    50   ~ 0
Baud Rate
Text GLabel 4105 6790 2    59   Input ~ 0
PA3
Text Notes 3920 6090 1    50   ~ 0
UPDI
Wire Wire Line
	4105 6690 4370 6690
Wire Wire Line
	4370 6690 4370 6090
Connection ~ 4370 6090
Wire Wire Line
	4370 6090 4450 6090
Wire Wire Line
	4105 6890 4370 6890
Wire Wire Line
	4370 6890 4370 6690
Connection ~ 4370 6690
Text GLabel 4105 6590 2    59   Input ~ 0
PA5
$EndSCHEMATC
