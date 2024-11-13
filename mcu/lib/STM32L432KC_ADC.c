// STM32L432KC_FLASH.c
// Source code for ADC functions

#include "STM32L432KC_ADC.h"

 // Section 16
 // PLLSAI
void configureADC(void) {

 ///////////////////// CLOCK CONFIGURATION///////////////////////////////////
   // configure the clock connections to the pins
   RCC->AHB2ENR |= RCC_AHB2ENR_ADCEN;
   RCC->CCIPR |= _VAL2FLD(RCC_CCIPR_ADCSEL, 0b11);

    // make sure ADEN = 0
    ADC1->CR &= ~ADC_CR_ADEN;
  ////////////////////////////////////////////////////////////////////////////





 ///////////////////////// CALIBRATE THE ADC /////////////////////////
   // start operating by setting ADC_DEEPPWD to 0
   ADC1->CR &= ~ADC_CR_DEEPPWD;

   //  enable the ADC internal voltage regulator by setting the bit ADVREGEN=1
   ADC1->CR |=  ADC_CR_ADVREGEN;

   // The software must wait for the startup time of the ADC voltage regulator (TADCVREG_STUP)
   // minimum time = 25 us -- https://hmc-e155.github.io/assets/doc/ds11451-stm32l432kc.pdf (132)
   volatile int i=0;
   while(i<0x6F) { __asm("nop"); i++; }

    // In single ended input mode, the analog voltage to be converted for channel “i” to Vref-
        // is the difference between the external voltage VINP[i] (positive input) 
        // and V_ref-[i] (negative input).
    //ADC1->CFGR |= ADC_CFGR_CONT;
    while(ADC1->CR & ADC_CR_ADEN);

    // ADC1->CR &= ~ADC_CR_ADCALDIF;
    ADC1->CR |=  ADC_CR_ADCAL;

    while(ADC1->CR & ADC_CR_ADCAL); // wait for ADCAL to = 0
    // calibration is stored in CALFACT_D[6:0] of ADC_CALFACT
  ////////////////////////////////////////////////////////////////////////////




  ///////////////////////// ENABLE THE ADC /////////////////////////
  
  // write ADC_ISR to 1 (will basically reset the RDY pin)
  ADC1->ISR |= ADC_ISR_ADRDY;
  ADC1->CR  |=  ADC_CR_ADEN;

  // enable ADC using ADCEN pin = 1
  while(!(ADC1->ISR & ADC_ISR_ADRDY));

  // wait for ADD_RDY to be true
  // make sure to wait four clock cycles after ADCAL=0 before setting ADEN: ADEN bit cannot be set during ADCAL=1
    // aka i'll put in a for loop for 10 ticks just in case.
  for(int i=0; i<10; i++);

  // Clear the operation
  ADC1->ISR |= ADC_ISR_ADRDY;
  ////////////////////////////////////////////////////////////////////////////






  /////////////////////////// SET MODE FOR ADC ////////////////////////////

  /// Write the control bits ADSTART, JADSTART and ADDIS of the ADC_CR register only if ADEN must be equal to 1 and ADDIS to 0
  while( ~(ADC1->CR  &  ADC_CR_ADEN) & (ADC1->CR & ADC_CR_ADDIS)); 

  // ADD_CR -> ADSTART = 1 (sets CONT=1) -- starts immediately if EXTEN = 0x0
  ADC1->CR |= ADC_CR_ADSTART;

  ////////////////////////////////////////////////////////////////////////////
}

/**
*   Set the pin to read one time
*/
void initReadOnce(uint32_t in_pin) {
  ADC1->SQR1 &= ~ADC_SQR1_L;

  ADC1->SQR1 |= in_pin << ADC_SQR1_SQ1_Pos; // ADC_PA5 -> ADC1_IN10
}

/**
*    Set the pin to stop reading and clear previously set bits (DR is only one pin at a time)
*/
void stopReadOnce(uint32_t in_pin) {
  ADC1->SQR1 &= ~ADC_SQR1_L;

  ADC1->SQR1 &= !(in_pin << ADC_SQR1_SQ1_Pos); // ADC_PA5 -> ADC1_IN10
}

 // uses PLL: f(VCOSAI1 clock) = f(PLL clock input) × (PLLSAI1N / PLLM)
 //RCC->PLLSAI1CFGR |= _VAL2FLD(RCC_PLLSAI1CFGR_PLLSAI1R, 3);
 // 01: PLLSAI1 “R” clock (PLLADC1CLK) selected as ADCs clock(1)
  //RCC->CCIPR |= _VAL2FLD(RCC_CCIPR_ADCSEL, 0b01);
 // ADC1_COMMON->CCR |=   _VAL2FLD(ADC_CCR_PRESC, 0b11); // set to 1011, or divide by 256
 // ADC1_COMMON->CCR &= ~(_VAL2FLD(ADC_CCR_CKMODE, 0b11));