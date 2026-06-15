/* //////////////////////////////////////////////////////////////////////////// 
     CTO19.s
Pérez Nava Yael Mauricio
Fecha de Compilacion: 12/05/26
Programa: Conteo ASC 0-99 multiplexado con botones de Start/Stop.
//////////////////////////////////////////////////////////////////////////// 
*/ 
 
PROCESSOR 18F4550 

;---- PALABRA DE CONFIGURACIÓN ----
  CONFIG  PLLDIV = 1, CPUDIV = OSC1_PLL2, USBDIV = 1
  CONFIG  FOSC = INTOSCIO_EC ; Oscilador interno, pines RA6 y RA7 como E/S
  CONFIG  FCMEN = OFF, IESO = OFF, PWRT = ON, BOR = OFF, BORV = 3
  CONFIG  VREGEN = OFF, WDT = OFF, WDTPS = 32768, CCP2MX = ON
  CONFIG  PBADEN = OFF       ; PORTB como digital (importante para los displays)
  CONFIG  LPT1OSC = OFF, MCLRE = ON, STVREN = ON, LVP = OFF, ICPRT = OFF
  CONFIG  XINST = OFF, CP0 = OFF, CP1 = OFF, CP2 = OFF, CP3 = OFF, CPB = OFF
  CONFIG  CPD = OFF, WRT0 = OFF, WRT1 = OFF, WRT2 = OFF, WRT3 = OFF, WRTC = OFF
  CONFIG  WRTB = OFF, WRTD = OFF, EBTR0 = OFF, EBTR1 = OFF, EBTR2 = OFF
  CONFIG  EBTR3 = OFF, EBTRB = OFF

#include <xc.inc>

;---- DECLARACIÓN DE VARIABLES ----   
PSECT UDATA_ACS 
UNIDAD:   DS 1   ; Guarda el valor de las unidades (0-9)
DECENA:   DS 1   ; Guarda el valor de las decenas (0-9)
CONTEO_5: DS 1   
CONTEO_1: DS 1   
ESTADO:   DS 1   ; Bit 0 controla: 1 = Marcha, 0 = Paro
 
;---- VECTOR DE RESET ----
PSECT CODE,RELOC=2,ABS 
ORG 0x00
GOTO INICIO      
 
;---- PROGRAMA PRINCIPAL ----
PSECT CODE,RELOC=2 
ORG 0X04


TABLAN: 
    ADDWF   PCL,F,A  ;salto
    RETLW   0XFC     ; 0  
    RETLW   0X60     ; 1  
    RETLW   0XDA     ; 2  
    RETLW   0XF2     ; 3  
    RETLW   0X66     ; 4  
    RETLW   0XB6     ; 5  
    RETLW   0XBE     ; 6  
    RETLW   0XE0     ; 7 
    RETLW   0XFE     ; 8 
    RETLW   0XF6     ; 9 

DECODIFICAR1: 
    RLNCF   WREG,F,A ; Multiplica por 2 el índice por ajuste 
    CALL    TABLAN  
    RETURN 
 
; Rutina de retardo de 5ms 
DELAY_5mS: 
    MOVLW   5 
    MOVWF   CONTEO_5,A 
DELAY_1mS: 
    MOVLW   160 
    MOVWF   CONTEO_1,A 
ASK: 
    DECFSZ  CONTEO_1,F,A ; ¿Llegó a 0 el interno?
    GOTO    ASK          ; No -> Repite bucle interno
    DECFSZ  CONTEO_5,F,A ; ¿Llegó a 0 el externo?
    GOTO    DELAY_1mS    ; No -> Reinicia bucle interno
    RETURN 

; Retardo de 500ms usando Timer0 (Sin apagar display)
DELAY_500mS: 
    MOVLW   0XE2 
    MOVWF   TMR0H,A      
    MOVLW   0XF7 
    MOVWF   TMR0L,A      
ASKF: 
    CALL    DECENAS      
    CALL    UNIDADES     
    BTFSS   INTCON,2,A   ; ¿Ya desbordó el Timer0? (TMR0IF)
    GOTO    ASKF         ; No -> Sigue refrescando pantallas
    BCF     INTCON,2,A   ; Sí -> Limpia la bandera de sobreflujo
    RETURN 
     
