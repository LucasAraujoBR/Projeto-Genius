list p=16f877

ORG 0x00
goto ini

ORG 0x04
goto inter

ini:
bcf 0x03,6
bsf 0x03,5 ; banco 01 -------------------------------------

movlw 0x00 ; LEDs do jogo
movwf 0x85 ; TrisA
movlw 0xF1 ; Botões do jogo e de Start/Reset
movwf 0x86 ; TrisB

clrf  0x87 ; TrisC
clrf  0x88 ; TrisD
clrf  0x89 ; TrisE

movlw 0x02 ; Liga interrupção para TMR2
movwf 0x8C ; PIE1

movlw .250
movwf 0x92 ; PR2

movlw 0x06 ; Mudar registradores para digital (RA0-RA3/RA5,RE0-R2)
movwf 0x9F ; Configurar ADCON1 para 16F877 
	
bcf 0x03,5 ; banco 00 ------------------------------------

clrf  0x05 ; PortA
clrf  0x06 ; PortB

clrf  0x07 ; PortC
clrf  0x08 ; PortD
clrf  0x09 ; PortE

movlw 0x00
movwf 0x0C ; PIR1 

; TMR1 Incia contagem em Zero
clrf 0x0E ; Configura TMR1 L
clrf 0x0F ; COnfigura TMR1 H

clrf 0x11 ; TMR2 começa em zero

movlw 0x01 ; Pré-escala 1:1 e liga TMR1
movwf 0x10 ; Configurar T1CON

movlw 0x49 ; Pré 1:4 | Pós 1:10 | TMR2 desligado
movwf 0x12 ; Configurar T2CON

; Interrupções Ativadas:
; 	Interrupçao de Perifericos
;	Interrupção Externa 
;	Interrupção de Mudança de Borda no PortB (Será ativada na hora desejada)
movlw 0xD0
movwf 0x0B ; Configurar INTCON

; Registradores que guardam a sequencia de cores
clrf 0x20
clrf 0x21
clrf 0x22
clrf 0x23 

; Registradores que guardam a sequencia apertada
clrf 0x30
clrf 0x31
clrf 0x32
clrf 0x33

; Regitrador que guarda a cor randomica
clrf 0x40    

; Registrador contador auxiliar do TMR2
movlw .100
movwf 0x41

; Registrador que determina o level
movlw .1 ; Começa no level 1
movwf 0x42

; Fim das Configurações ---------------------------------

loop:
	btfsc 0x40,4 ; Verifica se é para mostrar as cores para o jogador
	call ShowColors
	btfsc 0x40,0 ; Verifica se o jogo iniciou/resetou
	goto GetColors
goto loop

inter:
btfss 0x0B,0 ; Verifica Interrupção de Borda do PortB (Botoes das Cores)Verifica Interrupção Externa Primeiro (Start/Reset)
goto RBIF
btfss 0x0B,1 ; Verifica Interrupção Externa Primeiro (Start/Reset)
goto INTF
btfss 0x0C,2 ; Verifica Interrupçao do TMR2 até PR2
goto TMR2IF
retfie

RBIF:
bcf 0x0B,0 ; Apaga Flag
bsf 0x44,2
btfsc 0x06,4
goto bAmarelo
btfsc 0x06,5
goto bAzul
btfsc 0x06,6
goto bVermelho
goto bVerde

bAmarelo:
movlw .0
movwf 0x27
retfie

bAzul:
movlw .1
movwf 0x27
retfie

bVermelho:
movlw .2
movwf 0x27
retfie

bVerde:
movlw .3
movwf 0x27
retfie

INTF:
bcf 0x0B,1 ; Apaga Flag	
bsf 0x40,0 ; Iniciar jogo
retfie

TMR2IF:
bcf 0x0C,2 ; Apaga Flag
decfsz 0x41,1
retfie
bcf 0x12,2 ; Desliga TMR2
clrf 0x11
bcf 0x23,7 ; Termina o laço TimerLoop 
retfie

