
/*
////////////////////////////////////////////////////////////////////////////
El sistema enciende o apaga un LED en rb6 usando DOS botones
El botón conectado en RE0 tiene un resistor pull down y 
sirve para encender el LED (modo CLICK)
El botón conectado en RE1 tiene un resistor PULL UP y 
sirve para APAGAR el LED (modo PRESS) 
Consideramos un delay de 10mS para evitar el rebote del 
botón*/
////////////////////////////////////////////////////////////////////////////
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
DELAY_10mS:
 
 MOVLW 0XF6
 MOVWF TMR0H,A
 MOVLW 0X3C
 MOVWF TMR0L,A
ASK:
 BTFSS INTCON,2,A
 GOTO ASK
 BCF INTCON, 2,A
 RETURN
INICIO:
 MOVLW 01000000B
 MOVWF OSCCON,A //EL PIC TIENE FRECUECIA DE 1MHz
 
 CLRF TRISB,A
 CLRF LATB,A
 
 SETF TRISE,A
 MOVLW 15
 MOVWF ADCON1,A
 MOVLW 7
 MOVWF CMCON,A
 
 MOVLW 10000111B
 MOVWF T0CON,A
 
LEER_B1: 
 BTFSS PORTE,0,A//BTN1 YA TE PRESIONARON?RPD, CLICK
 BRA LEER_B2//NO, VE A LEER AL SEGUNDO BOTON
; BSF LATB,6,A
 
 
 CALL DELAY_10mS

 
 WAITB1:
  BTFSC PORTE,0,A
  BRA WAITB1
  BSF LATB,6,A
  BRA LEER_B2

LEER_B2:
 BTFSC PORTE,1,A//BTN2 YA TE PRESIONARON?RPU, PRESS
 BRA LEER_B1//NO, LEER BOT 
 
 BCF LATB, 6, A
 CALL DELAY_10mS

 WAITB2:
 BTFSS PORTE,1,A//YA TE SOLTARON?
 BRA WAITB2
 
 BRA LEER_B1//SI, REGRESA A LEER_B1
/*OFF:
 BSF LATB,6,A
 GOTO WAIT2
ON:
 BCF LATB,6,A
 GOTO LEER_B1*/
 END

