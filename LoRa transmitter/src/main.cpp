#include <SPI.h>
#include <LoRa.h>
#include <SoftwareSerial.h>
#include <HardwareSerial.h>

// define the pins used by the transceiver module
#define ss 2
#define rst 4
#define dio0 3
#define renable 5
#define rx 8
#define tx 9

int counter = 0;
volatile bool risingEdgeDetected = false;

SoftwareSerial Serial1(rx, tx); // RX, TX


void setup()
{
  // initialize Serial Monitor
  Serial.begin(115200);
  Serial1.begin(115200);
  pinMode(renable, INPUT);
  while (!Serial)
    ;

  Serial.println("LoRa Sender");
  
  // setup LoRa transceiver module
  LoRa.setPins(ss, rst, dio0);

  // replace the LoRa.begin(---E-) argument with your location's frequency
  // 433E6 for Asia
  // 866E6 for Europe
  // 915E6 for North America
  while (!LoRa.begin(433E6))
  {
    Serial.println(".");
    delay(500);
  } 

  // Change sync word (0xF3) to match the receiver
  // The sync word assures you don't get LoRa messages from other LoRa transceivers
  // ranges from 0-0xFF
  LoRa.setSyncWord(0x44);
  //Serial.println("LoRa Initializing OK!");

}

void loop()
{
  if (Serial.available())
  {
    String receivedData = Serial.readStringUntil('\n');
    Serial.println("Received: " + receivedData);
    LoRa.beginPacket();
    String thing = Serial.readString();
    Serial.println(thing);
    LoRa.print(thing);
    LoRa.endPacket();
  }
}

// Definition of the ISR
void risingEdgeISR()
{
  risingEdgeDetected = true;
}