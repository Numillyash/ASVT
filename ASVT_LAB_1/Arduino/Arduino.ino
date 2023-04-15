/*
  Fade

  This example shows how to fade an LED on pin 9 using the analogWrite()
  function.

  The analogWrite() function uses PWM, so if you want to change the pin you're
  using, be sure to use another PWM capable pin. On most Arduino, the PWM pins
  are identified with a "~" sign, like ~3, ~5, ~6, ~9, ~10 and ~11.

  This example code is in the public domain.

  https://www.arduino.cc/en/Tutorial/BuiltInExamples/Fade
*/

int led = 5;           // the PWM pin the LED is attached to
int brightness = 0;    // how bright the LED is
int fadeAmount = 5;    // how many points to fade the LED by
int razr_cur = 0;
int num_cur = 0;
// the setup routine runs once when you press reset:
void setup() {
  // declare pin 9 to be an output:
  pinMode(A0, OUTPUT);
  pinMode(A1, OUTPUT);
  pinMode(2, OUTPUT);
  pinMode(3, OUTPUT);
  pinMode(4, OUTPUT);
  pinMode(5, OUTPUT);
  pinMode(6, OUTPUT);
  pinMode(7, OUTPUT);
  pinMode(A5, INPUT);
  pinMode(8, OUTPUT);
  pinMode(10, OUTPUT);
  pinMode(11, OUTPUT);
  pinMode(12, OUTPUT);
}

void writeByte(int razr, int num, bool printReg)
{
  switch(razr)
  {
    case 0:
      PORTB = 0b11111100;
      break; 
    case 1:
      PORTB = 0b11111001;
      break; 
    case 2:
      PORTB = 0b11110101;
      break; 
    case 3:
      PORTB = 0b11101101;
      break; 
    default:
      break;
  }  
  if(printReg)
  {PORTD = num;
      PORTC = num % 4;}
  else
  switch(num)
  {
    case 0:
      PORTD = 0x7E;
      PORTC = 0x7E % 4;
      break;
    case 1:
      PORTD = 0x0C;
      PORTC = 0x0C % 4;
      break;
    case 2:
      PORTD = 0xB6;
      PORTC = 0xB6 % 4;
      break;
    case 3:
      PORTD = 0x9E;
      PORTC = 0x9E % 4;
      break;
    case 4:
      PORTD = 0xCC;
      PORTC = 0xCC % 4;
      break;
    case 5:
      PORTD = 0xDA;
      PORTC = 0xDA % 4;
      break;
    case 6:
      PORTD = 0xFA;
      PORTC = 0xFA % 4;
      break;
    case 7:
      PORTD = 0x0E;
      PORTC = 0x0E % 4;
      break;
    case 8:
      PORTD = 0xFE;
      PORTC = 0xFE % 4;
      break;
    case 9:
      PORTD = 0xDE;
      PORTC = 0xDE % 4;
      break;
    case 10:
      PORTD = 0xEE;
      PORTC = 0xEE % 4;
      break;
    case 11:
      PORTD = 0xFF;
      PORTC = 0xFF % 4;
      break;
    case 12:
      PORTD = 0x72;
      PORTC = 0x72 % 4;
      break;
    case 13:
      PORTD = 0x7F;
      PORTC = 0x7F % 4;
      break;
    case 14:
      PORTD = 0xF2;
      PORTC = 0xF2 % 4;
      break;
    case 15:
      PORTD = 0xE2;
      PORTC = 0xE2 % 4;
      break;
    default:
      PORTD = num;
      PORTC = num % 4;
      break;
  }
}

// the loop routine runs over and over again forever:
void loop() {
  // set the brightness of pin 9:
//  analogWrite(led, brightness);

//  // change the brightness for next time through the loop:
//  brightness = brightness + fadeAmount;
//
//  // reverse the direction of the fading at the ends of the fade:
//  if (brightness <= 0 || brightness >= 255) {
//    fadeAmount = -fadeAmount;
//  }
//  // wait for 30 milliseconds to see the dimming effect
//  for(num_cur = 0; num_cur < 16; num_cur++){
//  writeByte(razr_cur, num_cur);
//  delay(1000);}
//  razr_cur = (razr_cur+1)%4;
  int anRe = analogRead(A5)/4;
  writeByte(0, anRe, true);
  delay(1);
  writeByte(1, anRe, true);
  delay(1);
  writeByte(2, (anRe/16), false);
  delay(1);
  writeByte(3, anRe%16, false);
  delay(1);
}
