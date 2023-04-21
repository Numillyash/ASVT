;
; AssemblerApplication1.asm
;
; Created: 06.02.2023 18:38:51
; Author : Georgul
;
.device atmega328p
.def	wreg		= R16
.def	wreg2		= R17 
.def	tmp2		= R18 ;; non use
.def 	workMode 	= R19
.def 	tmp_reg 	= R20
.def	timer100Byte= R21
.def 	timer010Byte= R22
.def 	timer001Byte= R23
.def	tmp_reg_24	= R24
.def 	printByte 	= R26
.def 	hbyteNum 	= R27
.def 	lbyteNum 	= R28
.def 	delay_reg 	= R29 ;; non use


.org $000					; Reset Interrupt ADDR
	jmp init				; Reset Interrupt
.org INT0addr				; Interrupt INT0 ADDR
	jmp changeMode			; Interrupt INT0

init:
	LDI tmp_reg, 0xFF 		; Set B0-B5 (D8-D13) enable to write
	OUT DDRB, tmp_reg		; Common cathode (D8, D11-D13)
							; D9-D10 for PWM
	LDI tmp_reg, 0xF0		; Set D4-D7 ports enable to write
	OUT DDRD, tmp_reg		; high byte of 7-segment data
	LDI tmp_reg, 0x0F		; Set A0-A3 ports enable to write
	OUT DDRC, tmp_reg		; low  byte of 7-segment data
	LDI tmp_reg, 0xC6		; Set 0b**000110 to B port. 11 for PWM 
	OUT PORTB, tmp_reg		;
	LDI	tmp_reg,low(RAMEND) ; Setup stack            
	out	SPL,tmp_reg
	LDI	tmp_reg,high(RAMEND)
	out	SPH,tmp_reg

	cli						; Stop interrupts
	LDI tmp_reg, 0x83		; 0b10000011. Enable ADC, 011 - division by 8 (125 khz?)
	STS ADCSRA, tmp_reg
	LDI tmp_reg, 0x65		; 0b01100101. 01 - AVcc with external capacitor at AREF pin
	STS ADMUX, tmp_reg		; 1 - ADC Left Adjust Result
							; 0101 - ADC5 pin
	rcall adc_convert		; read ADC
    	
	LDI tmp_reg, 0xA1		; 0b10100001, FAST PWM 8-bit
	STS TCCR1A, tmp_reg		; Clear OC1A/OC1B on compare match, 
							; set OC1A/OC1B at BOTTOM (non-inverting mode)
	LDI tmp_reg, 0x09		; 0b00001001 No clock prescaling
	STS TCCR1B, tmp_reg

	LDI tmp_reg, 0x00		; Set MCUCR (???)
	OUT MCUCR, tmp_reg		;
	LDI tmp_reg, 0x03		; Enable interrupts on INT0 and INT1
	OUT EIMSK, tmp_reg		;
	OUT EIFR, tmp_reg 		; Avoid interrupt on awake (SEI)
	LDI tmp_reg, 0x0A		; 
	STS EICRA, tmp_reg		; FALLEN to intr setup
	
	LDI workMode, 0 		; Set workMode to 0 by default
	SEI 					; Start interrupts
; 							; End init
main:
	LDI tmp_reg, 1			; if mode is 1
	CP tmp_reg, workMode
	BRNE work_mode			; goto WorkMode
	jmp settings_mode		; else goto SettingsMode

changeMode:
	PUSH tmp_reg			; Send tmp to Stack

	inc workMode			; wm++
	LDI tmp_reg, 0x02		; compare with 0x02
	AND tmp_reg, workMode	; if second bit is down
	BREQ changeMode_exit	; goto and
	LDI tmp_reg, 0xFC		; else erase last 2 bits
	AND workMode, tmp_reg
changeMode_exit:
	POP tmp_reg				; Read tmp from Stack
	SEI						; Attach intr
	jmp main				; goto main

