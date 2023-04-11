Для начала необходимо включить настройку в Arduino ide: "Show verbose output during _compilation_"

После нажимаем "Проверить" и ждем компиляции. Нас интересуют последние строки в консоли:
**_Linking everything together...
/root/.arduino15/packages/arduino/tools/avr-gcc/7.3.0-atmel3.6.1-arduino7/bin/avr-gcc -w -Os -g -flto -fuse-linker-plugin -Wl,--gc-sections -mmcu=atmega328p -o /tmp/arduino_build_911156/Arduino.ino.elf /tmp/arduino_build_911156/sketch/Arduino.ino.cpp.o /tmp/arduino_build_911156/../arduino_cache_907233/core/core_arduino_avr_nano_cpu_atmega328_268bc38ea579a7dff992db9de586c135.a -L/tmp/arduino_build_911156 -lm
/root/.arduino15/packages/arduino/tools/avr-gcc/7.3.0-atmel3.6.1-arduino7/bin/avr-objcopy -O ihex -j .eeprom --set-section-flags=.eeprom=alloc,load --no-change-warnings --change-section-lma .eeprom=0 /tmp/arduino_build_911156/Arduino.ino.elf /tmp/arduino_build_911156/Arduino.ino.eep
/root/.arduino15/packages/arduino/tools/avr-gcc/7.3.0-atmel3.6.1-arduino7/bin/avr-objcopy -O ihex -R .eeprom /tmp/arduino_build_911156/Arduino.ino.elf /tmp/arduino_build_911156/Arduino.ino.hex
/root/.arduino15/packages/arduino/tools/avr-gcc/7.3.0-atmel3.6.1-arduino7/bin/avr-size -A /tmp/arduino_build_911156/Arduino.ino.elf
Sketch uses 1144 bytes (3%) of program storage space. Maximum is 30720 bytes.
Global variables use 13 bytes (0%) of dynamic memory, leaving 2035 bytes for local variables. Maximum is 2048 bytes._**

Из данных строк необходимо вытащить путь к hex файлу: **_/tmp/arduino_build_911156/Arduino.ino.hex_**

Далее необходимо вызвать **_copy_hex.sh /tmp/arduino_build_911156/Arduino.ino.hex_**

Данный скрипт скопирует hex файл и запустит python скрипт для расшифровки. Все результаты попадут в папку {hex_file_name}\_customHex.
