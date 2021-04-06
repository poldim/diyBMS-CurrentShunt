/*
 ____  ____  _  _  ____  __  __  ___    _  _  __
(  _ \(_  _)( \/ )(  _ \(  \/  )/ __)  ( \/ )/. |
 )(_) )_)(_  \  /  ) _ < )    ( \__ \   \  /(_  _)
(____/(____) (__) (____/(_/\/\_)(___/    \/   (_)

DIYBMS V4.0
CURRENT & VOLTAGE MONITORING SYSTEM BASEDO ON TEXAS INST. INA228

(c)2021 Stuart Pittaway

COMPILE THIS CODE USING PLATFORM.IO

LICENSE
Attribution-NonCommercial-ShareAlike 2.0 UK: England & Wales (CC BY-NC-SA 2.0 UK)
https://creativecommons.org/licenses/by-nc-sa/2.0/uk/

* Non-Commercial — You may not use the material for commercial purposes.
* Attribution — You must give appropriate credit, provide a link to the license, and indicate if changes were made.
  You may do so in any reasonable manner, but not in any way that suggests the licensor endorses you or your use.
* ShareAlike — If you remix, transform, or build upon the material, you must distribute your
  contributions under the same license as the original.
* No additional restrictions — You may not apply legal terms or technological measures
  that legally restrict others from doing anything the license permits.

** COMMERCIAL USE AND RESALE PROHIBITED **

*/

// ATTINY1614 (tinyAVR® 1-series of microcontrollers)
// http://ww1.microchip.com/downloads/en/DeviceDoc/ATtiny1614-data-sheet-40001995A.pdf

// MODBUS Protocol
// https://www.ni.com/en-gb/innovations/white-papers/14/the-modbus-protocol-in-depth.html

#if !defined(MODBUSDEFAULTBAUDRATE)
#error MODBUSDEFAULTBAUDRATE must be defined
#endif
#if !defined(MODBUSBASEADDRESS)
#error MODBUSBASEADDRESS must be defined
#endif
#if !defined(MODBUSSERIALCONFIG)
#error MODBUSSERIALCONFIG must be defined
#endif

#include <Arduino.h>
#include <avr/sleep.h>
#include <avr/power.h>
#include <avr/wdt.h>
#include <Wire.h>
#include <EEPROM.h>

#include <FastCRC.h>

FastCRC16 CRC16;

#include "main.h"
#include "settings.h"

#include "EmbeddedFiles_Defines.h"

#include "SimpleModbusSlave.h"

#define GREENLED_PIN_BITMAP PIN7_bm
#define REDLED_PIN_BITMAP PIN6_bm
#define RELAY_PIN_BITMAP PIN5_bm



typedef union
{
  double dblvalue;
  uint16_t word[2];
} DoubleUnionType;

const double full_scale_adc = 40.96;
const double CoulombsToAmpHours = 0.00027778;
const uint8_t INA228_I2C_Address = B1000000;

uint16_t ModBusBaudRate = MODBUSDEFAULTBAUDRATE;

uint8_t ModbusSlaveAddress = MODBUSBASEADDRESS;

bool relay_state = false;

unsigned long timer = 0;

#define combineBytes(high, low) (high << 8) + low

const uint16_t R_CONFIG = _BV(4); // ADCRANGE = 40.96mV scale

// This structure is held in EEPROM, it has the same register/values
// as the INA228 chip and is used to set the INA228 chip to the correct parameters on power up

// On initial power up (or EEPROM clear) these parameters are read from the INA228 chip
// to provide defaults.  Some values are overridden in code (like ADC_CONFIG and CONFIG)
// to configure to our prescribed needs.
struct eeprom_regs
{
  uint16_t R_ADC_CONFIG;
  uint16_t R_SHUNT_CAL;    //Shunt Calibration
  uint16_t R_SHUNT_TEMPCO; //Shunt Temperature Coefficient
  uint16_t R_DIAG_ALRT;
  uint16_t R_SOVL;
  uint16_t R_SUVL;
  uint16_t R_BOVL;
  uint16_t R_BUVL;
  uint16_t R_TEMP_LIMIT;
  uint16_t R_PWR_LIMIT;

  //Holds what alert events trigger the relay to turn on/high
  //uses the same values/mapping as enum DIAG_ALRT_FIELD
  uint16_t relay_trigger_bitmap;

  uint16_t shunt_max_current;
  uint16_t shunt_millivolt;

  double full_scale_current;
  double CURRENT_LSB;
  double RSHUNT;
};

eeprom_regs registers;

double amphour_in = 0;
double amphour_out = 0;

volatile bool ALERT_TRIGGERED = false;
uint16_t alert = 0;

volatile bool wdt_triggered = false;
volatile uint16_t wdt_triggered_count;

void ConfigurePorts()
{
  // PA1 = SDA
  // PA2 = SCL
  // PA3 = Baud Rate
  // PA4 = Modbus Address
  // PA5 = RELAY OUTPUT
  // PA6 = RED LED
  // PA7 = GREEN LED

  // Set pins as Outputs (other pins are inputs)
  PORTA.DIR = GREENLED_PIN_BITMAP | REDLED_PIN_BITMAP | RELAY_PIN_BITMAP;

  //Relay off by default
  PORTA.OUTCLR = RELAY_PIN_BITMAP;

  // Set Port B digital outputs
  // PB0 = XDIR (RS485 transmit enable)
  // PB1 = ALERT
  // PB2 = TX (has to be set as output on tiny1614)
  // PB3 = RX
  // Set pins as Outputs (other pins are inputs)
  PORTB.DIR = PIN0_bm | PIN2_bm;
  PORTB.PIN1CTRL = PORT_PULLUPEN_bm | PORT_ISC_enum::PORT_ISC_BOTHEDGES_gc;

  PORTB.OUTSET = PIN2_bm; // TX is high

  USART0.CTRLB = USART_RXEN_bm | USART_TXEN_bm; //enable rx and tx
  //Enable interrupts
  sei();
}

