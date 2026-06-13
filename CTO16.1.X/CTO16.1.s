/*
////////////////////////////////////////////////////////////////////////////
               CTO16.1.s
Pérez Nava Yael Mauricio
Fecha de Compilacion: 09/05/26
Programa: 
máquina de estados. ra6 y RE1 [00 imp] [10 par] [01 y 11 rst]
x=0 ascendente impares menores que 10
x=1 descendente pares menores que 10
	       
0 es el inicio de todo sistema secuencial
impares 1,3,5,7,9 (cinco estados)asc
m4 0,2,4,6,8 (4 estados y el cero) desc
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
 PSECT udata_acs
    PA_COPIA:   DS 1
    CONTEO_1:   DS 1
    CONTEO_5:   DS 1
    CONTEO_10:  DS 1
    CONTEO_500: DS 1
    COUNTER:    DS 1

VECTOR_RESET:
    PSECT CODE,RELOC=2,ABS
    ORG 0x00
    GOTO INICIO

PROGRAMA_PRINCIPAL:
    PSECT CODE,RELOC=2
    ORG 0X04

; --- Tabla de Decodificación (Display Cátodo Común) ---
TABLAN:
    ADDWF   PCL,F,A
    RETLW   0XFC ; Indice 0 -> Muestra 0 (PAR)
    RETLW   0XDA ; Indice 1 -> Muestra 2 (PAR)
    RETLW   0X66 ; Indice 2 -> Muestra 4 (PAR)
    RETLW   0XBE ; Indice 3 -> Muestra 6 (PAR)
    RETLW   0XFE ; Indice 4 -> Muestra 8 (PAR)
    
    RETLW   0X60 ; Indice 5 -> Muestra 1 (imp)
    RETLW   0XF2 ; Indice 6 -> Muestra 3 (imp)
    RETLW   0XB6 ; Indice 7 -> Muestra 5 (imp)
    RETLW   0XE0 ; Indice 8 -> Muestra 7 (imp)
    RETLW   0XF6 ; Indice 9 -> Muestra 9 (imp)

DECODIFICAR1:
    MOVF    COUNTER,W,A
    RLNCF   WREG,F,A
    CALL    TABLAN
    MOVWF   LATB,A
    RETURN

;DELAYS

; Delay base de 1ms
DELAY_1mS:
    MOVLW   81
    MOVWF   CONTEO_1,A
L1:
    DECFSZ  CONTEO_1,F,A
    BRA     L1
    RETURN

; Delay de 5ms para el multiplexado
DELAY_5mS:
    MOVLW   5
    MOVWF   CONTEO_5,A
L5:
    CALL    DELAY_1mS
    DECFSZ  CONTEO_5,F,A
    BRA     L5
    RETURN

; Delay de 10ms para el antirrebote del botón
DELAY_10mS:
    MOVLW   10
    MOVWF   CONTEO_10,A
L10:
    CALL    DELAY_1mS
    DECFSZ  CONTEO_10,F,A
    BRA     L10
    RETURN

; Delay de 500ms que revisa el botón de Reset constantemente
DELAY_500mS:
    MOVLW   100             ; 100 iteraciones de 5ms = 500ms
    MOVWF   CONTEO_500,A
L500:
    CALL    DELAY_5mS
    CALL    VERIFICAR_BOTON ; Revisa el RE1 cada 5ms
    DECFSZ  CONTEO_500,F,A
    BRA     L500
    RETURN
VERIFICAR_BOTON:
    ; 1. Prioridad Máxima: Botón RESET (RE1 - Pull Up -> Espera 0)
    BTFSS   PORTE, 1, A     ; ¿Picaron Reset?
    GOTO    ACCION_RESET    ; Sí -> Vamos a resetear

    ; 2. Prioridad Media: Botón STOP (RE0 - Pull Down -> Espera 1)
    BTFSC   PORTE, 0, A     ; ¿Picaron Stop?
    GOTO    ACCION_PAUSA    ; Sí -> Vamos a pausar

    RETURN                  ; Ninguno -> Sigue el conteo
;BOTON PULLDOWN
    
    ACCION_RESET:
    CALL    DELAY_10mS      ; Antirrebote
    WAIT_RST:
    BTFSS PORTE,1,A
    BRA WAIT_RST
    CLRF    STKPTR, A       ; Limpiamos Pila para no romper el PIC
    CLRF COUNTER,A 
    CALL DECODIFICAR1
    GOTO    ESTADO_CONGELADO       ; Mandamos al MAIN para que reinicie en el estado actual
   
    ; --- RUTINA DE PAUSA / PLAY ---
ACCION_PAUSA:
    CALL    DELAY_10mS      ; Antirrebote
ESPERAR_SOLTAR_PAUSA:
    BTFSC   PORTE, 0, A     
    BRA     ESPERAR_SOLTAR_PAUSA ; Espera a soltar para no hacer falsos
    
ESTADO_CONGELADO:
    ; ¡AQUÍ ESTÁ EN PAUSA! Pero seguimos vigilando si quieres Resetear
    BTFSS   PORTE, 1, A     ; ¿Picaron RESET mientras estaba pausado?
    GOTO    ACCION_RESET    ; ¡Sí! Le hacemos caso y salimos de la pausa

    ; Vigilamos si quieres quitar la pausa (Play)
    BTFSS   PORTE, 0, A     ; ¿Volvieron a picar RE0?
    BRA     ESTADO_CONGELADO; No -> Sigue congelado

    ; ¡Quitaron la pausa!
    CALL    DELAY_10mS      ; Antirrebote
ESPERAR_SOLTAR_PLAY:
    BTFSC   PORTE, 0, A
    BRA     ESPERAR_SOLTAR_PLAY ; Espera a que suelte
    
    RETURN                  ; Regresa a contar donde se quedó
    
INICIO:
    SETF    TRISA,A         ; Puerto A como entrada
    CLRF    PORTA,A
    MOVLW   00001111B       ; Pines digitales
    MOVWF   ADCON1,A
    MOVLW   00000111B       ; Apaga comparadores
    MOVWF   CMCON,A
    MOVLW   01000000B       ; Reloj interno a 1 MHz
    MOVWF   OSCCON,A
    CLRF    TRISB,A         ; Puerto B salida para display
    CLRF    LATB,A

SET_COUNTER:
    CLRF    COUNTER,A
    

MAIN:
    BTFSS   PORTA,6,A       ; RA6 = 0 -> Modo IMPARES asc
    GOTO    IMP_ASC
    GOTO    PAR_DES        ; RA6 = 1 -> Modo Múltiplos de 4 desc

; --- MÁQUINA 1: PARES Descendente (8 -> 6 -> 4 -> 2 -> 0) ---
PAR_DES:
    MOVLW   4               ; Índice inicial (Apunta al 8)
    MOVWF   COUNTER,A
PARES_LOOP:
    CALL    DECODIFICAR1
    CALL    DELAY_500mS
    BTFSS   PORTA,6,A       ; Si cambias el switch en medio de la cuenta, reinicia
    GOTO    MAIN
    
    DECF    COUNTER,F,A     ; Baja de índice
    MOVLW   255             ; ¿Bajó de cero?
    CPFSEQ  COUNTER,A
    GOTO    PARES_LOOP
    GOTO    PAR_DES        ; Cicla de nuevo al 8

; --- MÁQUINA 2: IMPARES Ascendente (1 -> 3 -> 5 -> 7 -> 9) ---
IMP_ASC:
    MOVLW   5               ; Índice inicial (Apunta al 2)
    MOVWF   COUNTER,A
IMP_LOOP:
    CALL    DECODIFICAR1
    CALL    DELAY_500mS
    BTFSC   PORTA,6,A       ; Si cambias el switch en medio de la cuenta, reinicia
    GOTO    MAIN
    
    INCF    COUNTER,F,A     ; Sube de índice
    MOVLW   10               ; ¿Ya pasó del estado 6 (que es el 7)?
    CPFSEQ  COUNTER,A
    GOTO    IMP_LOOP
    GOTO    IMP_ASC      ; Cicla de nuevo al 2

    END

