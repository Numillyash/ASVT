CC=gavrasm
AVRDUDE=avrdude
AVR=m328p
PROGRAMMATOR=usbasp
FILENAME=ADC_intr
DEVDATA=./data_from_device
DELFILES=$(FILENAME).lst $(DEVDATA)/*.*
HEXFILE=$(FILENAME).hex 
SOURCES=$(FILENAME).asm

all: 
#	make clean -i
	make build 
	make write

clean: 
	sudo rm $(DELFILES)

build:
	$(CC) $(SOURCES)

test:
	sudo $(AVRDUDE) -c $(PROGRAMMATOR) -p $(AVR)

read:
	sudo $(AVRDUDE) -c $(PROGRAMMATOR) -p $(AVR) -v -U flash:r:$(DEVDATA)/$(FILENAME).hex:i | tee ./data_from_device/read_data.txt
write:
	sudo $(AVRDUDE) -c $(PROGRAMMATOR) -p $(AVR) -U flash:w:./$(HEXFILE)

read_fuse:
	sudo $(AVRDUDE) -c $(PROGRAMMATOR) -p $(AVR) -U hfuse:r:$(DEVDATA)/$(AVR)_hfuse.txt:h -U lfuse:r:$(DEVDATA)/$(AVR)_lfuse.txt:h

write_fuse:
	sudo $(AVRDUDE) -c $(PROGRAMMATOR) -p $(AVR) -U lfuse:w:0xdf:m -U hfuse:w:0xDF:m -U efuse:w:0xF9:m -U lock:w:0xFF:m 

# 1 mhz
# avrdude -p atmega328p -c usbasp -U lfuse:w:0x62:m -U hfuse:w:0xD9:m -U efuse:w:0x7:m -U lock:w:0xFF:m 
# 3-8 mhz
# avrdude -p atmega328p -c usbasp -U lfuse:w:0xdc:m -U hfuse:w:0xDF:m -U efuse:w:0xFF:m -U lock:w:0xFF:m 
# 16 external
# avrdude -p atmega328p -c usbasp -U lfuse:w:0xdf:m -U hfuse:w:0xDF:m -U efuse:w:0xF9:m -U lock:w:0xFF:m 