// Read the jumper pins
void ReadJumperPins()
{
  //Switch pull ups on for the pins, if they are jumpered they are pulled to ground
  PORTA.PIN3CTRL = PORT_PULLUPEN_bm;
  PORTA.PIN4CTRL = PORT_PULLUPEN_bm;

  // PA3 = Baud Rate
  // PA4 = Modbus Address

  //High value means unconnected/not jumpered
  bool BaudRateJumper = (PORTA.IN & PIN3_bm);
  bool AddressJumper = (PORTA.IN & PIN4_bm);

  //TODO: Do something with the above jumper settings

  if (BaudRateJumper == false)
  {
    //Half the default baud rate if the jumper is connected, so 19200 goes to 9600
    ModBusBaudRate = ModBusBaudRate / 2;
  }

  if (AddressJumper == false)
  {
    //Jumper connected, increase address by 8
    ModbusSlaveAddress += 8;
  }

  //Switch off pull ups
  PORTA.PIN3CTRL = 0;
  PORTA.PIN4CTRL = 0;
}

void RedLED(bool value)
{
  if (value)
  {
    PORTA.OUTSET = REDLED_PIN_BITMAP;
  }
  else
  {
    PORTA.OUTCLR = REDLED_PIN_BITMAP;
  }
}

void GreenLED(bool value)
{
  if (value)
  {
    PORTA.OUTSET = GREENLED_PIN_BITMAP;
  }
  else
  {
    PORTA.OUTCLR = GREENLED_PIN_BITMAP;
  }
}

void EnableWatchdog()
{
  wdt_triggered = false;

  // Enter protection mode
  CCP = 0xD8;

  //8 seconds
  WDT.CTRLA = WDT_PERIOD_enum::WDT_PERIOD_8KCLK_gc;

  wdt_reset();
}

/*
void DisableSerial0TX()
{
  //On tiny1614 this saves about 10mA of current
  USART0.CTRLB &= ~(USART_TXEN_bm); // Transmitter Enable bit mask.
}

void EnableSerial0TX()
{
  //When the transmitter is disabled, it will no longer override the TXD pin, and the pin
  //direction is automatically set as input by hardware, even if it was configured as output by the user
  //PB2 as OUTPUT
  PORTB.DIRSET = PIN2_bm;
  USART0.CTRLB |= USART_TXEN_bm; // Transmitter Enable bit mask. 
}
*/

void WatchdogTriggered()
{
  // This is the watchdog timer - something went wrong and no serial activity received in over 8 seconds
  wdt_triggered = true;
  wdt_triggered_count++;
}

bool i2c_writeword(const uint8_t inareg, const uint16_t data)
{
  Wire.beginTransmission(INA228_I2C_Address);
  Wire.write(inareg);
  Wire.write((uint8_t)(data >> 8)); // Write the first (MSB) byte
  Wire.write((uint8_t)data);        // and then the second byte
  uint8_t result = Wire.endTransmission();

  //Delay after making a write to INA chip
  delayMicroseconds(10);

  return result == 0;
}

int16_t i2c_readword(const uint8_t inareg)
{
  Wire.beginTransmission(INA228_I2C_Address);
  Wire.write(inareg);
  Wire.endTransmission();
  delayMicroseconds(10);
  Wire.requestFrom(INA228_I2C_Address, (uint8_t)2); // Request 2 bytes

  while (!Wire.available())
  {
  };

  uint8_t a, b;
  a = Wire.read();
  b = Wire.read();

  return ((uint16_t)a << 8) | b;
}

uint32_t i2c_readUint24(const uint8_t inareg)
{
  Wire.beginTransmission(INA228_I2C_Address);
  Wire.write(inareg);
  Wire.endTransmission();

  delayMicroseconds(10);
  Wire.requestFrom(INA228_I2C_Address, (uint8_t)3); // Request 3 bytes
  while (!Wire.available())
  {
  };
  uint8_t a, b, c;
  a = Wire.read();
  b = Wire.read();
  c = Wire.read();

  uint32_t reply = (uint32_t)a << 16;
  reply += (uint32_t)b << 8;
  reply += (uint32_t)c;

  return reply;
}

uint64_t i2c_readUint40(const uint8_t inareg)
{
  Wire.beginTransmission(INA228_I2C_Address);
  Wire.write(inareg);
  Wire.endTransmission();
  delayMicroseconds(10);
  Wire.requestFrom(INA228_I2C_Address, (uint8_t)5); // Request 5 bytes
  while (!Wire.available())
  {
  };
  uint8_t a, b, c, d, e;
  a = Wire.read();
  b = Wire.read();
  c = Wire.read();
  d = Wire.read();
  e = Wire.read();

  uint64_t reply = (uint64_t)a << 32;
  reply += (uint64_t)b << 24;
  reply += (uint64_t)c << 16;
  reply += (uint64_t)d << 8;
  reply += (uint64_t)e;

  return reply;
}

