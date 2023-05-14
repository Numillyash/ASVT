   CLR    R1
   OUT    SREG, R1
   SER    R20
   OUT    SPL, R20
   LDI    R20, 8
   OUT    SPH, R20
   CLI    
   SBI    DDRD, 6
   SBI    DDRD, 5
   LDI    R20, 163
   OUT    TCCR0A, R20
   LDI    R20, 4
   OUT    TCCR0B, R20
   SEI    
   LDI    R28, 1
LABEL_2:
   OUT    OCR0B, R28
   MOV    R24, R28
   COM    R24
   OUT    OCR0A, R24
   SUBI   R28, 255
   CALL   LABEL_1
   RJMP   LABEL_2
LABEL_1:
   CLR    R16
   CLR    R17
   CLR    R18
   CLR    R20
   LDI    R16, 0
   LDI    R17, 2
   LSL    R16
   BST    R17, 7
   BLD    R16, 0
   LSL    R17
   LSL    R16
   BST    R17, 7
   BLD    R16, 0
   LSL    R17
LABEL_6:
   SUBI   R18, 1
   SBCI   R17, 0
   SBCI   R16, 0
   CPSE   R16, R20
   RJMP   LABEL_3
   CPSE   R17, R20
   RJMP   LABEL_4
   CPSE   R18, R20
   RJMP   LABEL_5
   NOP    
   NOP    
   NOP    
   RET    
LABEL_3:
   NOP    
   NOP    
   NOP    
LABEL_4:
   NOP    
   NOP    
   NOP    
LABEL_5:
   NOP    
   NOP    
   RJMP   LABEL_6
