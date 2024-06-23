#include <SoftwareSerial.h>
#include <Arduino.h>

#define rx 6
#define tx 7

SoftwareSerial Serial1(rx, tx); // RX, TX

void setup() {
  Serial.begin(115200);  // For debug output
  Serial1.begin(115200); // For communication with ESP32
  Serial.println("Arduino Nano Ready");
}

void loop() {
  if (Serial.available()) {
    String receivedData = Serial1.readStringUntil('\n');
    Serial.println("Received: " + receivedData);
  }
}