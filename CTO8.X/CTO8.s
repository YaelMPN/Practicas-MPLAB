/* 
//////////////////////////////////////////////////////////////////////////// 
Los interruptores conectados en las entradas ra6, ra5 y ra4 son las entradas selectoras de un mux 8*1. Cada selección realizara
una operacion aritmetica o logica de 2 bits, es decir, datoA(RA3,RA2) y datoB (RA1,RA0) de 2 bits cada uno.
La siguiente tabla miestra la operacion
     RA6 RA5 RA4 | PORTB
      0   0   0  | SUMA
      0   0   1  | RESTA
      0   1   0  | MULTIPLICACIÓN
      0   1   1  | AND
      1   0   0  | OR
      1   0   1  | XOR
      1   1   0  | COMPLEMENTO A 1 DE DATO A
      1   1   1  | COMPLEMENTO A 2 DE DATO A
//////////////////////////////////////////////////////////////////////////// 
*/ 
    PROCESSOR 18F4550 ;DISPOSITIVO A PROGRAMAR 
;////////////////////////////////////////////////////////////////////////////// 
; PIC18F4550 Configuration Bit Settings

; Assembly source line config statements

; CONFIG1L
  CONFIG  PLLDIV = 1            ; PLL Prescaler Selection bits (No prescale (4 MHz oscillator input drives PLL directly))
  CONFIG  CPUDIV = OSC1_PLL2    ; System Clock Postscaler Selection bits ([Primary Oscillator Src: /1][96 MHz PLL Src: /2])
  CONFIG  USBDIV = 1            ; USB Clock Selection bit (used in Full-Speed USB mode only; UCFG:FSEN = 1) (USB clock source comes directly from the primary oscillator block with no postscale)

; CONFIG1H
  CONFIG  FOSC = INTOSCIO_EC    ; Oscillator Selection bits (Internal oscillator, port function on RA6, EC used by USB (INTIO))
  CONFIG  FCMEN = OFF           ; Fail-Safe Clock Monitor Enable bit (Fail-Safe Clock Monitor disabled)
  CONFIG  IESO = OFF            ; Internal/External Oscillator Switchover bit (Oscillator Switchover mode disabled)

; CONFIG2L
  CONFIG  PWRT = ON             ; Power-up Timer Enable bit (PWRT enabled)
  CONFIG  BOR = OFF             ; Brown-out Reset Enable bits (Brown-out Reset disabled in hardware and software)
  CONFIG  BORV = 3              ; Brown-out Reset Voltage bits (Minimum setting 2.05V)
  CONFIG  VREGEN = OFF          ; USB Voltage Regulator Enable bit (USB voltage regulator disabled)

; CONFIG2H
  CONFIG  WDT = OFF             ; Watchdog Timer Enable bit (WDT disabled (control is placed on the SWDTEN bit))
  CONFIG  WDTPS = 32768         ; Watchdog Timer Postscale Select bits (1:32768)

; CONFIG3H
  CONFIG  CCP2MX = ON           ; CCP2 MUX bit (CCP2 input/output is multiplexed with RC1)
  CONFIG  PBADEN = OFF          ; PORTB A/D Enable bit (PORTB<4:0> pins are configured as digital I/O on Reset)
  CONFIG  LPT1OSC = OFF         ; Low-Power Timer 1 Oscillator Enable bit (Timer1 configured for higher power operation)
  CONFIG  MCLRE = ON            ; MCLR Pin Enable bit (MCLR pin enabled; RE3 input pin disabled)

; CONFIG4L
  CONFIG  STVREN = ON           ; Stack Full/Underflow Reset Enable bit (Stack full/underflow will cause Reset)
  CONFIG  LVP = OFF             ; Single-Supply ICSP Enable bit (Single-Supply ICSP disabled)
  CONFIG  ICPRT = OFF           ; Dedicated In-Circuit Debug/Programming Port (ICPORT) Enable bit (ICPORT disabled)
  CONFIG  XINST = OFF           ; Extended Instruction Set Enable bit (Instruction set extension and Indexed Addressing mode disabled (Legacy mode))

; CONFIG5L
  CONFIG  CP0 = OFF             ; Code Protection bit (Block 0 (000800-001FFFh) is not code-protected)
  CONFIG  CP1 = OFF             ; Code Protection bit (Block 1 (002000-003FFFh) is not code-protected)
  CONFIG  CP2 = OFF             ; Code Protection bit (Block 2 (004000-005FFFh) is not code-protected)
  CONFIG  CP3 = OFF             ; Code Protection bit (Block 3 (006000-007FFFh) is not code-protected)

; CONFIG5H
  CONFIG  CPB = OFF             ; Boot Block Code Protection bit (Boot block (000000-0007FFh) is not code-protected)
  CONFIG  CPD = OFF             ; Data EEPROM Code Protection bit (Data EEPROM is not code-protected)

