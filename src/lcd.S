
/**
 * @author Brendan Meyer
 * @license MIT
 *
 * Portions from COMP2300 audio.S under MIT License (author Benjamin Gray)
*/

.syntax unified

 

.data



.text
.global lcd_init
.type lcd_init, %function
lcd_init:
    push {lr}

    @ Enable LSI clock
    ldr r0, =RCC
    ldr r1, [r0, RCC_CSR]
    orr r1, (1 << RCC_CSR_LSION)
    str r1, [r0, RCC_CSR]

    @ Wait for change to take effect
1:
    ldr r1, [r0, RCC_CSR]
    mov r2, (1 << RCC_CSR_LSIRDY)
    tst r1, (1 << RCC_CSR_LSIRDY)
    ble 1b

    @ enable GPIO clocks A,B,C,D
    ldr r1, [r0, RCC_AHB2ENR]
    orr r1, (1 << RCC_AHB2ENR_GPIOAEN | 1 << RCC_AHB2ENR_GPIOBEN | 1 << RCC_AHB2ENR_GPIOCEN | 1 << RCC_AHB2ENR_GPIODEN)
    str r1, [r0, RCC_AHB2ENR]

    @ Configure GPIO ports as alternate functions
    @ 7.3.2 alternate mode
    @ stm32-L476xx-datasheet - Table 16. Alternate function AF0 to AF7 (for AF8 to AF15 see Table 17)
    @ stm32-L476G-discovery-user-manual - Figure 12. STM32L476VGT6 MCU
    @ PA 8 (COM0), 9 (COM1), 10 (COM2)
    @ PB 9 (COM3)
    @ PC 3 (VLCD)
    @ PA 6 (SEG23), 7 (SEG0), 15 (SEG10)
    @ PB 0 (SEG21), 1 (SEG2), 4 (SEG11), 5 (SEG12), 12 (SEG20), 13 (SEG3), 14 (SEG19), 15 (SEG4)
    @ PC 4 (SEG22), 5 (SEG1), 6 (SEG14), 7 (SEG9), 8 (SEG13)
    @ PD 8 (SEG18), 9 (SEG5), 10 (SEG17), 11 (SEG6), 12 (SEG16), 13 (SEG7), 14 (SEG15), 15 (SEG8)

    @ PA 6, 7, 8, 9, 10, 15
    ldr r0, =GPIOA
    ldr r1, [r0, GPIOx_AFRL]
    bic r1, (0b1111 << GPIOx_AFRL_AFSEL6) @ reset
    bic r1, (0b1111 << GPIOx_AFRL_AFSEL7)
    orr r1, (0b1011 << GPIOx_AFRL_AFSEL6) @set to AF11
    orr r1, (0b1011 << GPIOx_AFRL_AFSEL7)
    str r1, [r0, GPIOx_AFRL]
    ldr r1, [r0, GPIOx_AFRH]
    bic r1, (0b1111 << GPIOx_AFRH_AFSEL8) @ reset
    bic r1, (0b1111 << GPIOx_AFRH_AFSEL9)
    bic r1, (0b1111 << GPIOx_AFRH_AFSEL10)
    bic r1, (0b1111 << GPIOx_AFRH_AFSEL15)
    orr r1, (0b1011 << GPIOx_AFRH_AFSEL8) @set to AF11
    orr r1, (0b1011 << GPIOx_AFRH_AFSEL9)
    orr r1, (0b1011 << GPIOx_AFRH_AFSEL10)
    orr r1, (0b1011 << GPIOx_AFRH_AFSEL15)
    str r1, [r0, GPIOx_AFRH]

    @ PB 0, 1, 4, 5, 9, 12, 13, 14, 15
    ldr r0, =GPIOB
    ldr r1, [r0, GPIOx_AFRL]
    bic r1, (0b1111 << GPIOx_AFRL_AFSEL0) @ reset
    bic r1, (0b1111 << GPIOx_AFRL_AFSEL1)
    bic r1, (0b1111 << GPIOx_AFRL_AFSEL4)
    bic r1, (0b1111 << GPIOx_AFRL_AFSEL5)
    orr r1, (0b1011 << GPIOx_AFRL_AFSEL0) @set to AF11
    orr r1, (0b1011 << GPIOx_AFRL_AFSEL1)
    orr r1, (0b1011 << GPIOx_AFRL_AFSEL4)
    orr r1, (0b1011 << GPIOx_AFRL_AFSEL5)
    str r1, [r0, GPIOx_AFRL]
    ldr r1, [r0, GPIOx_AFRH]
    bic r1, (0b1111 << GPIOx_AFRH_AFSEL9) @ reset
    bic r1, (0b1111 << GPIOx_AFRH_AFSEL12)
    bic r1, (0b1111 << GPIOx_AFRH_AFSEL13)
    bic r1, (0b1111 << GPIOx_AFRH_AFSEL14)
    bic r1, (0b1111 << GPIOx_AFRH_AFSEL15)
    orr r1, (0b1011 << GPIOx_AFRH_AFSEL9) @set to AF11
    orr r1, (0b1011 << GPIOx_AFRH_AFSEL12)
    orr r1, (0b1011 << GPIOx_AFRH_AFSEL13)
    orr r1, (0b1011 << GPIOx_AFRH_AFSEL14)
    orr r1, (0b1011 << GPIOx_AFRH_AFSEL15)
    str r1, [r0, GPIOx_AFRH]

    @ PC 3, 4, 5, 6, 7, 8
    ldr r0, =GPIOC
    ldr r1, [r0, GPIOx_AFRL]
    bic r1, (0b1111 << GPIOx_AFRL_AFSEL3) @ reset
    bic r1, (0b1111 << GPIOx_AFRL_AFSEL4)
    bic r1, (0b1111 << GPIOx_AFRL_AFSEL5)
    bic r1, (0b1111 << GPIOx_AFRL_AFSEL6)
    bic r1, (0b1111 << GPIOx_AFRL_AFSEL7)
    orr r1, (0b1011 << GPIOx_AFRL_AFSEL3) @set to AF11
    orr r1, (0b1011 << GPIOx_AFRL_AFSEL4)
    orr r1, (0b1011 << GPIOx_AFRL_AFSEL5)
    orr r1, (0b1011 << GPIOx_AFRL_AFSEL6)
    orr r1, (0b1011 << GPIOx_AFRL_AFSEL7)
    str r1, [r0, GPIOx_AFRL]
    ldr r1, [r0, GPIOx_AFRH]
    bic r1, (0b1111 << GPIOx_AFRH_AFSEL8) @ reset
    orr r1, (0b1011 << GPIOx_AFRH_AFSEL8) @set to AF11
    str r1, [r0, GPIOx_AFRH]

    @ PD 8, 9, 10, 11, 12, 13, 14, 15
    ldr r0, =GPIOD
    ldr r1, [r0, GPIOx_AFRH]
    bic r1, (0b1111 << GPIOx_AFRH_AFSEL8) @ reset
    bic r1, (0b1111 << GPIOx_AFRH_AFSEL9)
    bic r1, (0b1111 << GPIOx_AFRH_AFSEL10)
    bic r1, (0b1111 << GPIOx_AFRH_AFSEL11)
    bic r1, (0b1111 << GPIOx_AFRH_AFSEL12)
    bic r1, (0b1111 << GPIOx_AFRH_AFSEL13)
    bic r1, (0b1111 << GPIOx_AFRH_AFSEL14)
    bic r1, (0b1111 << GPIOx_AFRH_AFSEL15)
    orr r1, (0b1011 << GPIOx_AFRH_AFSEL8) @set to AF11
    orr r1, (0b1011 << GPIOx_AFRH_AFSEL9)
    orr r1, (0b1011 << GPIOx_AFRH_AFSEL10)
    orr r1, (0b1011 << GPIOx_AFRH_AFSEL11)
    orr r1, (0b1011 << GPIOx_AFRH_AFSEL12)
    orr r1, (0b1011 << GPIOx_AFRH_AFSEL13)
    orr r1, (0b1011 << GPIOx_AFRH_AFSEL14)
    orr r1, (0b1011 << GPIOx_AFRH_AFSEL15)
    str r1, [r0, GPIOx_AFRH]

    @ set up pins as output pins - unsure about this, but this is what enabled visuals

    @ PA 6, 7, 8, 9, 10, 15
    ldr r0, =GPIOA
    ldr r1, [r0, GPIOx_MODER]
    bic r1, (0b11 << GPIOx_MODER_MODE6)
    orr r1, (0b10 << GPIOx_MODER_MODE6)
    bic r1, (0b11 << GPIOx_MODER_MODE7)
    orr r1, (0b10 << GPIOx_MODER_MODE7)
    bic r1, (0b11 << GPIOx_MODER_MODE8)
    orr r1, (0b10 << GPIOx_MODER_MODE8)
    bic r1, (0b11 << GPIOx_MODER_MODE9)
    orr r1, (0b10 << GPIOx_MODER_MODE9)
    bic r1, (0b11 << GPIOx_MODER_MODE10)
    orr r1, (0b10 << GPIOx_MODER_MODE10)
    bic r1, (0b11 << GPIOx_MODER_MODE15)
    orr r1, (0b10 << GPIOx_MODER_MODE15)
    str r1, [r0, GPIOx_MODER]

    @ PB 0, 1, 4, 5, 9, 12, 13, 14, 15
    ldr r0, =GPIOB
    ldr r1, [r0, GPIOx_MODER]
    bic r1, (0b11 << GPIOx_MODER_MODE0)
    orr r1, (0b10 << GPIOx_MODER_MODE0)
    bic r1, (0b11 << GPIOx_MODER_MODE1)
    orr r1, (0b10 << GPIOx_MODER_MODE1)
    bic r1, (0b11 << GPIOx_MODER_MODE4)
    orr r1, (0b10 << GPIOx_MODER_MODE4)
    bic r1, (0b11 << GPIOx_MODER_MODE5)
    orr r1, (0b10 << GPIOx_MODER_MODE5)
    bic r1, (0b11 << GPIOx_MODER_MODE9)
    orr r1, (0b10 << GPIOx_MODER_MODE9)
    bic r1, (0b11 << GPIOx_MODER_MODE12)
    orr r1, (0b10 << GPIOx_MODER_MODE12)
    bic r1, (0b11 << GPIOx_MODER_MODE13)
    orr r1, (0b10 << GPIOx_MODER_MODE13)
    bic r1, (0b11 << GPIOx_MODER_MODE14)
    orr r1, (0b10 << GPIOx_MODER_MODE14)
    bic r1, (0b11 << GPIOx_MODER_MODE15)
    orr r1, (0b10 << GPIOx_MODER_MODE15)
    str r1, [r0, GPIOx_MODER]

    @ PC 3, 4, 5, 6, 7, 8
    ldr r0, =GPIOC
    ldr r1, [r0, GPIOx_MODER]
    bic r1, (0b11 << GPIOx_MODER_MODE3)
    orr r1, (0b10 << GPIOx_MODER_MODE3)
    bic r1, (0b11 << GPIOx_MODER_MODE4)
    orr r1, (0b10 << GPIOx_MODER_MODE4)
    bic r1, (0b11 << GPIOx_MODER_MODE5)
    orr r1, (0b10 << GPIOx_MODER_MODE5)
    bic r1, (0b11 << GPIOx_MODER_MODE6)
    orr r1, (0b10 << GPIOx_MODER_MODE6)
    bic r1, (0b11 << GPIOx_MODER_MODE7)
    orr r1, (0b10 << GPIOx_MODER_MODE7)
    bic r1, (0b11 << GPIOx_MODER_MODE8)
    orr r1, (0b10 << GPIOx_MODER_MODE8)
    str r1, [r0, GPIOx_MODER]

    @ PD 8, 9, 10, 11, 12, 13, 14, 15
    ldr r0, =GPIOD
    ldr r1, [r0, GPIOx_MODER]
    bic r1, (0b11 << GPIOx_MODER_MODE8)
    orr r1, (0b10 << GPIOx_MODER_MODE8)
    bic r1, (0b11 << GPIOx_MODER_MODE9)
    orr r1, (0b10 << GPIOx_MODER_MODE9)
    bic r1, (0b11 << GPIOx_MODER_MODE10)
    orr r1, (0b10 << GPIOx_MODER_MODE10)
    bic r1, (0b11 << GPIOx_MODER_MODE11)
    orr r1, (0b10 << GPIOx_MODER_MODE11)
    bic r1, (0b11 << GPIOx_MODER_MODE12)
    orr r1, (0b10 << GPIOx_MODER_MODE12)
    bic r1, (0b11 << GPIOx_MODER_MODE13)
    orr r1, (0b10 << GPIOx_MODER_MODE13)
    bic r1, (0b11 << GPIOx_MODER_MODE14)
    orr r1, (0b10 << GPIOx_MODER_MODE14)
    bic r1, (0b11 << GPIOx_MODER_MODE15)
    orr r1, (0b10 << GPIOx_MODER_MODE15)
    str r1, [r0, GPIOx_MODER]

    @ Backup domain access
    @ armRM - 5.1.5 Battery backup domain

    @ armRM - 6.4.19 Enable PWR peripheral
    ldr r0, =RCC
    ldr r1, [r0, RCC_APB1ENR1]
    orr r1, (1 << RCC_APB1ENR1_PWREN)
    orr r1, (1 << RCC_APB1ENR1_LCDEN)
    str r1, [r0, RCC_APB1ENR1]

    @ Remove write protection of backup domain (5.1.5)
    ldr r0, =PWR
    ldr r1, [r0, PWR_CR1]
    orr r1, (1 << PWR_CR1_DBP)
    str r1, [r0, PWR_CR1]

    @ configure RTC to be LSI
    @ stm32-L476G-discovery-reference-manual
    @ 6.4.29 Backup domain control register (RCC_BDCR)
    @ 00: No clock
    @ 01: LSE oscillator clock used as RTC clock
    @ 10: LSI oscillator clock used as RTC clock
    @ 11: HSE oscillator clock divided by 32 used as RTC clock
    ldr r0, =RCC
    ldr r1, [r0, RCC_BDCR]
    bic r1, (0b11 << RCC_BDCR_RTCSEL)
    orr r1, (0b10 << RCC_BDCR_RTCSEL)
    str r1, [r0, RCC_BDCR]
    ldr r1, [r0, RCC_BDCR]
    bic r1, (1 << RCC_BDCR_RTCEN)
    orr r1, (1 << RCC_BDCR_RTCEN)
    str r1, [r0, RCC_BDCR]

    @ Restore write protection of backup domain
    ldr r0, =PWR
    ldr r1, [r0, PWR_CR1]
    bic r1, (1 << PWR_CR1_DBP)
    str r1, [r0, PWR_CR1]


    @ set duty and bias - 22.3.8
    @ 22.6.1 LCD control register
    ldr r0, =LCD
    ldr r1, [r0, LCD_CR]
    bic r1, (0b11 << LCD_CR_BIAS)
    bic r1, (0b111 << LCD_CR_DUTY)
    orr r1, (0b00 << LCD_CR_BIAS)
    orr r1, (0b000 << LCD_CR_DUTY)
    orr r1, (1 << LCD_CR_BUFEN)
    str r1, [r0, LCD_CR]

    @ delay for capacitor
    mov r0, 1000
    bl  delay

    @ set vsel
    @ 22.3.5 Voltage generator and contrast control
    ldr r0, =LCD
    ldr r1, [r0, LCD_CR]
    bic r1, (1 << LCD_CR_VSEL)
    str r1, [r0, LCD_CR]

    @ set UDR bit - 22.3.8
    ldr r0, =LCD
    ldr r1, [r0, LCD_SR]
    orr r1, (1 << LCD_SR_UDR)
    str r1, [r0, LCD_SR]

    @ set PS /DIV - 22.3.8
    ldr r0, =LCD
    ldr r1, [r0, LCD_FCR]
    bic r1, (0b1111 << LCD_FCR_PS)
    bic r1, (0b1111 << LCD_FCR_DIV)
    bic r1, (0b111 << LCD_FCR_PON)
    orr r1, (0b0100 << LCD_FCR_PS)
    orr r1, (0b0100 << LCD_FCR_DIV)
    orr r1, (0b001 << LCD_FCR_PON)
    orr r1, (1 << LCD_FCR_HD)
    str r1, [r0, LCD_FCR]

    @ contrast - 22.3.8
    ldr r0, =LCD
    ldr r1, [r0, LCD_FCR]
    bic r1, (0b111 << LCD_FCR_CC)
    orr r1, (0b111 << LCD_FCR_CC)
    str r1, [r0, LCD_FCR]

    @ 22.3.5 Voltage generator and contrast control
    ldr r0, =LCD
    ldr r1, [r0, LCD_CR]
    orr r1, (1 << LCD_CR_LCDEN)
    str r1, [r0, LCD_CR]

    pop {lr}
    bx lr
