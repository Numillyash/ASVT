# DEC = 1
# BRNE с переходом = 2, без = 1

# delay:
#    LDI R30, 255; x
#    LDI R29, 255; y
# delay_sub:
#    INC R29
#    NOP*10
#    BRNE delay_sub
#    NOP
#    DEC R30
#    BRNE delay_sub
#    RET

# N1 = (1_inc + 2_brne + 10_nop) * (255 - x - 1) + 1_inc + 1_brne + 10_nop = (3 + NOP1)*(256-x)-1

# N1* = (1_inc + 2_brne + 10_nop) * (256-1) + 1_inc + 1_brne + 10_nop = (3 + NOP1)*256-1

# N2 = 2ldi + N1 + (1_inc + NOP2 + 2_brne) + (N1* + 1_inc + NOP2 + 2_brne)*(255 - y - 1) + (N1* + 1_inc + 1_brne + NOP2) =
# = N1 + 3 + 770 * (255 - y - 1) + 769 = 1 + 3x + 770 * (255 - y) = N1 + 2 + (N1*+3)*(255-y)

def func(x, y, freq, nop1, nop2):
    N1 = (3+nop1)*(256-x)-1
    N1_ = (3+nop1)*256-1
    N2 = 2 + N1 + (3 + nop2) + (N1_ + 3 + nop2)*(y-1)
    N_a = N2
    # print("N1, N1_, N2 =", N1, N1_, N2)
    return N_a/freq


# 54
# 227
# 8
print('Time for ATMega32: ', 1000*func(213, 241, 8*10**6, 10, 1), 'msec')
print('Time for ATMega328p: ', 1000*func(20, 250, 16*10**6, 22, 0), 'msec')

def reverseFunc(targetTime, targetFrequency):
    old = 100000
    min_err = 100000
    parametres = [0, 0, 0, 0, min_err]
    for x in range(256):
        if x%16==0:
            print("x:", x)
        for y in range(256):
            for nop1 in range(200):
                for nop2 in range(200):
                    result = func(x, y, targetFrequency, nop1, nop2)
                    err = abs(targetTime - 1000*result)
                    if(err < min_err):
                        min_err = err
                        parametres = [x, y, nop1, nop2, min_err]Ы
    return parametres

print("Parametres for min error: ", reverseFunc(100, 16*10**6))

# Пару слов о том как запустить на ардуине
# Microchip studio, AVRdude_prog и usbASP. Все
