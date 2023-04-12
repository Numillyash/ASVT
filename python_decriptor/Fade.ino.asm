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
   ST     R1, OZU
LABEL_4:
   CPI    R26, 9
   CPC    R27, R18
   BRNE   LABEL_5
   CALL   LABEL_6
   
   JMP    LABEL_7
   
LABEL_2:
   JMP    LABEL_8
   
LABEL_3:
   NOP    
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
   
   MOVW   R0, R10
   LDS    R25, 262
   
   MOVW   R0, R12
   LDS    R26, 263
   
   MOVW   R0, R14
   LDS    R27, 264
   
   MOVW   R0, R16
   LDS    R19, 260
   
   MOVW   R0, R8
   LDI    R18, 3
LABEL_10:
   LSL    R18
   CPI    R18, 125
   BRCC   LABEL_9
   ADIW   R24, 1
   ROL    R26
   ROL    R27
   STS    260, R18
   
   MOVW   R0, R8
   STS    261, R24
   
   MOVW   R0, R10
   STS    262, R25
   
   MOVW   R0, R12
   STS    263, R26
   
   MOVW   R0, R14
   STS    264, R27
   
   MOVW   R0, R16
   LDS    R24, 256
   
   MOVW   R0, R0
   LDS    R25, 257
   
   MOVW   R0, R2
   LDS    R26, 258
   
   MOVW   R0, R4
   LDS    R27, 259
   
   MOVW   R0, R6
   ADIW   R24, 1
   ROL    R26
   ROL    R27
   STS    256, R24
   
   MOVW   R0, R0
   STS    257, R25
LABEL_9:
   
   MOVW   R0, R2
   STS    258, R26
   
   MOVW   R0, R4
   STS    259, R27
LABEL_6:
   
   MOVW   R0, R6
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
   LDI    R18, 134
   LSL    R18
   ADIW   R24, 2
   ROL    R26
   ROL    R27
   RJMP   LABEL_10
   CLI    
   SBI    DDRD, 6
   SBI    DDRD, 5
   OUT    TCCR0A, R1
   OUT    TCCR0B, R1
   OUT    TCNT0, R1
   IN     R24, TCCR0A
LABEL_12:
   ORI    R24, 32
   OUT    TCCR0A, R24
LABEL_11:
   IN     R24, TCCR0A
   ORI    R24, 3
   OUT    TCCR0A, R24
   IN     R24, TCCR0B
LABEL_7:
   ORI    R24, 8
LABEL_13:
   OUT    TCCR0B, R24
