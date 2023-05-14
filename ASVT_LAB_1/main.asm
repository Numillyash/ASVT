.device atmega328p ; ���������� ��� �����������

.def TMP = R20 ; ��������� R20 ��� �������� ��� ���������� ��������
.def tmp_reg = R20

.org $000
   JMP reset ; ��������� �� ������ ���������
 

; ��������� ���������
reset:
	ldi tmp_reg, 0xFF;(1<<DDB3)|(1<<DDB2)|(1<<DDB4)|(1<<DDB0)
	OUT  DDRB, tmp_reg
	ldi tmp_reg, 0xFF
	OUT  PORTB, tmp_reg
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

   ldi tmp_reg, 0b11101110
loop:
; ����������� ����� 8-���������� ����� R0
   BST R0, 0 ; ���������� �������� ���� �� ����� �
   ROR R0 ; ����������� ����� ������
   BLD R0, 7 ; ���������� 7 ���� ��������� �� ����� T
   OUT PORTD, R0
   ldi tmp_reg, 0b11101110
   OUT PORTB, tmp_reg
   LDI R30, 25
   CALL delay_setup;
   ldi tmp_reg, 0b11111110
   OUT PORTB, tmp_reg
   LDI R21, 0b11010110
   OUT PORTD, R21
   LDI R30, 250
   CALL delay_setup;
; ������� � ������ ��������� �����
   RJMP loop ;



delay_setup:
   CLR R16
   CLR R17
   CLR R18
   CLR tmp_reg
   LDI R16, 0 ; here is the hihest byte
   MOV R17, R30
   ;LDI R17, 250 ; here is the lowest byte
   LSL R16
   BST R17, 7
   BLD R16, 0
   LSL R17
   LSL R16
   BST R17, 7
   BLD R16, 0
   LSL R17
delay_cycle:
   SUBI R18, 1 ; 1 tick
   SBCI R17, 0 ; 1 tick
   SBCI R16, 0 ; 1 tick

   CPSE R16, tmp_reg ; 1 ticks, if equal then skip (2 ticks)
   RJMP wait_nop_8 ; 2 ticks
   CPSE R17, tmp_reg ; 1 ticks, if equal then skip (2 ticks)
   RJMP wait_nop_5 ; 2 ticks
   CPSE R18, tmp_reg ; 1 ticks, if equal then skip (2 ticks)
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
   