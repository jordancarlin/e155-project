// STM32L432KC_ADC.h
// Header for ADC functions
// author: zoe worrall
// version: december 10, 2024

#ifndef STM32L4_ADC_H
#define STM32L4_ADC_H

#include <stdint.h>
#include <stm32l432xx.h>
#include "STM32L432KC_GPIO.h"

// the sample time is dependent on the number of clock 
  // cycles for which we wait (2_5 -> 2.5 clk cycles)
#define ADC_SAMPLETIME_2_5    0b000
#define ADC_SAMPLETIME_6_5    0b001
#define ADC_SAMPLETIME_12_5   0b010
#define ADC_SAMPLETIME_24_5   0b011
#define ADC_SAMPLETIME_47_5   0b100
#define ADC_SAMPLETIME_92_5   0b101
#define ADC_SAMPLETIME_247_5  0b110
#define ADC_SAMPLETIME_640_5  0b111

// definition of which pins could be used as analog
#define ADC1_IN5  PA0
#define ADC1_IN6  PA1
#define ADC1_IN7  PA2
#define ADC1_IN8  PA3
#define ADC1_IN9  PA4
#define ADC1_IN10 PA5
#define ADC1_IN11 PA6
#define ADC1_IN12 PA7
#define ADC1_IN15 PB0
#define ADC1_IN16 PB1

// definition of which addresses that talk to each individual analog pin
#define ADC1_SQ1_PA0  5
#define ADC1_SQ1_PA1  6
#define ADC1_SQ1_PA2  7
#define ADC1_SQ1_PA3  8
#define ADC1_SQ1_PA4  9
#define ADC1_SQ1_PA5  10
#define ADC1_SQ1_PA6  11
#define ADC1_SQ1_PA7  12
#define ADC1_SQ1_PB0  15
#define ADC1_SQ1_PB1  16

///////////////////////////////////////////////////////////////////////////////
// Functions
///////////////////////////////////////////////////////////////////////////////

// sets up ADC (i.e. connects to clocks, etc.)
void configureADC(void);

// functions that turn the ADC on and turn it off while the user is reading input data
// based off of the ADC code used by Kavi Dey in his digital design project
    // see https://kavidey.com/projects/digital-camera-sensor/
void initReadOnce(uint32_t in_pin);
void stopReadOnce(uint32_t in_pin);

#endif