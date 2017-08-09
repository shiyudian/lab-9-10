

//////  *********************** main.s file template   ***************************** //////

                .include "address_map_arm.s"
/*

 * This program demonstrates the use of interrupts using the KEY and timer ports. It
 *            1. displays a sweeping red light on LEDR, which moves left and right
 *            2. stops/starts the sweeping motion if KEY3 is pressed
 * Both the timer and KEYs are handled via interrupts
*/
                .text
                .global   _start
_start:
                //initialize the IRQ stack pointer ...
                MOV     R0, #0b10010
                MSR     CPSR, R0              //change into IRQ mode
                LDR     SP, = 0xFFFFFFFC

                //initialize the SVC stack pointer ...
                MOV     R0, #0b10011
                MSR     CPSR, R0              //change into SVC mode
                LDR     SP, = 0x3FFFFFFC

                BL      CONFIG_GIC        // configure the ARM generic interrupt controller
                BL      CONFIG_PRIV_TIMER    // configure the MPCore private timer
                BL      CONFIG_KEYS                   // configure the pushbutton KEYs
                                            

                // enable ARM processor interrupts ...
                MOV     R0, #0b00010011          // I = 0, SVC mode
                MSR     CPSR, R0

                LDR     R6, =0xFF200000               // red LED base address
MAIN:
                LDR     R4, LEDR_PATTERN              // LEDR pattern; modified by timer ISR
                STR     R4, [R6]                      // write to red LEDs
                B       MAIN


/* Configure the MPCore private timer to create interrupts every 1/10 second */

CONFIG_PRIV_TIMER:
                LDR     R0, =0xFFFEC600              // Timer base address
                //… code not shown
                LDR     R8, =20000000
                STR     R8, [R0]
                MOV     R8,#0b111
                STR     R8, [R0, #8]
                //

                MOV     PC, LR                                                    // return


/* Configure the KEYS to generate an interrupt */


CONFIG_KEYS:
                LDR     R0, =0xFF200050          // KEYs base address
                //... code not shown
                LDR     R2, =0xFF200058               //interrupt register
                MOV     R9 , #0b1000
                STR     R9, [R2]                //KEY3 should cause interrupt
				//
                MOV     PC, LR                                                                    // return


                .global   LEDR_DIRECTION
LEDR_DIRECTION:
                .word    0                              // 0 means left, 1 means right


                .global   LEDR_PATTERN
LEDR_PATTERN:
                .word    0x1

