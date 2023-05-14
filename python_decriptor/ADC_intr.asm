   RJMP   LABEL_1
   RJMP   LABEL_2
   RJMP   LABEL_3
   RJMP   LABEL_4
   PUSH   R16
   LDS    R16, 63
   PUSH   R16
   LDS    R29, 120
   LDS    R29, 121
LABEL_4:
   POP    R16
   STS    63, R16
   POP    R16
   RETI   
   SER    R16
   OUT    DDRB, R16
   LDI    R16, 240
   OUT    DDRD, R16
   LDI    R16, 15
   OUT    DDRC, R16
   LDI    R16, 198
   OUT    PORTB, R16
   SER    R16
   OUT    SPL, R16
   LDI    R16, 8
   OUT    SPH, R16
   CLI    
   LDI    R16, 239
   STS    122, R16
   LDI    R16, 0
   STS    123, R16
   LDI    R16, 101
   STS    124, R16
   LDI    R16, 161
   STS    128, R16
   LDI    R16, 9
   STS    129, R16
   CLR    R27
   CLR    R28
   CLR    R26
   LDI    R16, 0
   OUT    MCUCR, R16
   LDI    R16, 3
   OUT    EIMSK, R16
   OUT    EIFR, R16
   LDI    R16, 10
   STS    105, R16
   LDI    R20, 0
   SEI    
LABEL_9:
   LDI    R16, 1
   AND    R16, R20
   BREQ   LABEL_5
   RJMP   LABEL_6
LABEL_5:
   CLR    R1
   STS    137, R1
LABEL_1:
   STS    136, R1
   SBRC   R26, 0
   STS    136, R27
   STS    139, R1
   STS    138, R1
   SBRC   R26, 1
   STS    138, R28
   LDI    R17, 7
   OUT    PORTB, R17
   LDI    R24, 18
   RCALL  LABEL_7
   RCALL  LABEL_8
   LDI    R17, 14
   OUT    PORTB, R17
   LDI    R24, 16
   RCALL  LABEL_7
   RCALL  LABEL_8
   LDI    R17, 22
   OUT    PORTB, R17
   LDI    R24, 17
   RCALL  LABEL_7
   RCALL  LABEL_8
   LDI    R17, 38
   OUT    PORTB, R17
   LDI    R24, 18
   RCALL  LABEL_7
   RCALL  LABEL_8
   RJMP   LABEL_9
LABEL_6:
   CLR    R1
   STS    137, R1
   STS    136, R1
   STS    139, R1
   STS    138, R1
   OUT    PORTC, R1
   LDI    R16, 15
   OUT    PORTD, R16
   LDI    R16, 9
   CP     R20, R16
   BRCC   LABEL_10
   LDI    R16, 8
   CP     R20, R16
   BRCC   LABEL_10
   LDI    R16, 5
   CP     R20, R16
   BRCC   LABEL_11
   LDI    R16, 4
   CP     R20, R16
   BRCC   LABEL_11
   LDI    R16, 1
   CP     R20, R16
   BRCC   LABEL_12
   LDI    R16, 0
   CP     R20, R16
   BRCC   LABEL_12
LABEL_12:
   MOV    R27, R29
   LDI    R17, 7
   OUT    PORTB, R17
   LDI    R24, 13
   RCALL  LABEL_7
   RCALL  LABEL_8
   LDI    R17, 14
   OUT    PORTB, R17
   LDI    R24, 19
   RCALL  LABEL_7
   RCALL  LABEL_8
   RJMP   LABEL_13
LABEL_11:
   MOV    R28, R29
   LDI    R17, 1
   OUT    PORTB, R17
   LDI    R24, 13
   RCALL  LABEL_7
   RCALL  LABEL_8
   LDI    R17, 8
   OUT    PORTB, R17
   LDI    R24, 20
   RCALL  LABEL_7
   RCALL  LABEL_8
LABEL_13:
   MOV    R16, R29
   ANDI   R16, 240
   LSR    R16
   LSR    R16
   LSR    R16
   LSR    R16
   LDI    R17, 16
   OUT    PORTB, R17
   MOV    R24, R16
   RCALL  LABEL_7
   RCALL  LABEL_8
   MOV    R16, R29
   ANDI   R16, 15
   LDI    R17, 32
   OUT    PORTB, R17
   MOV    R24, R16
   RCALL  LABEL_7
   RCALL  LABEL_8
   RJMP   LABEL_9
LABEL_10:
   LDI    R17, 1
   OUT    PORTB, R17
   LDI    R24, 12
   RCALL  LABEL_7
   RCALL  LABEL_8
   LDI    R17, 8
   OUT    PORTB, R17
   LDI    R24, 21
   RCALL  LABEL_7
   RCALL  LABEL_8
   CLR    R24
   BST    R29, 7
   LDI    R17, 16
   OUT    PORTB, R17
   BLD    R24, 0
   RCALL  LABEL_7
   RCALL  LABEL_8
   CLR    R24
   BST    R29, 6
   LDI    R17, 32
   OUT    PORTB, R17
   BLD    R24, 0
   RCALL  LABEL_7
   RCALL  LABEL_8
   MOV    R26, R29
   LSR    R26
   LSR    R26
   LSR    R26
   LSR    R26
   LSR    R26
   LSR    R26
   RJMP   LABEL_9