; CONFIG6L
  CONFIG  WRT0 = OFF            ; Write Protection bit (Block 0 (000800-001FFFh) is not write-protected)
  CONFIG  WRT1 = OFF            ; Write Protection bit (Block 1 (002000-003FFFh) is not write-protected)
  CONFIG  WRT2 = OFF            ; Write Protection bit (Block 2 (004000-005FFFh) is not write-protected)
  CONFIG  WRT3 = OFF            ; Write Protection bit (Block 3 (006000-007FFFh) is not write-protected)

; CONFIG6H
  CONFIG  WRTC = OFF            ; Configuration Register Write Protection bit (Configuration registers (300000-3000FFh) are not write-protected)
  CONFIG  WRTB = OFF            ; Boot Block Write Protection bit (Boot block (000000-0007FFh) is not write-protected)
  CONFIG  WRTD = OFF            ; Data EEPROM Write Protection bit (Data EEPROM is not write-protected)

; CONFIG7L
  CONFIG  EBTR0 = OFF           ; Table Read Protection bit (Block 0 (000800-001FFFh) is not protected from table reads executed in other blocks)
  CONFIG  EBTR1 = OFF           ; Table Read Protection bit (Block 1 (002000-003FFFh) is not protected from table reads executed in other blocks)
  CONFIG  EBTR2 = OFF           ; Table Read Protection bit (Block 2 (004000-005FFFh) is not protected from table reads executed in other blocks)
  CONFIG  EBTR3 = OFF           ; Table Read Protection bit (Block 3 (006000-007FFFh) is not protected from table reads executed in other blocks)

; CONFIG7H
  CONFIG  EBTRB = OFF           ; Boot Block Table Read Protection bit (Boot block (000000-0007FFh) is not protected from table reads executed in other blocks)

// config statements should precede project file includes.
#include <xc.inc>
    
DECLARAR_VARIABLES:
    PSECT UDATA 
    PA_COPIA: DS 1 
 /////////////////////////////////////////////////////////////////////////////// 
 VECTOR_RESET: 
    PSECT CODE,RELOC=2,ABS 
    ORG 0x00  //00000000B 0 
    GOTO INICIO 
/////////////////////////////////////////////////////////////////////////////// 
 PROGRAMA_PRINCIPAL: 
 PSECT CODE,RELOC=2 
 ORG 0X0A 
INICIO: 
    SETF    TRISA,A 
    CLRF    PORTA,A 
    MOVLW   00001111B 
    MOVWF   ADCON1,A 
    MOVLW   00000111B 
    MOVWF   CMCON,A 
    CLRF    TRISB,A 
    CLRF    LATB,A 

MAIN:
    MOVF PORTA,W,A
    ANDLW 00001100B
    RRNCF WREG,W,A
    RRNCF WREG,W,A
    MOVWF PA_COPIA,A //DatoA guardado
    MOVF PORTA,W,A
    ANDLW 00000011B  //B en W
//Selector de operaciones/
    //Preguntar por el número de operación bit por bit
BTFSC PORTA,6,A
GOTO S1
GOTO S0

S0:
    BTFSC PORTA,5,A
    GOTO S01
    GOTO S00

S1:
    BTFSC PORTA,5,A
    GOTO S11
    GOTO S10

S00:
    BTFSC PORTA,4,A
    GOTO RESTA
    GOTO SUMA

S01:
    BTFSC PORTA,4,A
    GOTO AND_OP
    GOTO MULT

S10:
    BTFSC PORTA,4,A
    GOTO XOR_OP
    GOTO OR_OP

S11:
    BTFSC PORTA,4,A
    GOTO COMP2
    GOTO COMP1

//Operaciónes

//000 SUMA
SUMA:
    ADDWF PA_COPIA,W ,A
    MOVWF LATB,A
    GOTO MAIN

//001 RESTA
RESTA:
    SUBWF PA_COPIA,W,A
    MOVWF LATB,A
    GOTO MAIN

//010 MULTIPLICACIÓN
MULT:
    MULWF   PA_COPIA,A
    MOVFF   PRODL,LATB
    GOTO MAIN

//011 AND
AND_OP:
    ANDWF PA_COPIA,W,A
    MOVWF LATB,A
    GOTO MAIN

//100 OR
OR_OP:
    IORWF PA_COPIA,W,A
    MOVWF LATB,A
    GOTO MAIN

//101 XOR
XOR_OP:
    XORWF PA_COPIA,W,A
    MOVWF LATB,A
    GOTO MAIN   

//110 COMPLEMENTO A 1
COMP1:
    MOVF PA_COPIA,W,A
    COMF WREG,W,A
    MOVWF LATB,A
    GOTO MAIN

//111 COMPLEMENTO A 2
COMP2:
    MOVF PA_COPIA,W,A
    COMF WREG,W,A
    ADDLW 1
    MOVWF LATB,A
    GOTO MAIN
END


