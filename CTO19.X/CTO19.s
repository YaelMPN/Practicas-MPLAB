 /* 
//////////////////////////////////////////////////////////////////////////// 
     CTO19.s
Pérez Nava Yael Mauricio
Fecha de Compilacion: 12/05/26
Programa:  el circuito muestra en exhibidores de 7 segmentos multi- 
plexados, EL CONTEO ASC 0-99 con botones para iniciar y parar el contador
*/
//////////////////////////////////////////////////////////////////////////// 
 
PROCESSOR 18F4550 ;DISPOSITIVO A PROGRAMAR 
;////////////////////////////////////////////////////////////////////////////// 
PALABRA_DE_CONFIGURACION: 
; PIC18F4550 Configuration Bit Settings
  CONFIG  PLLDIV = 1
  CONFIG  CPUDIV = OSC1_PLL2
  CONFIG  USBDIV = 1
  CONFIG  FOSC = INTOSCIO_EC
  CONFIG  FCMEN = OFF
  CONFIG  IESO = OFF
  CONFIG  PWRT = ON
  CONFIG  BOR = OFF
  CONFIG  BORV = 3
  CONFIG  VREGEN = OFF
  CONFIG  WDT = OFF
  CONFIG  WDTPS = 32768
  CONFIG  CCP2MX = ON
  CONFIG  PBADEN = OFF
  CONFIG  LPT1OSC = OFF
  CONFIG  MCLRE = ON
  CONFIG  STVREN = ON
  CONFIG  LVP = OFF
  CONFIG  ICPRT = OFF
  CONFIG  XINST = OFF
  CONFIG  CP0 = OFF
  CONFIG  CP1 = OFF
  CONFIG  CP2 = OFF
  CONFIG  CP3 = OFF
  CONFIG  CPB = OFF
  CONFIG  CPD = OFF
  CONFIG  WRT0 = OFF
  CONFIG  WRT1 = OFF
  CONFIG  WRT2 = OFF
  CONFIG  WRT3 = OFF
  CONFIG  WRTC = OFF
  CONFIG  WRTB = OFF
  CONFIG  WRTD = OFF
  CONFIG  EBTR0 = OFF
  CONFIG  EBTR1 = OFF
  CONFIG  EBTR2 = OFF
  CONFIG  EBTR3 = OFF
  CONFIG  EBTRB = OFF

#include <xc.inc>
/*///////////////////////////////////////////////////////////////////////////// */ 
DECLARAR_VARIABLES:   
PSECT UDATA_ACS 
UNIDAD: DS 1 
DECENA: DS 1 
CONTEO_5:DS 1 
CONTEO_1:DS 1 
ESTADO: DS 1
/////////////////////////////////////////////////////////////////////////////// 
VECTOR_RESET: 
PSECT CODE,RELOC=2,ABS 
ORG 0x00
GOTO INICIO
/////////////////////////////////////////////////////////////////////////////// 
PROGRAMA_PRINCIPAL: 
PSECT CODE,RELOC=2 
ORG 0X04

TABLAN: 
ADDWF   PCL,F,A
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

DECODIFICAR1: 
    RLNCF   WREG,F,A 
    CALL    TABLAN 
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
    MOVLW  0XE2 
    MOVWF  TMR0H,A 
    MOVLW  0XF7 
    MOVWF  TMR0L,A 
ASKF: 
    CALL    DECENAS 
    CALL    UNIDADES 
    BTFSS   INTCON,2,A 
    GOTO    ASKF 
    BCF     INTCON,2,A 
    RETURN 
     
DECENAS: 
    MOVF    DECENA,W,A 
    CALL    DECODIFICAR1 
    CALL    DECENASD 
    CALL    DELAY_5mS 
    RETURN 
     
UNIDADES:     
    MOVF    UNIDAD,W,A 
    CALL    DECODIFICAR1 
    CALL    UNIDADESD 
    CALL    DELAY_5mS 
    RETURN 
     
DECENASD: 
    CLRF    LATC,A 
    BSF     LATC,1,A 
    MOVWF   LATB,A 
    RETURN 
     
UNIDADESD:     
    CLRF    LATC,A 
    BSF     LATC,0,A 
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
    SETF    TRISE,A     ; RE0 y RE1 como Entradas
    CLRF    ESTADO,A    ; Inicia en estado STOP (0) 

MAIN:  
    CLRF    UNIDAD,A 
    CLRF    DECENA,A 
     
REFRESCAR_DISPLAYS:
    CALL    UNIDADES 
    CALL    DECENAS 
    
    ;Leer Botón (Solo RE0 - Pull Down)
    BTFSS   PORTE, 0, A      ; ¿Botón presionado (1)?
    GOTO    DECIDIR          ; No -> salta a decidir
    
    ; lo presiono :o
    BTG     ESTADO, 0, A     ; Alterna el bit (Start/Stop)
    
ESPERAR_SOLTAR:
    ; Anti-rebote: mantiene vivos los displays mientras el botón siga apretado
    CALL    UNIDADES
    CALL    DECENAS
    BTFSC   PORTE, 0, A      ; ¿El botón sigue presionado?
    GOTO    ESPERAR_SOLTAR   ; Sí -> se queda aqui 
    
DECIDIR:
    ; Decidir si el contador avanza
    BTFSS   ESTADO, 0, A     ; ¿Estado = 1 (avanzar)?
    GOTO    REFRESCAR_DISPLAYS ; No -> Sigue refrescando el mismo número

CUENTA: 
    ; Si Estado = 1, esperamos el medio segundo y avanzamos
    CALL    DELAY_500mS 
    
    INCF    UNIDAD,F,A 
    MOVLW   9 
    CPFSGT  UNIDAD,A
    GOTO    REFRESCAR_DISPLAYS 
    
    CLRF    UNIDAD,A 
    INCF    DECENA,F,A 
    MOVLW   10 
    CPFSLT  DECENA,A
    GOTO    MAIN 
    GOTO    REFRESCAR_DISPLAYS 

    END