DECENAS: 
    MOVF    DECENA,W,A   ; Carga valor numérico de la decena
    CALL    DECODIFICAR1 ; Convierte a 7 segmentos
    CALL    DECENASD     ; Activa hardware de decenas
    CALL    DELAY_5mS    ; Muestra por 5ms
    RETURN 
     
UNIDADES:     
    MOVF    UNIDAD,W,A   ; Carga valor numérico de la unidad
    CALL    DECODIFICAR1 ; Convierte a 7 segmentos
    CALL    UNIDADESD    ; Activa hardware de unidades
    CALL    DELAY_5mS    ; Muestra por 5ms
    RETURN 
     
DECENASD: 
    CLRF    LATC,A       ; Apaga displays 
    BSF     LATC,1,A     ; Enciende display de Decenas (RC1)
    MOVWF   LATB,A       ; Envía los segmentos al Puerto B
    RETURN 
     
UNIDADESD:     
    CLRF    LATC,A       ; Apaga displays
    BSF     LATC,0,A     ; Enciende display de Unidades (RC0)
    MOVWF   LATB,A       ; Envía los segmentos al Puerto B
    RETURN 
      

INICIO: 
    SETF    TRISA,A      ; Puerto A como entradas
    CLRF    PORTA,A 
    MOVLW   00001111B 
    MOVWF   ADCON1,A     ; Configura pines como digitales
    MOVLW   00000111B 
    MOVWF   CMCON,A      ; Desactiva comparadores analógicos
    MOVLW   01010000B 
    MOVWF   OSCCON,A     ; Configura oscilador interno a 4 MHz
    CLRF    TRISB,A      ; Puerto B como salidas (Displays)
    CLRF    LATB,A 
    CLRF    PORTC,A 
    BCF     TRISC,0,A    ; RC0 como salida (Habilitador Unidades) este y el de abajo van conectados al comun de cada display
    BCF     TRISC,1,A    ; RC1 como salida (Habilitador Decenas)
    MOVLW   10010011B 
    MOVWF   T0CON,A      ; Timer0: ON, 16 bits, Prescaler 1:16
    SETF    TRISE,A      ; Puerto E como entradas (Botones)
    CLRF    ESTADO,A     ; Inicializa en modo STOP (0)

;---- BUCLE PRINCIPAL ----
MAIN:  
    CLRF    UNIDAD,A     ; Resetea unidades a 0
    CLRF    DECENA,A     ; Resetea decenas a 0 
     
REFRESCAR_DISPLAYS:
    CALL    UNIDADES     ; Muestra unidad actual
    CALL    DECENAS      ; Muestra decena actual
    
    ; --- Leer Botón de Control (RE0) ---
    BTFSS   PORTE, 0, A  ; ¿Botón presionado? (1 lógico)
    GOTO    DECIDIR      ; No -> Comprueba si debe contar
    
    ; Acción al presionar el botón
    BTG     ESTADO, 0, A ; Invierte bit de marcha/paro (Toggle)
    
ESPERAR_SOLTAR:
    CALL    UNIDADES     ; Mantiene vivo el display mientras se presiona
    CALL    DECENAS
    BTFSC   PORTE, 0, A  ; ¿Sigue presionado?
    GOTO    ESPERAR_SOLTAR ; Sí -> Espera hasta que se suelte 
    
DECIDIR:
    BTFSS   ESTADO, 0, A ; ¿El sistema está en modo Marcha (1)?
    GOTO    REFRESCAR_DISPLAYS ; No (0) -> Mantiene el número estático

; ---- LÓGICA DEL CONTADOR ----
CUENTA: 
    CALL    DELAY_500mS  ; Espera 0.5 segundos manteniendo encendido el display
    
    INCF    UNIDAD,F,A   ; Incrementa las unidades
    MOVLW   9 
    CPFSGT  UNIDAD,A     ; ¿Unidades > 9?
    GOTO    REFRESCAR_DISPLAYS ; No -> Sigue mostrando el número
    
    CLRF    UNIDAD,A     ; Sí -> Resetea unidades a 0
    INCF    DECENA,F,A   ; Incrementa las decenas
    MOVLW   10 
    CPFSLT  DECENA,A     ; ¿Decenas < 10?
    GOTO    MAIN         ; No (Llegó a 99+1) -> Resetea todo el contador a 00
    GOTO    REFRESCAR_DISPLAYS ; Sí -> Continúa el conteo normal

    END