LABEL_7:
   RCALL  LABEL_14
   PUSH   R16
   LDS    R16, 63
   PUSH   R16
   MOV    R19, R24
   ANDI   R19, 240
   LDI    R16, 15
   LSL    R19
   OUT    PORTD, R19
   MOV    R18, R24
   ANDI   R18, 15
   OUT    PORTC, R18
   POP    R16
   STS    63, R16
   POP    R16
   RET    
   PUSH   R16
   INC    R20
   LDI    R16, 2
   AND    R16, R20
   BREQ   LABEL_15
   LDI    R16, 252
   AND    R20, R16
LABEL_15:
   POP    R16
   SEI    
   RJMP   LABEL_9
   PUSH   R16
   LDI    R16, 4
   LSL    R20
   LDI    R16, 12
   AND    R16, R20
   SUBI   R16, 12
   BRNE   LABEL_16
   LDI    R16, 227
   AND    R20, R16
LABEL_16:
   POP    R16
   SEI    
   RJMP   LABEL_9
LABEL_14:
   PUSH   R16
   LDI    R16, 21
   CP     R24, R16
   BRCC   LABEL_17
   LDI    R16, 20
   CP     R24, R16
   BRCC   LABEL_18
   LDI    R16, 19
   CP     R24, R16
   BRCC   LABEL_19
   LDI    R16, 18
   CP     R24, R16
   BRCC   LABEL_20
   LDI    R16, 17
   CP     R24, R16
   BRCC   LABEL_21
   LDI    R16, 16
   CP     R24, R16
   BRCC   LABEL_22
   LDI    R16, 15
   CP     R24, R16
   BRCC   LABEL_23
   LDI    R16, 14
   CP     R24, R16
LABEL_2:
   BRCC   LABEL_24
   LDI    R16, 13
   CP     R24, R16
   BRCC   LABEL_25
   LDI    R16, 12
   CP     R24, R16
   BRCC   LABEL_26
   LDI    R16, 11
   CP     R24, R16
LABEL_3:
   BRCC   LABEL_27
   LDI    R16, 10
   CP     R24, R16
   BRCC   LABEL_28
   LDI    R16, 9
   CP     R24, R16
   BRCC   LABEL_29
   LDI    R16, 8
   CP     R24, R16
   BRCC   LABEL_30
   LDI    R16, 7
   CP     R24, R16
   BRCC   LABEL_31
   LDI    R16, 6
   CP     R24, R16
   BRCC   LABEL_32
   LDI    R16, 5
   CP     R24, R16
   BRCC   LABEL_33
   LDI    R16, 4
   CP     R24, R16
   BRCC   LABEL_34
   LDI    R16, 3
   CP     R24, R16
   BRCC   LABEL_35
   LDI    R16, 2
   CP     R24, R16
   BRCC   LABEL_36
   LDI    R16, 1
   CP     R24, R16
   BRCC   LABEL_37
   LDI    R16, 0
   CP     R24, R16
   BRCC   LABEL_38
LABEL_17:
   LDI    R24, 237
   RJMP   LABEL_39
LABEL_18:
   LDI    R24, 183
   RJMP   LABEL_39
LABEL_19:
   LDI    R24, 13
   RJMP   LABEL_39
LABEL_20:
   LDI    R24, 128
   RJMP   LABEL_39
LABEL_21:
   LDI    R24, 168
   RJMP   LABEL_39
LABEL_22:
   LDI    R24, 184
   RJMP   LABEL_39
LABEL_23:
   LDI    R24, 226
   RJMP   LABEL_39
LABEL_24:
   LDI    R24, 242
   RJMP   LABEL_39
LABEL_25:
   LDI    R24, 188
   RJMP   LABEL_39
LABEL_26:
   LDI    R24, 114
   RJMP   LABEL_39
LABEL_27:
   LDI    R24, 248
   RJMP   LABEL_39
LABEL_28:
   LDI    R24, 238
   RJMP   LABEL_39
LABEL_29:
   LDI    R24, 222
   RJMP   LABEL_39
LABEL_30:
   LDI    R24, 254
   RJMP   LABEL_39
LABEL_31:
   LDI    R24, 14
   RJMP   LABEL_39
LABEL_32:
   LDI    R24, 250
   RJMP   LABEL_39
LABEL_33:
   LDI    R24, 218
   RJMP   LABEL_39
LABEL_34:
   LDI    R24, 204
   RJMP   LABEL_39
LABEL_35:
   LDI    R24, 158
   RJMP   LABEL_39
LABEL_36:
   LDI    R24, 182
   RJMP   LABEL_39
LABEL_37:
   LDI    R24, 12
   RJMP   LABEL_39
LABEL_38:
   LDI    R24, 126
   RJMP   LABEL_39
LABEL_39:
   POP    R16
   RET    
LABEL_8:
   CLR    R21
   CLR    R22
   CLR    R23
   CLR    R1
   LDI    R21, 0
   LDI    R22, 1
   LSL    R21
   BST    R22, 7
   BLD    R21, 0
   LSL    R22
   LSL    R21
   BST    R22, 7
   BLD    R21, 0
   LSL    R22
LABEL_43:
   SUBI   R23, 1
   SBCI   R22, 0
   SBCI   R21, 0
   CPSE   R21, R1
   RJMP   LABEL_40
   CPSE   R22, R1
   RJMP   LABEL_41
   CPSE   R23, R1
   RJMP   LABEL_42
   NOP    
   NOP    
   NOP    
   RET    
LABEL_40:
   NOP    
   NOP    
   NOP    
LABEL_41:
   NOP    
   NOP    
   NOP    
LABEL_42:
   NOP    
   NOP    
   RJMP   LABEL_43