int64_t i2c_readInt40(const uint8_t inareg)
{
  Wire.beginTransmission(INA228_I2C_Address);
  Wire.write(inareg);
  Wire.endTransmission();
  delayMicroseconds(10);
  Wire.requestFrom(INA228_I2C_Address, (uint8_t)5); // Request 5 bytes

  uint8_t a, b, c, d, e;
  a = Wire.read();
  b = Wire.read();
  c = Wire.read();
  d = Wire.read();
  e = Wire.read();

  //Check if a twos compliment negative number
  uint64_t reply = (a & 0x80) ? (uint64_t)0xFFFFFF0000000000 : 0;

  reply += (uint64_t)a << 32;
  reply += (uint64_t)b << 24;
  reply += (uint64_t)c << 16;
  reply += (uint64_t)d << 8;
  reply += (uint64_t)e;

  //Cast to signed integer
  return (int64_t)reply;
}

//Read a 24 bit (3 byte) TWOS COMPLIMENT integer
int32_t i2c_readInt24(const uint8_t inareg)
{
  uint32_t value = (i2c_readUint24(inareg) & (uint32_t)0xFFFFF0) >> 4;

  //Is the signed bit set (bit 20)
  if (value & 0x80000UL)
  {
    //Set bits 24 to 32 to indicate negative number (twos compliment)
    value |= 0xfff00000UL;
  }

  return (int32_t)value;
}

void i2c_error()
{
  //Halt here with an error, i2c comms with INA228 failed
  for (size_t i = 0; i < 100; i++)
  {
    wdt_reset();
    RedLED(true);
    delay(50);
    RedLED(false);
    delay(50);
  }

  //Finally just hang - this will trigger the watchdog causing a reboot
  delay(10000);
}

void ResetChargeEnergyRegisters()
{
  //BIT 14
  //Resets the contents of accumulation registers ENERGY and CHARGE to 0
  //0h = Normal Operation
  //1h = Clears registers to default values for ENERGY and CHARGE registers

  if (!i2c_writeword(INA_REGISTER::CONFIG, R_CONFIG | 0x1000))
  {
    i2c_error();
  }
}

volatile uint16_t diag_alrt_value = 0;

void SetINA228Registers()
{
  uint8_t result = 0;
  result += i2c_writeword(INA_REGISTER::SHUNT_CAL, registers.R_SHUNT_CAL);
  result += i2c_writeword(INA_REGISTER::SHUNT_TEMPCO, registers.R_SHUNT_TEMPCO);
  result += i2c_writeword(INA_REGISTER::SOVL, registers.R_SOVL);
  result += i2c_writeword(INA_REGISTER::SUVL, registers.R_SUVL);
  result += i2c_writeword(INA_REGISTER::BOVL, registers.R_BOVL);
  result += i2c_writeword(INA_REGISTER::BUVL, registers.R_BUVL);
  result += i2c_writeword(INA_REGISTER::TEMP_LIMIT, registers.R_TEMP_LIMIT);
  result += i2c_writeword(INA_REGISTER::PWR_LIMIT, registers.R_PWR_LIMIT);

  if (result != 8)
  {
    i2c_error();
  }
}

void SaveConfig()
{
  WriteConfigToEEPROM((uint8_t *)&registers, sizeof(eeprom_regs));
}

bool SetRegister(uint16_t address, uint16_t value)
{
  static DoubleUnionType newvalue;

  switch (address)
  {
  case 4:
  case 6:
  case 22:
  case 24:
  case 26:
  case 28:
  case 30:
  {
    //Set word[0] in preperation for the next register to be written
    newvalue.word[0] = value;
    break;
  }

  case 5:
  {
    //amphour_out
    newvalue.word[1] = value;
    amphour_out = newvalue.dblvalue;
    break;
  }

  case 7:
  {
    //amphour_in
    newvalue.word[1] = value;
    amphour_in = newvalue.dblvalue;
    break;
  }

  case 9:
  {
    //Watchdog timer trigger count (like error counter)
    wdt_triggered_count = value;
    break;
  }

  case 18:
  {
    registers.shunt_max_current = value;
    CalculateLSB();
    break;
  }
  case 19:
  {
    registers.shunt_millivolt = value;
    CalculateLSB();
    break;
  }

  case 20:
  {
    //SHUNT_CAL register
    registers.R_SHUNT_CAL = value;
    break;
  }

  case 21:
  {
    //temperature limit
    //Case unsigned to int16 to cope with negative temperatures
    registers.R_TEMP_LIMIT = (int16_t)value / (double)0.0078125;
    break;
  }

  case 23:
  {
    //Bus Overvoltage (overvoltage protection).
    //Unsigned representation, positive value only. Conversion factor: 3.125 mV/LSB.
    //BusOverVolt.dblvalue = ((double)(uint16_t)i2c_readword(INA_REGISTER::BOVL)) * 0.003125F;
    newvalue.word[1] = value;
    registers.R_BOVL = newvalue.dblvalue / 0.003125F;
    //TODO: Save the new value
    break;
  }

  case 25:
  {
    //Bus under voltage
    newvalue.word[1] = value;
    registers.R_BUVL = newvalue.dblvalue / 0.003125F;
    break;
  }

  case 27:
  {
    //Shunt Over Voltage Limit (current limit)
    newvalue.word[1] = value;
    registers.R_SOVL = (newvalue.dblvalue * 1000 / 1.25) * full_scale_adc / registers.full_scale_current;

    break;
  }

  case 29:
  {
    //Shunt UNDER Voltage Limit (under current limit)
    newvalue.word[1] = value;
    registers.R_SUVL = (newvalue.dblvalue * 1000 / 1.25) * full_scale_adc / registers.full_scale_current;
    break;
  }

  case 31:
  {
    //Shunt Over POWER LIMIT
    newvalue.word[1] = value;
    registers.R_PWR_LIMIT = (uint16_t)(newvalue.dblvalue / 256.0 / 3.2 / registers.CURRENT_LSB);
    break;
  }

  case 32:
  {
    //Shunt Temperature Coefficient
    registers.R_SHUNT_TEMPCO = value;
    break;
  }

  default:
  {
    return false;
    break;
  }
  }

  SaveConfig();
  SetINA228Registers();

  return true;
}

