/*********************************************************************
*                    SEGGER Microcontroller GmbH                     *
*                        The Embedded Experts                        *
**********************************************************************

@author: zoe worrall
@contact: zworrall@g.hmc.edu
@version: November 10, 2024

-------------------------- END-OF-HEADER -----------------------------

File    : main.c for Lab 5
Purpose : A function that will measure the frequency and duty cycle of
          an incoming motor.

*/

#include <stdio.h>
#include "stm32l432xx.h"
#include "../lib/main.h"

int main(void) {
  configurePLL();
  // configureADC();

 /**
An interrupt can be enabled for each of the 3 analog watchdogs by 
      setting AWDxIE in the ADC_IER register (x=1,2,3).

AWDx (x=1,2,3) flag is cleared by software by writing 1 to it.

The ADC conversion result is compared to the lower and higher thresholds before alignment.

The AWD analog watchdog 1 is enabled by setting the AWD1EN bit in the ADC_CFGR register. 
This watchdog monitors whether either one selected channel or all enabled channels(1) remain within a configured voltage range (window).

AWD1EN, JAWD1EN, AWD1SGL, AWD1CH, AWD2CH, AWD3CH, AWD_HTx, AWD_LTx, AWDx

Four sizes of thickness (four ranges within the module)
Joystick values - need to see the readout for this first unfortunately
 */

}

void read_XY(void) { int i = 1; }
void read_brushSize(void) { int i = 1; }

/*************************** End of file ****************************/