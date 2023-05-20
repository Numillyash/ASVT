#include <Wire.h>
#define MESSAGE "ABCDEFGHIJKLMNOPQRSTUVWXYZ" //"JOINDARKIKIZI"
#define MLEN 26

void messageFunction(uint8_t msgLen, const char *msg)
{
  Serial.println("Function is on now");
  Wire.beginTransmission(8); // transmit to device #8
  Wire.write('!');           // Send "START"
  Wire.endTransmission();
  char requestReal[256] = "";
  sprintf(requestReal, ":%c%s", msgLen, msg);
  // String requestReal = ":" + (char)msgLen + msg + "\n";
  char requestTaken[256] = "";
transmission:
  Serial.println("Begin main");
  Wire.beginTransmission(8); // transmit to device #8
  Wire.write(':');           // Send "MSG"
  Wire.write(msgLen + 1);    // Send Length up to 255
  Wire.write(msg);
  Wire.write('\n');
  Wire.endTransmission();

  Wire.requestFrom((uint8_t)8, msgLen); // request 6 bytes from slave device #8
  int rt_len = 0;
  while (Wire.available())
  {                       // slave may send less than requested
    char c = Wire.read(); // receive a byte as character
    requestTaken[rt_len++] = c;
    Serial.print((int)c);
  }
  Serial.println("");
  Serial.print(requestReal);
  Serial.print(requestTaken);
  if (strcmp(requestReal + 2, requestTaken))
  {
    goto transmission;
  }
  Wire.beginTransmission(8); // transmit to device #8
  Wire.write('?');           // send "END"
  Wire.endTransmission();

  long t = 1500 * (long)(MLEN + 2) + 2000;
  Serial.print("Waitin for : ");
  Serial.println(t);
  delay(t);
}

void setup()
{
  // put your setup code here, to run once:
  Wire.begin();       // join I2C bus (address optional for master)
  Serial.begin(9600); // start serial for output
}

void loop()
{
  Serial.println("Start new cycle");
  messageFunction(MLEN, MESSAGE); // Starting transmisson
}