ShowColors:
	bcf 0x40,4 ; Apaga Flag
	movlw .1
	movwf 0x43
	movf 0x20,0
	movlw 0x44
	btfsc 0x31,0
	
start:
	btfss 0x44,1
	goto Ver1
	btfss 0x44,0
	goto LedAmarelo
	goto LedAzul
	Ver1:
	btfss 0x44,0
	goto LedVermelho
	goto LedVerde

LedAmarelo:
	bsf 0x05,3
	goto timer

LedAzul:
	bsf 0x05,2
	goto timer

LedVermelho:
	bsf 0x05,1
	goto timer

LedVerde:
	bsf 0x05,0
	goto timer

timer:
	bsf 0x12,2 ; Liga TMR2
	; 	Esta Flag ligada indica que o simom ainda esta mantendo o LED ligado
	; porque o TMR2 ainda não rodou por 1s.
	bsf 0x23,7 
	TimerLoop:
	btfsc 0x23,7
	goto TimerLoop
	
	btfsc 0x05,0
	goto desligaVerde 
	btfsc 0x05,1
	goto desligaVermelho
	btfsc 0x05,2
	goto desligaAzul
	goto desligaAmarelo

	desligaVerde:
	bcf 0x05,0
	goto nextColor

	desligaVermelho:
	bcf 0x05,1
	goto nextColor

	desligaAzul:
	bcf 0x05,2
	goto nextColor

	desligaAmarelo:
	bcf 0x05,3
	goto nextColor

nextColor:
	movf 0x43,0
	subwf 0x42,0
	btfsc 0x03,2
	goto fimShowColors
	incf 0x43,1
	clrf 0x44
	
	btfss 0x43,3
	goto nr2a7
	goto nr8a15
	
	nr2a7:
	btfss 0x43,2
	goto nr2a3
	goto nr4a7

	nr8a15:
	btfss 0x43,2
	goto nr8a11
	goto nr12a15
	
	nr2a3:
	btfss 0x43,0
	goto nr2
	goto nr3

	nr4a7:
	btfss 0x43,1
	goto nr4a5
	goto nr6a7

	nr8a11:
	btfss 0x43,1
	goto nr8a9
	goto nr10a11

	nr12a15:
	btfss 0x43,1
	goto nr12a13
	goto nr14a15
	
	nr4a5:
	btfss 0x43,0
	goto nr4
	goto nr5

	nr6a7:
	btfss 0x43,0
	goto nr6
	goto nr7
	
	nr8a9:
	btfss 0x43,0
	goto nr8
	goto nr9	

	nr10a11:
	btfss 0x43,0
	goto nr10
	goto nr11

	nr12a13:
	btfss 0x43,0
	goto nr12
	goto nr13	
	
	nr14a15:
	btfss 0x43,0
	goto nr14
	goto nr15

	nr2:
	btfsc 0x20,2
	bcf 0x44,0
	btfsc 0x20,3
	bcf 0x44,1
	goto start
	
	nr3:
	btfsc 0x20,4
	bcf 0x44,0
	btfsc 0x20,5
	bcf 0x44,1
	goto start
	
	nr4:
	btfsc 0x20,6
	bcf 0x44,0
	btfsc 0x20,7
	bcf 0x44,1
	goto start
	
	nr5:
	btfsc 0x21,0
	bcf 0x44,0
	btfsc 0x21,1
	bcf 0x44,1
	goto start	
	
	nr6:
	btfsc 0x21,2
	bcf 0x44,0
	btfsc 0x21,3
	bcf 0x44,1
	goto start	
	
	nr7:
	btfsc 0x21,4
	bcf 0x44,0
	btfsc 0x21,5
	bcf 0x44,1
	goto start	

	nr8:
	btfsc 0x21,6
	bcf 0x44,0
	btfsc 0x21,7
	bcf 0x44,1
	goto start	

	nr9:
	btfsc 0x22,0
	bcf 0x44,0
	btfsc 0x22,1
	bcf 0x44,1
	goto start	

	nr10:
	btfsc 0x22,2
	bcf 0x44,0
	btfsc 0x22,3
	bcf 0x44,1
	goto start	

	nr11:
	btfsc 0x22,4
	bcf 0x44,0
	btfsc 0x22,5
	bcf 0x44,1
	goto start	

	nr12:
	btfsc 0x22,6
	bcf 0x44,0
	btfsc 0x22,7
	bcf 0x44,1
	goto start	

	nr13:
	btfsc 0x23,0
	bcf 0x44,0
	btfsc 0x23,1
	bcf 0x44,1
	goto start	

	nr14:
	btfsc 0x23,2
	bcf 0x44,0
	btfsc 0x20,3
	bcf 0x44,1
	goto start	

	nr15:
	btfsc 0x23,4
	bcf 0x44,0
	btfsc 0x23,5
	bcf 0x44,1
	goto start
	
