/*
////////////////////////////////////////////////////////////////////////////
     CTO12.s
Pérez Nava Yael Mauricio
Fecha de Compilacion: 06/05/26
Programa:  el circuito muestra en exhibidores de 7 segmentos 
     multiplexados, el número ingresado en PA


/////////////////////////////////////////////////////
*/
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
/*/////////////////////////////////////////////////////////////////////////////
*/
DECLARAR_VARIABLES: 
 PSECT UDATA_ACS
 PA_COPIA: DS 1
 UNIDAD: DS 1
 DECENA: DS 1
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
 RETLW 0XFC //0 
 RETLW 0X60 //1 
 RETLW 0XDA //2 
 RETLW 0XF2 //3 
 RETLW 0X66 //4 
 RETLW 0XB6 //5 
 RETLW 0XBE //6 
 RETLW 0XE0 // 7
 RETLW 0XFE //8
 RETLW 0XF6 //9
//LOS VALORES DE ARRIBA SON DECODIFICACIONES PARA 7 SEG CC
 
DECODIFICAR1:
 RLNCF WREG,F,A
 CALL TABLAN
 RETURN
 
 DELAY_5mS:
 MOVLW 251
 MOVWF TMR0L,A
ASK:
 BTFSS INTCON,2,A 
 GOTO ASK
 BCF INTCON,2,A 
 RETURN
 
DECENAS:
 MOVF DECENA,W,A
 CALL DECODIFICAR1
 CALL DECENASD
 CALL DELAY_5mS
 RETURN
 
UNIDADES: 
 MOVF UNIDAD,W,A
 CALL DECODIFICAR1
 CALL UNIDADESD
 CALL DELAY_5mS
 RETURN
 
DECENASD: 
 CLRF LATC,A
 BSF LATC,0,A
; COMF WREG,F,A
 MOVWF LATB,A
 RETURN
 
UNIDADESD: 
 CLRF LATC,A //ESTE VALOR ES DIRIGIDO AL DISPLAY COMUN
 BSF LATC,1,A
 ;COMF WREG,F,A
 MOVWF LATB,A
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
 CLRF PORTC,A
 BCF TRISC,0,A
 BCF TRISC,1,A
 MOVLW 11010111B //TMR0 ON, 8 BITS RELOJ INTERNO,
 //PREESCALER 1:256
 MOVWF T0CON,0
 CLRF TMR0L,A
MAIN:
 CLRF DECENA,A
 CLRF UNIDAD,A
 MOVFF PORTA,PA_COPIA
 MOVLW 011111111B
 ANDWF PA_COPIA,F,A
MENOR_100:
 MOVLW 99 ;EL NUM DESEADO EN W
 CPFSGT PA_COPIA,A ;EL DE LA COMPA EN REG
 GOTO MENOR_10
 CLRF LATB,A
 GOTO MAIN
MENOR_10: 
 MOVLW 10
 CPFSLT PA_COPIA,A
 GOTO DIVISION
 MOVFF PA_COPIA,UNIDAD
 CALL DECENAS
 CALL UNIDADES
 GOTO MAIN
DIVISION:
 MOVLW 10
 SUBWF PA_COPIA,F,A
 BTFSS STATUS,4,A //STATUS, 4 ES EL BIT NEGATIVE
 GOTO SIGUE
 CALL DECENAS
 CALL UNIDADES
 GOTO MAIN
SIGUE:
 INCF DECENA,F,A
 MOVFF PA_COPIA,UNIDAD
 GOTO DIVISION
 END



