// main.h
// Zoe Worrall
// November 10, 2024

#ifndef MAIN_H
#define MAIN_H

#include "STM32L432KC.h"
#include <stm32l432xx.h>

#define WHITE    PB0
#define RED      PA8
#define BLUE     PA10
#define GREEN    PA9
#define YELLOW   PA12
#define PURPLE   PB6
#define ERASE    PB7

#define WHITE_BITS  0b000
#define RED_BITS    0b001
#define BLUE_BITS   0b010
#define GREEN_BITS  0b011
#define YELLOW_BITS 0b100
#define PURPLE_BITS 0b101
#define ERASE_BITS  0b111

#define BRUSH_UP PB1

#define COLOR_BITS 0 // there are three color bits from 2:0

#define XLIM 200
#define YLIM 200

#define XLEFT  0b00
#define XRIGHT 0b11
#define XMID   0b01

#define YUP    0b11
#define YDOWN  0b00
#define YMID   0b01

///////////////////////////////////////////////////////////////////////////////
// Custom defines 
///////////////////////////////////////////////////////////////////////////////

// sets up the color buttons with interrupts
void configureSettings(void);

// reads the incoming x/y signals
void initControls(void);

// reads the incoming x/y signals
uint32_t *read_XY(void);
uint32_t read_X(void);
uint32_t read_Y(void);

// reads the incoming brush size using potentiometer
uint32_t read_brushSize(void);


#endif // MAIN_H