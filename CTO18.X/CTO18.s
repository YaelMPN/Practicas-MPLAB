
/* 
//////////////////////////////////////////////////////////////////////////// 

     
     CTO18.s
Pérez Nava Yael Mauricio
Fecha de Compilacion: 12/05/26
Programa:   El sistema muestra el conteo ascendente y descendente del 0 al 9 controlado por botones
     para incrementar o decrementar el conteo

*/

//////////////////////////////////////////////////////////////////////////// 

    PROCESSOR 18F4550 ;DISPOSITIVO A PROGRAMAR 
;////////////////////////////////////////////////////////////////////////////// 
PALABRA_DE_CONFIGURACION: 
; PIC18F4550 Configuration Bit Settings 
    ; Assembly source line config statements

; CONFIG1L
  CONFIG  PLLDIV = 1            ; PLL Prescaler Selection bits (No prescale (4 MHz oscillator input drives PLL directly))
  CONFIG  CPUDIV = OSC1_PLL2    ; System Clock Postscaler Selection bits ([Primary Oscillator Src: /1][96 MHz PLL Src: /2])
  CONFIG  USBDIV = 1            ; USB Clock Selection bit (used in Full-Speed USB mode only; UCFG:FSEN = 1) (USB clock source comes directly from the primary oscillator block with no postscale)

; CONFIG1H
  CONFIG  FOSC = INTOSCIO_EC     ; Oscillator Selection bits (EC oscillator, PLL enabled, port function on RA6 (ECPIO))
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

;config statements should precede project file includes.
    #include<xc.inc>
/*///////////////////////////////////////////////////////////////////////////// 
*/ 

    PSECT UDATA 
    COUNTER: DS 1 
    DELAY1:  DS 1    
    DELAY2:  DS 1    


PSECT CODE, RELOC=2, ABS 
ORG 0x00 
    GOTO INICIO 

; --- TABLA DECODIFICADORA ---
PSECT CODE, RELOC=2
 ORG 0X04
TABLA: 
    ADDWF   PCL, F, A 
    RETLW 0XFC ;0
    RETLW 0X60 ;1
    RETLW 0XDA ;2
    RETLW 0XF2 ;3
    RETLW 0X66 ;4
    RETLW 0XB6 ;5
    RETLW 0XBE ;6
    RETLW 0XE0 ;7
    RETLW 0XFE ;8
    RETLW 0XF6 ;9


DECODIFICAR: 
    /*MOVF    COUNTER, W, A
    RLNCF WREG,F,A
    CALL    TABLA
    ;COMF    WREG, F, A   ; Invertir para Ánodo Común
    MOVWF   LATB, A
    RETURN*/
    
    
    MOVLW   11
    CPFSEQ  COUNTER, A
    BRA     CHECA_10
    BRA     CONTEO_11       ; Sí es 11, va a su multiplexado

CHECA_10:
    ; --- CHECAR SI ES 10 ---
    MOVLW   10
    CPFSEQ  COUNTER, A
    BRA     CONTEO_0_9      ; No es ni 10 ni 11, es del 0 al 9
    BRA     CONTEO_10       ; Sí es 10, va a su multiplexado

CONTEO_0_9:

    BSF     LATC, 0, A      ; RC0 = 1 (Apaga Decenas)
    BCF     LATC, 1, A      ; RC1 = 0 (Prende Unidades)
    MOVF    COUNTER, W, A   ; Carga el dígito directo
    RLNCF   WREG, F, A
    CALL    TABLA
    MOVWF   LATB, A
    RETURN

CONTEO_10:
   
    BSF     LATC, 1, A      ; Apaga Unidades
    BCF     LATC, 0, A      ; Prende Decenas
    MOVLW   1               ; Forzamos '1'
    RLNCF   WREG, F, A
    CALL    TABLA
    MOVWF   LATB, A
    CALL    DELAY_MS        ; Retardo 
    
  
    BSF     LATC, 0, A      ; Apaga Decenas
    BCF     LATC, 1, A      ; Prende Unidades
    MOVLW   0               ; Forzamos  '0'
    RLNCF   WREG, F, A
    CALL    TABLA
    MOVWF   LATB, A
    CALL    DELAY_MS        ; Retardo para retención visual
    RETURN

CONTEO_11:
    ; --- MOSTRAR EL 11 
    ; Paso A: Mostrar el '1' en las Decenas
    BSF     LATC, 1, A      ; Apaga Unidades
    BCF     LATC, 0, A      ; Prende Decenas
    MOVLW   1
    RLNCF   WREG, F, A
    CALL    TABLA
    MOVWF   LATB, A
    CALL    DELAY_MS
    
    ; Paso B: Mostrar el '1' en las Unidades
    BSF     LATC, 0, A      ; Apaga Decenas
    BCF     LATC, 1, A      ; Prende Unidades
    MOVLW   1
    RLNCF   WREG, F, A
    CALL    TABLA
    MOVWF   LATB, A
    CALL    DELAY_MS
    RETURN
    
    
    
DELAY_MS:
    MOVLW   20           
    MOVWF   DELAY1, A
L1: MOVLW   50          
    MOVWF   DELAY2, A
L2: DECFSZ  DELAY2, F, A
    GOTO    L2
    DECFSZ  DELAY1, F, A
    GOTO    L1
    RETURN

INICIO:
    MOVLW   0x0F        
    MOVWF   ADCON1, A    
    MOVLW   0x07        
    MOVWF   CMCON, A     
    CLRF    TRISB, A     
    CLRF    TRISC, A     
    MOVLW   0x03         
    MOVWF   TRISE, A     
    
    
    BCF     LATC, 0, A   
    BCF     LATC, 1, A  
    CLRF    COUNTER, A

MAIN:
    CALL    DECODIFICAR  

CHECK_RE0:
    BTFSS   PORTE, 0, A  
    GOTO    CHECK_RE1    
    CALL    DELAY_MS     ; Ahora es mucho más rápido
    
    MOVLW   11
    CPFSEQ COUNTER,A
    ;SUBWF   COUNTER, W, A 
    ;BC      ESPERAR_RE0  
    INCF    COUNTER, F, A
    
ESPERAR_RE0:
    BTFSC   PORTE, 0, A  
    GOTO    ESPERAR_RE0  ; Se queda aquí hasta que sueltes
    CALL    DELAY_MS     ; Pequeña ráfaga para evitar ruido al soltar
    GOTO    MAIN

; --- BOTÓN DECREMENTO (RE1) ---
; --- BOTÓN DECREMENTO (RE1) ---
CHECK_RE1:
    BTFSC   PORTE, 1, A  
    GOTO    MAIN         
    CALL    DELAY_MS     
    
    MOVF    COUNTER, W, A 
    BZ      ESPERAR_RE1  
    DECF    COUNTER, F, A 

ESPERAR_RE1:
    BTFSS   PORTE, 1, A  
    GOTO    ESPERAR_RE1  ; Se queda aquí hasta que sueltes
    CALL    DELAY_MS
    GOTO    MAIN

END