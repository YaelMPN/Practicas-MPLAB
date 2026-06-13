/*CTO2.s
Pérez Nava Yael Mauricio
Fecha de Compilacion: 10/03/26
Programa:PROGRAMA PARA COMPROBAR LAS INSTRUCCIONES ORIENTADAS A LAS VARIABLES
(GPR Y SFR)
REPRESENTADAS POR EL PARAMETRO "F" EN LA SINTAXIS. LAS OPERACIONES SE
REALIZARAN
CON LOS DATOS A=42 Y B=110 Y LOS RESULTADOS SE GUARDARAN EN OTROS
EN ESTE CASO SE MANTIENEN LOS 105 Y 9 REGISTROS
DENTRO DE LA MEMORIA RAM.
*/
PROCESSOR 18F4550 ;DISPOSITIVO A PROGRAMAR
    

//////////////////////////////////////////////////////////////////////////////
 PALABRA_DE_CONFIGURACION:
    
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
EN ESTA SECCIÓN SE DA NOMBRE A LOS DIFERENTES REGISTROS A UTILIZAR EN EL
CÓDIGO
RECUERDA QUE LAS ETIQUETAS SE ASIGNAN COLOCANDO ":" DESPUÉS DEL ALIAS.
EXISTEN
TRES FORMAS DE RESERVAR ESPACIOS DE MEMORIA EN LA RAM DEL PIC, EN ESTE
PROGRAMA
UTILIZAREMOS EL ACCESS BANK*. PARA INDICAR AL PROCESADOR QUE UTILIZARAS ESA
MEMORIA, EL PARAMETRO "A" DEBE TENER EL VALOR "0"
*ACCESS BANK SE REFIERE A LOS PRIMEROS 96 REGISTROS DEL BNK 0 (GPR'S) Y LOS
ÚLTIMOS 160 REGISTROS DEL BNK 15 (SFR'S)
*/
  
  DECLARAR_VARIABLES:
PSECT udata_acs ;variables almacenadas en access bank(UDATA_ACS)
DATOA: DS 1 //DATOA ES EL NOMBRE DE LA VARIABLE. "DS" SIGNIFICA "DEFINE STORAGE"
DATOB: DS 1 //EL "1" ES EL NÚMERO DE BYTES QUE OCUPA LA VARIABLE
SUMA: DS 1
ANDR: DS 1
ACEROS: DS 1
NOTR: DS 1
MENOS1: DS 1
MAS1: DS 1
IORR: DS 1
MULH: DS 1
MULL: DS 1
NEGATIVO: DS 1
IZQ: DS 1
DERECHA: DS 1
AUNOS: DS 1
RESTA: DS 1
SWAP: DS 1
XORR: DS 1  
    
    ///////////////////////////////////////////////////////////////////////////////
VECTOR_RESET:
PSECT CODE,RELOC=2,ABS
ORG 0x00 //00000000B 0
GOTO INICIO
 ///////////////////////////////////////////////////////////////////////////////
PROGRAMA_PRINCIPAL:
PSECT CODE,RELOC=2
ORG 0X04 ;PARA SALTAR EL VECTOR INTERRUPCIÓN
INICIO: //configurar SFR'S
CLRF WREG,A //CLRF F,A WREG=00000000
CLRF PRODL,A //A SIGNIFICA ENTRAR AL
CLRF PRODH //ACCESS BANK O A. RAM
//INICIAR DATOA Y DATOB
    MAIN:
MOVLW 9 //PRIMERO COLOCAR VALOR A W
MOVWF DATOA,A //PASARLO AL REG da=w=9
MOVLW 105
MOVWF DATOB,A //MOVFF WREG,DATOB
    //MOVFF FS,FD
    //WREG=FE8 1111 1110 1000 W=0 0
SUMAR:
MOVF DATOA,W,A //MOVF F,D,A DA=9 DB=105 W=9
ADDWF DATOB,W,A//ADDWF F,D,A DA=9 DB=105 W=114
MOVWF SUMA,A
    
AND_D:
MOVF DATOA,W,A
ANDWF DATOB,W,A
MOVWF ANDR,A
    
LIMPIAR: //CLRF ACEROS,A
MOVF DATOA,W,A//W=00001001
CLRF WREG,A//W=00000000
MOVWF ACEROS,A//ACEROS=W=0
    
NOT_T:
COMF DATOA,W,A//DA=9 W=11110110
MOVWF NOTR,A
    
DECREMENTO:
MOVF DATOA,W,A
DECF DATOA,W,A  ;AQUI LE RESTO 1 A DATOA, Y LO MANDA A W
MOVWF MENOS1, A
    
INCREMENTAR: 
MOVF DATOA,W,A
INCF DATOA,W,A      ; SUMA 1 A DATOA Y LO MANDA A W
MOVWF MAS1,A

IOR_OP:
MOVF DATOA,W,A
IORWF DATOB,W,A     ; OR Inclusivo entre W (DATOA) y DATOB. Destino W
MOVWF IORR,A

MULTIPLICAR:
MOVF DATOA,W,A
MULWF DATOB,A       ; Multiplica W (DATOA) x DATOB. Resultado a PRODH:PRODL
MOVFF PRODH, MULH   ; Copiamos parte alta del resultado a MULH para mostrarlo
MOVFF PRODL, MULL   ; Copiamos parte baja del resultado a MULL para mostrarlo

ROTAR_IZQ:
MOVF DATOA,W,A
RLNCF DATOA,W,A     ; Rota DATOA a la izq sin usar Carry. Destino W
MOVWF IZQ,A

ROTAR_DER:
MOVF DATOA,W,A
RRNCF DATOA,W,A     ; Rota DATOA a la der sin usar Carry. Destino W
MOVWF DERECHA,A

SET_OP:
SETF AUNOS,A        ; Pone todos los bits de AUNOS en 1 (Queda en 0xFF / 255)

RESTAR:
MOVF DATOA,W,A
SUBWF DATOB,W,A     ; Resta DATOB - W (105 - 9). Destino W
MOVWF RESTA,A

SWAP_OP:
MOVF DATOA,W,A
SWAPF DATOA,W,A     ; Intercambia los 4 bits altos con los bajos de DATOA. Destino W
MOVWF SWAP,A

XOR_OP:
MOVF DATOA,W,A
XORWF DATOB,W,A     ; XOR exclusivo entre W (DATOA) y DATOB. Destino W
MOVWF XORR,A    
    
GOTO SUMAR
END
    