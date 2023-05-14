LABEL_5:
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
   
LABEL_1:
   CLR    R1
   OUT    SREG, R1
   SER    R28
   LDI    R29, 8
   OUT    SPH, R29
   OUT    SPL, R28
   CALL   LABEL_3
   
   JMP    LABEL_4
   
LABEL_2:
   JMP    LABEL_5
   
LABEL_3:
   NOP    
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
   LDI    R24, 41
   OUT    OCR0A, R24
   LDI    R24, 70
   OUT    OCR0B, R24
LABEL_6:
   SEI    
   IN     R24, OCR0B
   SUBI   R24, 255
   OUT    OCR0B, R24
LABEL_4:
   RJMP   LABEL_6
LABEL_7:
   CLI    
