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
  configureFlash();
  configureClock();
  configureADC();
  
  initControls();
  ADC1->CR |= ADC_CR_ADSTART;

  // Enable end of conversion interrupt
  // NVIC->ISER[0] |= (1 << 18);
  // ADC1->IER |= ADC_IER_EOCIE;

  volatile uint32_t x = 0;
  volatile uint32_t y = 0;
  volatile uint32_t *loc_arr;
  uint16_t timeVibes = 0;
  while(1) {
    // Start conversion;

    for(int i=0; i<1000000; i++);

    loc_arr = read_XY();

    x = loc_arr[0];
    y = loc_arr[1];
    
    //printf("%d and %d\n", x, y);
    //printf("%d\n\n", timeVibes++);
  }

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

void initControls(void) {
  //////// ENABLE ANALOG GPIO PINS DESIRED /////////
  
  // Turn on GPIOA and GPIOB clock domains (GPIOAEN and GPIOBEN bits in AHB1ENR)
  RCC->AHB2ENR |= (RCC_AHB2ENR_GPIOAEN | RCC_AHB2ENR_GPIOBEN);

  // output the stored ADC values to the GPIO pins
  gpioEnable(GPIO_PORT_A);
  gpioEnable(GPIO_PORT_B);

  pinMode(ADC1_IN10, GPIO_ANALOG);  // joystick_x, PA5
  pinMode(ADC1_IN11, GPIO_ANALOG);  // joystick_y, PA6
  pinMode(ADC1_IN5,  GPIO_ANALOG);   // brush thickness, PA0

}

uint32_t *read_XY(void) {
  static uint32_t loc_arr[2];

  loc_arr[0] = read_X();
  loc_arr[1] = read_Y();

  if (loc_arr[0] > 1000)
    printf("ON (%d)\n", loc_arr[0]/10);
  else
    printf("OFF (%d)\n", loc_arr[0]/10);
  
  if (loc_arr[1] > 1000)
    printf("ON (%d)\n\n", loc_arr[1]/10);
  else
    printf("OFF (%d)\n\n", loc_arr[1]/10);
  
  return loc_arr;
}

uint32_t read_X(void) {

  initReadOnce(ADC1_SQ1_PA5);

  ADC1->CR |= ADC_CR_ADSTART;
  while (!(ADC1->ISR & ADC_ISR_EOC));

  for(int i=0; i<1000; i++);
  stopReadOnce(ADC1_SQ1_PA5);

  return ADC1->DR;
}

uint32_t read_Y(void) {

  initReadOnce(ADC1_SQ1_PA6);
  ADC1->CR |= ADC_CR_ADSTART;

  while (!(ADC1->ISR & ADC_ISR_EOC));

  for(int i=0; i<1000; i++);
  stopReadOnce(ADC1_SQ1_PA6);

  return ADC1->DR;
}

void read_brushSize(void) { 
  initReadOnce(ADC1_SQ1_PA0); 
}

/*************************** End of file ****************************/
