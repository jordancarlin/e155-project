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

char color_spi; 
char just_set;

// grid of 0's
uint32_t grid[400] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,   // 1
                      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
                      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
                      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
                      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,    // 5
                      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
                      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
                      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
                      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
                      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,    // 10
                      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
                      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
                      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
                      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
                      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,    // 15
                      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
                      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
                      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
                      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
                      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};    // 20

char timer[16] = {0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
                0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x0D, 0x0E, 0x0F};

char location[16] = {0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
                0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x0D, 0x0E, 0x0F};
                
char changebrush[16] = {0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07,
                0x08, 0x09, 0x0A, 0x0B, 0x0C, 0x0D, 0x0E, 0x0F};


int main(void) {


///////////////////////////// CONFIGURATIONS ///////////////////////////////
  // configure all necessary files beforehand
  configureFlash();
  configureClock();
  configureADC();
  
    // Initialize timer
    RCC->APB1ENR1 |= RCC_APB1ENR1_TIM2EN;
    initTIM(TIM2);

  
  // initialize the buttons/pins used for analog (joystick and potentiometer)
  initControls();
  ADC1->CR |= ADC_CR_ADSTART;

  // initialize the variables that are used for analog
  volatile uint32_t x = 0;
  volatile uint32_t y = 0;
  volatile uint32_t *loc_arr;
  uint16_t timeVibes = 0;
///////////////////////////////////////////////////////////////////////////


///////////////////////////// COLOR BUTTONS ///////////////////////////////
  configureSettings();
  just_set = 0;
////////////////////////////////////////////////////////////////////////


  // infinite loop used to send and receive desired signals
  while(1) {

    // for printing data at a manageable rate
    delay_millis(TIM2, 5000);

    // read the current joystick measurement
    loc_arr = read_XY();

    // set the x and y location to be the current joystick readout
    x = loc_arr[0];
    y = loc_arr[1];

    if(just_set) {
      printf("Button was Pressed: %d", color_spi);
    }
    
    just_set = 0;
  }

}

