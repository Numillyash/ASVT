#include <Wire.h>
#include <SoftwareSerial.h>

#define _SS_MAX_RX_BUFF 256

SoftwareSerial mySerial(7, 8);

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
  delay(2000);
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
  { // slave may send less than requested
    char c = Wire.read(); // receive a byte as character
    requestTaken[rt_len++] = c;
    Serial.print((int)c);
    Serial.print(" ");
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

  long t = 1500 * (long)(msgLen + 2) + 2000;
  Serial.print("Waitin for : ");
  Serial.println(t);
  delay(t);
}

void setup()
{
  // put your setup code here, to run once:
  Wire.begin();       // join I2C bus (address optional for master)
  Serial.begin(9600); // start serial for output
  mySerial.begin(19200);

  Serial.println("Initializing GPRS...");
  delay(1000);

  mySerial.println("AT"); updateSerial();
  mySerial.println("AT+CSQ"); updateSerial();

  // Прочитать информацию о SIM карте, чтобы убедиться, что SIM карта подключена
  mySerial.println("AT+CCID"); updateSerial();
  // Настройка текствого режима
  mySerial.println("AT+CMGF=1");
  updateSerial();
  // Решает, как следует обрабатывать новые входящие SMS сообщения
  mySerial.println("AT+CNMI=1,2,0,0,0");
  updateSerial();
}

void loop()
{
  Serial.println("Start new cycle");
  updateSerial();
  // messageFunction(MLEN, MESSAGE);
  // messageFunction(MLEN, MESSAGE); // Starting transmisson
}

void updateSerial()
{
  char buf[256];
  memset(buf, 0, 256);
  bool flagMsg = false;

  delay(500);

  while (Serial.available())
  {
    // Пересылка того, что было получено с аппаратного последовательного порта,
    // на программный последовательный порт
    mySerial.write(Serial.read());
  }

  int ln = 0;
  while (mySerial.available())
  {
    Serial.print("\n Avaible = ");
    Serial.print(mySerial.available()); 
    Serial.print("\nWhile start here: ln = ");
    Serial.println(ln);
    // Пересылка того, что было получено с программного последовательного порта,
    // на аппаратный последовательный порт
    buf[ln++] = mySerial.read();
    Serial.write(buf[ln - 1]);

    Serial.print((int)buf[ln - 1]);
    
    if (buf[ln - 1] == '\x10' || buf[ln - 1] == '\n')
    {
      Serial.write("\nEND OF STR\n");
      ln = 0;
      if (prefix("+CMT", buf))
      {
        flagMsg = true;
        Serial.write("\nWE GOT MSG\n");
        memset(buf, 0, 256);
        continue;
        
      } 
    }
    Serial.print("\nWhile end here\n");
  }
  ln+=1;
  Serial.println("NO CYCLE HERE");
  Serial.println("Some buffer");
  for(int i = 0; i < ln; i++)
  {
      Serial.write(buf[i]);
  }
  Serial.println(buf);
  if (flagMsg)
      {
        Serial.write("\nWE sent MSG\n");
        // To uppercase
        char *s = buf;
        ln = 0;
        while (*s)
        {
          *s = toupper((unsigned char) * s);
          s++;
          ln++;
        }
        buf[ln-2] = '\0';
        ln -= 2;
        messageFunction(ln, buf);
        flagMsg = false;
      }
}

bool prefix(const char *pre, const char *str)
{
  return strncmp(pre, str, strlen(pre)) == 0;
}
