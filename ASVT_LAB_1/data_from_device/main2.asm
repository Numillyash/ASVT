   JMP    LABEL_1
LABEL_3:
   LDI    R30, 20
   LDI    R31, 79
LABEL_2:
   INC    R30
   NOP    
   NOP    
   BRNE   LABEL_2
   NOP    
   DEC    R31
   BRNE   LABEL_2
   RET    
LABEL_1:
   LDI    R20, 1
   MOV    R0, R20
   CLR    R20
   SER    R20
   OUT    DDRD, R20
   LDI    R20, 8
   OUT    SPH, R20
   SER    R20
   OUT    SPL, R20
LABEL_4:
   BST    R0, 0
   ROR    R0
   BLD    R0, 7
   OUT    PORTD, R0
   CALL   LABEL_3
   RJMP   LABEL_4