void ConfigureI2C()
{
  // join i2c bus (address optional for master)
  Wire.begin();
  //Change TWI pins to use PA1/PA2 and not PB1/PB0
  Wire.swap(1);
  //Use fast i2c
  Wire.setClock(400000);

  //See if the device is connected/soldered on board
  Wire.beginTransmission(INA228_I2C_Address); // transmit to device
  if (Wire.endTransmission() > 0)
  {
    i2c_error();
  }

  //Now we know the INA228 is connected, reset to power on defaults
  if (!i2c_writeword(INA_REGISTER::CONFIG, (uint16_t)_BV(15)))
  {
    i2c_error();
  }

  //Allow the reset to work
  delay(100);

  //Get the INA chip model number (make sure we are dealing with an INA228)

  //Clear lower 4 bits, holds chip revision (zero in my case)
  int16_t dieid = i2c_readword(INA_REGISTER::DIE_ID);
  dieid = (dieid & 0xFFF0) >> 4;
  //INA228 chip
  if (dieid != 0x228)
  {
    i2c_error();
  }

  // Configure our registers (after reset)
  if (!i2c_writeword(INA_REGISTER::CONFIG, R_CONFIG))
  {
    i2c_error();
  }

  if (!i2c_writeword(INA_REGISTER::ADC_CONFIG, registers.R_ADC_CONFIG))
  {
    i2c_error();
  }

  //Shunt cal
  if (!i2c_writeword(INA_REGISTER::SHUNT_CAL, registers.R_SHUNT_CAL))
  {
    i2c_error();
  }

  //SLOWALERT ALATCH
  if (!i2c_writeword(INA_REGISTER::DIAG_ALRT, registers.R_DIAG_ALRT))
  {
    i2c_error();
  }

  //Check MEMSTAT=1 which proves the INA chip is not corrupt
  diag_alrt_value = i2c_readword(INA_REGISTER::DIAG_ALRT);
  if (diag_alrt_value & bit(DIAG_ALRT_FIELD::MEMSTAT) == 0)
  {
    //MEMSTAT
    //This bit is set to 0 if a checksum error is detected in the device trim memory space.
    //0h = Memory Checksum Error
    //1h = Normal Operation
    i2c_error();
  }

  SetINA228Registers();

  /*
  //Sets the threshold for comparison of the value to detect Bus Overvoltage (overvoltage protection).
  //Unsigned representation, positive value only. Conversion factor: 3.125 mV/LSB.
  uint16_t BusOvervoltageThreshold = (uint16_t)(12.0F / 0.003125F) & 0x7FFFU;
  i2c_writeword(INA_REGISTER::BOVL, BusOvervoltageThreshold);

  //5Volt
  //uint16_t BusUndervoltageThreshold = (uint16_t)(5.0F / 0.003125F) & 0x7FFFU;
  //i2c_writeword(INA_REGISTER::BUVL, BusUndervoltageThreshold);

  //Sets the threshold for comparison of the value to detect power overlimit measurements. Unsigned representation, positive value only.
  //The value entered in this field compares directly against the value from the POWER register to determine if an
  //over power condition exists. Conversion factor: 256 × Power LSB.
  //uint16_t PowerOverLimitThreshold = (uint16_t)(100);
  //i2c_writeword(INA_REGISTER::PWR_LIMIT, PowerOverLimitThreshold);

  //Current limit based on mV scale on shunt
  //Sets the threshold for comparison of the value to detect Shunt Overvoltage (overcurrent protection). Two's complement value.
  //Conversion Factor: 1.25 µV/LSB when ADCRANGE = 1.

  //Alert over current at 0.725A
  const double x = (1.0 / full_scale_current) * full_scale_adc;
  int16_t CurrentOverThreshold = (x * 1000.0 / 1.25);
  i2c_writeword(INA_REGISTER::SOVL, CurrentOverThreshold);

  //Negative (limit current whilst charging)
  const double y = (-0.500 / full_scale_current) * full_scale_adc;
  int16_t CurrentUnderThreshold = (y * 1000.0 / 1.25);
  i2c_writeword(INA_REGISTER::SUVL, CurrentUnderThreshold);
  */
}

void CalculateLSB()
{
  //150A@50mV shunt =   122.88A @ 40.96mV (full scale ADC)
  // Each LSB on the 20 bit ADC (524288 possibl values) is 122.88/524288 = 0.000234375A
  // Resistance (RSHUNT) = 0.00033333333333

  // Shunt calibration = 52428800000 * 0.000234375 * 0.00033333333333 = 4095.999999 = 4096

  registers.full_scale_current = ((double)registers.shunt_max_current / (double)registers.shunt_millivolt) * full_scale_adc;
  registers.RSHUNT = ((double)registers.shunt_millivolt / 1000.0) / (double)registers.shunt_max_current;
  registers.CURRENT_LSB = registers.full_scale_current / (double)0x80000;
  registers.R_SHUNT_CAL = 4 * 13107200000 * registers.CURRENT_LSB * registers.RSHUNT;
}