.size lcd_init, .-lcd_init



    @@@@@@@@@@@@@@@
    @@ Constants @@
    @@@@@@@@@@@@@@@

    .set LCD, 0x40002400
    .set LCD_CR, 0x00
        .set LCD_CR_LCDEN,     0
        .set LCD_CR_VSEL,      1
        .set LCD_CR_DUTY,      2 @ [3]
        .set LCD_CR_BIAS,      5 @ [2]
        .set LCD_CR_MUX_SEG,   7
        .set LCD_CR_BUFEN,     8
    .set LCD_FCR, 0x04
        .set LCD_FCR_HD,       0
        .set LCD_FCR_SOFIE,    1
        .set LCD_FCR_UDDIE,    3
        .set LCD_FCR_PON,      4  @ [3]
        .set LCD_FCR_DEAD,     7  @ [3]
        .set LCD_FCR_CC,       10 @ [3]
        .set LCD_FCR_BLINKF,   13 @ [3]
        .set LCD_FCR_BLINK,    16 @ [2]
        .set LCD_FCR_DIV,      18 @ [4]
        .set LCD_FCR_PS,       22 @ [4]
    .set LCD_SR, 0x08
        .set LCD_SR_ENS,       0
        .set LCD_SR_SOF,       1
        .set LCD_SR_UDR,       2
        .set LCD_SR_UDD,       3
        .set LCD_SR_RDY,       4
        .set LCD_SR_FCRSF,     5
    .set LCD_CLR, 0x0C
        .set LCD_CLR_SOLC,     1
        .set LCD_CLR_UDDC,     3
    .set LCD_RAM_COM0_31_0,  0x14
    .set LCD_RAM_COM0_43_32, 0x18
    .set LCD_RAM_COM1_31_0,  0x1C
    .set LCD_RAM_COM1_43_32, 0x20
    .set LCD_RAM_COM2_31_0,  0x24
    .set LCD_RAM_COM2_43_32, 0x28
    .set LCD_RAM_COM3_31_0,  0x2C
    .set LCD_RAM_COM3_43_32, 0x30
    .set LCD_RAM_COM4_31_0,  0x34
    .set LCD_RAM_COM4_43_32, 0x38
    .set LCD_RAM_COM5_31_0,  0x3C
    .set LCD_RAM_COM5_43_32, 0x40
    .set LCD_RAM_COM6_31_0,  0x44
    .set LCD_RAM_COM6_43_32, 0x48
    .set LCD_RAM_COM7_31_0,  0x4C
    .set LCD_RAM_COM7_43_32, 0x50
        .set LCD_RAM_COMx_31_0_0,   0
        .set LCD_RAM_COMx_31_0_1,   1
        .set LCD_RAM_COMx_31_0_2,   2
        .set LCD_RAM_COMx_31_0_3,   3
        .set LCD_RAM_COMx_31_0_4,   4
        .set LCD_RAM_COMx_31_0_5,   5
        .set LCD_RAM_COMx_31_0_6,   6
        .set LCD_RAM_COMx_31_0_7,   7
        .set LCD_RAM_COMx_31_0_8,   8
        .set LCD_RAM_COMx_31_0_9,   9
        .set LCD_RAM_COMx_31_0_10,  10
        .set LCD_RAM_COMx_31_0_11,  11
        .set LCD_RAM_COMx_31_0_12,  12
        .set LCD_RAM_COMx_31_0_13,  13
        .set LCD_RAM_COMx_31_0_14,  14
        .set LCD_RAM_COMx_31_0_15,  15
        .set LCD_RAM_COMx_31_0_16,  16
        .set LCD_RAM_COMx_31_0_17,  17
        .set LCD_RAM_COMx_31_0_18,  18
        .set LCD_RAM_COMx_31_0_19,  19
        .set LCD_RAM_COMx_31_0_20,  20
        .set LCD_RAM_COMx_31_0_21,  21
        .set LCD_RAM_COMx_31_0_22,  22
        .set LCD_RAM_COMx_31_0_23,  23
        .set LCD_RAM_COMx_31_0_24,  24
        .set LCD_RAM_COMx_31_0_25,  25
        .set LCD_RAM_COMx_31_0_26,  26
        .set LCD_RAM_COMx_31_0_27,  27
        .set LCD_RAM_COMx_31_0_28,  28
        .set LCD_RAM_COMx_31_0_29,  29
        .set LCD_RAM_COMx_31_0_30,  30
        .set LCD_RAM_COMx_31_0_31,  31
        .set LCD_RAM_COMx_43_32_32, 0
        .set LCD_RAM_COMx_43_32_33, 1
        .set LCD_RAM_COMx_43_32_34, 2
        .set LCD_RAM_COMx_43_32_35, 3
        .set LCD_RAM_COMx_43_32_36, 4
        .set LCD_RAM_COMx_43_32_37, 5
        .set LCD_RAM_COMx_43_32_38, 6
        .set LCD_RAM_COMx_43_32_39, 7
        .set LCD_RAM_COMx_43_32_40, 8
        .set LCD_RAM_COMx_43_32_41, 9
        .set LCD_RAM_COMx_43_32_42, 10
        .set LCD_RAM_COMx_43_32_43, 11
    .set PWR, 0x40007000
    .set PWR_CR1, 0x00
        .set PWR_CR1_DBP, 8
    .set RCC, 0x40021000
    .set RCC_AHB2ENR, 0x4C
        .set RCC_AHB2ENR_GPIOAEN, 0
        .set RCC_AHB2ENR_GPIOBEN, 1
        .set RCC_AHB2ENR_GPIOCEN, 2
        .set RCC_AHB2ENR_GPIODEN, 3
        .set RCC_AHB2ENR_GPIOEEN, 4
        .set RCC_AHB2ENR_GPIOFEN, 5
        .set RCC_AHB2ENR_GPIOGEN, 6
        .set RCC_AHB2ENR_GPIOHEN, 7
    .set RCC_APB1ENR1, 0x58
        .set RCC_APB1ENR1_LCDEN,  9
        .set RCC_APB1ENR1_PWREN,  28
    .set RCC_BDCR, 0x90
        .set RCC_BDCR_RTCSEL, 8 @ [2]
        .set RCC_BDCR_RTCEN,  15
    .set RCC_CSR, 0x94
        .set RCC_CSR_LSION,  0
        .set RCC_CSR_LSIRDY, 1
        

    .set GPIOA, 0x48000000
    .set GPIOB, 0x48000400
    .set GPIOC, 0x48000800
    .set GPIOD, 0x48000C00
    .set GPIOE, 0x48001000
    .set GPIOF, 0x48001400
    .set GPIOG, 0x48001800
    .set GPIOH, 0x48001C00
    .set GPIOx_AFRL,    0x20
        .set GPIOx_AFRL_AFSEL0,  0 @ [4]
        .set GPIOx_AFRL_AFSEL1,  4 @ [4]
        .set GPIOx_AFRL_AFSEL2,  8 @ [4]
        .set GPIOx_AFRL_AFSEL3,  12 @ [4]
        .set GPIOx_AFRL_AFSEL4,  16 @ [4]
        .set GPIOx_AFRL_AFSEL5,  20 @ [4]
        .set GPIOx_AFRL_AFSEL6,  24 @ [4]
        .set GPIOx_AFRL_AFSEL7,  28 @ [4]
    .set GPIOx_AFRH,    0x24
        .set GPIOx_AFRH_AFSEL8,  0 @ [4]
        .set GPIOx_AFRH_AFSEL9,  4 @ [4]
        .set GPIOx_AFRH_AFSEL10, 8 @ [4]
        .set GPIOx_AFRH_AFSEL11, 12 @ [4]
        .set GPIOx_AFRH_AFSEL12, 16 @ [4]
        .set GPIOx_AFRH_AFSEL13, 20 @ [4]
        .set GPIOx_AFRH_AFSEL14, 24 @ [4]
        .set GPIOx_AFRH_AFSEL15, 28 @ [4]
    .set GPIOx_MODER,   0x00
        .set GPIOx_MODER_MODE0, 0 @ [2]
        .set GPIOx_MODER_MODE1, 2 @ [2]
        .set GPIOx_MODER_MODE2, 4 @ [2]
        .set GPIOx_MODER_MODE3, 6 @ [2]
        .set GPIOx_MODER_MODE4, 8 @ [2]
        .set GPIOx_MODER_MODE5, 10 @ [2]
        .set GPIOx_MODER_MODE6, 12 @ [2]
        .set GPIOx_MODER_MODE7, 14 @ [2]
        .set GPIOx_MODER_MODE8, 16 @ [2]
        .set GPIOx_MODER_MODE9, 18 @ [2]
        .set GPIOx_MODER_MODE10, 20 @ [2]
        .set GPIOx_MODER_MODE11, 22 @ [2]
        .set GPIOx_MODER_MODE12, 24 @ [2]
        .set GPIOx_MODER_MODE13, 26 @ [2]
        .set GPIOx_MODER_MODE14, 28 @ [2]
        .set GPIOx_MODER_MODE15, 30 @ [2]
