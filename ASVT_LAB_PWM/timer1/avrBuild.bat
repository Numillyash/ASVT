cd "C:\AVR\Projects\timer1\"
C:
del timer1.map
del timer1.lst
"C:\AVR\AVR Studio 4\AvrAssembler\avrasm32.exe" -fI "C:\AVR\Projects\timer1\timer1.asm" -o "timer1.hex" -d "timer1.obj" -I "C:\AVR\Projects\timer1" -I "C:\AVR\AVR Studio 4\AvrAssembler\AppNotes"