void setup()
{
  //Did we have a watchdog reboot?
  if (RSTCTRL.RSTFR & RSTCTRL_WDRF_bm)
  {
    // Must be first line of code
    WatchdogTriggered();
  }
  else
  {
    wdt_triggered_count = 0;
  }

  ConfigurePorts();
  RedLED(false);
  GreenLED(false);
  EnableWatchdog();

  if (ReadConfigFromEEPROM((uint8_t *)&registers, sizeof(eeprom_regs)) == false)
  {
    //Flash RED led 5 times to indicate facory reset
    for (size_t i = 0; i < 5; i++)
    {
      RedLED(true);
      delay(200);
      RedLED(false);
      delay(200);
    }

    //EEPROM is invalid, so apply "factory" defaults

    //Clear structure
    memset(&registers, 0, sizeof(eeprom_regs));

    //Conversion times for voltage and current = 2074us
    //temperature = 540us
    //256 times sample averaging
    // 1111 = Continuous bus, shunt voltage and temperature
    // 110 = 6h = 2074 µs BUS VOLT
    // 110 = 6h = 2074 µs CURRENT
    // 100 = 4h = 540 µs TEMPERATURE
    // 101 = 5h = 256 ADC sample averaging count
    // B1111 110 110 100 101
    //                   AVG
    registers.R_ADC_CONFIG = 0xFDA5;

    //Default 150A shunt @ 50mV scale
    registers.R_SHUNT_CAL = 0x1000;
    registers.shunt_max_current = 150;
    registers.shunt_millivolt = 50;

    //SLOWALERT = Wait for full sample averaging time before triggering alert (about 1.5 seconds)
    registers.R_DIAG_ALRT = bit(DIAG_ALRT_FIELD::SLOWALERT);

    //This is not enabled by default
    //The 16 bit register provides a resolution of 1ppm/°C/LSB
    registers.R_SHUNT_TEMPCO = 15;

    //Read the defaults from the INA228 chip as a starting point
    registers.R_SOVL = 0x7FFF;
    registers.R_SUVL = 0x8000;
    //85volt max
    registers.R_BOVL = 0x6A40; //i2c_readword(INA_REGISTER::BOVL);
    registers.R_BUVL = 0;
    registers.R_TEMP_LIMIT = 0x2800; //80 degrees C

    CalculateLSB();

    //Default Power limit = 5kW
    registers.R_PWR_LIMIT = (uint16_t)((5000.0 / registers.CURRENT_LSB / 3.2) / 256.0); //5kW

    //By default, trigger relay on all alerts
    registers.relay_trigger_bitmap = ALL_ALERT_BITS;
  }

  for (size_t i = 0; i < 6; i++)
  {
    GreenLED(true);
    if (wdt_triggered)
    {
      RedLED(true);
    }
    delay(50);
    GreenLED(false);
    if (wdt_triggered)
    {
      RedLED(false);
    }
    delay(150);
  }

  ReadJumperPins();

  //Disable RS485 receiver (debug!)
  PORTB.OUTSET = PIN0_bm;
  PORTB.PIN0CTRL = 0;

  ConfigureI2C();

  //Serial uses PB2/PB3 and PB0 for XDIR
  Serial.begin(ModBusBaudRate, MODBUSSERIALCONFIG);

  //0x01= Enables RS-485 mode with control of an external line driver through a dedicated Transmit Enable (TE) pin.
  //USART0.CTRLA |= B00000001;

  wdt_triggered = false;

  modbus_configure(&Serial, ModBusBaudRate);
}

double BusVoltage()
{
  //Bus voltage output. Two's complement value, however always positive.  Value in bits 23 to 4
  //195.3125uV per LSB
  return (double)195.3125 * (double)i2c_readInt24(INA_REGISTER::VBUS) / 1000000.0;
}

double ShuntVoltage()
{
  //Shunt voltage in MILLIVOLTS mV (Two's complement value)
  //78.125 nV/LSB
  return (double)78.125 * (double)i2c_readInt24(INA_REGISTER::VSHUNT) / 1e+6;
}

//Energy in JOULES
double Energy()
{
  uint64_t energy = i2c_readUint40(INA_REGISTER::ENERGY);
  return 16.0 * 3.2 * registers.CURRENT_LSB * energy;
}

// Charge in Coulombs
double Charge()
{
  int64_t charge = i2c_readInt40(INA_REGISTER::CHARGE);
  return registers.CURRENT_LSB * (int32_t)charge;
}

double Power()
{
  //Calculated power output.
  //Output value in watts.
  //Unsigned representation. Positive value.
  //POWER Power [W] = 3.2 x CURRENT_LSB x POWER
  return (double)i2c_readUint24(INA_REGISTER::POWER) * (double)3.2 * registers.CURRENT_LSB;
}

double DieTemperature()
{
  //The INA228 device has an internal temperature sensor which can measure die temperature from –40 °C to +125
  //°C. The accuracy of the temperature sensor is ±2 °C across the operational temperature range. The temperature
  //value is stored inside the DIETEMP register and can be read through the digital interface
  //Internal die temperature measurement. Two's complement value. Conversion factor: 7.8125 m°C/LSB

  //Case unsigned to int16 to cope with negative temperatures
  double dietemp = (int16_t)i2c_readword(INA_REGISTER::DIETEMP);

  return dietemp * (double)0.0078125;
}

