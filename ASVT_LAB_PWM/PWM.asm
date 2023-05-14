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
.def tmp_sreg = R19

start:
   CLR    R1            ; R1 = 0
   OUT    SREG, R1      ; reset SREG
   SER    tmp_reg       ; tmp = 255
   OUT    SPL, tmp_reg  ; setup stack: low  is 255
   LDI    tmp_reg, 8    ; tmp = 8
   OUT    SPH, tmp_reg  ; setup stack: high is 8
   LDI    R18, 1        ; R18 = 1
   LDI    R26, 0        ; R26 = 0
   LDI    R27, 1        ; R27 = 1
   RJMP   sreg_to_stack_sub
sreg_to_stack:
   ST     X+, R1        ; add SREG to stack
sreg_to_stack_sub:
   CPI    R26, 9        ; if R26 >= 9 then C = 0
   CPC    R27, R18      ; if R27 == R18+C then Z = 0
   BRNE   sreg_to_stack ; if Z = 0 goto sreg_to_stack
   CALL   setup         ; call setup
start_delay:
   IN     tmp_sreg, SREG      ; tmp_sreg = SREG
   CLI                        ; stop interrupts
   LDS    R24, 261            ; R24 = 261 from RAM
   LDS    R25, 262            ; R25 = 262 from RAM
   LDS    R26, 263            ; R26 = 263 from RAM
   LDS    R27, 264            ; R27 = 264 from RAM
   IN     R18, TCNT0          ; R18 = TCNT0 =  Timer/Counter0 (8-bit)
   SBIS   TIFR0, 0            ; if (TIFR0(0) = TOV0 = 1) skip next
   RJMP   LABEL_9             ; goto LABEL_9
   CPI    R18, 255            ; compare R18 with 255 (if R18 == 255 then Z = 1 else Z = 0)
   BREQ   LABEL_9             ; if (Z = 1) goto LABEL_9
   ADIW   R24, 1              ; R24-25 += 1
   ROL    R26                 ; R26 = R26 * 2 + C, C = highest bit R26
   ROL    R27                 ; R27 = R27 * 2 + C, C = highest bit R27
LABEL_9:
   OUT    SREG, tmp_sreg      ; SREG = tmp_sreg
   MOV    R27, R26            ; R27 = R26
   MOV    R26, R25            ; R26 = R25
   MOV    R25, R24            ; R25 = R24
   CLR    R24                 ; R24 = 0
   MOVW   R22, R24            ; R22-23 = R24-25
   MOVW   R24, R26            ; R24-25 = R26-27
   LDI    tmp_reg, 3          ; tmp_reg = 2
micro_cycle:
   LSL    R22                 ; R22 <<= 1
   ROL    R23                 ; R23 = R23 * 2 + C, C = highest bit R23               
   ROL    R24                 ; R24 = R24 * 2 + C, C = highest bit R24
   ROL    R25                 ; R25 = R25 * 2 + C, C = highest bit R25
   DEC    tmp_reg             ; tmp_reg--
   BRNE   micro_cycle         ; if tmp_reg > 0 then recycle
   RET                        ; go back
LABEL_3:
   PUSH   R1                  ; Stack ← R1
   PUSH   R0                  ; Stack ← R0
   IN     R0, SREG            ; R0 = SREG
   PUSH   R0                  ; Stack ← R0
   CLR    R1                  ; R1 = 0
   PUSH   R18                 ; Stack ← R18
   PUSH   R19                 ; Stack ← R19
   PUSH   R24                 ; Stack ← R24
   PUSH   R25                 ; Stack ← R25
   PUSH   R26                 ; Stack ← R26
   PUSH   R27                 ; Stack ← R27
   LDS    R19, 256            ; R19 = 256 from RAM
   LDS    R24, 257            ; R24 = 257 from RAM
   LDS    R25, 258            ; R25 = 258 from RAM
   LDS    R26, 259            ; R26 = 259 from RAM
   LDS    R27, 260            ; R27 = 260 from RAM       
   LDI    R18, 3              ; R18 = 3
   LSL    R18                 ; R18 <<= 1 = 6
   CPI    R18, 125            ; compare R18 with 125
   BRCC   LABEL_11            ; if R18 >= 125 goto LABEL_11
   ADIW   R24, 1              ; R24-25 += 1
   ROL    R26                 ; R26 = R26 * 2 + C, C = highest bit R26
   ROL    R27                 ; R27 = R27 * 2 + C, C = highest bit R27
