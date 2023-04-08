;
; AssemblerApplication1.asm
;
; Created: 06.02.2023 18:38:51
; Author : Georgul
;
.device atmega328p

.def TMP = R20

.org $000
   JMP reset ; Указатель на начало программы

; Функция паузы 54-227-8
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

; Начальная настройка
reset:
; настройка исходных значений
   LDI  TMP, 0x01;
   MOV  R0, TMP
   CLR  TMP;
; настройка портов ввода-вывода
   SER  TMP ; 0xFF
   OUT  DDRD, TMP ; Вывод
; Установка вершины стека в конец ОЗУ
   LDI  TMP, HIGH(RAMEND) ; Старшие разряды адреса
   OUT  SPH, TMP 
   LDI  TMP, LOW(RAMEND) ; Младшие разряды адреса
   OUT  SPL, TMP

; Основной цикл
loop:
; Циклический сдвиг 32-разрядного числа R0-R3 
   BST R0, 0 ; сохранение младшего бита во флаге Т
   ROR R0 ; циклический сдвиг вправо
   BLD R0, 7 ; заполнение 7 бита значением из флага T
; Вывод 32-разрядного числа R0-R3 на порты PORTA-PORTD
   OUT PORTD, R0
; Пауза
   CALL delay;
; Возврат в начало основного цикла
   RJMP loop ;
