#include <Arduino.h>
#include <EEPROM.h>
#include <HX711_ADC.h>
#if defined(ESP8266)|| defined(ESP32) || defined(AVR)
#include <EEPROM.h>
#endif


//Global Variables

int currOffsetX = 0; //EEPROM size is 2-bytes
int currOffsetY = 0; //EEPROM size is 2-bytes
const int HX711_1_dout = 28; //mcu > HX711 dout pin
const int HX711_1_sck = 29; //mcu > HX711 sck pin
const int HX711_2_dout = 30; //mcu > HX711 dout pin
const int HX711_2_sck = 31; //mcu > HX711 sck pin
float totWeight = 0;
int step = 0;
int absWeight = 0;
int command = 'C';

int scanLength = 0; 
//HX711 constructor:
//HX711_ADC LoadCell_1(HX711_1_dout, HX711_1_sck);
HX711_ADC LoadCell_2(HX711_2_dout, HX711_2_sck);

const int calVal_eepromAdress = 0;
const int calVal_eepromAdress2 = 32;
unsigned long t = 0;


void setup() 
{
  Serial.begin(57600); delay(10);
  pinMode(40, OUTPUT);
  pinMode(41, OUTPUT);
  pinMode(50, OUTPUT);
  pinMode(51, OUTPUT);

  //LoadCell_1.begin();
  LoadCell_2.begin();
  unsigned long stabilizingtime = 2000; // preciscion right after power-up can be improved by adding a few seconds of stabilizing time
  boolean _tare = true; //set this to false if you don't want tare to be performed in the next step
 // LoadCell_1.start(stabilizingtime, _tare);
  LoadCell_2.start(stabilizingtime, _tare);
  //if (LoadCell_1.getTareTimeoutFlag() || LoadCell_1.getSignalTimeoutFlag()) {
    //Serial.println("Timeout, check MCU>HX711 wiring and pin designations");
  //  while (1);
  //}
  //else {
   // LoadCell_1.setCalFactor(1.0); // user set calibration value (float), initial value 1.0 may be used for this sketch
   // //Serial.println("Startup is complete");
  //}
  if (LoadCell_2.getTareTimeoutFlag() || LoadCell_2.getSignalTimeoutFlag()) {
    //Serial.println("Timeout, check MCU>HX711 wiring and pin designations");
    while (1);
  }
  else {
    LoadCell_2.setCalFactor(1.0); // user set calibration value (float), initial value 1.0 may be used for this sketch
    //Serial.println("Startup is complete");
  }
  //while (!LoadCell_1.update());

  while (!LoadCell_2.update());
  //LoadCell_1.tareNoDelay(); //start calibration procedure
  LoadCell_2.tareNoDelay();
}

void forwardMov(long distance)
{
  
  for(int x = 0; x < distance; x++)
      {
        digitalWrite(40, LOW);
        digitalWrite(41, LOW);
        delayMicroseconds(60);
        digitalWrite(41, HIGH);
        delayMicroseconds(60);
      }
  currOffsetY += distance;


}

void reverseMov(long distance)
{
  
  
  

  for(int x = 0; x < distance; x++)
      {
        digitalWrite(40, HIGH);
        digitalWrite(41, LOW);
        delayMicroseconds(60);
        digitalWrite(41, HIGH);
        delayMicroseconds(60);
      }
  currOffsetY -= distance;

}

void leftMov(long distance)
{
  for(int x = 0; x < distance; x++)
      {
        digitalWrite(51, HIGH);
        digitalWrite(50, LOW);
        delayMicroseconds(60);
        digitalWrite(50, HIGH);
        delayMicroseconds(60);
      }
  currOffsetX += distance;

}

void rightMov(long distance)
{
  
  if(currOffsetX <= 0)
  {
    currOffsetX = 0;
    return;
  }
  
  for(int x = 0; x < distance; x++)
      {
        digitalWrite(51, LOW);
        digitalWrite(50, LOW);
        delayMicroseconds(60);
        digitalWrite(50, HIGH);
        delayMicroseconds(60);
      }
  currOffsetX -= distance;
  
}