double TemperatureLimit()
{
  //Case unsigned to int16 to cope with negative temperatures
  double temp = (int16_t)i2c_readword(INA_REGISTER::TEMP_LIMIT);

  return temp * (double)0.0078125;
}

double Current()
{
  //Current.
  //Calculated current output in Amperes. Two's complement value.
  return registers.CURRENT_LSB * (double)i2c_readInt24(INA_REGISTER::CURRENT);
}

ISR(PORTB_PORT_vect)
{
  uint8_t flags = PORTB.INTFLAGS;
  PORTB.INTFLAGS = flags; //clear flags

  if (flags && PIN1_bm)
  {
    //INA228 has triggered an ALERT interrupt
    RedLED(true);
    ALERT_TRIGGERED = true;
  }
}

//Modbus command 2 Read Discrete Inputs
//This assumes the byte array pointed to by *frame has been
//zeroed by the caller
uint8_t ReadDiscreteInputs(uint16_t address, uint16_t quantity, uint8_t *frame)
{
  uint8_t ptr = 0;

  uint16_t config = i2c_readword(INA_REGISTER::CONFIG);
  uint16_t adc_config = i2c_readword(INA_REGISTER::ADC_CONFIG);

  uint8_t bitPosition = 0;
  for (size_t i = address; i < address + quantity; i++)
  {
    bool outcome = false;
    switch (i)
    {

    case 0:
    {
      outcome = diag_alrt_value & bit(DIAG_ALRT_FIELD::TMPOL);
      break;
    }
    case 1:
    {
      outcome = diag_alrt_value & bit(DIAG_ALRT_FIELD::SHNTOL);
      break;
    }
    case 2:
    {
      outcome = diag_alrt_value & bit(DIAG_ALRT_FIELD::SHNTUL);
      break;
    }
    case 3:
    {
      outcome = diag_alrt_value & bit(DIAG_ALRT_FIELD::BUSOL);
      break;
    }
    case 4:
    {
      outcome = diag_alrt_value & bit(DIAG_ALRT_FIELD::BUSUL);
      break;
    }
    case 5:
    {
      //Power over limit
      outcome = diag_alrt_value & bit(DIAG_ALRT_FIELD::POL);
      break;
    }
    case 6:
    {
      //Temperature compensation
      outcome = config & bit(5);
      break;
    }

    case 7:
    {
      //ADC Range
      //0h = ±163.84 mV, 1h = ± 40.96 mV
      outcome = config & bit(4);
      break;
    }

      //Output bits for relay_trigger_bitmap
    case 8:
    {
      outcome = registers.relay_trigger_bitmap & bit(DIAG_ALRT_FIELD::TMPOL);
      break;
    }
    case 9:
    {
      outcome = registers.relay_trigger_bitmap & bit(DIAG_ALRT_FIELD::SHNTOL);
      break;
    }
    case 10:
    {
      outcome = registers.relay_trigger_bitmap & bit(DIAG_ALRT_FIELD::SHNTUL);
      break;
    }
    case 11:
    {
      outcome = registers.relay_trigger_bitmap & bit(DIAG_ALRT_FIELD::BUSOL);
      break;
    }
    case 12:
    {
      outcome = registers.relay_trigger_bitmap & bit(DIAG_ALRT_FIELD::BUSUL);
      break;
    }
    case 13:
    {
      outcome = registers.relay_trigger_bitmap & bit(DIAG_ALRT_FIELD::POL);
      break;
    }

    case 14:
    {
      outcome = relay_state;
      break;
    }
    case 15:
    {
      //Factory reset - always FALSE
      break;
    }

    default:
    {
      break;
    }
    }

    if (outcome)
    {
      //Set the bit if needed
      frame[ptr] = frame[ptr] | (1 << bitPosition);
    }

    bitPosition++;
    if (bitPosition == 8)
    {
      bitPosition = 0;
      ptr++;
    }
  }

  //Return number of bytes we have populated
  return 1 + ptr;
}

