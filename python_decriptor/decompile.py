import pandas as pd
import os
import sys

if len(sys.argv) != 2:
    print('Usage: python my_script.py filename (without .hex)')
    print(sys.argv)
    sys.exit(1)

script_path = os.path.abspath(__file__)
dir_path = os.path.dirname(script_path)

# # Чтение файла и выбор определенных столбцов
# df = pd.read_excel(f'{dir_path}/commands.xlsx', usecols=[1, 7])

# com_lst = []

# # Вывод значений столбцов
# for index, row in df.iterrows():
#     col_2_value = row[0]  # Второй столбец
#     col_8_value = row[1]  # Восьмой столбец
#     com_lst.append([col_2_value, col_8_value])

# com_lst = com_lst[2::]
# print("lst_dict = [", end='')
# for i in com_lst:
#     print(f'[\'{i[0]}\', \'{i[1]}\'],', end='')
# print("]")

# hex_file_name = f"{dir_path}/main.hex"
file_name = sys.argv[1]
hex_file_name = f"{dir_path}/{sys.argv[1]}.hex"

# print(hex_file_name)

data_str = []
with open(hex_file_name, 'r') as file:
    for line in file:
        line = line.strip()  # удаляем перенос строки
        # print(line)
        if line[0] == ':' and len(line) > 11:
            byte_count = int(line[1:3], 16)
            address = int(line[3:7], 16)
            record_type = int(line[7:9], 16)
            if(record_type != 2):
                data = line[9:9+byte_count*2]
                data_hex = []
                for i in range(0, len(data), 2):
                    l_byte = int(data[i:i+2], 16)
                    data_hex.append(l_byte)
                data_words = []
                for i in range(0, len(data_hex), 2):
                    data_words.append(data_hex[i+1]*256+data_hex[i])
                data_str.append(data_words)
            checksum = int(line[9+byte_count*2:11+byte_count*2], 16)
            # здесь можно обработать прочитанные данные

bit_strings = []
hex_strings = []
for i in data_str:
    for j in i:
        hex_str = hex(j)[2:].zfill(4)
        my_string = bin(j)[2:].zfill(16)
        new_string = '.'.join([my_string[i:i+4] for i in range(0, len(my_string), 4)])

        bit_strings.append(new_string)
        hex_strings.append(hex_str)
# print(bit_strings)
# print(hex_strings)

lst_dict = [['ADIW', '1001.0110.KKdd.KKKK'],['AND', '0010.00rd.dddd.rrrr'],['ANDI', '0111.KKKK.dddd.KKKK'],['ASR', '1001.010d.dddd.0101'],['BCLR', '1001.0100.1sss.1000'],['BLD', '1111.100d.dddd.0bbb'],['BRBC', '1111.01kk.kkkk.ksss'],['BRBS', '1111.00kk.kkkk.ksss'],['BRCC', '1111.01kk.kkkk.k000'],['BRCS', '1111.00kk.kkkk.k000'],['BREAK', '1001.0101.1001.1000'],['BREQ', '1111.00kk.kkkk.k001'],['BRGE', '1111.01kk.kkkk.k100'],['BRHC', '1111.01kk.kkkk.k101'],['BRHS', '1111.00kk.kkkk.k101'],['BRID', '1111.01kk.kkkk.k111'],['BRIE', '1111.00kk.kkkk.k111'],['BRLO', '1111.00kk.kkkk.k000'],['BRLT', '1111.00kk.kkkk.k100'],['BRMI', '1111.00kk.kkkk.k010'],['BRNE', '1111.01kk.kkkk.k001'],['BRPL', '1111.01kk.kkkk.k010'],['BRSH', '1111.01kk.kkkk.k000'],['BRTC', '1111.01kk.kkkk.k110'],['BRTS', '1111.00kk.kkkk.k110'],['BRVC', '1111.01kk.kkkk.k011'],['BRVS', '1111.00kk.kkkk.k011'],['BSET', '1001.0100.0sss.1000'],['BST', '1111.101d.dddd.0bbb'],['CALL', '1001.010k.kkkk.111k.kkkk.kkkk.kkkk.kkkk'],['CBI', '1001.1000.AAAA.Abbb'],['CBR', '0111.KKKK.dddd.KKKK'],['CLC', '1001.0100.1000.1000'],['CLH', '1001.0100.1101.1000'],['CLI', '1001.0100.1111.1000'],['CLN', '1001.0100.1010.1000'],['CLR', '0010.01dd.dddd.dddd'],['CLS', '1001.0100.1100.1000'],['CLT', '1001.0100.1110.1000'],['CLV', '1001.0100.1011.1000'],['CLZ', '1001.0100.1001.1000'],['COM', '1001.010d.dddd.0000'],['CP', '0001.01rd.dddd.rrrr'],['CPC', '0000.01rd.dddd.rrrr'],['CPI', '0011.kkkk.dddd.kkkk'],['CPSE', '0001.00rd.dddd.rrrr'],['DEC', '1001.010d.dddd.1010'],['EOR', '0010.01rd.dddd.rrrr'],['FMUL', '0000.0011.0ddd.1rrr'],['FMULS', '0000.0011.1ddd.0rrr'],['FMULSU', '0000.0011.1ddd.1rrr'],['ICALL', '1001.0101.0000.1001'],['IJMP', '1001.0100.0000.1001'],['IN', '1011.0AAd.dddd.AAAA'],['INC', '1001.010d.dddd.0011'],['JMP', '1001.010k.kkkk.110k.kkkk.kkkk.kkkk.kkkk'],['LD', '1001.000d.dddd.1100'],['LD', '1001.000d.dddd.1101'],['LD', '1001.000d.dddd.1110'],['LD', '1000.000d.dddd.1000'],['LD', '1001.000d.dddd.1001'],['LD', '1001.000d.dddd.1010'],['LD', '1000.000d.dddd.0000'],['LD', '1001.000d.dddd.0001'],['LD', '1001.000d.dddd.0010'],['LDD', '10q0.qq0d.dddd.1qqq'],['LDD', '10q0.qq0d.dddd.0qqq'],['LDI', '1110.KKKK.dddd.KKKK'],['LDS', '1001.000d.dddd.0000.kkkk.kkkk.kkkk.kkkk'],['LPM', '1001.0101.1100.1000'],['LPM', '1001.000d.dddd.0100'],['LPM', '1001.000d.dddd.0101'],['LSL', '0000.11dd.dddd.dddd'],['LSR', '1001.010d.dddd.0110'],['MOV', '0010.11rd.dddd.rrrr'],['MOVW', '0000.0001.dddd.rrrr'],['MUL', '1001.11rd.dddd.rrrr'],['MULS', '0000.0010.dddd.rrrr'],['MULSU', '0000.0011.0ddd.0rrr'],['NEG', '1001.010d.dddd.0001'],['NOP', '0000.0000.0000.0000'],['OR', '0010.10rd.dddd.rrrr'],['ORI', '0110.KKKK.dddd.KKKK'],['OUT', '1011.1AAr.rrrr.AAAA'],['POP', '1001.000d.dddd.1111'],['PUSH', '1001.001d.dddd.1111'],['RCALL', '1101.kkkk.kkkk.kkkk'],['RET', '1001.0101.0000.1000'],['RETI', '1001.0101.0001.1000'],['RJMP', '1100.kkkk.kkkk.kkkk'],['ROL', '0001.11dd.dddd.dddd'],['ROR', '1001.010d.dddd.0111'],['SBC', '0000.10rd.dddd.rrrr'],['SBCI', '0100.KKKK.dddd.KKKK'],['SBI', '1001.1010.AAAA.Abbb'],['SBIC', '1001.1001.AAAA.Abbb'],['SBIS', '1001.1011.AAAA.Abbb'],['SBIW', '1001.0111.KKdd.KKKK'],['SBR', '0110.KKKK.dddd.KKKK'],['SBRC', '1111.110r.rrrr.0bbb'],['SBRS', '1111.111r.rrrr.0bbb'],['SEC', '1001.0100.0000.1000'],['SEH', '1001.0100.0101.1000'],['SEI', '1001.0100.0111.1000'],['SEN', '1001.0100.0010.1000'],['SER', '1110.1111.dddd.1111'],['SES', '1001.0100.0100.1000'],['SET', '1001.0100.0110.1000'],['SEV', '1001.0100.0011.1000'],['SEZ', '1001.0100.0001.1000'],['SLEEP', '1001.0101.1000.1000'],['SPM', '1001.0101.1110.1000'],['ST', '1001.001r.rrrr.1100'],['ST', '1001.001r.rrrr.1101'],['ST', '1001.001r.rrrr.1110'],['ST', '1000.001r.rrrr.1000'],['ST', '1001.001r.rrrr.1001'],['ST', '1001.001r.rrrr.1010'],['ST', '1000.001r.rrrr.0000'],['ST', '1001.001r.rrrr.0001'],['ST', '1001.001r.rrrr.0010'],['STD', '10q0.qq1r.rrrr.1qqq'],['STD', '10q0.qq1r.rrrr.0qqq'],['STS', '1001.001d.dddd.0000.kkkk.kkkk.kkkk.kkkk'],['SUB', '0001.10rd.dddd.rrrr'],['SUBI', '0101.KKKK.dddd.KKKK'],['SWAP', '1001.010d.dddd.0010'],['TST', '0010.00dd.dddd.dddd'],['WDR', '1001.0101.1010.1000']]

