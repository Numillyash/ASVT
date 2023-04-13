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
   LDS    R24, 261
   LDS    R25, 262
   LDS    R26, 263
   LDS    R27, 264
   LDS    R19, 260
   LDI    R18, 3
   LSL    R18
   CPI    R18, 125
   BRCC   LABEL_9
   ADIW   R24, 1
   ROL    R26
   ROL    R27
LABEL_10:
   STS    260, R18
   STS    261, R24
   STS    262, R25
   STS    263, R26
   STS    264, R27
   LDS    R24, 256
   LDS    R25, 257
   LDS    R26, 258
   LDS    R27, 259
   ADIW   R24, 1
   ROL    R26
   ROL    R27
   STS    256, R24
   STS    257, R25
   STS    258, R26
   STS    259, R27
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
LABEL_9:
   LDI    R18, 134
   LSL    R18
   ADIW   R24, 2
   ROL    R26
   ROL    R27
   RJMP   LABEL_10
LABEL_6:
   CLI    
   SBI    DDRD, 6
   SBI    DDRD, 5
   OUT    TCCR0A, R1
   OUT    TCCR0B, R1
   OUT    TCNT0, R1
   IN     R24, TCCR0A
   ORI    R24, 32
   OUT    TCCR0A, R24
   IN     R24, TCCR0A
   ORI    R24, 3
   OUT    TCCR0A, R24
   IN     R24, TCCR0B
   ORI    R24, 8
   OUT    TCCR0B, R24
   IN     R24, TCCR0B
   ORI    R24, 2
   OUT    TCCR0B, R24
   LDI    R24, 232
   OUT    OCR0A, R24
   LDI    R24, 70
   OUT    OCR0B, R24
   SEI    
   LDI    R24, 1
   LDI    R18, 3
   LDI    R19, 61
LABEL_12:
   OUT    OCR0B, R24
   MOVW   R30, R18
LABEL_11:
   SBIW   R30, 1
   BRNE   LABEL_11
   SUBI   R24, 255
   RJMP   LABEL_12
LABEL_7:
   CLI    
LABEL_13:
   RJMP   LABEL_13
