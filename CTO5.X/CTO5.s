/*CTO5.s
Pérez Nava Yael Mauricio
Fecha de Compilacion: 21/03/26
Programa: CUANDO EN LA PARTE EXTREMA IZQUIERDA DEL DIP SE HAGA EL 14(4 BITS DE DERECHA A IZQUIERDA, SIN CONTAR EL ULTIMO (EL TOTAL SON 7 ASI QUE DE IZQUIERDA A DERECHA SE CUENTAN 4 SOBRANDO 3)), 
     EN LA BARRA DE LEDS SE REFLEJARA UNA SUMA DE LA CONSTANTE 60 MAS LA SUMA DE LOS 3 BITS DE LA EXTREMA IZQUIERDA DEL DIP QUE SOBRAN, DANDO RESULTADOS DESDE 60 HASTA 67, EN CUALQUIER OTRA COMBINACION QUE NO SEA EL 14 NO LO HARA
*/
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
    PSECT UDATA_ACS
    PA_COPIA: DS 1
    UNIDAD: DS 1
    DECENA:DS 1
  //VECTOR_RESET:
 PSECT CODE,RELOC=2,ABS
 ORG 0x00 //00000000B 0
 GOTO INICIO
 
 PROGRAMA_PRINCIPAL:
 PSECT CODE,RELOC=2
 ORG 0X04
 INICIO://configuramos sfr
    SETF TRISA,A //Los pines del PA son input (7)
    CLRF PORTA,A //Limpiar PA
    MOVLW 15 // W= 15
    MOVWF ADCON1, A //ADCON1 = 15 POR LO TANTO LAS ENTRADAS
    //EN PORTA, B Y E SON DIGITALES
    MOVLW 7 // W=7
    MOVWF CMCON,A //CMCON=7 POR LO TANTO EL COMPARADOR
    // DE VOLTAJES ESTA OFF
    CLRF TRISB,A //TRISB=00000000 POR LO TANTO PB ES SALIDA
    //DEDICADA
    CLRF LATB,A //LATB=00000000B LIMPIO LA SALIDA
    CLRF WREG,A // W=0D
    
    MAIN:
    LEER_Y_COPIAR: 
    MOVFF PORTA,PA_COPIA //PA Y COPIA VALEN LO MISMO
			   //PA = 01011111=PA_COPIA EJEMPLO

    ENMASCARAR:
    MOVLW 01111000B //W ES LA MASCARA W=01111000 PA <6:3>
    ANDWF PA_COPIA,F,A //COPIA FUE ENMASCARADA Y SOLO SE
			//CONSERVARON SUS BITS 6:3
			//PA_COPIA=01111000
    POSICIONAR:
    RLNCF PA_COPIA,F,A //PA_COPIA=11110000, SE MOVIO TODO A LA IZQUIERDA UNA POSICION 
    SWAPF PA_COPIA,F,A //PA_COPIA=00001111, SE VOLTEAN LOS 4 BITS COMPLETOS
    
    VALIDAR_EL_14:
    MOVLW 00001110B //W=14
    CPFSEQ PA_COPIA,A //ESTOY PREGUNTANDO SI COPIA=14
    GOTO NO_ES
    GOTO SI_ES
    
    SI_ES:
    MOVLW 00000111B // MASCARA PARA LOS 3 BITS EXTREMA DERECHA
    ANDWF PORTA,W,A // W=00000 B->2,1,0
    
    ADDLW 60 // W= W+60
    MOVWF LATB,A //SE SACA EL RESULTADO A LEDS ENTER 60 Y 67
    GOTO MAIN
    
    NO_ES:
    CLRF LATB,A //SE APAGA TODA LA BARRA DE LEDS
    
    GOTO MAIN
    END