uint16_t ReadHoldingRegister(uint16_t address)
{
  //Temporary variables to hold the register data
  static DoubleUnionType v;
  static DoubleUnionType c;
  static DoubleUnionType p;
  static DoubleUnionType shuntv;

  static DoubleUnionType BusOverVolt;
  static DoubleUnionType BusUnderVolt;
  static DoubleUnionType ShuntOverCurrentLimit;
  static DoubleUnionType ShuntUnderCurrentLimit;
  static DoubleUnionType PowerLimit;

  static DoubleUnionType copy_amphour_out;
  static DoubleUnionType copy_amphour_in;

  static DoubleUnionType copy_current_lsb;
  static DoubleUnionType copy_shunt_resistance;

  switch (address)
  {
  case 0:
  {
    //Voltage
    v.dblvalue = BusVoltage();
    return v.word[0];
    break;
  }

  case 1:
  {
    //Voltage
    return v.word[1];
    break;
  }

  case 2:
  {
    //Current
    c.dblvalue = Current();
    return c.word[0];
    break;
  }

  case 3:
  {
    //Current
    return c.word[1];
    break;
  }

  case 4:
  {
    //amphour_out
    copy_amphour_out.dblvalue = amphour_out;
    return copy_amphour_out.word[0];
    break;
  }

  case 5:
  {
    //amphour_out
    return copy_amphour_out.word[1];
    break;
  }

  case 6:
  {
    //amphour_in
    copy_amphour_in.dblvalue = amphour_in;
    return copy_amphour_in.word[0];
    break;
  }

  case 7:
  {
    //amphour_in
    return copy_amphour_in.word[1];
    break;
  }

  case 8:
  {
    //temperature
    return (int16_t)DieTemperature();
    break;
  }

  case 9:
  {
    //Watchdog timer trigger count (like error counter)
    return wdt_triggered_count;
    break;
  }

  case 10:
  {
    //Power
    p.dblvalue = Power();
    return p.word[0];
    break;
  }

  case 11:
  {
    //Power
    return p.word[1];
    break;
  }

  case 12:
  {
    //Shunt mV
    shuntv.dblvalue = ShuntVoltage();
    return shuntv.word[0];
    break;
  }

  case 13:
  {
    //Shunt mV
    return shuntv.word[1];
    break;
  }

  case 14:
  {
    copy_current_lsb.dblvalue = registers.CURRENT_LSB;
    return copy_current_lsb.word[0];
    break;
  }

  case 15:
  {
    return copy_current_lsb.word[1];
    break;
  }
  case 16:
  {
    copy_shunt_resistance.dblvalue = registers.RSHUNT;
    return copy_shunt_resistance.word[0];
    break;
  }

  case 17:
  {
    return copy_shunt_resistance.word[1];
    break;
  }

  case 18:
  {
    return registers.shunt_max_current;
    break;
  }
  case 19:
  {
    return registers.shunt_millivolt;
    break;
  }

  case 20:
  {
    //SHUNT_CAL register
    return i2c_readword(INA_REGISTER::SHUNT_CAL);
    break;
  }

  case 21:
  {
    //temperature limit
    return (int16_t)TemperatureLimit();
    break;
  }

  case 22:
  {
    //Bus Overvoltage (overvoltage protection).
    //Unsigned representation, positive value only. Conversion factor: 3.125 mV/LSB.
    BusOverVolt.dblvalue = ((double)(uint16_t)i2c_readword(INA_REGISTER::BOVL)) * 0.003125F;
    return BusOverVolt.word[0];
    break;
  }

  case 23:
  {
    return BusOverVolt.word[1];
    break;
  }

  case 24:
  {
    BusUnderVolt.dblvalue = (double)i2c_readword(INA_REGISTER::BUVL) * 0.003125F;
    return BusOverVolt.word[0];
    break;
  }

  case 25:
  {
    return BusOverVolt.word[1];
    break;
  }

  case 26:
  {
    //Shunt Over Voltage Limit (current limit)
    int16_t value = i2c_readword(INA_REGISTER::SOVL);

    //1.25 µV/LSB
    ShuntOverCurrentLimit.dblvalue = ((double)value / 1000 * 1.25) / full_scale_adc * registers.full_scale_current;

    return ShuntOverCurrentLimit.word[0];
    break;
  }
  case 27:
  {
    return ShuntOverCurrentLimit.word[1];
    break;
  }

  case 28:
  {
    //Shunt UNDER Voltage Limit (under current limit)
    int16_t value = i2c_readword(INA_REGISTER::SUVL);

    //const double x = (0.725 / full_scale_current) * full_scale_adc;
    //int16_t CurrentOverThreshold = (x * 1000.0 / 1.24);

    ShuntUnderCurrentLimit.dblvalue = ((double)value / 1000 * 1.25) / full_scale_adc * registers.full_scale_current;

    return ShuntUnderCurrentLimit.word[0];
    break;
  }
  case 29:
  {
    return ShuntUnderCurrentLimit.word[1];
    break;
  }

  case 30:
  {
    //Shunt Over POWER LIMIT
    PowerLimit.dblvalue = (uint16_t)i2c_readword(INA_REGISTER::PWR_LIMIT);
    PowerLimit.dblvalue = PowerLimit.dblvalue * 256 * 3.2 * registers.CURRENT_LSB;
    return PowerLimit.word[0];
    break;
  }
  case 31:
  {
    return PowerLimit.word[1];
    break;
  }

  case 32:
  {
    //Shunt Temperature Coefficient
    return (uint16_t)i2c_readword(INA_REGISTER::SHUNT_TEMPCO);
    break;
  }

  case 33:
  {
    //INAXXX chip model number (should always be 0x0228)
    uint16_t dieid = i2c_readword(INA_REGISTER::DIE_ID);
    dieid = (dieid & 0xFFF0) >> 4;
    return dieid;
    break;
  }

  //These settings would probably be better in a 0x2B function code
  //https://modbus.org/docs/Modbus_Application_Protocol_V1_1b.pdf
  case 34:
  {
    //GITHUB version
    return GIT_VERSION_B1;
    break;
  }
  case 35:
  {
    //GITHUB version
    return GIT_VERSION_B2;
    break;
  }

  case 36:
  {
    //COMPILE_DATE_TIME_EPOCH
    return (uint16_t)COMPILE_DATE_TIME_UTC_EPOCH;
    break;
  }
  case 37:
  {
    //COMPILE_DATE_TIME_EPOCH
    uint32_t x = COMPILE_DATE_TIME_UTC_EPOCH >> 16;
    return (uint16_t)x;
    break;
  }
  case 38:
  {
    //Spare
    return 0x7890;
    break;
  }

  case 39:
  {
    return i2c_readword(INA_REGISTER::CONFIG);
    break;
  }
  case 40:
  {
    return i2c_readword(INA_REGISTER::ADC_CONFIG);
    break;
  }
  case 41:
  {
    return i2c_readword(INA_REGISTER::SHUNT_CAL);
    break;
  }
  case 42:
  {
    return i2c_readword(INA_REGISTER::SHUNT_TEMPCO);
    break;
  }
  case 43:
  {
    return i2c_readword(INA_REGISTER::DIAG_ALRT);
    break;
  }
  case 44:
  {
    return i2c_readword(INA_REGISTER::SOVL);
    break;
  }
  case 45:
  {
    return i2c_readword(INA_REGISTER::SUVL);
    break;
  }
  case 46:
  {
    return i2c_readword(INA_REGISTER::BOVL);
    break;
  }
  case 47:
  {
    return i2c_readword(INA_REGISTER::BUVL);
    break;
  }
  case 48:
  {
    return i2c_readword(INA_REGISTER::TEMP_LIMIT);
    break;
  }
  case 49:
  {
    return i2c_readword(INA_REGISTER::PWR_LIMIT);
    break;
  }
  case 50:
  {
    return i2c_readword(INA_REGISTER::DIETEMP);
    break;
  }

  } //end switch

  return 0;
}

