.def TMP = R20

.org $000
   JMP reset ; ��������� �� ������ ���������

; ������� �����
delay:
   LDI R29, 20; x
   LDI R30, 79; y
delay_sub:
   INC R29
   NOP
   NOP
   BRNE delay_sub
   DEC R30
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