/**
*  Configures all the desired color buttons with external interrupts 
*/
void configureSettings(void) {
///////////////////////////// INPUT INTERRUPTS ///////////////////////////////

    // Enable button as input
    gpioEnable(GPIO_PORT_A);
    pinMode(WHITE,   GPIO_INPUT);  // PB 0
    pinMode(RED,     GPIO_INPUT);  // PA 8
    pinMode(BLUE,    GPIO_INPUT);  // PA 10
    pinMode(GREEN,   GPIO_INPUT);  // PA 9
    pinMode(YELLOW,  GPIO_INPUT);  // PA 12
    pinMode(PURPLE,  GPIO_INPUT);  // PB 6
    pinMode(ERASE,   GPIO_INPUT);  // PB 7

    // Setting Pull Downs
    GPIOB->PUPDR |= _VAL2FLD(GPIO_PUPDR_PUPD0,  0b10);  // Set PB 0  as pull-down
    GPIOA->PUPDR |= _VAL2FLD(GPIO_PUPDR_PUPD8,  0b10);  // Set PA 8  as pull-down
    GPIOA->PUPDR |= _VAL2FLD(GPIO_PUPDR_PUPD10, 0b10);  // Set PA 10 as pull-down
    GPIOA->PUPDR |= _VAL2FLD(GPIO_PUPDR_PUPD9,  0b10);  // Set PA 9  as pull-down
    GPIOA->PUPDR |= _VAL2FLD(GPIO_PUPDR_PUPD12, 0b10);  // Set PA 12 as pull-down
    GPIOB->PUPDR |= _VAL2FLD(GPIO_PUPDR_PUPD6,  0b10);  // Set PB 6  as pull-down
    GPIOB->PUPDR |= _VAL2FLD(GPIO_PUPDR_PUPD7,  0b10);  // Set PB 7  as pull-down

    // 1. Enable SYSCFG clock domain in RCC
    // RCC_APB2ENR, bit 0, is SYSCFGEN @ bit 0
    RCC->APB2ENR |= (1<<0);

    // External Interrupt for the given set of pins
    SYSCFG->EXTICR[0] |=  _VAL2FLD(SYSCFG_EXTICR1_EXTI0,  0b001); // PB0  (001)
    SYSCFG->EXTICR[2] &= ~_VAL2FLD(SYSCFG_EXTICR3_EXTI8,  0b111); // PA8  (000)
    SYSCFG->EXTICR[2] &= ~_VAL2FLD(SYSCFG_EXTICR3_EXTI8,  0b111); // PA9  (000)
    SYSCFG->EXTICR[2] &= ~_VAL2FLD(SYSCFG_EXTICR3_EXTI10, 0b111); // PA10 (000)
    SYSCFG->EXTICR[3] &= ~_VAL2FLD(SYSCFG_EXTICR4_EXTI12, 0b111); // PA12 (000)
    SYSCFG->EXTICR[1] |=  _VAL2FLD(SYSCFG_EXTICR2_EXTI6,  0b001); // PB6  (001)
    SYSCFG->EXTICR[1] |=  _VAL2FLD(SYSCFG_EXTICR2_EXTI7,  0b001); // PB7  (001)

    // Enable interrupts globally
    __enable_irq();
///////////////////////////////////////////////////////////////////////////


    // EXTI: GPIO lines are bits 0-15, and are configurable
    EXTI->IMR1 |= _VAL2FLD(EXTI_IMR1_IM0, 0b1);
    EXTI->IMR1 |= _VAL2FLD(EXTI_IMR1_IM8, 0b1);
    EXTI->IMR1 |= _VAL2FLD(EXTI_IMR1_IM9, 0b1);
    EXTI->IMR1 |= _VAL2FLD(EXTI_IMR1_IM10, 0b1);
    EXTI->IMR1 |= _VAL2FLD(EXTI_IMR1_IM12, 0b1);
    EXTI->IMR1 |= _VAL2FLD(EXTI_IMR1_IM6, 0b1);
    EXTI->IMR1 |= _VAL2FLD(EXTI_IMR1_IM7, 0b1);
    
    // 2. Disable rising edge trigger
    EXTI->RTSR1 |= ~_VAL2FLD(EXTI_RTSR1_RT0, 0b1);  // 0: Rising trigger enabled (for Event and Interrupt) for input line 4
    EXTI->RTSR1 |= ~_VAL2FLD(EXTI_RTSR1_RT8, 0b1);
    EXTI->RTSR1 |= ~_VAL2FLD(EXTI_RTSR1_RT9, 0b1);
    EXTI->RTSR1 |= ~_VAL2FLD(EXTI_RTSR1_RT10, 0b1);
    EXTI->RTSR1 |= ~_VAL2FLD(EXTI_RTSR1_RT12, 0b1);
    EXTI->RTSR1 |= ~_VAL2FLD(EXTI_RTSR1_RT6, 0b1);
    EXTI->RTSR1 |= ~_VAL2FLD(EXTI_RTSR1_RT7, 0b1);

    // 4. Turn on EXTI interrupt in NVIC_ISER
    NVIC->ISER[0] |= (1 << EXTI0_IRQn);
    NVIC->ISER[0] |= (1 << EXTI9_5_IRQn);

    uint32_t loc = EXTI15_10_IRQn - 32;
    NVIC->ISER[1] |= (1 << loc);

}