settings_mode:
	LDI R30, 0b00111101;
	OUT PORTB, R30
	;LDI wreg2, 0xF0
	MOV wreg, workMode
	call movBytes ; set bytes
	; hbyte
	LDI R30, 0b00101000;0b11110101 ; 3-d digit
	MOV printByte, hbyteNum
	call printByte_func
	CLR tmp_reg_24
	BST printByte, 0
	BLD tmp_reg_24, 0
	BST printByte, 1
	BLD tmp_reg_24, 1 
	BST printByte, 2
	BLD tmp_reg_24, 2
	BST printByte, 3
	BLD tmp_reg_24, 3 
	OUT PORTB, R30
	LDI tmp_reg, 0x0C
	OR printByte, tmp_reg ; set interrupts on p3 and p2
	OUT PORTD, printByte
	OUT PORTC, tmp_reg_24
	rcall delay_setup

	; lbyte
	LDI R30, 0b00110000;0b11101101 ; 4-d digit
	MOV printByte, lbyteNum
	call printByte_func
	CLR tmp_reg_24
	BST printByte, 0
	BLD tmp_reg_24, 0
	BST printByte, 1
	BLD tmp_reg_24, 1 
	BST printByte, 2
	BLD tmp_reg_24, 2
	BST printByte, 3
	BLD tmp_reg_24, 3 
	OUT PORTB, R30
	LDI tmp_reg, 0x0C
	OR printByte, tmp_reg ; set interrupts on p3 and p2
	OUT PORTD, printByte
	OUT PORTC, tmp_reg_24
	rcall delay_setup
	;call delay_setup
rjmp main

work_mode:
	CLR R1						; Clear R1 (zero register)
	LDI tmp_reg, 0x0C			; 
	OUT PORTD, tmp_reg
	OUT PORTC, R1

	rcall adc_convert			; get ADC

	; 1-s digit for PWM
	CLR R1						; Clear R1 (zero register)
	LDI tmp_reg, 0b00000111		; Open 1-d digit
	OUT PORTB, tmp_reg			; 
	LDI tmp_reg, 0x00			; 
	OUT PORTD, R1			; 
	STS OCR1AH, R1
	STS OCR1AL, wreg
	STS OCR1BH, R1
	STS OCR1BL, wreg

	rcall delay_setup
	; Clear PWM
	;LDI wreg2, 0x00
	;STS OCR1AH, wreg2
	;STS OCR1AL, wreg2
	; SEND adc to 2-d digit
	LDI R30, 0b00001000;0b11111001
	CLR tmp_reg_24
	BST wreg, 0
	BLD tmp_reg_24, 0
	BST wreg, 1
	BLD tmp_reg_24, 1 
	BST wreg, 2
	BLD tmp_reg_24, 2
	BST wreg, 3
	BLD tmp_reg_24, 3 
	OUT PORTD, wreg
	OUT PORTC, tmp_reg_24
	OUT PORTB, R30
	rcall delay_setup

	; convert ADC to 2 bytes
	call movBytes ; set bytes
	
	; hbyte
	LDI R30, 0b00010000;0b11110101 ; 3-d digit
	MOV printByte, hbyteNum
	call printByte_func
	CLR tmp_reg_24
	BST printByte, 0
	BLD tmp_reg_24, 0
	BST printByte, 1
	BLD tmp_reg_24, 1 
	BST printByte, 2
	BLD tmp_reg_24, 2
	BST printByte, 3
	BLD tmp_reg_24, 3 
	OUT PORTB, R30
	LDI tmp_reg, 0x0C
	OR printByte, tmp_reg ; set interrupts on p3 and p2
	OUT PORTD, printByte
	OUT PORTC, tmp_reg_24
	rcall delay_setup

	; lbyte
	LDI R30, 0b00100000;0b11101101 ; 4-d digit
	MOV printByte, lbyteNum
	call printByte_func
	CLR tmp_reg_24
	BST printByte, 0
	BLD tmp_reg_24, 0
	BST printByte, 1
	BLD tmp_reg_24, 1 
	BST printByte, 2
	BLD tmp_reg_24, 2
	BST printByte, 3
	BLD tmp_reg_24, 3 
	OUT PORTB, R30
	LDI tmp_reg, 0x0C
	OR printByte, tmp_reg ; set interrupts on p3 and p2	OUT PORTD, printByte
	OUT PORTC, tmp_reg_24
	rcall delay_setup
rjmp main

printByte_func:
	PUSH tmp_reg
	LDI tmp_reg, 15
	CP printByte, tmp_reg
	BRSH print_F
	LDI tmp_reg, 14
	CP printByte, tmp_reg
	BRSH print_E
	LDI tmp_reg, 13
	CP printByte, tmp_reg
	BRSH print_D
	LDI tmp_reg, 12
	CP printByte, tmp_reg
	BRSH print_C
	LDI tmp_reg, 11
	CP printByte, tmp_reg
	BRSH print_B
	LDI tmp_reg, 10
	CP printByte, tmp_reg
	BRSH print_A
	LDI tmp_reg, 9
	CP printByte, tmp_reg
	BRSH print_9
	LDI tmp_reg, 8
	CP printByte, tmp_reg
	BRSH print_8
	LDI tmp_reg, 7
	CP printByte, tmp_reg
	BRSH print_7
	LDI tmp_reg, 6
	CP printByte, tmp_reg
	BRSH print_6
	LDI tmp_reg, 5
	CP printByte, tmp_reg
	BRSH print_5
	LDI tmp_reg, 4
	CP printByte, tmp_reg
	BRSH print_4
	LDI tmp_reg, 3
	CP printByte, tmp_reg
	BRSH print_3
	LDI tmp_reg, 2
	CP printByte, tmp_reg
	BRSH print_2
	LDI tmp_reg, 1
	CP printByte, tmp_reg
	BRSH print_1
	LDI tmp_reg, 0
	CP printByte, tmp_reg
	BRSH print_0
