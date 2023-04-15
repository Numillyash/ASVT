;
; AssemblerApplication1.asm
;
; Created: 06.02.2023 18:38:51
; Author : Georgul
;
.device atmega328p
.def	wreg		=R16
.def	duration	=R17
.def	wreg2		=R18
.def printByte = R26
.def hbyteNum = R27
.def lbyteNum = R28
.def delay_reg = R29
.def tmp_reg = R20
init:
	ldi wreg, 0xFF;(1<<DDB3)|(1<<DDB2)|(1<<DDB4)|(1<<DDB0)
	OUT  DDRB, wreg
	ldi wreg, 0b00000011
	OUT  DDRC, wreg
	ldi wreg, 0b11100010
	OUT  PORTB, wreg
	ldi		wreg,low(RAMEND)             
	out		SPL,wreg

	ldi		wreg,high(RAMEND)	; Stack Pointer = $45F
	out		SPH,wreg

	cli							; ��������� ����������


	ldi wreg, 0b10000011		; ���. ���, ������. ������., ���������� ���������, ��/8 (125 kHz)
	STS ADCSRA, wreg

	ldi wreg, 0b01100101		; AVcc, ����. ����. �� Aref, ������. �� ���. ����, channel 1.23V bg
	STS ADMUX, wreg

	rcall adc_convert

    
	ldi		wreg,0x00		
	out		PORTB,wreg			; ������ 0 � ����
	ldi		wreg,0xFF		; PortB.1 (OC1A) - Output
	out		DDRB,wreg		
	
	ldi wreg, 0b10000001		; �����. 8 ������ ���
	STS TCCR1A, wreg

	ldi wreg, 0b00001001		; CK/1
	STS TCCR1B, wreg
	SEI
	LDI R19, 250
main:
	CLR R24
	CLR printByte
	OUT PORTD, printByte
	OUT PORTC, R24

	; GET ADC
	ldi wreg, 0b01100101		; ADC Channel 5 (PortC.5 ; pin 28)
	rcall adc_convert

	
	
	; 1-s digit for PWM
	ldi R30, 0b11111110
	ldi wreg2, 0x00
	OUT PORTD, wreg2
	STS OCR1AH, wreg2
	STS OCR1AL, wreg
	OUT PORTB, R30
	rcall delay_setup
	; Clear PWM
	ldi wreg2, 0x00
	STS OCR1AH, wreg2
	STS OCR1AL, wreg2
	; SEND adc to 2-d digit
	ldi R30, 0b11111001
	CLR R24
	BST wreg, 0
	BLD R24, 0
	BST wreg, 1
	BLD R24, 1 
	OUT PORTD, wreg
	OUT PORTC, R24
	OUT PORTB, R30
	rcall delay_setup

	; convert ADC to 2 bytes
	call movBytes ; set bytes
	
	; hbyte
	ldi R30, 0b11110101 ; 3-d digit
	MOV printByte, hbyteNum
	call printByte_func
	CLR R24
	BST printByte, 0
	BLD R24, 0
	BST printByte, 1
	BLD R24, 1 
	OUT PORTB, R30
	OUT PORTD, printByte
	OUT PORTC, R24
	rcall delay_setup

	; lbyte
	ldi R30, 0b11101101 ; 4-d digit
	MOV printByte, lbyteNum
	call printByte_func
	CLR R24
	BST printByte, 0
	BLD R24, 0
	BST printByte, 1
	BLD R24, 1 
	OUT PORTB, R30
	OUT PORTD, printByte
	OUT PORTC, R24
	rcall delay_setup



rjmp main

printByte_func:
	ldi R22, 15
	CP printByte, R22
	BRSH print_F
	ldi R22, 14
	CP printByte, R22
	BRSH print_E
	ldi R22, 13
	CP printByte, R22
	BRSH print_D
	ldi R22, 12
	CP printByte, R22
	BRSH print_C
	ldi R22, 11
	CP printByte, R22
	BRSH print_B
	ldi R22, 10
	CP printByte, R22
	BRSH print_A
	ldi R22, 9
	CP printByte, R22
	BRSH print_9
	ldi R22, 8
	CP printByte, R22
	BRSH print_8
	ldi R22, 7
	CP printByte, R22
	BRSH print_7
	ldi R22, 6
	CP printByte, R22
	BRSH print_6
	ldi R22, 5
	CP printByte, R22
	BRSH print_5
	ldi R22, 4
	CP printByte, R22
	BRSH print_4
	ldi R22, 3
	CP printByte, R22
	BRSH print_3
	ldi R22, 2
	CP printByte, R22
	BRSH print_2
	ldi R22, 1
	CP printByte, R22
	BRSH print_1
	ldi R22, 0
	CP printByte, R22
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
   CLR R21
   CLR R22
   CLR R23
   CLR tmp_reg
   LDI R21, 0 ; here is the hihest byte
   LDI R22, 1
   ;LDI R17, 250 ; here is the lowest byte
   LSL R21
   BST R22, 7
   BLD R21, 0
   LSL R22
   LSL R21
   BST R22, 7
   BLD R21, 0
   LSL R22
delay_cycle:
   SUBI R23, 1 ; 1 tick
   SBCI R22, 0 ; 1 tick
   SBCI R21, 0 ; 1 tick

   CPSE R21, tmp_reg ; 1 ticks, if equal then skip (2 ticks)
   RJMP wait_nop_8 ; 2 ticks
   CPSE R22, tmp_reg ; 1 ticks, if equal then skip (2 ticks)
   RJMP wait_nop_5 ; 2 ticks
   CPSE R23, tmp_reg ; 1 ticks, if equal then skip (2 ticks)
   RJMP wait_nop_2 ; 2 ticks
   NOP
   NOP
   NOP
   RET                        ; go back, 4 ticks
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

	STS ADMUX, wreg				; wreg contains channel
	LDS R25, ADCSRA
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


   LDS wreg, ADCL				; ������ ������������ (������ ������ �������� ADCL)
	;OUT PORTD, wreg
   ;ldi wreg, 250				; 25mS
	;rcall delay
   LDS wreg, ADCH				; wreg contains result
   ;OUT PORTD, wreg
   ;ldi wreg, 250		case 0:
    ;out  PORTB,  0b11111110;
     ; break; 	; 25mS
	;rcall delay

ret