dict_keywords = {'0x03':'PINB', '0x04':'DDRB', '0x05': 'PORTB', '0x06':'PINC', '0x07':'DDRC', '0x08':'PORTC', '0x09':'PIND', '0x0A':'DDRD', '0x0B':'PORTD', '0x15':'TIFR0', '0x16':'TIFR1', '0x17':'TIFR2', '0x1B':'PCIFR', '0x1C':'EIFR', '0x1D':'EIMSK', '0x1E':'GPIOR0', '0x1F':'EECR', '0x20':'EEDR', '0x21':'EEARL', '0x22':'EEARH', '0x23':'GTCCR', '0x24':'TCCR0A', '0x25':'TCCR0B', '0x26':'TCNT0', '0x27':'OCR0A', '0x28':'OCR0B', '0x2A':'GPIOR1', '0x2B':'GPIOR2', '0x2C':'SPCR', '0x2D':'SPSR', '0x2E':'SPDR', '0x30':'ACSR', '0x33':'SMCR','0x34':'MCUSR', '0x35':'MCUCR', '0x37':'SPMCSR', '0x3D':'SPL', '0x3E':'SPH', '0x3F':'SREG'}

def compare_strings(a, b):
    a_ = a.replace('.', '')
    b_ = b.replace('.', '')
    comp_symbols = 0
    if(len(a_) != len(b_) and len(a_)//2 != len(b_)):
        print("ERROR")
        print(a_, len(a_))
        print(b_, len(b_))
        exit()
    if(len(a_) // 2 == len(b_)):
        return -1
    elif(len(a_) == len(b_)):
        ln = len(a_)
        for ind in range(ln):
            if(a_[ind] != '1' and a_[ind] != '0'):
                continue
            if(a_[ind] != b_[ind]):
                return 0
            comp_symbols += 1
        return comp_symbols

def decode_2word(esp, command, string, strings, labels):
    my_string = string.replace(".", "")
    result_addr = ''
    if(command == 'CALL' or command == 'JMP'):
        bit_str_k = my_string[7:12] + my_string[15:32]
        addr = int(bit_str_k, 2)
        is_label = -1
        for a in range(len(labels)):
            if labels[a][1] == addr:
                is_label = a
                break
        if is_label == -1:
            label_number = labels[0][0]+1
            label_name = f'label_{label_number}'
            labels[0][0] += 1
            labels.append([label_number, addr])
            result_addr = label_name
        else:
            label_number = labels[a][0]
            label_name = f'label_{label_number}'
            result_addr = label_name
    if(command == 'LDS' or command == 'STS'):
        bit_str_d = my_string[7:12]
        bit_str_k = my_string[16:32]
        if(command == 'LDS'):
            result_addr = 'R' + str(int(bit_str_d, 2)) + ', ' + str(int(bit_str_k, 2))
        if(command == 'STS'):
            result_addr = '' + str(int(bit_str_k, 2)) + ', R' + str(int(bit_str_d, 2))
           
    comm_addr_l = hex(esp)[2:].zfill(6)
    comm_addr_h = hex(esp+1)[2:].zfill(6)
    l_byte = hex(int(my_string[0:16], 2))[2:].zfill(4)
    h_byte = hex(int(my_string[16:32], 2))[2:].zfill(4)

    result_string_l = comm_addr_l + ' ' + l_byte + ' ' + command + ' ' * (7-len(command)) + result_addr
    result_string_h = comm_addr_h + ' ' + h_byte 
    strings.append(result_string_l.upper())
    strings.append(result_string_h.upper())

def decode_1word(esp, command, string, strings, labels):
    my_string = string.replace(".", "")
    global dict_keywords
    result_addr = ''

    if(command == 'ADC'):
        bit_str_r = my_string[6:7] + my_string[12:16]
        bit_str_d = my_string[7:12]
        result_addr = 'R' + str(int(bit_str_d, 2)) + ', R' + str(int(bit_str_r, 2))
    elif(command == 'ADD'):
        bit_str_r = my_string[6:7] + my_string[12:16]
        bit_str_d = my_string[7:12]
        result_addr = 'R' + str(int(bit_str_d, 2)) + ', R' + str(int(bit_str_r, 2))
    elif(command == 'ADIW'):
        bit_str_K = my_string[8:10] + my_string[12:16]
        bit_str_d = my_string[10:12]
        result_addr = 'R' + str(int(bit_str_d, 2)*2+24) + ', ' + str(int(bit_str_K, 2))
    elif(command == 'AND'):
        bit_str_r = my_string[6:7] + my_string[12:16]
        bit_str_d = my_string[7:12]
        result_addr = 'R' + str(int(bit_str_d, 2)) + ', R' + str(int(bit_str_r, 2))
    elif(command == 'ANDI'):
        bit_str_k = my_string[4:8] + my_string[12:16]
        bit_str_d = my_string[8:12]
        result_addr = 'R' + str(int(bit_str_d, 2)+16) + ', ' + str(int(bit_str_k, 2))
    elif(command == 'ASR'):
        bit_str_d = my_string[7:12]
        result_addr = 'R' + str(int(bit_str_d, 2))
    elif(command == 'BCLR'):
        bit_str_s = my_string[9:12]
        result_addr = '' + str(int(bit_str_s, 2)) 
    elif(command == 'BLD'):
        bit_str_b = my_string[13:16]
        bit_str_d = my_string[7:12]
        result_addr = 'R' + str(int(bit_str_d, 2)) + ', ' + str(int(bit_str_b, 2))
    elif(command == 'BRBC'):
        bit_str_s = my_string[13:16]
        bit_str_k = my_string[6:13]
        bits_int = int(bit_str_k, 2)
        if bits_int >= 64:
            bits_int -= 128

        addr = esp + bits_int + 1
        is_label = -1
        for a in range(len(labels)):
            if labels[a][1] == addr:
                is_label = a
                break
        if is_label == -1:
            label_number = labels[0][0]+1
            label_name = f'label_{label_number}'
            labels[0][0] += 1
            labels.append([label_number, addr])
            result_addr = str(int(bit_str_s, 2)) + ', ' + label_name
        else:
            label_number = labels[a][0]
            label_name = f'label_{label_number}'
            result_addr = str(int(bit_str_s, 2)) + ', ' + label_name

        # result_addr = str(int(bit_str_s, 2)) + ', ' + str(bits_int)  + f' (0x{hex(esp + bits_int + 1)[2:].zfill(4)})'
    elif(command == 'BRBS'):
        bit_str_s = my_string[13:16]
        bit_str_k = my_string[6:13]
        bits_int = int(bit_str_k, 2)
        if bits_int >= 64:
            bits_int -= 128

        addr = esp + bits_int + 1
        is_label = -1
        for a in range(len(labels)):
            if labels[a][1] == addr:
                is_label = a
                break
        if is_label == -1:
            label_number = labels[0][0]+1
            label_name = f'label_{label_number}'
            labels[0][0] += 1
            labels.append([label_number, addr])
            result_addr = str(int(bit_str_s, 2)) + ', ' + label_name
        else:
            label_number = labels[a][0]
            label_name = f'label_{label_number}'
            result_addr = str(int(bit_str_s, 2)) + ', ' + label_name
        # result_addr = str(int(bit_str_s, 2)) + ', ' + str(bits_int)  + f' (0x{hex(esp + bits_int + 1)[2:].zfill(4)})'
    elif(command == 'BRCC'):
        bit_str_k = my_string[6:13]
        bits_int = int(bit_str_k, 2)
        if bits_int >= 64:
            bits_int -= 128

        addr = esp + bits_int + 1
        is_label = -1
        for a in range(len(labels)):
            if labels[a][1] == addr:
                is_label = a
                break
        if is_label == -1:
            label_number = labels[0][0]+1
            label_name = f'label_{label_number}'
            labels[0][0] += 1
            labels.append([label_number, addr])
            result_addr = label_name
        else:
            label_number = labels[a][0]
            label_name = f'label_{label_number}'
            result_addr = label_name
    elif(command == 'BRCS'):
        bit_str_k = my_string[6:13]
        bits_int = int(bit_str_k, 2)
        if bits_int >= 64:
            bits_int -= 128

        addr = esp + bits_int + 1
        is_label = -1
        for a in range(len(labels)):
            if labels[a][1] == addr:
                is_label = a
                break
        if is_label == -1:
            label_number = labels[0][0]+1
            label_name = f'label_{label_number}'
            labels[0][0] += 1
            labels.append([label_number, addr])
            result_addr = label_name
        else:
            label_number = labels[a][0]
            label_name = f'label_{label_number}'
            result_addr = label_name
    elif(command == 'BREAK'):
        result_addr = ''
    elif(command == 'BREQ'):
        bit_str_k = my_string[6:13]
        bits_int = int(bit_str_k, 2)
        if bits_int >= 64:
            bits_int -= 128

        addr = esp + bits_int + 1
        is_label = -1
        for a in range(len(labels)):
            if labels[a][1] == addr:
                is_label = a
                break
        if is_label == -1:
            label_number = labels[0][0]+1
            label_name = f'label_{label_number}'
            labels[0][0] += 1
            labels.append([label_number, addr])
            result_addr = label_name
        else:
            label_number = labels[a][0]
            label_name = f'label_{label_number}'
            result_addr = label_name
    elif(command == 'BRGE'):
        bit_str_k = my_string[6:13]
        bits_int = int(bit_str_k, 2)
        if bits_int >= 64:
            bits_int -= 128

        addr = esp + bits_int + 1
        is_label = -1
        for a in range(len(labels)):
            if labels[a][1] == addr:
                is_label = a
                break
        if is_label == -1:
            label_number = labels[0][0]+1
            label_name = f'label_{label_number}'
            labels[0][0] += 1
            labels.append([label_number, addr])
            result_addr = label_name
        else:
            label_number = labels[a][0]
            label_name = f'label_{label_number}'
            result_addr = label_name
    elif(command == 'BRHC'):
        bit_str_k = my_string[6:13]
        bits_int = int(bit_str_k, 2)
        if bits_int >= 64:
            bits_int -= 128

        addr = esp + bits_int + 1
        is_label = -1
        for a in range(len(labels)):
            if labels[a][1] == addr:
                is_label = a
                break
        if is_label == -1:
            label_number = labels[0][0]+1
            label_name = f'label_{label_number}'
            labels[0][0] += 1
            labels.append([label_number, addr])
            result_addr = label_name
        else:
            label_number = labels[a][0]
            label_name = f'label_{label_number}'
            result_addr = label_name
    elif(command == 'BRHS'):
        bit_str_k = my_string[6:13]
        bits_int = int(bit_str_k, 2)
        if bits_int >= 64:
            bits_int -= 128

        addr = esp + bits_int + 1
        is_label = -1
        for a in range(len(labels)):
            if labels[a][1] == addr:
                is_label = a
                break
        if is_label == -1:
            label_number = labels[0][0]+1
            label_name = f'label_{label_number}'
            labels[0][0] += 1
            labels.append([label_number, addr])
            result_addr = label_name
        else:
            label_number = labels[a][0]
            label_name = f'label_{label_number}'
            result_addr = label_name
    elif(command == 'BRID'):
        bit_str_k = my_string[6:13]
        bits_int = int(bit_str_k, 2)
        if bits_int >= 64:
            bits_int -= 128

        addr = esp + bits_int + 1
        is_label = -1
        for a in range(len(labels)):
            if labels[a][1] == addr:
                is_label = a
                break
        if is_label == -1:
            label_number = labels[0][0]+1
            label_name = f'label_{label_number}'
            labels[0][0] += 1
            labels.append([label_number, addr])
            result_addr = label_name
        else:
            label_number = labels[a][0]
            label_name = f'label_{label_number}'
            result_addr = label_name
    elif(command == 'BRIE'):
        bit_str_k = my_string[6:13]
        bits_int = int(bit_str_k, 2)
        if bits_int >= 64:
            bits_int -= 128

        addr = esp + bits_int + 1
        is_label = -1
        for a in range(len(labels)):
            if labels[a][1] == addr:
                is_label = a
                break
        if is_label == -1:
            label_number = labels[0][0]+1
            label_name = f'label_{label_number}'
            labels[0][0] += 1
            labels.append([label_number, addr])
            result_addr = label_name
        else:
            label_number = labels[a][0]
            label_name = f'label_{label_number}'
            result_addr = label_name
    elif(command == 'BRLO'):
        bit_str_k = my_string[6:13]
        bits_int = int(bit_str_k, 2)
        if bits_int >= 64:
            bits_int -= 128

        addr = esp + bits_int + 1
        is_label = -1
        for a in range(len(labels)):
            if labels[a][1] == addr:
                is_label = a
                break
        if is_label == -1:
            label_number = labels[0][0]+1
            label_name = f'label_{label_number}'
            labels[0][0] += 1
            labels.append([label_number, addr])
            result_addr = label_name
        else:
            label_number = labels[a][0]
            label_name = f'label_{label_number}'
            result_addr = label_name
    elif(command == 'BRLT'):
        bit_str_k = my_string[6:13]
        bits_int = int(bit_str_k, 2)
        if bits_int >= 64:
            bits_int -= 128

        addr = esp + bits_int + 1
        is_label = -1
        for a in range(len(labels)):
            if labels[a][1] == addr:
                is_label = a
                break
        if is_label == -1:
            label_number = labels[0][0]+1
            label_name = f'label_{label_number}'
            labels[0][0] += 1
            labels.append([label_number, addr])
            result_addr = label_name
        else:
            label_number = labels[a][0]
            label_name = f'label_{label_number}'
            result_addr = label_name
    elif(command == 'BRMI'):
        bit_str_k = my_string[6:13]
        bits_int = int(bit_str_k, 2)
        if bits_int >= 64:
            bits_int -= 128

        addr = esp + bits_int + 1
        is_label = -1
        for a in range(len(labels)):
            if labels[a][1] == addr:
                is_label = a
                break
        if is_label == -1:
            label_number = labels[0][0]+1
            label_name = f'label_{label_number}'
            labels[0][0] += 1
            labels.append([label_number, addr])
            result_addr = label_name
        else:
            label_number = labels[a][0]
            label_name = f'label_{label_number}'
            result_addr = label_name
    elif(command == 'BRNE'):
        bit_str_k = my_string[6:13]
        bits_int = int(bit_str_k, 2)
        if bits_int >= 64:
            bits_int -= 128

        addr = esp + bits_int + 1
        is_label = -1
        for a in range(len(labels)):
            if labels[a][1] == addr:
                is_label = a
                break
        if is_label == -1:
            label_number = labels[0][0]+1
            label_name = f'label_{label_number}'
            labels[0][0] += 1
            labels.append([label_number, addr])
            result_addr = label_name
        else:
            label_number = labels[a][0]
            label_name = f'label_{label_number}'
            result_addr = label_name
    elif(command == 'BRPL'):
        bit_str_k = my_string[6:13]
        bits_int = int(bit_str_k, 2)
        if bits_int >= 64:
            bits_int -= 128

        addr = esp + bits_int + 1
        is_label = -1
        for a in range(len(labels)):
            if labels[a][1] == addr:
                is_label = a
                break
        if is_label == -1:
            label_number = labels[0][0]+1
            label_name = f'label_{label_number}'
            labels[0][0] += 1
            labels.append([label_number, addr])
            result_addr = label_name
        else:
            label_number = labels[a][0]
            label_name = f'label_{label_number}'
            result_addr = label_name
    elif(command == 'BRSH'):
        bit_str_k = my_string[6:13]
        bits_int = int(bit_str_k, 2)
        if bits_int >= 64:
            bits_int -= 128

        addr = esp + bits_int + 1
        is_label = -1
        for a in range(len(labels)):
            if labels[a][1] == addr:
                is_label = a
                break
        if is_label == -1:
            label_number = labels[0][0]+1
            label_name = f'label_{label_number}'
            labels[0][0] += 1
            labels.append([label_number, addr])
            result_addr = label_name
        else:
            label_number = labels[a][0]
            label_name = f'label_{label_number}'
            result_addr = label_name
    elif(command == 'BRTC'):
        bit_str_k = my_string[6:13]
        bits_int = int(bit_str_k, 2)
        if bits_int >= 64:
            bits_int -= 128

        addr = esp + bits_int + 1
        is_label = -1
        for a in range(len(labels)):
            if labels[a][1] == addr:
                is_label = a
                break
        if is_label == -1:
            label_number = labels[0][0]+1
            label_name = f'label_{label_number}'
            labels[0][0] += 1
            labels.append([label_number, addr])
            result_addr = label_name
        else:
            label_number = labels[a][0]
            label_name = f'label_{label_number}'
            result_addr = label_name
    elif(command == 'BRTS'):
        bit_str_k = my_string[6:13]
        bits_int = int(bit_str_k, 2)
        if bits_int >= 64:
            bits_int -= 128

        addr = esp + bits_int + 1
        is_label = -1
        for a in range(len(labels)):
            if labels[a][1] == addr:
                is_label = a
                break
        if is_label == -1:
            label_number = labels[0][0]+1
            label_name = f'label_{label_number}'
            labels[0][0] += 1
            labels.append([label_number, addr])
            result_addr = label_name
        else:
            label_number = labels[a][0]
            label_name = f'label_{label_number}'
            result_addr = label_name
    elif(command == 'BRVC'):
        bit_str_k = my_string[6:13]
        bits_int = int(bit_str_k, 2)
        if bits_int >= 64:
            bits_int -= 128

        addr = esp + bits_int + 1
        is_label = -1
        for a in range(len(labels)):
            if labels[a][1] == addr:
                is_label = a
                break
        if is_label == -1:
            label_number = labels[0][0]+1
            label_name = f'label_{label_number}'
            labels[0][0] += 1
            labels.append([label_number, addr])
            result_addr = label_name
        else:
            label_number = labels[a][0]
            label_name = f'label_{label_number}'
            result_addr = label_name
    elif(command == 'BRVS'):
        bit_str_k = my_string[6:13]
        bits_int = int(bit_str_k, 2)
        if bits_int >= 64:
            bits_int -= 128

        addr = esp + bits_int + 1
        is_label = -1
        for a in range(len(labels)):
            if labels[a][1] == addr:
                is_label = a
                break
        if is_label == -1:
            label_number = labels[0][0]+1
            label_name = f'label_{label_number}'
            labels[0][0] += 1
            labels.append([label_number, addr])
            result_addr = label_name
        else:
            label_number = labels[a][0]
            label_name = f'label_{label_number}'
            result_addr = label_name
    elif(command == 'BSET'):
        bit_str_s = my_string[9:12]
        result_addr = str(bit_str_s)
    elif(command == 'BST'):
        bit_str_b = my_string[13:16]
        bit_str_d = my_string[7:12]
        result_addr = 'R' + str(int(bit_str_d, 2)) + ', ' + str(int(bit_str_b, 2))
    elif(command == 'CBI'):
        bit_str_b = my_string[13:16]
        bit_str_A = my_string[8:13]
        keyA = '0x'+hex(int(bit_str_A, 2))[2:].zfill(2).upper()
         
        if keyA in dict_keywords.keys():
            result_addr = dict_keywords[keyA] + ', ' + str(int(bit_str_b))
        else:
            result_addr = str(int(bit_str_A)) + ', ' + str(int(bit_str_b))
    elif(command == 'CBR'):
        bit_str_k = my_string[4:8] + my_string[12:16]
        bit_str_d = my_string[8:12]
        result_addr = 'R' + str(int(bit_str_d, 2)+16) + ', ' + str(int(bit_str_k, 2))
    elif(command == 'CLC'):
        result_addr = ''
    elif(command == 'CLH'):
        result_addr = ''
    elif(command == 'CLI'):
        result_addr = ''
    elif(command == 'CLN'):
        result_addr = ''
    elif(command == 'CLR'):
        bit_str_r = my_string[6:7] + my_string[12:16]
        bit_str_d = my_string[7:12]
        result_addr = 'R' + str(int(bit_str_d, 2)) 
    elif(command == 'CLS'):
        result_addr = ''
    elif(command == 'CLT'):
        result_addr = ''
    elif(command == 'CLV'):
        result_addr = ''
    elif(command == 'CLZ'):
        result_addr = ''
    elif(command == 'COM'):
        bit_str_d = my_string[7:12]
        result_addr = 'R' + str(int(bit_str_d, 2)) 
    elif(command == 'CP'):
        bit_str_r = my_string[6:7] + my_string[12:16]
        bit_str_d = my_string[7:12]
        result_addr = 'R' + str(int(bit_str_d, 2)) + ', R' + str(int(bit_str_r, 2))
    elif(command == 'CPC'):
        bit_str_r = my_string[6:7] + my_string[12:16]
        bit_str_d = my_string[7:12]
        result_addr = 'R' + str(int(bit_str_d, 2)) + ', R' + str(int(bit_str_r, 2))
    elif(command == 'CPI'):
        bit_str_k = my_string[4:8] + my_string[12:16]
        bit_str_d = my_string[8:12]
        result_addr = 'R' + str(int(bit_str_d, 2)+16) + ', ' + str(int(bit_str_k, 2))
    elif(command == 'CPSE'):
        bit_str_k = my_string[4:8] + my_string[12:16]
        bit_str_d = my_string[8:12]
        result_addr = 'R' + str(int(bit_str_d, 2)+16) + ', ' + str(int(bit_str_k, 2))
    elif(command == 'DEC'):
        bit_str_d = my_string[7:12]
        result_addr = 'R' + str(int(bit_str_d, 2))
    elif(command == 'EOR'):
        bit_str_r = my_string[6:7] + my_string[12:16]
        bit_str_d = my_string[7:12]
        result_addr = 'R' + str(int(bit_str_d, 2)) + ', R' + str(int(bit_str_r, 2))
    elif(command == 'FMUL'):
        bit_str_r = my_string[13:16]
        bit_str_d = my_string[9:12]
        result_addr = 'R' + str(int(bit_str_d, 2)+16) + ', R' + str(int(bit_str_r, 2)+16)
    elif(command == 'FMULS'):
        bit_str_r = my_string[13:16]
        bit_str_d = my_string[9:12]
        result_addr = 'R' + str(int(bit_str_d, 2)+16) + ', R' + str(int(bit_str_r, 2)+16)
    elif(command == 'FMULSU'):
        bit_str_r = my_string[13:16]
        bit_str_d = my_string[9:12]
        result_addr = 'R' + str(int(bit_str_d, 2)+16) + ', R' + str(int(bit_str_r, 2)+16)
    elif(command == 'ICALL'):
        result_addr = ''
    elif(command == 'IJMP'):
        result_addr = ''
    elif(command == 'IN'):
        bit_str_A = my_string[5:7] + my_string[12:16]
        bit_str_d = my_string[7:12]

        keyA = '0x'+hex(int(bit_str_A, 2))[2:].zfill(2).upper()
         
        if keyA in dict_keywords.keys():
            result_addr = 'R' + str(int(bit_str_d, 2)) + ', ' + dict_keywords[keyA]
        else:
            result_addr = 'R' + str(int(bit_str_d, 2)) + ', ' + str(int(bit_str_r, 2))
    elif(command == 'INC'):
        bit_str_d = my_string[7:12]
        result_addr = 'R' + str(int(bit_str_d, 2))
    elif(command == 'LD'):
        bit_str_mode = my_string[3:4] + my_string[12:16]
        mode = ''
        if(bit_str_mode == '11100'):
            mode = 'X'
        elif(bit_str_mode == '11101'):
            mode = 'X+'
        elif(bit_str_mode == '11110'):
            mode = '-X'
        elif(bit_str_mode == '01000'):
            mode = 'Y'
        elif(bit_str_mode == '11001'):
            mode = 'Y+'
        elif(bit_str_mode == '11010'):
            mode = '-Y'
        elif(bit_str_mode == '00000'):
            mode = 'Z'
        elif(bit_str_mode == '10001'):
            mode = 'Z+'
        elif(bit_str_mode == '10010'):
            mode = '-Z'
        bit_str_d = my_string[7:12]
        result_addr = 'R' + str(int(bit_str_d, 2)) + ', ' + mode
    elif(command == 'LDD'):
        bit_str_mode = my_string[12:13]
        mode = ''
        bit_str_q = my_string[13:16]
        if(bit_str_mode == '1'):
            mode = 'Y+' + str(int(bit_str_q, 2))
        elif(bit_str_mode == '0'):
            mode = 'Z+' + str(int(bit_str_q, 2))
        bit_str_d = my_string[7:12]
        result_addr = 'R' + str(int(bit_str_d, 2)) + ', ' + mode 
    elif(command == 'LDI'):
        bit_str_k = my_string[4:8] + my_string[12:16]
        bit_str_d = my_string[8:12]
        result_addr = 'R' + str(int(bit_str_d, 2)+16) + ', ' + str(int(bit_str_k, 2))
    elif(command == 'LPM'):
        bit_str_mode = my_string[6:7]+my_string[12:16]
        mode = ''
        result_addr = ''
        bit_str_d = my_string[7:12]
        if(bit_str_mode == '11000'):
            result_addr = ''
        elif(bit_str_mode == '00100'):
            mode = ', Z'
            result_addr = 'R' + str(int(bit_str_d, 2)) + mode
        elif(bit_str_mode == '00101'):
            mode = ', Z+'
            result_addr = 'R' + str(int(bit_str_d, 2)) + mode
    elif(command == 'LSL'):
        bit_str_r = my_string[6:7] + my_string[12:16]
        bit_str_d = my_string[7:12]
        result_addr = 'R' + str(int(bit_str_d, 2))
    elif(command == 'LSR'):
        bit_str_r = my_string[6:7] + my_string[12:16]
        bit_str_d = my_string[7:12]
        result_addr = 'R' + str(int(bit_str_d, 2))
    elif(command == 'MOV'):
        bit_str_r = my_string[6:7] + my_string[12:16]
        bit_str_d = my_string[7:12]
        result_addr = 'R' + str(int(bit_str_d, 2)) + ', R' + str(int(bit_str_r, 2))
    elif(command == 'MOVW'):
        bit_str_r = my_string[12:16]
        bit_str_d = my_string[8:12]
        result_addr = 'R' + str(int(bit_str_d, 2)*2) + ', R' + str(int(bit_str_r, 2)*2)
    elif(command == 'MUL'):
        bit_str_r = my_string[6:7] + my_string[12:16]
        bit_str_d = my_string[7:12]
        result_addr = 'R' + str(int(bit_str_d, 2)) + ', R' + str(int(bit_str_r, 2))
    elif(command == 'MULS'):
        bit_str_r = my_string[12:16]
        bit_str_d = my_string[8:12]
        result_addr = 'R' + str(int(bit_str_d, 2)*2) + ', R' + str(int(bit_str_r, 2)*2)
    elif(command == 'MULSU'):
        bit_str_r = my_string[13:16]
        bit_str_d = my_string[9:12]
        result_addr = 'R' + str(int(bit_str_d, 2)+16) + ', R' + str(int(bit_str_r, 2)+16)
    elif(command == 'NEG'):
        bit_str_d = my_string[7:12]
        result_addr = 'R' + str(int(bit_str_d, 2))
    elif(command == 'NOP'):
        result_addr = ''
    elif(command == 'OR'):
        bit_str_r = my_string[6:7] + my_string[12:16]
        bit_str_d = my_string[7:12]
        result_addr = 'R' + str(int(bit_str_d, 2)) + ', R' + str(int(bit_str_r, 2))
    elif(command == 'ORI'):
        bit_str_k = my_string[4:8] + my_string[12:16]
        bit_str_d = my_string[8:12]
        result_addr = 'R' + str(int(bit_str_d, 2)+16) + ', ' + str(int(bit_str_k, 2))
    elif(command == 'OUT'):
        bit_str_A = my_string[5:7] + my_string[12:16]
        bit_str_r = my_string[7:12]
        keyA = '0x'+hex(int(bit_str_A, 2))[2:].zfill(2).upper()
         
        if keyA in dict_keywords.keys():
            result_addr = dict_keywords[keyA] + ', ' + 'R' + str(int(bit_str_r, 2))
        else:
            result_addr = '0x' + hex(int(bit_str_A, 2))[2:].zfill(6) + ', ' + 'R' + str(int(bit_str_r, 2))
    elif(command == 'POP'):
        bit_str_d = my_string[7:12]
        result_addr = 'R' + str(int(bit_str_d, 2))
    elif(command == 'PUSH'):
        bit_str_d = my_string[7:12]
        result_addr = 'R' + str(int(bit_str_d, 2))
    elif(command == 'RCALL'):
        bit_str_k = my_string[4:16]
        bits_int = int(bit_str_k, 2)
        if bits_int >= 2048:
            bits_int -= 4096
        addr = esp + bits_int + 1
        is_label = -1
        for a in range(len(labels)):
            if labels[a][1] == addr:
                is_label = a
                break
        if is_label == -1:
            label_number = labels[0][0]+1
            label_name = f'label_{label_number}'
            labels[0][0] += 1
            labels.append([label_number, addr])
            result_addr = label_name
        else:
            label_number = labels[a][0]
            label_name = f'label_{label_number}'
            result_addr = label_name
    elif(command == 'RET'):
        result_addr = ''
    elif(command == 'RETI'):
        result_addr = ''
    elif(command == 'RJMP'):
        bit_str_k = my_string[4:16]
        bits_int = int(bit_str_k, 2)
        if bits_int >= 2048:
            bits_int -= 4096
        addr = esp + bits_int + 1
        is_label = -1
        for a in range(len(labels)):
            if labels[a][1] == addr:
                is_label = a
                break
        if is_label == -1:
            label_number = labels[0][0]+1
            label_name = f'label_{label_number}'
            labels[0][0] += 1
            labels.append([label_number, addr])
            result_addr = label_name
        else:
            label_number = labels[a][0]
            label_name = f'label_{label_number}'
            result_addr = label_name
    elif(command == 'ROL'):
        bit_str_r = my_string[7:12]
        result_addr = 'R' + str(int(bit_str_r, 2))
    elif(command == 'ROR'):
        bit_str_r = my_string[7:12]
        result_addr = 'R' + str(int(bit_str_r, 2))
    elif(command == 'SBC'):
        bit_str_r = my_string[6:7] + my_string[12:16]
        bit_str_d = my_string[7:12]
        result_addr = 'R' + str(int(bit_str_d, 2)) + ', R' + str(int(bit_str_r, 2))
    elif(command == 'SBCI'):
        bit_str_k = my_string[4:8] + my_string[12:16]
        bit_str_d = my_string[8:12]
        result_addr = 'R' + str(int(bit_str_d, 2)+16) + ', ' + str(int(bit_str_k, 2))
    elif(command == 'SBI'):
        bit_str_A = my_string[8:13]
        bit_str_b = my_string[13:16]
        keyA = '0x'+hex(int(bit_str_A, 2))[2:].zfill(2).upper()
         
        if keyA in dict_keywords.keys():
            result_addr = dict_keywords[keyA] + ', ' + str(int(bit_str_b, 2))
        else:
            result_addr = str(int(bit_str_A, 2)) + ', ' + str(int(bit_str_b, 2))
    elif(command == 'SBIC'):
        bit_str_A = my_string[8:13]
        bit_str_b = my_string[13:16]
        keyA = '0x'+hex(int(bit_str_A, 2))[2:].zfill(2).upper()
         
        if keyA in dict_keywords.keys():
            result_addr = dict_keywords[keyA] + ', ' + str(int(bit_str_b, 2))
        else:
            result_addr = str(int(bit_str_A, 2)) + ', ' + str(int(bit_str_b, 2))
    elif(command == 'SBIS'):
        bit_str_A = my_string[8:13]
        bit_str_b = my_string[13:16]
        keyA = '0x'+hex(int(bit_str_A, 2))[2:].zfill(2).upper()
         
        if keyA in dict_keywords.keys():
            result_addr = dict_keywords[keyA] + ', ' + str(int(bit_str_b, 2))
        else:
            result_addr = str(int(bit_str_A, 2)) + ', ' + str(int(bit_str_b, 2))
    elif(command == 'SBIW'):
        bit_str_K = my_string[8:10] + my_string[12:16]
        bit_str_d = my_string[10:12]
        result_addr = 'R' + str(int(bit_str_d, 2)*2+24) + ', ' + str(int(bit_str_K, 2))
    elif(command == 'SBR'):
        bit_str_k = my_string[4:8] + my_string[12:16]
        bit_str_d = my_string[8:12]
        result_addr = 'R' + str(int(bit_str_d, 2)+16) + ', ' + str(int(bit_str_k, 2))
    elif(command == 'SBRC'):
        bit_str_r = my_string[7:12]
        bit_str_b = my_string[13:16]
        result_addr = 'R' + str(int(bit_str_r, 2)) + ', ' + str(int(bit_str_b, 2))
    elif(command == 'SBRS'):
        bit_str_r = my_string[7:12]
        bit_str_b = my_string[13:16]
        result_addr = 'R' + str(int(bit_str_r, 2)) + ', ' + str(int(bit_str_b, 2))
    elif(command == 'SEC'):
        result_addr = ''
    elif(command == 'SEH'):
        result_addr = ''
    elif(command == 'SEI'):
        result_addr = ''
    elif(command == 'SEN'):
        result_addr = ''
    elif(command == 'SER'):
        bit_str_r = my_string[8:12]
        result_addr = 'R' + str(int(bit_str_r, 2)+16)
    elif(command == 'SES'):
        result_addr = ''
    elif(command == 'SET'):
        result_addr = ''
    elif(command == 'SEV'):
        result_addr = ''
    elif(command == 'SEZ'):
        result_addr = ''
    elif(command == 'SLEEP'):
        result_addr = ''
    elif(command == 'SPM'):
        result_addr = ''    
    elif(command == 'ST'):
        bit_str_mode = my_string[3:4] + my_string[12:16]
        mode = ''
        if(bit_str_mode == '11100'):
            mode = 'X'
        elif(bit_str_mode == '11101'):
            mode = 'X+'
        elif(bit_str_mode == '11110'):
            mode = '-X'
        elif(bit_str_mode == '01000'):
            mode = 'Y'
        elif(bit_str_mode == '11001'):
            mode = 'Y+'
        elif(bit_str_mode == '11010'):
            mode = '-Y'
        elif(bit_str_mode == '00000'):
            mode = 'Z'
        elif(bit_str_mode == '10001'):
            mode = 'Z+'
        elif(bit_str_mode == '10010'):
            mode = '-Z'
        bit_str_d = my_string[7:12]
        result_addr = mode + ', R' + str(int(bit_str_d, 2))
    elif(command == 'STD'):
        bit_str_mode = my_string[12:13]
        mode = ''
        bit_str_q = my_string[13:16]
        if(bit_str_mode == '1'):
            mode = 'Y+' + str(int(bit_str_q, 2))
        elif(bit_str_mode == '0'):
            mode = 'Z+' + str(int(bit_str_q, 2))
        bit_str_d = my_string[7:12]
        result_addr = mode + ', R' + str(int(bit_str_d, 2)) 
    elif(command == 'SUB'):
        bit_str_r = my_string[6:7] + my_string[12:16]
        bit_str_d = my_string[7:12]
        result_addr = 'R' + str(int(bit_str_d, 2)) + ', R' + str(int(bit_str_r, 2))
    elif(command == 'SUBI'):
        bit_str_k = my_string[4:8] + my_string[12:16]
        bit_str_d = my_string[8:12]
        result_addr = 'R' + str(int(bit_str_d, 2)+16) + ', ' + str(int(bit_str_k, 2))
    elif(command == 'SWAP'):
        bit_str_d = my_string[7:12]
        result_addr = 'R' + str(int(bit_str_d, 2))
    elif(command == 'TST'):
        bit_str_d = my_string[7:12]
        result_addr = 'R' + str(int(bit_str_d, 2))
    elif(command == 'WDR'):
        result_addr = ''

    else:
        return(string,"is", command)

    comm_addr_l = hex(esp)[2:].zfill(6)
    l_byte = hex(int(my_string[0:16], 2))[2:].zfill(4)

    result_string_l = comm_addr_l + ' ' + l_byte + ' ' + command + ' ' * (7-len(command)) + result_addr
    strings.append(result_string_l.upper())

def find_string(bit_str_arr):
    lss_file_name = f"{dir_path}/{file_name}.lss"
    asm_file_name = f"{dir_path}/{file_name}.asm"
    lst_strings = []
    lst_labels = [[0, -1]]
    with open(lss_file_name, 'w') as f:
        wasDouble = False
        for x in range(len(bit_str_arr)):
            if wasDouble:
                wasDouble = False
                continue
            comped_symbols = -1
            words = 0
            command = ''
            # print(bit_str_arr[x], hex(int(bit_str_arr[x].replace(".", ""), 2)))
            for i in lst_dict:
                returned = compare_strings(i[1], bit_str_arr[x])
                if(returned >= 1 and returned > comped_symbols):
                    words = 1
                    command = i[0]
                    comped_symbols = returned
                elif(returned == -1):
                    # print('2 word')
                    if(x != len(bit_str_arr)-1):
                        new_str = bit_str_arr[x] + '.' + bit_str_arr[x+1]
                        returned = compare_strings(i[1], new_str)
                        if(returned >= 1):
                            words = 2
                            command = i[0]
                            wasDouble = True
                            # print(new_str, command)
                            # decode_2word(x, i[0], new_str)
            if words == 1:
                decode_1word(x, command, bit_str_arr[x], lst_strings, lst_labels)
            elif words == 2:
                if(x != len(bit_str_arr)-1):
                    new_str = bit_str_arr[x] + '.' + bit_str_arr[x+1]
                    decode_2word(x, command, new_str, lst_strings, lst_labels)
            else:
                print ('ERROR!')
                print (bit_str_arr[x])
                print (hex(x))
                print (hex(int(bit_str_arr[x].replace(".", ""), 2))[2:].zfill(4))
                exit(-1)
        for x in range(len(bit_str_arr)):
            for a in range(len(lst_labels)):
                if lst_labels[a][1] == x:
                    f.write(f'label_{a}:'.upper() + '\n')
            f.write(lst_strings[x] + '\n')
    with open(asm_file_name, 'w') as f:
        for x in range(len(bit_str_arr)):
            for a in range(len(lst_labels)):
                if lst_labels[a][1] == x:
                    f.write(f'label_{a}:'.upper() + '\n')
            if len(lst_strings[x]) > 12:
                f.write('   ' + lst_strings[x][12:] + '\n')
find_string(bit_strings)