fimShowColor:
movlw .1
movwf 0x43
bsf 0x0B, 3 ; Liga interrupções RB Port Change
turnLoop:
btfss 0x44,2
goto turnLoop
	bcf 0x44,2 ; Apaga flag
	; Encontrar a posição que sera guardado a cor precionada  
	btfss 0x43,3
	goto nr1a7
	goto nr8a15
	
	lv1a7:
	btfss 0x43,2
	goto lv1a3
	goto lv4a7

	lv8a15:
	btfss 0x43,2
	goto lv8a11
	goto lv12a15
	
	lv1a3:
	btfss 0x43,1
	goto lv1
	goto lv2a3

	lv4a7:
	btfss 0x43,1
	goto lv4a5
	goto lv6a7

	lv8a11:
	btfss 0x43,1
	goto lv8a9
	goto lv10a11

	lv12a15:
	btfss 0x43,1
	goto lv12a13
	goto lv14a15
	
	lv2a3:
	btfss 0x43,0
	goto lv2
	goto lv3
	
	lv4a5:
	btfss 0x43,0
	goto lv4
	goto lv5

	lv6a7:
	btfss 0x43,0
	goto lv6
	goto vl7
	
	lv8a9:
	btfss 0x43,0
	goto lv8
	goto lv9	

	lv10a11:
	btfss 0x43,0
	goto lv10
	goto lv11

	lv12a13:
	btfss 0x43,0
	goto lv12
	goto lv13	
	
	lv14a15:
	btfss 0x43,0
	goto lv14
	goto lv15

	lv1:
	bcf 0x30,0
	bcf 0x30,1
	btfsc 0x27,0
	bsf 0x30,0
	btfsc 0x27,1
	bsf 0x30,1
	goto nextButton
	
	lv2:
	bcf 0x30,2
	bcf 0x30,3
	btfsc 0x27,0
	bsf 0x30,2
	btfsc 0x27,1
	bsf 0x30,3
	goto nextButton
	
	nr3:
	bcf 0x30,4
	bcf 0x30,5
	btfsc 0x27,0
	bsf 0x30,4
	btfsc 0x27,1
	bsf 0x30,5
	goto nextButton
	
	nr4:
	bcf 0x30,6
	bcf 0x30,7
	btfsc 0x27,0
	bsf 0x30,6
	btfsc 0x27,1
	bsf 0x30,7
	goto nextButton
	
	nr5:
	bcf 0x31,0
	bcf 0x31,1
	btfsc 0x27,0
	bsf 0x31,0
	btfsc 0x27,1
	bsf 0x31,1
	goto nextButton
	
	nr6:
	bcf 0x31,2
	bcf 0x31,3
	btfsc 0x27,0
	bsf 0x31,2
	btfsc 0x27,1
	bsf 0x31,3
	goto nextButton
	
	nr7:
	bcf 0x31,4
	bcf 0x31,5
	btfsc 0x27,0
	bsf 0x31,4
	btfsc 0x27,1
	bsf 0x31,5
	goto nextButton

	nr8:
	bcf 0x31,6
	bcf 0x31,7
	btfsc 0x27,0
	bsf 0x31,6
	btfsc 0x27,1
	bsf 0x31,7
	goto nextButton

	nr9:
	bcf 0x32,0
	bcf 0x32,1
	btfsc 0x27,0
	bsf 0x32,0
	btfsc 0x27,1
	bsf 0x32,1
	goto nextButton

	nr10:
	bcf 0x32,2
	bcf 0x32,3
	btfsc 0x27,0
	bsf 0x32,2
	btfsc 0x27,1
	bsf 0x32,3
	goto nextButton

	nr11:
	bcf 0x32,4
	bcf 0x32,5
	btfsc 0x27,0
	bsf 0x32,4
	btfsc 0x27,1
	bsf 0x32,5
	goto nextButton

	nr12:
	bcf 0x32,6
	bcf 0x32,7
	btfsc 0x27,0
	bsf 0x32,6
	btfsc 0x27,1
	bsf 0x32,7
	goto nextButton

	nr13:
	bcf 0x33,0
	bcf 0x33,1
	btfsc 0x27,0
	bsf 0x33,0
	btfsc 0x27,1
	bsf 0x33,1
	goto nextButton

	nr14:
	bcf 0x33,2
	bcf 0x33,3
	btfsc 0x27,0
	bsf 0x33,2
	btfsc 0x27,1
	bsf 0x33,3
	goto nextButton

	nr15:
	bcf 0x33,4
	bcf 0x33,5
	btfsc 0x27,0
	bsf 0x33,4
	btfsc 0x27,1
	bsf 0x33,5
	
	nextButton:
	movf 0x43,0
	subwf 0x42,0
	btfsc 0x03,2
	goto CheckColors
	incf 0x43,1
	goto turnLoop
	
