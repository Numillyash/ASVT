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
	LDI R29, 54;
	LDI R30, 227
	LDI R31, 8;
	
delay_sub:
	DEC R29
	BRNE delay_sub
	INC R30
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
; ����������� ����� 32-���������� ����� R0-R3 
   BST R0, 0 ; ���������� �������� ���� �� ����� �
   ROR R0 ; ����������� ����� ������
   BLD R0, 7 ; ���������� 7 ���� ��������� �� ����� T
; ����� 32-���������� ����� R0-R3 �� ����� PORTA-PORTD
   OUT PORTD, R0
; �����
   CALL delay;
; ������� � ������ ��������� �����
   RJMP loop ;
