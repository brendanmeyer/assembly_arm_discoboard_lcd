
/**
 * @author Brendan Meyer
 * @license MIT
 *
*/

.syntax unified

 

.data



.text
.global main
.type main, %function
main:


  bl lcd_init

  
  @ @ set a ram bit - 22.3.8
  @ ldr r0, =LCD
  @ ldr r1, [r0, LCD_RAM_COM0_31_0]
  @ orr r1, (0b0001 << LCD_RAM_COMx_31_0_0)
  @ @ orr r1, (0b1111 << LCD_RAM_COMx_31_0_4)
  @ @ orr r1, (0b1111 << LCD_RAM_COMx_31_0_8)
  @ str r1, [r0, LCD_RAM_COM0_31_0]

end:
  nop
  b end
.size main, .-main



