Чтобы все работало, сначала ставим все нужные пакеты согласно инструкции в https://datasheets.raspberrypi.com/pico/getting-started-with-pico.pdf

Затем в CMakeLists.txt ставим значение в строчке set(PICO_SDK_PATH "/home/numil/VSARM/pico/pico-sdk") на свое

После пишем в папке pico-'name':
**_cmake .
make_**

Получаем готовый файл.
