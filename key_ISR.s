
/////////  *****************KEY   ISR    file template   ***************************** ///////



/********************************************************************************

 * Pushbutton - Interrupt Service Routine                                

 *                                                                          

 * This routine checks which KEY has been pressed.  If KEY3 it stops/starts the timer.

*********************************************************************************/
                                                       

                .global   KEY_ISR
KEY_ISR:
                LDR        R0, =0xFF200050   //=KEY_BASE          // base address of KEYs parallel port
                LDR        R1, [R0, #0xC]                                    // read edge capture register
                STR     R1, [R0, #0xC]                                    // clear the interrupt

CHK_KEY3:          //...
                //CMP      R1, #0b01000                     //check if KEY3 is pressed
                TST		R1, #0b1000
				BEQ    END_KEY_ISR  


START_STOP:     
                LDR        R0, =0xFFFEC600      //=MPCORE_PRIV_TIMER             // timer base address
                LDR        R1, [R0, #0x8]       // read timer control register
                //…

               EOR    R1, R1, #1                                      
			   STR	  R1, [R0, #0x8]	

END_KEY_ISR:  
                MOV     PC, LR
                .end

