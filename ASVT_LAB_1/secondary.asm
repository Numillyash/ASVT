
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
    LDI R29, 0
	LDI R30, 1
	LDI R31, 48;
	
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
    CPSE R30, R29
	CALL delay_sub
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
	DEC R31
	CPSE R31, R29
	CALL delay_sub
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
