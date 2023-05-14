#include <stdio.h>
#include <string.h>
#include "pico/stdlib.h"   // stdlib 
#include "hardware/irq.h"  // interrupts
#include "hardware/pwm.h"  // pwm 
#include "hardware/sync.h" // wait for interrupt 

#include "hardware/i2c.h"
#include "pico/i2c_slave.h"
// Audio PIN is to match some of the design guide shields. 
#define AUDIO_PIN 20  // you can change this to whatever you like
static const uint I2C_SLAVE_ADDRESS = 0x08;
static const uint I2C_BAUDRATE = 100000; // 100 kHz
static const uint I2C_SLAVE_SDA_PIN = PICO_DEFAULT_I2C_SDA_PIN; // 4
static const uint I2C_SLAVE_SCL_PIN = PICO_DEFAULT_I2C_SCL_PIN; // 5
/* 
 * This include brings in static arrays which contain audio samples. 
 * if you want to know how to make these please see the python code
 * for converting audio samples into static arrays. 
 */

static struct
{
    uint8_t mem[256];
    uint8_t mem_address;
    bool mem_address_written;
} context;


/*
 * PWM Interrupt Handler which outputs PWM level and advances the 
 * current sample. 
 * 
 * We repeat the same value for 8 cycles this means sample rate etc
 * adjust by factor of 8   (this is what bitshifting <<3 is doing)
 * 
 */
// Our handler is called from the I2C ISR, so it must complete quickly. Blocking calls /
// printing to stdio may interfere with interrupt handling.
static void i2c_slave_handler(i2c_inst_t *i2c, i2c_slave_event_t event) {
    switch (event) {
    case I2C_SLAVE_RECEIVE: // master has written some data
        // save into memory
        context.mem[context.mem_address] = i2c_read_byte_raw(i2c);
        context.mem_address++;
        break;
    case I2C_SLAVE_REQUEST: // master is requesting data
        // load from memory
        i2c_write_byte_raw(i2c, context.mem[context.mem_address]);
        context.mem_address++;
        break;
    case I2C_SLAVE_FINISH: // master has signalled Stop / Restart
        context.mem_address = 0;
        printf("SLAVE DONE\n");
        break;
    default:
        break;
    }
}

static void setup_slave() {
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

int main() {
    stdio_init_all();
    setup_slave();

    const uint LED_PIN = PICO_DEFAULT_LED_PIN;
    gpio_init(LED_PIN);
    gpio_set_dir(LED_PIN, GPIO_OUT);



    while(true)
    {
        gpio_put(LED_PIN, 1);
        sleep_ms(250);
        gpio_put(LED_PIN, 0);
        sleep_ms(250);
        //__wfi(); // Wait for Interrupt
    }
}


// void playSample(int n)
// {
//     choose_sample(n);
//     printf("Playing %d sample\n", n);

//     isPlaying = 1;
//     while(isPlaying == 1) {
//         __wfi(); // Wait for Interrupt
//     }
// }

// int main(void) {
//     /* Overclocking for fun but then also so the system clock is a 
//      * multiple of typical audio sampling rates.
//      */
//     stdio_init_all();
//     set_sys_clock_khz(176000, true); 
//     gpio_set_function(AUDIO_PIN, GPIO_FUNC_PWM);

//     int audio_pin_slice = pwm_gpio_to_slice_num(AUDIO_PIN);

//     // Setup PWM interrupt to fire when PWM cycle is complete
//     pwm_clear_irq(audio_pin_slice);
//     pwm_set_irq_enabled(audio_pin_slice, true);
//     // set the handle function above
//     irq_set_exclusive_handler(PWM_IRQ_WRAP, pwm_interrupt_handler); 
//     irq_set_enabled(PWM_IRQ_WRAP, true);

//     // Setup PWM for audio output
//     pwm_config config = pwm_get_default_config();
//     /* Base clock 176,000,000 Hz divide by wrap 250 then the clock divider further divides
//      * to set the interrupt rate. 
//      * 
//      * 11 KHz is fine for speech. Phone lines generally sample at 8 KHz
//      * 
//      * 
//      * So clkdiv should be as follows for given sample rate
//      *  8.0f for 11 KHz
//      *  4.0f for 22 KHz
//      *  2.0f for 44 KHz etc
//      */
//     pwm_config_set_clkdiv(&config, 8.0f); 
//     pwm_config_set_wrap(&config, 250); 
//     pwm_init(audio_pin_slice, &config, true);

//     pwm_set_gpio_level(AUDIO_PIN, 0);


//     while(true){
//         for(int i = 0; i < msg1_len; i++)
//         {
//             playSample((int)message1[i]);
//         }
//     }
// }
