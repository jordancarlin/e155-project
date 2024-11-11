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

#define BRUSH_UP PB1

///////////////////////////////////////////////////////////////////////////////
// Custom defines 
///////////////////////////////////////////////////////////////////////////////

// reads the incoming x/y signals
void read_XY(void);

// reads the incoming brush size using potentiometer
void read_brushSize(void);

#endif // MAIN_H