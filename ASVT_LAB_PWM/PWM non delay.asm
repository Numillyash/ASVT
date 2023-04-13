;
; AssemblerApplication1.asm
;
; Created: 06.02.2023 18:38:51
; Author : Georgul
;
.device atmega328p
.def pinD6_reg = R24
.def pinD5_reg = R28
.def tmp_reg = R20

start:
   CLR    R1            ; R1 = 0
   OUT    SREG, R1      ; reset SREG
   SER    tmp_reg       ; tmp = 255
   OUT    SPL, tmp_reg  ; setup stack: low  is 255
   LDI    tmp_reg, 8    ; tmp = 8
   OUT    SPH, tmp_reg  ; setup stack: high is 8
setup:
   CLI                        ; stop interrupts
   SBI    DDRD, 6             ; open pin_D6 port to OUT
   SBI    DDRD, 5             ; open pin_D5 port to OUT
   LDI    tmp_reg, 163        ; setup timer
   OUT    TCCR0A, tmp_reg
   LDI    tmp_reg, 4          ; setup timer
   OUT    TCCR0B, tmp_reg
   SEI                        ; start interrupts
   LDI    pinD5_reg, 1        ; setup register with 1 
loop:
   OUT    OCR0B, pinD5_reg       ; setup d5 percent
   MOV    pinD6_reg, pinD5_reg   ; copy d5 to d6
   COM    pinD6_reg              ; d6 = 255 - d6
   OUT    OCR0A, pinD6_reg       ; setup d6 percent
   SUBI   pinD5_reg, 255         ; d5 ++
   RJMP   loop