///////////////////// INTERRUPTS //////////////////////
/**
*  The Handler that is called when the button is pressed
*/
void EXTI9_5_IRQHandler (void){
    color_spi &= ~(0b111 << COLOR_BITS);
  just_set = 1;

    // Check that the button was what triggered our interrupt
    if (EXTI->PR1 & (1 << 8)) {          // PA8 = RED
        // If so, clear the interrupt (NB: Write 1 to reset)

        EXTI->PR1 |= (1 << _FLD2VAL(EXTI_PR1_PIF8, 1));
        color_spi &= ~(0b111 << COLOR_BITS);
        color_spi |=  (RED_BITS << COLOR_BITS);

    } else if (EXTI->PR1 & (1 << 9)) {    // PA9 = GREEN

        // If so, clear the interrupt (NB: Write 1 to reset)
        EXTI->PR1 |= (1 << _FLD2VAL(EXTI_PR1_PIF9, 1));
        color_spi &= ~(0b111 << COLOR_BITS);
        color_spi |=  (GREEN_BITS << COLOR_BITS);

    } else if (EXTI->PR1 & (1 << 6)) {    // PB6 = PURPLE

        // If so, clear the interrupt (NB: Write 1 to reset)
        EXTI->PR1 |= (1 << _FLD2VAL(EXTI_PR1_PIF6, 1));
        color_spi &= ~(0b111 << COLOR_BITS);
        color_spi |=  (PURPLE_BITS << COLOR_BITS);

    } else if (EXTI->PR1 & (1 << 7)) {    // PB7 = ERASE

        // If so, clear the interrupt (NB: Write 1 to reset)
        EXTI->PR1 |= (1 << _FLD2VAL(EXTI_PR1_PIF7, 1));
        color_spi &= ~(0b111 << COLOR_BITS);
        color_spi |=  (ERASE_BITS << COLOR_BITS);

    } 
}

void EXTI15_10_IRQHandler (void){ // -> not working atm
    color_spi &= ~(0b111 << COLOR_BITS);
  just_set = 1;

    // Check that the button was what triggered our interrupt
    if (EXTI->PR1 & (1 << 10)) {          // PA10 = BLUE

        // If so, clear the interrupt (NB: Write 1 to reset)
        EXTI->PR1 |= (1 << _FLD2VAL(EXTI_PR1_PIF10, 1));
        color_spi &= ~(0b111 << COLOR_BITS);
        color_spi |=  (BLUE_BITS << COLOR_BITS);

    } else if (EXTI->PR1 & (1 << 12)) {    // PA12 = YELLOW

        // If so, clear the interrupt (NB: Write 1 to reset)
        EXTI->PR1 |= (1 << _FLD2VAL(EXTI_PR1_PIF12, 1));
        color_spi &= ~(0b111 << COLOR_BITS);
        color_spi |=  (YELLOW_BITS << COLOR_BITS);

    }
}

void EXTI0_IRQHandler (void){
    color_spi &= ~(0b111 << COLOR_BITS);
  just_set = 1;

    // Check that the button was what triggered our interrupt
    if (EXTI->PR1 & (1 << 0)) {          // PA8 = RED

        // If so, clear the interrupt (NB: Write 1 to reset)
        EXTI->PR1 |= (1 << _FLD2VAL(EXTI_PR1_PIF0, 1));
        color_spi &= ~(0b111 << COLOR_BITS);
        color_spi |=  (WHITE_BITS << COLOR_BITS);

    } 
}

/////////////////////////////////////////////////////////

/**
*   Initiailizes the Joysticks and brush thickness Analog controls
*
*    Implements ADC input on GPIO pins PA5, PA6, and PA0
*/
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

/**
*     Return a list of x and y values read off of the ADC periods
*/
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

/**
*   Returns the analog readout of PA5 (joystick X)
*/
uint32_t read_X(void) {

  initReadOnce(ADC1_SQ1_PA5);

  ADC1->CR |= ADC_CR_ADSTART;
  while (!(ADC1->ISR & ADC_ISR_EOC));

  for(int i=0; i<1000; i++);
  stopReadOnce(ADC1_SQ1_PA5);

  return ADC1->DR;
}

/**
*   Returns the analog readout of PA6 (joystick Y)
*/
uint32_t read_Y(void) {

  initReadOnce(ADC1_SQ1_PA6);
  ADC1->CR |= ADC_CR_ADSTART;

  while (!(ADC1->ISR & ADC_ISR_EOC));

  for(int i=0; i<1000; i++);
  stopReadOnce(ADC1_SQ1_PA6);

  return ADC1->DR;
}

/**
*   Returns the analog readout of PA0 (potentiometer)
*/
uint32_t read_brushSize(void) { 
  initReadOnce(ADC1_SQ1_PA0);
  ADC1->CR |= ADC_CR_ADSTART;

  while (!(ADC1->ISR & ADC_ISR_EOC));

  for(int i=0; i<1000; i++);
  stopReadOnce(ADC1_SQ1_PA6);

  return ADC1->DR;
}

/*************************** End of file ****************************/
