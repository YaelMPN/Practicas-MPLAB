/*
////////////////////////////////////////////////////////////////////////////
               CTO16.s
Pérez Nava Yael Mauricio
Fecha de Compilacion: 09/05/26
Programa: 
máquina de estados. ra6 y ra5 00 pri 10 mul4 01 y 11 rst
x=0 ascendente primos menores que 10
x=1 ascendente  múltiplos de 4 menores que 10
0 es el inicio de todo sistema secuencial
primos 2,3,5,7 (cuatro estados) 2=3,3=4,5=5,7=6 asc
m4 0,4,8 (2 estados y el cero) 0=0, 4=1, 8=2 desc
1000mS equivale a 1 seg
1mS equivale a 0.001seg
100mS equivale a 0.1 seg
/*/////////////////////////////////////////////////////////////////////////////
PROCESSOR 18F4550 ;DISPOSITIVO A PROGRAMAR
;//////////////////////////////////////////////////////////////////////////////
PALABRA_DE_CONFIGURACION:
; PIC18F4550 Configuration Bit Settings
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
 CONTEO_100: DS 1
 CONTEO_1: DS 1
 CONTEO_500: DS 1
 COUNTER: DS 1
///////////////////////////////////////////////////////////////////////////////
VECTOR_RESET:
 PSECT CODE,RELOC=2,ABS
 ORG 0x00 //00000000B 0
 GOTO INICIO //goto ocupa 2 direcciones la 0 y la 2
///////////////////////////////////////////////////////////////////////////////
PROGRAMA_PRINCIPAL:
PSECT CODE,RELOC=2
ORG 0X04 //puede ser cualquier dirección par a partir 
 //del 4
TABLAN:
 ADDWF PCL,F,A //abcdefg pd
 RETLW 0XFC //0 decodificado como cero
 RETLW 0X66 //1 decodificado como 4
 RETLW 0XFE //2 decodificado como 8
 RETLW 0XDA //3 decodificado como 2
 RETLW 0XF2 //4 decodificado como 3
 RETLW 0XB6 //5 decodificado como 5
 RETLW 0XE0 //6 decodificado como 7
//LOS VALORES DE ARRIBA SON DECODIFICACIONES PARA 7 SEG CC
DECODIFICAR1:
 MOVF COUNTER,W,A
 RLNCF WREG,F,A
 CALL TABLAN
 ;COMF WREG,F,A
 MOVWF LATB,A
 RETURN
DELAY_500mS:
 MOVLW 5
 MOVWF CONTEO_500,A
DELAY_100mS:
 MOVLW 100
 MOVWF CONTEO_100,A
DELAY_1mS:
 MOVLW 81
 MOVWF CONTEO_1,A
AGAIN:
 DECFSZ CONTEO_1,F,A
 BRA AGAIN
 DECFSZ CONTEO_100,F,A
 BRA DELAY_1mS
 DECFSZ CONTEO_500,F,A
 BRA DELAY_100mS
 RETURN
INICIO:
 SETF TRISA,A
 CLRF PORTA,A
 MOVLW 00001111B
 MOVWF ADCON1,A
 MOVLW 00000111B
 MOVWF CMCON,A
 MOVLW 01000000B
 MOVWF OSCCON,A
 CLRF TRISB,A
 CLRF LATB,A
SET_COUNTER:
 CLRF COUNTER,A
DECISION:
 BTFSS PORTA,6,A
 GOTO PRIMOS_ASC
 GOTO MUL4_DES
MUL4_DES:
 CALL DECODIFICAR1
 CALL DELAY_500mS
 BTFSC PORTA,5,A
 BRA SET_COUNTER
 BTFSS PORTA,6,A
 GOTO SET_COUNTER
 INCF COUNTER,F,A
 MOVLW 3
 CPFSEQ COUNTER,A
 GOTO MUL4_DES 
 GOTO SET_COUNTER
PRIMOS_ASC:
 CALL DECODIFICAR1
 CALL DELAY_500mS
 BTFSC PORTA,5,A
 BRA SET_COUNTER
 BTFSC PORTA,6,A
 GOTO SET_COUNTER
SET_COUNTER_PRIMOS:
 MOVLW 3
 MOVWF COUNTER,A
SIGUE_PRIMOS:
 CALL DECODIFICAR1
 CALL DELAY_500mS
 BTFSC PORTA,5,A
 BRA SET_COUNTER
 BTFSC PORTA,6,A
 GOTO SET_COUNTER
 INCF COUNTER,F,A
 MOVLW 7
 CPFSEQ COUNTER,A
 GOTO SIGUE_PRIMOS 
 GOTO SET_COUNTER_PRIMOS
 END


