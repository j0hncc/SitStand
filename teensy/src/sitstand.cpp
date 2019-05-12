/*
 SitStand jcc 1/2014
 v 1.2

 Read state of switch.  If changed, write the state to the serial port

*/

#include "Arduino.h"
 
const int LED=11;
const int SWITCH=23;
 
void setup()
{               
  pinMode(LED,OUTPUT);
  pinMode(SWITCH, INPUT_PULLUP);
  Serial.begin(9600);
}
int currstate=0, prevstate=0;
 
// return true if state has changed
bool stateChanged()
{
  currstate = digitalRead( SWITCH); 
  if ( currstate != prevstate)
  {
    prevstate = currstate;
    return true;
  }
  return false;
}
 
void loop()
{
  if ( stateChanged() )
  {
    digitalWrite( LED, currstate);
    if ( currstate == HIGH )
    {
      Serial.println("Open");
    }
    else
    {
      Serial.println("Closed");
    } 
  }
 
  delay(100);
   
}