void resetPos()
{
  for(int x = 0; x < 1000000; x++)
      {
        if(currOffsetX > 0)
        {
          rightMov(currOffsetX);
        }
        else
        {
          currOffsetX = 0;
          break;
        }
      }
  for(int x = 0; x < 10000000; x++)
      {
        if(currOffsetY > 0)
        {
          reverseMov(currOffsetY);
        }
        else
        {
          currOffsetY = 0;
          break;
        }
      }
  
}

void customSWIPath(long length)
{
  
  forwardMov(length);
    
  
}


//3200 steps is a full rotation for our current setup. One rotation = .25 inch

void loop() {
  long convertedLength = 0;
  static boolean newDataReady_1 = 0;
  static boolean newDataReady_2 = 0;
  const int serialPrintInterval = 0;
  
  //customSWIPath(10000);
  //everseMov(1000);
  //forwardMov(1000);
  
    if (Serial.available())
    {
      command = Serial.read();
    }
    //if (Serial.available())
    
      //char length =  Serial.read();
      switch(command) 
      {
        
        case 'C':
          //if (LoadCell_1.update()) newDataReady_1 = true;
          if (LoadCell_2.update()) newDataReady_2 = true;
          if (newDataReady_1 && newDataReady_2)
          {
            /*
            if (newDataReady_1) {
              if (millis() > t + serialPrintInterval) {
                float i = LoadCell_1.getData();
                //Serial.print("Load_cell_1 output val: ");
                //Serial.println(i);
                totWeight = i + totWeight;
                newDataReady_1 = 0;
                t = millis();
              }
              */
              delay(1);
              if (newDataReady_2) {
                if (millis() > t + serialPrintInterval) {
                  float i = LoadCell_2.getData();
                  //Serial.print("Load_cell_2 output val: ");
                  //Serial.println(i);
                  totWeight = i + totWeight;
                  newDataReady_2 = 0;
                  t = millis();
                }
              }
            }

            
            //Serial.print("Total weight is: " );
            //Serial.println(totWeight/9520);
            //Serial.write(abs((int)(totWeight/9520)));
            Serial.println(abs((int)(totWeight/9520)));

            totWeight = 0;
            //Serial.flush();
            break;
        case 'G':
          Serial.flush();
          for(int i = 0; i < 8; i++)
          {
            forwardMov(scanLength);
            delay(500);
          }
          
          command = '-';
          Serial.write('D');
            
          
          break;
        case 'H':
          scanLength = 7294;
          command = 'C';
          Serial.write('C');
          break;
        case 'I':
          scanLength = 7294;
          command = 'C';
          break;
        case 'J':
          scanLength = 7294;
          command = 'C';
          break;
        case 'K':
          scanLength = 7294;
          command = 'C';
          break;
        case 'L':
          scanLength = 7294;
          command = 'C';
          break;
        case 'M':
          scanLength = 7294;
          command = 'C';
          break;
        case 'N':
          scanLength = 7294;
          command = 'C';
          break;
        case 'O':
          scanLength = 7294;
          command = 'C';
          break;
        case 'P':
          scanLength = 7294;
          command = 'C';
          break;
        case 'Q':
          scanLength = 7294;
          command = 'C';
          break;
        case 'R':
          scanLength = 7294;
          command = 'C';
          break;
        case 'S':
          scanLength = 7294;
          command = 'C';
          break;
        case 'T':
          scanLength = 7294;
          command = 'C';
          break;
        case 'U':
          scanLength = 7294;
          command = 'C';
          break;
        case 'V':
          scanLength = 7294;
          command = 'C';
          break;
        case 'W':
          scanLength = 7294;
          command = 'C';
          break;
        case 'X':
          scanLength = 7294;
          command = 'C';
          break;
        case 'Y':
          scanLength = 7294;
          command = 'C';
          break;
        case 'Z':
          scanLength = 7294;
          command = 'C';
          break;
        case '!':
          scanLength = 7294;
          command = 'C';
          break;
        case '@':
          scanLength = 7294;
          command = 'C';
          break;
        case '#':
          scanLength = 9344;
          command = 'C';
          break;

      }
      
    
  
  

  }
  