print_F:
	LDI printByte, 0xE2
	RJMP label_ret	
print_E:
	LDI printByte, 0xF2
	RJMP label_ret	
print_D:
	LDI printByte, 0x7F
	RJMP label_ret	
print_C:
	LDI printByte, 0x72
	RJMP label_ret	
print_B:
	LDI printByte, 0xFF
	RJMP label_ret	
print_A:
	LDI printByte, 0xEE
	RJMP label_ret	
print_9:
	LDI printByte, 0xDE
	RJMP label_ret	
print_8:
	LDI printByte, 0xFE
	RJMP label_ret	
print_7:
	LDI printByte, 0x0E
	RJMP label_ret
print_6:
	LDI printByte, 0xFA
	RJMP label_ret	
print_5:
	LDI printByte, 0xDA
	RJMP label_ret	
print_4:
	LDI printByte, 0xCC
	RJMP label_ret	
print_3:
	LDI printByte, 0x9E
	RJMP label_ret	
print_2:
	LDI printByte, 0xB6
	RJMP label_ret	
print_1:
	LDI printByte, 0x0C
	RJMP label_ret
print_0:
	LDI printByte, 0x7E
	RJMP label_ret
label_ret:
	POP tmp_reg
	RET


movBytes:
	CLR lbyteNum
	CLR hbyteNum
	MOV hbyteNum, wreg
	LSR hbyteNum
	LSR hbyteNum
	LSR hbyteNum
	LSR hbyteNum
	MOV lbyteNum, wreg
	LSL lbyteNum
	LSL lbyteNum
	LSL lbyteNum
	LSL lbyteNum
	LSR lbyteNum
	LSR lbyteNum
	LSR lbyteNum
	LSR lbyteNum
	RET
   
delay_setup:
   CLR timer100Byte
   CLR timer010Byte
   CLR timer001Byte
   CLR tmp_reg
   LDI timer100Byte, 0 			; here is the hihest byte
   LDI timer010Byte, 1 			; here is the lowest byte

   LSL timer100Byte				; << 2 left to have 10 clear bits at right
   BST timer010Byte, 7			; 14 left to set time
   BLD timer100Byte, 0			; 
   LSL timer010Byte
   LSL timer100Byte
   BST timer010Byte, 7
   BLD timer100Byte, 0
   LSL timer010Byte
delay_cycle:
   SUBI timer001Byte, 1 		; 1 tick
   SBCI timer010Byte, 0 		; 1 tick
   SBCI timer100Byte, 0 		; 1 tick

   CPSE timer100Byte, tmp_reg 	; 1 ticks, if equal then skip (2 ticks)
   RJMP wait_nop_8 				; 2 ticks
   CPSE timer010Byte, tmp_reg 	; 1 ticks, if equal then skip (2 ticks)
   RJMP wait_nop_5 				; 2 ticks
   CPSE timer001Byte, tmp_reg 	; 1 ticks, if equal then skip (2 ticks)
   RJMP wait_nop_2 				; 2 ticks
   NOP
   NOP
   NOP
   RET                        	; go back, 4 ticks
wait_nop_8:
   NOP
   NOP
   NOP
wait_nop_5:
   NOP
   NOP
   NOP
wait_nop_2:
   NOP
   NOP
   RJMP   delay_cycle
   

adc_convert:
	LDI wreg, 0b01100101	; ADC Channel 5 (PortC.5 ; pin 28)
	STS ADMUX, wreg			; wreg contains channel
	LDS R25, ADCSRA			; 
	OUT PORTD, R25
	sbi PORTD, ADSC
   	IN R25, PORTD
   	STS ADCSRA, R25
cycle_adc:
   	LDS R25, ADCSRA
   	OUT PORTD, R25
	sbic PORTD , ADSC
	rjmp cycle_adc
   	IN R25, PORTD
   	STS ADCSRA, R25
	LDS wreg, ADCL
   	LDS wreg, ADCH
ret

clear_output:

ret

