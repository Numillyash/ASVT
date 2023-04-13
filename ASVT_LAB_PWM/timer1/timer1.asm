��; crystal 1MHZinternal)
; Timer Counter 1 
; Fast PWM

.include "m8def.inc"
		
.def	wreg		=R16
.def	duration	=R17
.def	wreg2		=R18


init:

	ldi		wreg,low(RAMEND)             
	out		SPL,wreg

	ldi		wreg,high(RAMEND)	; Stack Pointer = $45F
	out		SPH,wreg

	cli							; ��������� ����������


	ldi wreg, 0b10000011		; ���. ���, ������. ������., ���������� ���������, ��/8 (125 kHz)
	out ADCSR, wreg

	ldi wreg, 0b01101110		; AVcc, ����. ����. �� Aref, ������. �� ���. ����, channel 1.23V bg
	out ADMUX, wreg

	rcall adc_convert


;*******************    TIMER1    ***********************
 
	ldi		wreg,0x00		
	out		PORTB,wreg			; ������ 0 � ����

	ldi		wreg,0b00000010		; PortB.1OC1A) - Output
	out		DDRB,wreg	

	
	
	ldi wreg, 0b10000001		; �����. 8 ������ ���
	out TCCR1A, wreg

	ldi wreg, 0b00001001		; CK/1
	out TCCR1B, wreg

	ldi wreg, 0b00000000
	out TIMSK, wreg



main:
	
	ldi wreg, 250				; 25mS
	rcall delay

	ldi wreg, 0b01100101		; ADC Channel 5PortC.5 ; pin 28)
	rcall adc_convert
	
	ldi wreg2, 0x00
	out OCR1AH, wreg2

	out OCR1AL, wreg


rjmp main



;*********************** DELAYS **************************

delay:							; 0.1mS * wreg
		ldi duration, 24
		cycle:
		nop
		dec 	duration
		brne	cycle
		dec 	wreg
		brne	delay
ret


;********************** AD CONVERTION *******************

adc_convert:

	out ADMUX, wreg				; wreg contains channel
	
	sbi ADCSR, ADSC				; Start Convertion
	sbic ADCSR , ADSC
	rjmp PC-1
	in wreg, ADCL				; ������ ������������ (������ ������ �������� ADCL)

	in wreg, ADCH				; wreg contains result

ret





