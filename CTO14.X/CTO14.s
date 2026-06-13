/*
////////////////////////////////////////////////////////////////////////////
     CTO14.s
Pérez Nava Yael Mauricio
Fecha de Compilacion: 06/05/26
Programa:  Contador de 0 a 9 y del nombre "yael" ascendente en cada display 


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
/*/////////////////////////////////////////////////////////////////////////////*/ 
DECLARAR_VARIABLES:   
    PSECT UDATA_ACS 
    UNIDAD:   DS 1 
    DECENA:   DS 1 
    CONTEO_5: DS 1 
    CONTEO_1: DS 1 

/*/////////////////////////////////////////////////////////////////////////////*/ 
VECTOR_RESET: 
PSECT CODE,RELOC=2,ABS 
ORG 0x00  //00000000B 0 
    GOTO INICIO 

/*/////////////////////////////////////////////////////////////////////////////*/ 
PROGRAMA_PRINCIPAL: 
PSECT CODE,RELOC=2 
ORG 0X04

TABLAN: 
    ADDWF   PCL,F,A  //abcdefg pd 
    RETLW   0XFC //0  
    RETLW   0X60 //1  
    RETLW   0XDA //2  
    RETLW   0XF2 //3  
    RETLW   0X66 //4  
    RETLW   0XB6 //5  
    RETLW   0XBE //6  
    RETLW   0XE0 //7 
    RETLW   0XFE //8 
    RETLW   0XF6 //9 

TABLA_YAEL_MAURICIO:
    ADDWF   PCL,F,A
    RETLW   0X76 //0 -> "y" (minúscula, se ve mejor en 7 seg)
    RETLW   0XEE //1 -> "A" (mayúscula)
    RETLW   0X9E //2 -> "E" (mayúscula)
    RETLW   0X1C //3 -> "L" (mayúscula)
    RETLW   0X00 // 4 -> " " (Espacio en blanco)
    RETLW   0X2A // 5 -> "m" (minúscula, se ve como dos montañitas)
    RETLW   0XEE // 6 -> "A"
    RETLW   0X7C // 7 -> "U"
    RETLW   0X0A // 8 -> "r" (minúscula)
    RETLW   0X60 // 9 -> "I"
    RETLW   0X9C // 10 -> "C"
    RETLW   0X60 // 11 -> "I"
    RETLW   0X3A // 12 -> "o" (minúscula)

DECODIFICAR1: 
    RLNCF   WREG,F,A 
    CALL    TABLAN 
    RETURN 

DECODIFICAR_LETRA:
    RLNCF   WREG,F,A 
    CALL    TABLA_YAEL_MAURICIO 
    RETURN

DELAY_5mS: 
    MOVLW 5 
    MOVWF CONTEO_5,A 
DELAY_1mS: 
    MOVLW 160 
    MOVWF CONTEO_1,A 
ASK: 
    DECFSZ CONTEO_1,F,A 
    GOTO ASK 
    DECFSZ CONTEO_5,F,A 
    GOTO DELAY_1mS 
    RETURN 

DELAY_500mS: 
    MOVLW  0XC2 
    MOVWF  TMR0H,A 
    MOVLW  0XF7 
    MOVWF  TMR0L,A 
ASKF: 
    BTFSS   PORTA,0,A       ; Si RA0 = 0, brinca la siguiente instrucción
    CALL    DECENAS         ; Llama al display de números (0-9)
    
    BTFSC   PORTA,0,A       ; Si RA0 = 1, brinca la siguiente instrucción
    CALL    UNIDADES        ; Llama al display de letras (yAEL)
    
    BTFSS   INTCON,2,A 
    GOTO    ASKF 
    BCF     INTCON,2,A
    
    ;CALL    DECENAS 
    ;CALL    UNIDADES 
    ;BTFSS   INTCON,2,A 
    ;GOTO    ASKF 
    ;BCF     INTCON,2,A 
    RETURN 
     
DECENAS: 
    MOVF    DECENA,W,A 
    CALL    DECODIFICAR1 
    CALL    DECENASD 
    CALL    DELAY_5mS 
    RETURN 
     
UNIDADES:     
    MOVF    UNIDAD,W,A 
    CALL    DECODIFICAR_LETRA 
    CALL    UNIDADESD 
    CALL    DELAY_5mS 
    RETURN 
     
DECENASD: 
    CLRF    LATC,A 
    BSF     LATC,1,A 
    //COMF    WREG,F,A 
    MOVWF   LATB,A 
    RETURN 
     
UNIDADESD:     
    CLRF    LATC,A 
    BSF     LATC,0,A 
    //COMF    WREG,F,A 
    MOVWF   LATB,A 
    RETURN 
      
INICIO: 
    SETF    TRISA,A 
    CLRF    PORTA,A 
    MOVLW   00001111B 
    MOVWF   ADCON1,A 
    MOVLW   00000111B 
    MOVWF   CMCON,A 
    MOVLW   01010000B 
    MOVWF   OSCCON,A 
    CLRF    TRISB,A 
    CLRF    LATB,A 
    CLRF    PORTC,A 
    BCF     TRISC,0,A 
    BCF     TRISC,1,A 
    MOVLW   10010011B 
    MOVWF   T0CON,A   

MAIN:  
    CLRF    UNIDAD,A 
    CLRF    DECENA,A 
     
CUENTA: 
    
    CALL    DELAY_500mS 
    
    BTFSS   PORTA,0,A       ; Revisamos RA0 para saber qué incrementar
    GOTO    CUENTA_NUMEROS
    
    /*CALL    UNIDADES 
    CALL    DECENAS 
    CALL    DELAY_500mS 
    
    ; Incrementa letra de nombre (0 a 3)
    INCF    UNIDAD,F,A 
    MOVLW   3 
    CPFSGT  UNIDAD,A 
    GOTO    CHECK_DECENA 
    CLRF    UNIDAD,A */
    
    CUENTA_LETRAS:
    INCF    UNIDAD,F,A 
    MOVLW   12
    CPFSGT  UNIDAD,A 
    GOTO    CUENTA 
    CLRF    UNIDAD,A 
    GOTO    CUENTA
    
    CUENTA_NUMEROS:
    INCF    DECENA,F,A 
    MOVLW   9 
    CPFSGT  DECENA,A 
    GOTO    CUENTA 
    CLRF    DECENA,A 
    GOTO    CUENTA

/*CHECK_DECENA:
    ; Incrementa número (0 a 9)
    INCF    DECENA,F,A 
    MOVLW   9 
    CPFSGT  DECENA,A 
    GOTO    CUENTA 
    CLRF    DECENA,A 
    GOTO    CUENTA */

    END
