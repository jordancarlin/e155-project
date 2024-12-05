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

// Format:
//  _7_ _6_ _5_    _4_    _3_ _2_ _1_ _0_
//   1   1   1   [br_up]   0   [colors] 
//     CONFIG             data
char color_spi[2]; 
char just_set;

// assume 200 x 200 (so we need 8 bits for x and y each)
// Format:
//        [7:0]      ||        [7:0]       ||
//   x1 bits [7:0]   ||     y1 bits [7:0]   ||
//     never 0xFF    ||      y bits
char loc_spi[2];
char currX, currY;

uint32_t thickness;


int main(void) {


///////////////////////////// CONFIGURATIONS ///////////////////////////////
  // configure all necessary files beforehand
  configureFlash();
  configureClock();
  configureADC();

  thickness = 1;
  
    // Initialize timer
    RCC->APB1ENR1 |= RCC_APB1ENR1_TIM2EN;
    initTIM(TIM2);

    currX = 25;
    currY = 25;

    initSPI(0b111, 0, 0);

  
  // initialize the buttons/pins used for analog (joystick and potentiometer)
  initControls();
  ADC1->CR |= ADC_CR_ADSTART;

  // initialize the variables that are used for analog
  volatile uint32_t x = 0;
  volatile uint32_t y = 0;
  uint32_t loc_arr[2];
  uint16_t timeVibes = 0;
  uint32_t prevBrush = 0;
///////////////////////////////////////////////////////////////////////////


///////////////////////////// COLOR BUTTONS ///////////////////////////////
  configureSettings();
  color_spi[1] |= 0b111 << 5; // header for the color_spi is set
  just_set = 0;
////////////////////////////////////////////////////////////////////////


  // infinite loop used to send and receive desired signals
  while(1) {
    delay_millis(TIM2, 500);

    // read the current joystick measurement
    read_XY();


    // for (int i=0; i<1000; i++);

    printf(" Color and Brush Up: %d\n", color_spi[1]);
    color_spi[1] &= ~(0b1 << BRUSHUP_BITS);
    color_spi[1] |=  (digitalRead(BRUSH_UP) << BRUSHUP_BITS);
    if (digitalRead(BRUSH_UP) != prevBrush) just_set = 0b1;
    prevBrush = digitalRead(BRUSH_UP);

    if(just_set) {
      digitalWrite(SPI_CE, 1);
      spiSendReceive(color_spi[1]);
      spiSendReceive(0);
      digitalWrite(SPI_CE, 0);
    }

    printf("Thickness: %d\n", thickness);

    for (int i=0; i<thickness; i++) {
      for (int j=0; j<thickness; j++) {
      
        loc_arr[0] = currX+i;
        loc_arr[1] = currY+j;
        
        digitalWrite(SPI_CE, 1);
        spiSendReceive(loc_arr[0]);
        digitalWrite(SPI_CE, 0);

        digitalWrite(SPI_CE, 1);
        spiSendReceive(loc_arr[1]);
        digitalWrite(SPI_CE, 0);


        printf("%d %d   ||   ", currX+i, currY+j);
      }
      printf("\n");
    }
    printf("\n\n\n");

    // printf("X: %d, Y: %d\n\n", currX, currY);

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
    pinMode(BRUSH_UP,GPIO_INPUT);  // PB_1

    
    pinMode(PA7,GPIO_OUTPUT);  // PA7

    pinMode(SPI_CE, GPIO_OUTPUT); //  Manual CS

    // Setting Pull Downs
    GPIOB->PUPDR |= _VAL2FLD(GPIO_PUPDR_PUPD0,  0b10);  // Set PB 0  as pull-down
    GPIOA->PUPDR |= _VAL2FLD(GPIO_PUPDR_PUPD8,  0b10);  // Set PA 8  as pull-down
    GPIOA->PUPDR |= _VAL2FLD(GPIO_PUPDR_PUPD10, 0b10);  // Set PA 10 as pull-down
    GPIOA->PUPDR |= _VAL2FLD(GPIO_PUPDR_PUPD9,  0b10);  // Set PA 9  as pull-down
    GPIOA->PUPDR |= _VAL2FLD(GPIO_PUPDR_PUPD12, 0b10);  // Set PA 12 as pull-down
    GPIOB->PUPDR |= _VAL2FLD(GPIO_PUPDR_PUPD6,  0b10);  // Set PB 6  as pull-down
    GPIOB->PUPDR |= _VAL2FLD(GPIO_PUPDR_PUPD7,  0b10);  // Set PB 7  as pull-down
    GPIOB->PUPDR |= _VAL2FLD(GPIO_PUPDR_PUPD1,  0b10);  // Set PB 1  as pull-down
    
    GPIOA->PUPDR |= _VAL2FLD(GPIO_PUPDR_PUPD11,  0b10);  // Set PB 1  as pull-down


    //GPIOB->PUPDR |= _VAL2FLD(GPIO_PUPDR_PUPD3,  0b10);  // Set PB 3  as pull-down
    //GPIOB->PUPDR |= _VAL2FLD(GPIO_PUPDR_PUPD4,  0b10);  // Set PB 4  as pull-down
    //GPIOB->PUPDR |= _VAL2FLD(GPIO_PUPDR_PUPD5,  0b10);  // Set PB 5  as pull-down


    // 1. Enable SYSCFG clock domain in RCC
    // RCC_APB2ENR, bit 0, is SYSCFGEN @ bit 0
    RCC->APB2ENR |= (1<<0);

    // External Interrupt for the given set of pins
    SYSCFG->EXTICR[0] |=  _VAL2FLD(SYSCFG_EXTICR1_EXTI0,  0b001); // PB0  (001)
    SYSCFG->EXTICR[2] &= ~_VAL2FLD(SYSCFG_EXTICR3_EXTI8,  0b111); // PA8  (000)
    SYSCFG->EXTICR[2] &= ~_VAL2FLD(SYSCFG_EXTICR3_EXTI8,  0b111); // PA9  (000)
    SYSCFG->EXTICR[2] &= ~_VAL2FLD(SYSCFG_EXTICR3_EXTI10, 0b111); // PA10 (000)
    SYSCFG->EXTICR[3] &= ~_VAL2FLD(SYSCFG_EXTICR4_EXTI12, 0b111); // PA12 (000)

    SYSCFG->EXTICR[1] &= ~_VAL2FLD(SYSCFG_EXTICR2_EXTI6,  0b111); // PB6  (001)
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
    EXTI->RTSR1 |= _VAL2FLD(EXTI_RTSR1_RT0, 0b1);  // 0: Rising trigger enabled (for Event and Interrupt) for input line 4
    EXTI->RTSR1 |= _VAL2FLD(EXTI_RTSR1_RT8, 0b1);
    EXTI->RTSR1 |= _VAL2FLD(EXTI_RTSR1_RT9, 0b1);
    EXTI->RTSR1 |= _VAL2FLD(EXTI_RTSR1_RT10, 0b1);
    EXTI->RTSR1 |= _VAL2FLD(EXTI_RTSR1_RT12, 0b1);
    EXTI->RTSR1 |= _VAL2FLD(EXTI_RTSR1_RT6, 0b1);
    EXTI->RTSR1 |= _VAL2FLD(EXTI_RTSR1_RT7, 0b1);

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
    color_spi[1] &= ~(0b111 << COLOR_BITS);
  just_set = 1;

    // Check that the button was what triggered our interrupt
    if (EXTI->PR1 & (1 << 8)) {          // PA8 = RED
        // If so, clear the interrupt (NB: Write 1 to reset)

        EXTI->PR1 |= (1 << _FLD2VAL(EXTI_PR1_PIF8, 1));
        color_spi[1] &= ~(0b111 << COLOR_BITS);
        color_spi[1] |=  (RED_BITS << COLOR_BITS);

    } else if (EXTI->PR1 & (1 << 9)) {    // PA9 = GREEN

        // If so, clear the interrupt (NB: Write 1 to reset)
        EXTI->PR1 |= (1 << _FLD2VAL(EXTI_PR1_PIF9, 1));
        color_spi[1] &= ~(0b111 << COLOR_BITS);
        color_spi[1] |=  (GREEN_BITS << COLOR_BITS);

    } else if (EXTI->PR1 & (1 << 6)) {    // PB6 = PURPLE

        // If so, clear the interrupt (NB: Write 1 to reset)
        EXTI->PR1 |= (1 << _FLD2VAL(EXTI_PR1_PIF6, 1));
        color_spi[1] &= ~(0b111 << COLOR_BITS);
        color_spi[1] |=  (PURPLE_BITS << COLOR_BITS);

    } else if (EXTI->PR1 & (1 << 7)) {    // PB7 = ERASE

        // If so, clear the interrupt (NB: Write 1 to reset)
        EXTI->PR1 |= (1 << _FLD2VAL(EXTI_PR1_PIF7, 1));
        color_spi[1] &= ~(0b111 << COLOR_BITS);
        color_spi[1] |=  (ERASE_BITS << COLOR_BITS);

    } 
}

void EXTI15_10_IRQHandler (void){ // -> not working atm
    color_spi[1] &= ~(0b111 << COLOR_BITS);
  just_set = 1;

    // Check that the button was what triggered our interrupt
    if (EXTI->PR1 & (1 << 10)) {          // PA10 = BLUE

        // If so, clear the interrupt (NB: Write 1 to reset)
        EXTI->PR1 |= (1 << _FLD2VAL(EXTI_PR1_PIF10, 1));
        color_spi[1] &= ~(0b111 << COLOR_BITS);
        color_spi[1] |=  (BLUE_BITS << COLOR_BITS);

    } else if (EXTI->PR1 & (1 << 12)) {    // PA12 = YELLOW

        // If so, clear the interrupt (NB: Write 1 to reset)
        EXTI->PR1 |= (1 << _FLD2VAL(EXTI_PR1_PIF12, 1));
        color_spi[1] &= ~(0b111 << COLOR_BITS);
        color_spi[1] |=  (YELLOW_BITS << COLOR_BITS);

    }
}

void EXTI0_IRQHandler (void){
    color_spi[1] &= ~(0b111 << COLOR_BITS);
    just_set = 1;

    // Check that the button was what triggered our interrupt
    if (EXTI->PR1 & (1 << 0)) {          // PA8 = RED

        // If so, clear the interrupt (NB: Write 1 to reset)
        EXTI->PR1 |= (1 << _FLD2VAL(EXTI_PR1_PIF0, 1));
        color_spi[1] &= ~(0b111 << COLOR_BITS);
        color_spi[1] |=  (WHITE_BITS << COLOR_BITS);

    } 
}

/////////////////////////////////////////////////////////



///////////////////// CONTROLS //////////////////////
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
*     Return a list of x and y values read off of the ADC periods. 
*       Used by Joystick. Returns whether we are Down, Up, etc.
*/
uint32_t read_XY(void) {

  uint32_t t = read_X();
  for (int i=0; i<1000; i++);
  uint32_t y = read_Y();
  for (int i=0; i<1000; i++);
  uint32_t x = read_brushSize();
  for (int i=0; i<1000; i++);

  printf("x is %d, y is %d, t is %d", x, y, t);

  if ((x < 50) && (currX != 0))
    currX = currX-1;
  else if (x < 100)
    currX = currX;
  else if (currX <= 128-thickness)
    currX = currX+1;
  
  if ((y < 100) && (currY != 0))
    currY = currY-1;
  else if (y < 150)
    currY = currY;
  else if (currY != 128)
    currY = currY+1;
  
  if (t < 1266)
    thickness = 1;
  else if (t < 2533)
    thickness = 2;
  else
    thickness = 3;


  return 1;
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
  stopReadOnce(ADC1_SQ1_PA0);

  return ADC1->DR;
}


/*************************** End of file ****************************/
