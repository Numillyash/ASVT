   JMP    LABEL_1
   
LABEL_3:
   LDI    R29, 20
   LDI    R30, 250
LABEL_2:
   INC    R29
   NOP    
   NOP    
   NOP    
   NOP    
   NOP    
   NOP    
   NOP    
   NOP    
   NOP    
   NOP    
   NOP    
   NOP    
   NOP    
   NOP    
   NOP    
   NOP    
   NOP    
   NOP    
   NOP    
   NOP    
   NOP    
   NOP    
   BRNE   LABEL_2
   NOP    
   DEC    R30
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
   ROR    R0
   OUT    PORTD, R0
   CALL   LABEL_3
   
   RJMP   LABEL_4
