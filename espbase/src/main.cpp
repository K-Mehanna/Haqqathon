#include <WiFi.h>
#include <ESPAsyncWebServer.h>
#include <AsyncTCP.h>
#include <ArduinoJson.h>
#include <Wire.h>
#include <SPI.h>
#include <LoRa.h>


//define the pins used by the transceiver module
#define ss 25
#define rst 27
#define dio0 32

#define ECG_PIN 2  // ECG sensor pin L0 +
#define ECG_PIN2 0 // ECG sensor pin L0 -
#define ECGREAD 34

const char *ssid = "ESP32-Access-Point";
const char *password = "123456789";

AsyncWebServer server(8090);
AsyncWebSocket ws("/ws");

JsonDocument doc;
JsonArray ecgDataArray;
JsonArray ecgTimeArray;

JsonDocument doc2;

void setupJSON();
void onWebSocketEvent(AsyncWebSocket *server, AsyncWebSocketClient *client, AwsEventType type, void *arg, uint8_t *data, size_t len);
void sendWsMessage();
void readSensors();
void sendLoraMessage();

void setup() {
  //initialize Serial Monitor
  Serial.begin(115200);

  pinMode(ECG_PIN, INPUT);
  pinMode(ECG_PIN2, INPUT);

  WiFi.softAP(ssid, password);
  IPAddress IP = WiFi.softAPIP();
  Serial.print("AP IP address: ");
  Serial.println(IP);

  ws.onEvent(onWebSocketEvent);
  server.addHandler(&ws);

  server.begin();
  Serial.println("Web server started!");

  setupJSON();

  //setup LoRa transceiver module
  LoRa.setPins(ss, rst, dio0);
  
  //replace the LoRa.begin(---E-) argument with your location's frequency 
  //433E6 for Asia
  //866E6 for Europe
  //915E6 for North America
  while (!LoRa.begin(433E6)) {
    Serial.println(".");
    delay(500);
  }
   // Change sync word (0xF3) to match the receiver
  // The sync word assures you don't get LoRa messages from other LoRa transceivers
  // ranges from 0-0xFF
  LoRa.setSyncWord(0x44);
  Serial.println("LoRa Initializing OK!");
}

void loop() {
  readSensors();
  sendWsMessage();
  sendLoraMessage();

  delay(100);
}

void setupJSON() {
  JsonObject ecgdata = doc.createNestedObject("ecgdata");
  ecgDataArray = ecgdata.createNestedArray("data");
  ecgTimeArray = ecgdata.createNestedArray("time");
  
  for (int i = 0; i < 6; i++) {
    ecgDataArray.add(0);
    ecgTimeArray.add(0);
  }

  doc["oxygendata"] = 0;
  doc["heartRate"] = 0;
}

void readSensors() {
  
  // Simulated sensor readings
  for (int i = 0; i < 6; i++) {
    float newECGValue = analogRead(ECGREAD);
    ecgDataArray[i] = newECGValue;
    ecgTimeArray[i] = String(micros());
  }

  doc["oxygendata"] = random(90, 100);
  doc["heartRate"] = random(60, 100);
}

void onWebSocketEvent(AsyncWebSocket *server, AsyncWebSocketClient *client, AwsEventType type, void *arg, uint8_t *data, size_t len) {
  if (type == WS_EVT_CONNECT) {
    Serial.println("Websocket client connection received");
  } else if (type == WS_EVT_DISCONNECT) {
    Serial.println("Client disconnected");
  } else if (type == WS_EVT_DATA) {
    Serial.printf("Data received: %s\n", data);
   // client->text("Hello from ESP32 Server");
    deserializeJson(doc2, data);
  }
}

void sendWsMessage() {
  String json;
  serializeJson(doc, json);
  Serial.println(json);
  ws.textAll(json);
}

void sendLoraMessage() {
  String json;
  serializeJson(doc2, json);
  Serial.println(json);
  LoRa.beginPacket();
  LoRa.print(json);
  LoRa.endPacket();
}