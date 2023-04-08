
;
;
;
; AssemblerApplication1.asm
;
; Created: 06.02.2023 18:38:51
; Author : Georgul
;
.device atmega328p

.def TMP = R20

.org $000
   JMP reset ; ��������� �� ������ ���������

; ������� ����� 54-227-8
delay:
	LDI R30, 20
	LDI R31, 250;
	
delay_sub:
	INC R30
   NOP
   NOP
   NOP
   NOP
   NOP
   NOP
   NOP
   NOP
   NOP
   NOP
   NOP
   NOP
   NOP
   NOP
   NOP
   NOP
   NOP
   NOP
   NOP
   NOP
   NOP
   NOP
	BRNE delay_sub
	NOP
	DEC R31
	BRNE delay_sub
	RET

; ��������� ���������
reset:
; ��������� �������� ��������
   LDI  TMP, 0x01;
   MOV  R0, TMP
   CLR  TMP;
; ��������� ������ �����-������
   SER  TMP ; 0xFF
   OUT  DDRD, TMP ; �����
; ��������� ������� ����� � ����� ���
   LDI  TMP, HIGH(RAMEND) ; ������� ������� ������
   OUT  SPH, TMP 
   LDI  TMP, LOW(RAMEND) ; ������� ������� ������
   OUT  SPL, TMP

; �������� ����
loop:
; ����������� ����� 8-���������� ����� R0
   ROR R0 ; ����������� ����� ������
; ����� 8-���������� ����� R0 �� ���� PORTD
   OUT PORTD, R0
; �����
   CALL delay;
; ������� � ������ ��������� �����
   RJMP loop ;

; � ��������� ������������ R31, ������� �������������� ��� SREG?