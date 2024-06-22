#include <Arduino.h>

// put function declarations here:
int myFunction(int, int);

void setup() {
// initialize the serial communication:
  Serial.begin(9600);
  pinMode(23, INPUT); // Setup for leads off detection LO +
  pinMode(22, INPUT); // Setup for leads off detection LO -
}

void loop() {
  // put your main code here, to run repeatedly:
   
  if((digitalRead(23) == 1)||(digitalRead(22) == 1)){
    Serial.println('!');
  }

  else{
  // send the value of analog input 0:
    Serial.println(analogRead(36));
  }

  //Wait for a bit to keep serial data from saturating
  delay(1);

}

