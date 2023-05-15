#include <Wire.h>
#include <SoftwareSerial.h>

SoftwareSerial mySerial(7, 8);

#define MESSAGE "ABCDEFGHIJKLMNOPQRSTUVWXYZ"//"JOINDARKIKIZI"
#define MLEN 26

#define _SS_MAX_RX_BUFF 256

void messageFunction(uint8_t msgLen, const char* msg)
{
    Serial.println("Function is on now");
    Wire.beginTransmission(8); // transmit to device #8
    Wire.write('!');             // Send "START"
    Wire.endTransmission();
    char requestReal[256] = "";
    sprintf(requestReal, ":%c%s", msgLen, msg);
    //String requestReal = ":" + (char)msgLen + msg + "\n";
    char requestTaken[256] = "";
transmission:
    Serial.println("Begin main");
    Wire.beginTransmission(8); // transmit to device #8
    Wire.write(':');             // Send "MSG"
    Wire.write(msgLen + 1);    // Send Length up to 255
    Wire.write(msg);
    Wire.write('\n');
    Wire.endTransmission();

    

    Wire.requestFrom((uint8_t)8, msgLen); // request 6 bytes from slave device #8
    int rt_len = 0;
    while (Wire.available())
    {                         // slave may send less than requested
        char c = Wire.read(); // receive a byte as character
        requestTaken[rt_len++] = c;
        Serial.print((int)c);
    }
    Serial.println("");
    Serial.print(requestReal);
    Serial.print(requestTaken);
    if(strcmp(requestReal+2, requestTaken))
    {
      goto transmission;
    }
    Wire.beginTransmission(8); // transmit to device #8
    Wire.write('?');             // send "END"
    Wire.endTransmission();
}

void setup()
{
    // put your setup code here, to run once:
    Wire.begin();       // join I2C bus (address optional for master)
    Serial.begin(9600); // start serial for output
    mySerial.begin(9600);

    Serial.println("Initializing GPRS...");
    delay(1000);

    mySerial.println("AT"); updateSerial();
    mySerial.println("AT+CSQ"); updateSerial();

    // Прочитать информацию о SIM карте, чтобы убедиться, что SIM карта подключена
    mySerial.println("AT+CCID"); updateSerial();
}

void loop()
{
  updateSerial();
  // messageFunction(MLEN, MESSAGE);
  delay(5000);
}

bool prefix(const char *pre, const char *str)
{
    return strncmp(pre, str, strlen(pre)) == 0;
}

void updateSerial()
{
  char buf[256];
  bool flagMsg = false;

  delay(500);

  while (Serial.available()) 
  {
    // Пересылка того, что было получено с аппаратного последовательного порта, 
    // на программный последовательный порт
    mySerial.write(Serial.read());
  }
  while(mySerial.available()) 
  {
    // Пересылка того, что было получено с программного последовательного порта, 
    // на аппаратный последовательный порт
    Serial.write(mySerial.read(buf));

    if (prefix("+CMT", buf))
    {
      flagMsg = true;
      continue;
    }

    if (flagMsg)
    {
      // To uppercase
      char *s = buf;
      int ln = 0;
      while (*s)
      {
        *s = toupper((unsigned char) *s);
        s++;
        ln++;
      }
      
      messageFunction(ln, buf);
    }
  }
}
