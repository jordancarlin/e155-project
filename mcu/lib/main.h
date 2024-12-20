// main.h

/**
@author: zoe worrall
@contact: zworrall@g.hmc.edu
@version: December 10, 2024
*/

#ifndef MAIN_H
#define MAIN_H

#include "STM32L432KC.h"
#include <stm32l432xx.h>

// Pin definement for color buttons
#define WHITE    PB0
#define RED      PA8
#define BLUE     PA10
#define GREEN    PA9
#define YELLOW   PA12
#define PURPLE   PB6
#define ERASE    PB7
#define BRUSH_UP PB1  // the brush pin

// Definement of different color bits as they exist on the FPGA
#define WHITE_BITS  0b111
#define RED_BITS    0b001
#define BLUE_BITS   0b010
#define GREEN_BITS  0b011
#define YELLOW_BITS 0b100
#define PURPLE_BITS 0b101
#define ERASE_BITS  0b000

// defining the location in the color_spi packet where we will be changing values
#define COLOR_BITS   0 // there are three color bits from 2:0
#define BRUSHUP_BITS 4

// defining the dimensions of the screen we're drawing on
#define XLIM 128
#define YLIM 128

///////////////////////////////////////////////////////////////////////////////
// Custom defines 
///////////////////////////////////////////////////////////////////////////////

// sets up the color buttons with interrupts
void configureSettings(void);

// reads the incoming x/y signals
void initControls(void);

// reads the incoming x/y signals
uint32_t read_XY(void);
uint32_t read_X(void);
uint32_t read_Y(void);

// returns the width (1, 2, 3) of the current packet
uint32_t getThickness(void);

// reads the incoming brush size using potentiometer
uint32_t read_brushSize(void);

#endif // MAIN_H