void loop()
{
  wdt_reset();

  /*
  //Enable interrupts
  sei();
  //Start frame detection
  USART0.CTRLB |= USART_SFDEN_bm;

  //Switch off TX, saves current
  //DisableSerial0TX();

  if (!Serial.available())
  {
    //Enter sleep
    set_sleep_mode(SLEEP_MODE_STANDBY);
    sleep_enable();
    sleep_cpu();

    //Snoring can be heard at this point....
    sleep_disable();
  }
*/

  if (ALERT_TRIGGERED)
  {
    ALERT_TRIGGERED = false;
    diag_alrt_value = i2c_readword(INA_REGISTER::DIAG_ALRT);

    alert = diag_alrt_value & ALL_ALERT_BITS;

    if (alert == 0)
    {
      RedLED(false);
    }

    //Apply relay_trigger_bitmap bitmask over the top of the alerts, so we only trigger on specific events
    relay_state = ((alert & registers.relay_trigger_bitmap) != 0);

    //Turn relay on/off
    if (relay_state)
    {
      PORTA.OUTSET = RELAY_PIN_BITMAP;
    }
    else
    {
      PORTA.OUTCLR = RELAY_PIN_BITMAP;
    }
  }

  modbus_update();

  /*
  while (Serial.available())
  {

    // we have a rolling 8 byte window
    for (uint8_t k = 1; k < 8; k++)
    {
      modbus[k - 1] = modbus[k];
    }

    modbus[7] = (uint8_t)Serial.read(); // receive a byte

    uint8_t cmd = modbus[1];

    // 8 byte commands 2/3/6
    if ((modbus[0] == ModbusSlaveAddress) && ((cmd == 2) || (cmd == 3) || (cmd == 6)))
    {
      uint16_t crc16 = combineBytes(modbus[7], modbus[6]);
      uint16_t calculatedCRC = ModbusRTU_CRC(modbus, 6);
      if (crc16 == calculatedCRC)
      {
        //Do something
        GreenLED(true);
        //EnableSerial0TX();

        //Prepare reply buffer
        memset(sendbuff, 0, sizeof(sendbuff));
        sendbuff[0] = ModbusSlaveAddress; // slv addr
        sendbuff[1] = cmd;
        uint8_t ptr = 0;

        //1 = command
        //2+3 = data address
        //4+5 = data amount/quantity
        if (cmd == 2)
        {
          ptr = ReadDiscreteInputs(combineBytes(modbus[2], modbus[3]), combineBytes(modbus[4], modbus[5]));
        }

        if (cmd == 3)
        {
          ptr = ReadHoldingRegisters(combineBytes(modbus[2], modbus[3]), combineBytes(modbus[4], modbus[5]));
        }

        if (cmd == 0x06)
        {
          //Set highest bit to indicate error
          sendbuff[1] = cmd | B10000000;
          //Illegal Function
          sendbuff[2] = 0x01;
          ptr = 3;
        }

        if ((sendbuff[1] & B10000000) == 0)
        {
          //No error, so populate the length (error packets don't have this byte)
          sendbuff[2] = ptr - 3;
        }

        SendModbusData(&sendbuff[0], ptr);
        GreenLED(false);
      } //end of crc check

    } //end of if

  } //end while
*/
  if (millis() > timer)
  {

    RedLED(true);

    //Do it again in 5 seconds
    timer = millis() + 5000;

    //double voltage = BusVoltage();
    //150A@50mV shunt =   122.88A @ 40.96mV (full scale ADC)
    //double current = Current();
    double power = Power();
    //double temperature = DieTemperature();
    //double shuntv = ShuntVoltage();
    //double energy_joules = Energy();
    double charge_coulombs = Charge();

    //If we don't have a power reading, ignore the coulombs - also means
    //Ah counting won't work without voltage reading on the INA228 chip
    if (power > 0)
    {
      if (charge_coulombs > 0)
      {
        amphour_out += charge_coulombs * CoulombsToAmpHours;
      }
      else
      {
        amphour_in += charge_coulombs * CoulombsToAmpHours;
      }
    }

    ResetChargeEnergyRegisters();

    if (alert == 0)
    {
      //Turn LED off if alert is not active
      RedLED(false);
    }
  }
}