LABEL_12:
   STS    256, R18            ; 256 ← R18
   STS    257, R24            ; 257 ← R24
   STS    258, R25            ; 258 ← R25
   STS    259, R26            ; 259 ← R26
   STS    260, R27            ; 260 ← R27
   LDS    R24, 261            ; R24 = 261 from RAM
   LDS    R25, 262            ; R25 = 262 from RAM
   LDS    R26, 263            ; R26 = 263 from RAM
   LDS    R27, 264            ; R27 = 264 from RAM
   ADIW   R24, 1              ; R24-25 += 1
   ROL    R26                 ; R26 = R26 * 2 + C, C = highest bit R26
   ROL    R27                 ; R27 = R27 * 2 + C, C = highest bit R27
   STS    261, R24            ; 261 ← R24
   STS    262, R25            ; 262 ← R25
   STS    263, R26            ; 263 ← R26
   STS    264, R27            ; 264 ← R27
   POP    R27                 ; R27 ← Stack
   POP    R26                 ; R26 ← Stack
   POP    R25                 ; R25 ← Stack
   POP    R24                 ; R24 ← Stack
   POP    R19                 ; R19 ← Stack
   POP    R18                 ; R18 ← Stack
   POP    R0                  ; R0 ← Stack
   OUT    SREG, R0            ; SREG = R0
   POP    R0                  ; R0 ← Stack
   POP    R1                  ; R1 ← Stack
   RETI                       ; PC ← Stack ; I = 1
LABEL_11:
   LDI    R18, 134            ; R18 = 134
   LSL    R18                 ; R18 <<= 1 = 268 = 12
   ADIW   R24, 1              ; R24-25 += 1
   ROL    R26                 ; R26 = R26 * 2 + C, C = highest bit R26
   ROL    R27                 ; R27 = R27 * 2 + C, C = highest bit R27
   RJMP   LABEL_12            ; goto LABEL_12
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
   CALL   start_delay            ; start delay
   MOVW   R8, R22                ; copy R22-23 to R8-9 
   MOVW   R10, R24               ; copy R24-25 to R10-11
   LDI    R24, 42                ; R24 = 42
   MOV    R12, R24               ; R12 = R24 = 42
   MOV    R13, R1                ; R13 = R1
   MOV    R14, R1                ; R14 = R1
   MOV    R15, R1                ; R15 = R1
LABEL_14:
   CALL   start_delay            ; start delay
   SUB    R22, R8                ; R22 -= R8
   SBC    R23, R9                ; R23 -= R9
   SBC    R24, R10               ; R24 -= (R10 + C)
   SBC    R25, R11               ; R25 -= (R11 + C)
   CPI    R22, 232               ; compare R22 with 232
   SBCI   R23, 3                 ; R23 -= (3 + C)
   CPC    R24, R1                ; compare R24 with (R1 + C)
   CPC    R25, R1                ; compare R25 with (R1 + C)
   BRCS   LABEL_14               ; if (C = 1) goto LABEL_14
   LDI    R18, 1                 ; R18 = 1
   SUB    R12, R18               ; R12 -= R18
   SBC    R13, R1                ; R13 -= R1
   SBC    R14, R1                ; R14 -= R1
   SBC    R15, R1                ; R15 -= R1
   LDI    R24, 232               ; R24 = 232
   LSL    R8                     ; R8 <<= 1
   LDI    R24, 3                 ; R24 = 3
   ROL    R9                     ; R9 = R9 * 2 + C, C = highest bit R9
   ROL    R10                    ; R10 = R10 * 2 + C, C = highest bit R10
   ROL    R11                    ; R11 = R11 * 2 + C, C = highest bit R11
   CP     R12, R1                ; compare R12 with R1
   CPC    R13, R1                ; compare R13 with (R1 + C)
   CPC    R14, R1                ; compare R14 with (R1 + C)
   CPC    R15, R1                ; compare R15 with (R1 + C)
   BRNE   LABEL_14               ; if (C = 1) goto LABEL_14
   SUBI   pinD5_reg, 255         ; d5 ++
   RJMP   loop                   ; back to loop
