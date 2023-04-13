LABEL_8:
   JMP    LABEL_1
   JMP    LABEL_2
   JMP    LABEL_2
   JMP    LABEL_2
   JMP    LABEL_2
   JMP    LABEL_2
   JMP    LABEL_2
   JMP    LABEL_2
   JMP    LABEL_2
   JMP    LABEL_2
   JMP    LABEL_2
   JMP    LABEL_2
   JMP    LABEL_2
   JMP    LABEL_2
   JMP    LABEL_2
   JMP    LABEL_2
   JMP    LABEL_3
   JMP    LABEL_2
   JMP    LABEL_2
   JMP    LABEL_2
   JMP    LABEL_2
   JMP    LABEL_2
   JMP    LABEL_2
   JMP    LABEL_2
   JMP    LABEL_2
   JMP    LABEL_2
LABEL_1:
   CLR    R1
   OUT    SREG, R1
   SER    R28
   LDI    R29, 8
   OUT    SPH, R29
   OUT    SPL, R28
   LDI    R18, 1
   LDI    R26, 0
   LDI    R27, 1
   RJMP   LABEL_4
LABEL_5:
   ST     X+, R1
LABEL_4:
   CPI    R26, 9
   CPC    R27, R18
   BRNE   LABEL_5
   CALL   LABEL_6
   JMP    LABEL_7
LABEL_2:
   JMP    LABEL_8
LABEL_13:
   IN     R19, SREG
   CLI    
   LDS    R24, 261
   LDS    R25, 262
   LDS    R26, 263
   LDS    R27, 264
   IN     R18, TCNT0
   SBIS   TIFR0, 0
   RJMP   LABEL_9
   CPI    R18, 255
   BREQ   LABEL_9
   ADIW   R24, 1
   ROL    R26
   ROL    R27
LABEL_9:
   OUT    SREG, R19
   MOV    R27, R26
   MOV    R26, R25
   MOV    R25, R24
   CLR    R24
   MOVW   R22, R24
   MOVW   R24, R26
   LSL    R22
   ROL    R23
   ROL    R24
   ROL    R25
   LDI    R20, 2
LABEL_10:
   LSL    R22
   ROL    R23
   ROL    R24
   ROL    R25
   DEC    R20
   BRNE   LABEL_10
   RET    
LABEL_3:
   PUSH   R1
   PUSH   R0
   IN     R0, SREG
   PUSH   R0
   CLR    R1
   PUSH   R18
   PUSH   R19
   PUSH   R24
   PUSH   R25
   PUSH   R26
   PUSH   R27
   LDS    R24, 257
   LDS    R25, 258
   LDS    R26, 259
   LDS    R27, 260
   LDS    R19, 256
   LDI    R18, 3
   LSL    R18
   CPI    R18, 125
   BRCC   LABEL_11
   ADIW   R24, 1
   ROL    R26
   ROL    R27
LABEL_12:
   STS    256, R18
   STS    257, R24
   STS    258, R25
   STS    259, R26
   STS    260, R27
   LDS    R24, 261
   LDS    R25, 262
   LDS    R26, 263
   LDS    R27, 264
   ADIW   R24, 1
   ROL    R26
   ROL    R27
   STS    261, R24
   STS    262, R25
   STS    263, R26
   STS    264, R27
   POP    R27
   POP    R26
   POP    R25
   POP    R24
   POP    R19
   POP    R18
   POP    R0
   OUT    SREG, R0
   POP    R0
   POP    R1
   RETI   
LABEL_11:
   LDI    R18, 134
   LSL    R18
   ADIW   R24, 2
   ROL    R26
   ROL    R27
   RJMP   LABEL_12
LABEL_6:
   CLI    
   SBI    DDRD, 6
   SBI    DDRD, 5
   LDI    R24, 163
   OUT    TCCR0A, R24
   LDI    R24, 4
   OUT    TCCR0B, R24
   SEI    
   LDI    R28, 1
LABEL_15:
   OUT    OCR0B, R28
   MOV    R24, R28
   COM    R24
   OUT    OCR0A, R24
   CALL   LABEL_13
   MOVW   R8, R22
   MOVW   R10, R24
   LDI    R24, 240
   MOV    R12, R24
   MOV    R13, R1
   MOV    R14, R1
   MOV    R15, R1
LABEL_14:
   CALL   LABEL_13
   SUB    R22, R8
   SBC    R23, R9
   SBC    R24, R10
   SBC    R25, R11
   CPI    R22, 232
   SBCI   R23, 3
   CPC    R24, R1
   CPC    R25, R1
   BRCS   LABEL_14
   LDI    R18, 1
   SUB    R12, R18
   SBC    R13, R1
   SBC    R14, R1
   SBC    R15, R1
   LDI    R24, 232
   LSL    R8
   LDI    R24, 3
   ROL    R9
   ROL    R10
   ROL    R11
   CP     R12, R1
   CPC    R13, R1
   CPC    R14, R1
   CPC    R15, R1
   BRNE   LABEL_14
   SUBI   R28, 255
   RJMP   LABEL_15
LABEL_7:
   CLI    
LABEL_16:
   RJMP   LABEL_16
