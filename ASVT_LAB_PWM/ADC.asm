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

init:

	ldi		wreg,low(RAMEND)             
	out		SPL,wreg

	ldi		wreg,high(RAMEND)	; Stack Pointer = $45F
	out		SPH,wreg

	cli							; ��������� ����������


	ldi wreg, 0b10000011		; ���. ���, ������. ������., ���������� ���������, ��/8 (125 kHz)
	STS ADCSRA, wreg

	ldi wreg, 0b01101110		; AVcc, ����. ����. �� Aref, ������. �� ���. ����, channel 1.23V bg
	STS ADMUX, wreg

	rcall adc_convert

    
	ldi		wreg,0x00		
	out		PORTB,wreg			; ������ 0 � ����
	ldi		wreg,0b00000010		; PortB.1 (OC1A) - Output
	out		DDRB,wreg		
	
	ldi wreg, 0b10000001		; �����. 8 ������ ���
	STS TCCR1A, wreg

	ldi wreg, 0b00001001		; CK/1
	STS TCCR1B, wreg


main:
	
	ldi wreg, 250				; 25mS
	rcall delay

	ldi wreg, 0b01100101		; ADC Channel 5 (PortC.5 ; pin 28)
	rcall adc_convert
	
	ldi wreg2, 0x00
	STS OCR1AH, wreg2
	STS OCR1AL, wreg

rjmp main



delay:							; 0.1mS * wreg
		ldi duration, 24
		cycle:
		nop
		dec 	duration
		brne	cycle
		dec 	wreg
		brne	delay
ret
   
adc_convert:

	STS ADMUX, wreg				; wreg contains channel
	LDS R25, ADCSRA
   OUT PORTB, R25
	sbi PORTB, ADSC
   IN R25, PORTB
   STS ADCSRA, R25

   LDS R25, ADCSRA
   OUT PORTB, R25
	sbic PORTB , ADSC
	rjmp PC-3
   IN R25, PORTB
   STS ADCSRA, R25


   LDS wreg, ADCL				; ������ ������������ (������ ������ �������� ADCL)
	LDS wreg, ADCH				; wreg contains result

ret



