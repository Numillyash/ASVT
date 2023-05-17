#include <stdio.h>
#include <string.h>
#include "pico/stdlib.h"   // stdlib
#include "hardware/irq.h"  // interrupts
#include "hardware/pwm.h"  // pwm
#include "hardware/sync.h" // wait for interrupt

#include "hardware/i2c.h"
#include "pico/i2c_slave.h"
#include "sounddata.h"
// Audio PIN is to match some of the design guide shields.
#define AUDIO_PIN 20 // you can change this to whatever you like
static const uint I2C_SLAVE_ADDRESS = 0x08;
static const uint I2C_BAUDRATE = 100000; // 100 kHz
static const uint I2C_SLAVE_SDA_PIN = 0; // 4
static const uint I2C_SLAVE_SCL_PIN = 1; // 5

int wav_position = 0;
int WAV_DATA_LENGTH = 21482;
uint8_t *WAV_DATA;
const uint LED_PIN = PICO_DEFAULT_LED_PIN;
void choose_sample(int i);

/*
 * This include brings in static arrays which contain audio samples.
 * if you want to know how to make these please see the python code
 * for converting audio samples into static arrays.
 */

#define bool uint8_t
#define false 0
#define true 1

bool hadRecievedMessage = false;
bool isPlaying = false;
static struct
{
    uint8_t buffer[256];
    uint8_t buffer_address;
    uint8_t mem[256];
    uint8_t mem_address;
    bool IsRecieveStarted;
} context;

static void i2c_slave_handler(i2c_inst_t *i2c, i2c_slave_event_t event)
{
    // printf("I2C interr!!!\n");
    if (!hadRecievedMessage)
    {
        switch (event)
        {
        case I2C_SLAVE_RECEIVE: // master has written some data
            // save into memory
            context.buffer[context.buffer_address] = i2c_read_byte_raw(i2c);
            context.buffer_address++;
            // context.mem[context.mem_address] = i2c_read_byte_raw(i2c);
            // context.mem_address++;
            break;
        case I2C_SLAVE_REQUEST: // master is requesting data
            // load from memory
            i2c_write_byte_raw(i2c, context.mem[context.mem_address]);
            context.mem_address++;
            break;
        case I2C_SLAVE_FINISH: // master has signalled Stop / Restart
            // обработка входящего сообщения
            int isMessageStart = context.buffer[0] == '!' ? 1 : 0;
            int isMessage = context.buffer[0] == ':' ? 1 : 0;
            int isMessageEnd = context.buffer[0] == '?' ? 1 : 0;
            if (isMessageStart)
            {
                printf("msg start\n");
                memset(context.mem, 0, 256);
                context.mem_address = 0;
            }
            else if (isMessageEnd)
            {
                printf("msg end\n");
                hadRecievedMessage = true;
            }
            else if (isMessage)
            {
                printf("msg\n");
                strncpy(context.mem, context.buffer + 2, context.buffer[1]);
                printf("%s %d\n", context.mem, context.buffer[1]);
                context.mem_address = 0; // context.buffer_address - 2;
            }
            memset(context.buffer, 0, 256);
            context.buffer_address = 0;
            printf("SLAVE DONE\n");

            break;
        default:
            break;
        }
    }
}

static void setup_slave()
{
    gpio_init(I2C_SLAVE_SDA_PIN);
    gpio_set_function(I2C_SLAVE_SDA_PIN, GPIO_FUNC_I2C);
    gpio_pull_up(I2C_SLAVE_SDA_PIN);

    gpio_init(I2C_SLAVE_SCL_PIN);
    gpio_set_function(I2C_SLAVE_SCL_PIN, GPIO_FUNC_I2C);
    gpio_pull_up(I2C_SLAVE_SCL_PIN);

    i2c_init(i2c0, I2C_BAUDRATE);
    // configure I2C0 for slave mode
    i2c_slave_init(i2c0, I2C_SLAVE_ADDRESS, &i2c_slave_handler);
}

void pwm_interrupt_handler()
{
    pwm_clear_irq(pwm_gpio_to_slice_num(AUDIO_PIN));
    if (wav_position < (WAV_DATA_LENGTH << 3) - 1)
    {
        pwm_set_gpio_level(AUDIO_PIN, WAV_DATA[wav_position >> 3]);
        wav_position++;
    }
    else
    {
        // reset to start
        pwm_set_gpio_level(AUDIO_PIN, 0);
        isPlaying = false;
        wav_position = 0;
    }
}

// void playSample(int n)
// {
//     printf("Playing %c sample (%d)\nCMA = %d\n", n, (n - 'A') * 10, context.mem_address);
//     printf("HRM: %d\n", hadRecievedMessage);
//     sleep_ms(500);
// }

void playSample(int n)
{
    choose_sample(n);
    printf("Playing %d sample\n", n);

    isPlaying = true;
    while (isPlaying)
    {
        __wfi(); // Wait for Interrupt
    }
}

