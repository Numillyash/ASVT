.device atmega328p ; ���������� ��� �����������

.def TMP = R20 ; ��������� R20 ��� �������� ��� ���������� ��������

.org $000
   JMP reset ; ��������� �� ������ ���������

; ������� ����� 
delay:
	LDI R29, 20 ; ��������� �������� R29 (x) � �������� 20
	LDI R30, 250 ; ��������� �������� R30 (y) � �������� 250
	
delay_sub:
	INC R29 ; �������������� x
    NOP     ; ����� nop
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
	BRNE delay_sub ; ���� x ���� 0, ����������. ����� �������
	NOP
	DEC R30 ; �������������� y
	BRNE delay_sub ; ���� y ���� 0, ����������. ����� �������
	RET ; ������� �� ������ �������� � �������� ����

; ��������� ���������
reset:
; ��������� �������� ��������
   LDI  TMP, 0x01 ; �������� 1 � temp
   MOV  R0, TMP ; �������� temp � R0
   CLR  TMP ; �������� temp
; ��������� ������ �����-������
   SER  TMP ; �������� 0xFF � temp (-//- LDI 0xFF)
   OUT  DDRD, TMP ; ������� ��� ������ ����� ����� D �� ������
; ��������� ������� ����� � ����� ���
   LDI  TMP, HIGH(RAMEND) ; ������� ������� ������
   OUT  SPH, TMP ; ���������� ������� ������� ESP
   LDI  TMP, LOW(RAMEND) ; ������� ������� ������
   OUT  SPL, TMP ; ���������� ������� ������� ESP

;   LDI R25, 16
;   LDI R26, 0
;   LDI R27, 0
   
;   SUBI R27, 170
;   SBCI R26, 203
;   SBCI R25, 237

; �������� ����
loop:
; ����������� ����� 8-���������� ����� R0
   ROR R0 ; ����������� ����� ������
; ����� 8-���������� ����� R0 �� ���� PORTD
;   OUT PORTD, R27
; �����
;   CALL delay;
;   CALL delay;
;   CALL delay;
;   CALL delay;
;   CALL delay;
;   CALL delay;
;   CALL delay;
;   CALL delay;
;   CALL delay;
;   CALL delay;

   ;OUT PORTD, R26
; �����
;   CALL delay;
;   CALL delay;
;   CALL delay;
;   CALL delay;
;   CALL delay;
;   CALL delay;
;   CALL delay;
;   CALL delay;
;   CALL delay;
;   CALL delay;

;   OUT PORTD, R25
; �����
;   CALL delay;
;   CALL delay;
;   CALL delay;
;   CALL delay;
;   CALL delay;
;   CALL delay;
;   CALL delay;
;   CALL delay;
;   CALL delay;
;   CALL delay;
   OUT PORTD, R0
   CALL delay;
; ������� � ������ ��������� �����
   RJMP loop ;