CheckColors:
	movlw .1
	movwf 0x43
	
	btfss 0x30,0
	goto bit0_zero
	goto bit0_um

	bit0_zero:
	btfss 0x20,0
	goto bit1
	goto fail
	
	bit0_um:
	btfss 0x20,0
	goto fail
	goto bit1
	
	bit1:
	btfss 0x30,1
	goto bit1_zero
	goto bit1_um
	
	bit1_zero:
	btfss 0x20,1
	goto Color2
	goto fail
	
	bit1_um:
	btfss 0x20,1
	goto fail
	goto Color2
	
	Color2:
	movf 0x43,0
	subwf 0x42,0
	btfsc 0x03,2
	goto endTurn
	incf 0x43,1
	
	btfss 0x30,2
	goto bit2_zero
	goto bit2_um

	bit2_zero:
	btfss 0x20,2
	goto bit3
	goto fail
	
	bit2_um:
	btfss 0x20,2
	goto fail
	goto bit3
	
	bit3:
	btfss 0x30,3
	goto bit3_zero
	goto bit3_um
	
	bit3_zero:
	btfss 0x20,3
	goto Color3
	goto fail
	
	bit3_um:
	btfss 0x20,3
	goto fail
	goto Color3
	
	Color3:
	movf 0x43,0
	subwf 0x42,0
	btfsc 0x03,2
	goto endTurn
	incf 0x43,1

	
	


btfsc 0x44,7
goto endTurn
goto turnLoop
endTurn:
incf 0x42,1
btfsc 0x42,8 ; Verifica se o level passou de 15 (Critério de vitoria)
goto WIN

return

GetColors:
	bcf 0x40,0 ; Apagar Flag
	bsf 0x40,4 ; Indica que vai mostrar as Cores para o jogador

	movf  0x0E,0
	movwf 0x20 ; Inseri 4 cores
	movwf 0x21 ; Inseri as mesmas 4 cores mas...
	movlw .123
	addwf 0x21,1 ; Elas são "embaralhadas"

	movf  0x0F,0
	movwf 0x22 ; Inseri mais 4 cores
	movwf 0x23 ; Inseri as mesmas 4 cores mas...
	movlw .123
	addwf 0x23,1 ; Elas são "embaralhadas"
		
	goto loop

WIN:


end