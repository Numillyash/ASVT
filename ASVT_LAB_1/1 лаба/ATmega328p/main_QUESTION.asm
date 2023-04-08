.def TMP = R20

.org $000
   JMP reset ; ��������� �� ������ ���������

; ������� �����
delay:
   LDI R29, 20; x
   LDI R30, 250; y
delay_sub:
   INC R29
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
   DEC R30
   BRNE delay_sub
   RET

; ��������� ���������
reset:
; ��������� �������� ��������
   LDI  TMP, 0x01;
   MOV  R0, TMP
   CLR  TMP;
   MOV  R1, TMP
   MOV  R2, TMP
   MOV  R3, TMP
; ��������� ������ �����-������
   SER  TMP ; 0xFF
   OUT  DDRA, TMP ; �����
   OUT  DDRB, TMP ; �����
   OUT  DDRC, TMP ; �����
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
   LSR R3 ; ���������� ����� ������ 
   ROR R2 ; ����������� ����� ������
   ROR R1 ; ����������� ����� ������
   ROR R0 ; ����������� ����� ������
   BLD R3, 7 ; ���������� 7 ���� ��������� �� ����� T
; ����� 32-���������� ����� R0-R3 �� ����� PORTA-PORTD
   OUT PORTA, R0
   OUT PORTB, R1
   OUT PORTC, R2
   OUT PORTD, R3
; �����
   CALL delay;
; ������� � ������ ��������� �����
   RJMP loop ;