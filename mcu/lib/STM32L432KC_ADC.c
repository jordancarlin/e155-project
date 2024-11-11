// STM32L432KC_FLASH.c
// Source code for ADC functions

#include "STM32L432KC_ADC.h"

void configureADC(void) {
 // Section 16
 // PLLSAI
 // uses PLL: f(VCOSAI1 clock) = f(PLL clock input) × (PLLSAI1N / PLLM)
 RCC->PLLSAI1CFGR |= _VAL2FLD(RCC_PLLSAI1CFGR_PLLSAI1R, 3);
 RCC->AHB2ENR |= RCC_AHB2ENR_ADCEN;

  // Turn on GPIOA and GPIOB clock domains (GPIOAEN and GPIOBEN bits in AHB1ENR)
  RCC->AHB2ENR |= (RCC_AHB2ENR_GPIOAEN | RCC_AHB2ENR_GPIOBEN);

  // make sure ADEN = 0
  ADC1->CR &= ~ADC_CR_ADEN;

 ADC1_COMMON->CCR |= _VAL2FLD(ADC_CCR_PRESC, 0b11); // set to 1011, or divide by 256
 ADC1_COMMON->CCR &= ~(_VAL2FLD(ADC_CCR_CKMODE, 0b11));

 ////// CALIBRATE THE ADC //////

 // start operating by setting ADC_DEEPPWD to 0
 //  enable the ADC internal voltage regulator by setting the bit ADVREGEN=1
 ADC1->CR &=~ ADC_CR_DEEPPWD;
 ADC1->CR |=  ADC_CR_ADVREGEN;

 // The software must wait for the startup time of the ADC voltage regulator (TADCVREG_STUP)
 while(ADC1->CR & ADC_CR_ADVREGEN);

  // In single ended input mode, the analog voltage to be converted for channel “i” to Vref-
      // is the difference between the external voltage VINP[i] (positive input) 
      // and V_ref-[i] (negative input).

  ADC1->CR &= ~ADC_CR_ADCALDIF;
  ADC1->CR |=  ADC_CR_ADCAL;
  while(ADC1->CR & ADC_CR_ADCAL);
  // calibration is stored in CALFACT_D[6:0] of ADC_CALFACT

  ////// ENABLE THE ADC //////
  
  // write ADC_ISR to 1 (will basically reset the RDY pin)
  ADC1->ISR |= ADC_ISR_ADRDY;
  ADC1->CR  |=  ADC_CR_ADEN;

  // enable ADC using ADCEN pin = 1
  while(~(ADC1->ISR |= ADC_ISR_ADRDY));

  // wait for ADD_RDY to be true
  // make sure to wait four clock cycles after ADCAL=0 before setting ADEN: ADEN bit cannot be set during ADCAL=1
    // aka i'll put in a for loop for 10 ticks just in case.
  for(int i=0; i<10; i++);

  //////// SET MODE FOR ADC /////////
  /// Write the control bits ADSTART, JADSTART and ADDIS of the ADC_CR register only if ADEN must be equal to 1 and ADDIS to 0
  while( !(ADC1->CR  &  ADC_CR_ADEN) & (ADC1->CR & ADC_CR_ADDIS)); 

  // ADD_CR -> ADSTART = 1 (sets CONT=1) -- starts immediately if EXTEN = 0x0
  ADC1->CR |= ADC_CR_ADSTART;


  //////// ENABLE ANALOG GPIO PINS DESIRED /////////
  // output the stored ADC values to the GPIO pins
  gpioEnable(GPIO_PORT_A);
  gpioEnable(GPIO_PORT_B);

  pinMode(JOYSTICK_X, GPIO_ANALOG);
  pinMode(JOYSTICK_Y, GPIO_ANALOG);
  pinMode(THICKNESS, GPIO_ANALOG);

  // When the I/O port is programmed as analog configuration:
     //  The output buffer is disabled
     //  The Schmitt trigger input is deactivated, providing zero consumption for every analog value of the I/O pin. The output of the Schmitt trigger is forced to a constant value (0).
     //  The weak pull-up and pull-down resistors are disabled by hardware
     //  Read access to the input data register gets the value “0”
}