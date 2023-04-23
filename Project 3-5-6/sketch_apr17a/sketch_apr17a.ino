#include <List.hpp>
#include <string.h>

String message = "";
String key = "";
List<uint8_t> encrypted;
bool isDecrypting = false;
char currSymb;
String currentStr = "";

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
}

void Decrypt() {
  // code to decrypt
  if (encrypted.getSize() == 0)
    Serial.println("Bad string: Length of message is zero");
  if (key.length() == 0)
    Serial.println("Bad string: Length of key is zero");
  if (encrypted.getSize() != key.length())
    Serial.println("Bad string: Length of key not equal length of message");
  message = "";
  int8_t tmp_sym;
  key.toLowerCase();
  for (int i = 0; i < encrypted.getSize(); i++) {
    if (key[i] < 'a' || key[i] > 'z') {
      Serial.println("Bad string: key symbol out of alphabet");
      goto end;
    }
    if (encrypted[i] > 25) {
      Serial.println("Bad string: enc number out of alphabet");
      goto end;
    }
    tmp_sym = key[i] - 'a';
    tmp_sym = (encrypted[i]-tmp_sym);
    if(tmp_sym < 0)
      tmp_sym+= 26;
    message+=(char)(tmp_sym+'a');
  }
  Serial.print("Message is: ");
  Serial.println(message);
end:
  return;
}

bool ParseString() {
  char *pch;
  String tmp[3];
  String tmp_;
  char buf[256] = "";
  if (currentStr.length() > 256) {
    Serial.println("Bad string: string is too long");
  }
  currentStr.toCharArray(buf, 256);
  pch = strtok(buf, " ");
  uint8_t sz = 0;
  while (pch != NULL) {
    tmp[sz] = "";
    tmp[sz] += pch;
    pch = strtok(NULL, " ");
    sz++;
  }
  if (sz == 1) {
    if (tmp[0].compareTo("read") == 0) {
      Decrypt();
      return true;
    } else if (tmp[0].compareTo("print") == 0) {
      Serial.print("message: ");
      Serial.println(message);
      Serial.print("key: ");
      Serial.println(key);
      Serial.print("enc: ");
      String enc = "";
      for (int i = 0; i < encrypted.getSize(); i++) {
        enc += encrypted[i];
        if (i != encrypted.getSize() - 1)
          enc += '-';
      }
      Serial.println(enc);
      return true;
    } else
      return false;
  }
  if (sz != 3)
    return false;
  if (tmp[0].compareTo("write") != 0)
    return false;
  if (tmp[1].compareTo("-key") == 0) {
    key = "";
    key += tmp[2];
    return true;
  } else if (tmp[1].compareTo("-msg") == 0) {
    char key_tmp[256];
    tmp[2].toCharArray(key_tmp, 255);
    pch = strtok(key_tmp, "-");
    encrypted.removeAll();
    uint8_t tmp_num = 0;
    while (pch != NULL) {
      tmp_ = "";
      tmp_ += pch;
      tmp_num = (uint8_t)tmp_.toInt();
      encrypted.add(tmp_num);
      pch = strtok(NULL, "-");
    }
    return true;
  } else
    return false;
  return true;
}

void SerialHelp() {
}

void loop() {
  // put your main code here, to run repeatedly:
  if (Serial.available() > 0) {
    currSymb = (char)Serial.read();
    if (currSymb == '\n') {
      bool strBool = ParseString();
      if (!strBool) {
        Serial.print("Bad string: ");
        Serial.println(currentStr);
        SerialHelp();
      }
      currentStr = "";
    } else
      currentStr += currSymb;
  }
  delay(42);
}