int main()
{
    stdio_init_all();
    setup_slave();

    gpio_init(LED_PIN);
    gpio_set_dir(LED_PIN, GPIO_OUT);
    set_sys_clock_khz(176000, true);
    gpio_set_function(AUDIO_PIN, GPIO_FUNC_PWM);

    int audio_pin_slice = pwm_gpio_to_slice_num(AUDIO_PIN);

    // Setup PWM interrupt to fire when PWM cycle is complete
    pwm_clear_irq(audio_pin_slice);
    pwm_set_irq_enabled(audio_pin_slice, true);
    // set the handle function above
    irq_set_exclusive_handler(PWM_IRQ_WRAP, pwm_interrupt_handler);
    irq_set_enabled(PWM_IRQ_WRAP, false);

    // Setup PWM for audio output
    pwm_config config = pwm_get_default_config();
    /* Base clock 176,000,000 Hz divide by wrap 250 then the clock divider further divides
     * to set the interrupt rate.
     *
     * 11 KHz is fine for speech. Phone lines generally sample at 8 KHz
     *
     *
     * So clkdiv should be as follows for given sample rate
     *  8.0f for 11 KHz
     *  4.0f for 22 KHz
     *  2.0f for 44 KHz etc
     */
    pwm_config_set_clkdiv(&config, 8.0f);
    pwm_config_set_wrap(&config, 250);
    pwm_init(audio_pin_slice, &config, true);

    pwm_set_gpio_level(AUDIO_PIN, 0);

    while (true)
    {

        if (hadRecievedMessage)
        {
            irq_set_enabled(PWM_IRQ_WRAP, true);
            gpio_put(LED_PIN, 1);
            // printf("HAD RECEIVED MSG\n");
            int msg1_len = strlen(context.mem); // context.mem_address;
            // context.mem_address++;
            playSample((int)-1);
            for (context.mem_address = 0; context.mem_address < msg1_len - 1; context.mem_address++)
            {
                playSample((int)context.mem[context.mem_address] - (int)'A');
            }
            playSample((int)26);
            hadRecievedMessage = false;
            irq_set_enabled(PWM_IRQ_WRAP, false);
        }
        else
        {
            printf("NO RECEIVED MSG\n");
            sleep_ms(250);
            gpio_put(LED_PIN, 0);
            //__wfi(); // Wait for Interrupt
        }
    }

    // while (true)
    // {
    //     for (int i = 0; i < msg1_len; i++)
    //     {
    //         playSample((int)message1[i]);
    //     }
    // }
}

void choose_sample(int i)
{
    wav_position = 0;
    switch (i)
    {
    case -1:
        WAV_DATA_LENGTH = len_s;
        WAV_DATA = samp_s;
        break;

    case 0:
        WAV_DATA_LENGTH = len_0;
        WAV_DATA = samp_0;
        break;

    case 1:
        WAV_DATA_LENGTH = len_1;
        WAV_DATA = samp_1;
        break;

    case 2:
        WAV_DATA_LENGTH = len_2;
        WAV_DATA = samp_2;
        break;

    case 3:
        WAV_DATA_LENGTH = len_3;
        WAV_DATA = samp_3;
        break;

    case 4:
        WAV_DATA_LENGTH = len_4;
        WAV_DATA = samp_4;
        break;

    case 5:
        WAV_DATA_LENGTH = len_5;
        WAV_DATA = samp_5;
        break;

    case 6:
        WAV_DATA_LENGTH = len_6;
        WAV_DATA = samp_6;
        break;

    case 7:
        WAV_DATA_LENGTH = len_7;
        WAV_DATA = samp_7;
        break;

    case 8:
        WAV_DATA_LENGTH = len_8;
        WAV_DATA = samp_8;
        break;

    case 9:
        WAV_DATA_LENGTH = len_9;
        WAV_DATA = samp_9;
        break;

    case 10:
        WAV_DATA_LENGTH = len_10;
        WAV_DATA = samp_10;
        break;

    case 11:
        WAV_DATA_LENGTH = len_11;
        WAV_DATA = samp_11;
        break;

    case 12:
        WAV_DATA_LENGTH = len_12;
        WAV_DATA = samp_12;
        break;

    case 13:
        WAV_DATA_LENGTH = len_13;
        WAV_DATA = samp_13;
        break;

    case 14:
        WAV_DATA_LENGTH = len_14;
        WAV_DATA = samp_14;
        break;

    case 15:
        WAV_DATA_LENGTH = len_15;
        WAV_DATA = samp_15;
        break;

    case 16:
        WAV_DATA_LENGTH = len_16;
        WAV_DATA = samp_16;
        break;

    case 17:
        WAV_DATA_LENGTH = len_17;
        WAV_DATA = samp_17;
        break;

    case 18:
        WAV_DATA_LENGTH = len_18;
        WAV_DATA = samp_18;
        break;

    case 19:
        WAV_DATA_LENGTH = len_19;
        WAV_DATA = samp_19;
        break;

    case 20:
        WAV_DATA_LENGTH = len_20;
        WAV_DATA = samp_20;
        break;

    case 21:
        WAV_DATA_LENGTH = len_21;
        WAV_DATA = samp_21;
        break;

    case 22:
        WAV_DATA_LENGTH = len_22;
        WAV_DATA = samp_22;
        break;

    case 23:
        WAV_DATA_LENGTH = len_23;
        WAV_DATA = samp_23;
        break;

    case 24:
        WAV_DATA_LENGTH = len_24;
        WAV_DATA = samp_24;
        break;

    case 25:
        WAV_DATA_LENGTH = len_25;
        WAV_DATA = samp_25;
        break;

    case 26:
        WAV_DATA_LENGTH = len_e;
        WAV_DATA = samp_e;
        break;
    }
}