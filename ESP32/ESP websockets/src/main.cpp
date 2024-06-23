#include <WiFi.h>
#include <ESPAsyncWebServer.h>
#include <AsyncTCP.h>
#include <ArduinoJson.h>
#include <Wire.h>
#include "MAX30105.h"
#include "spo2_algorithm.h"
#include <SPI.h>
#include <LoRa.h>

#define ECG_PIN 16  // ECG sensor pin L0 +
#define ECG_PIN2 17 // ECG sensor pin L0 -

#define LORA 14

const char *ssid = "ESP32-Access-Point";
const char *password = "123456789";

AsyncWebServer server(8080);
AsyncWebSocket ws("/ws");

JsonDocument doc;
JsonArray ecgDataArray;
JsonArray ecgTimeArray;

JsonDocument doc2;

MAX30105 particleSensor;

#define MAX_BRIGHTNESS 255

uint32_t irBuffer[100];
uint32_t redBuffer[100];

int32_t bufferLength;
int32_t spo2;
int8_t validSPO2;
int32_t heartRate;
int8_t validHeartRate;

void setupJSON();
void onWebSocketEvent(AsyncWebSocket *server, AsyncWebSocketClient *client, AwsEventType type, void *arg, uint8_t *data, size_t len);
void sendWsMessage();
void readSensors();

void setup() {
  Serial.begin(115200);

  pinMode(ECG_PIN, INPUT);
  pinMode(ECG_PIN2, INPUT);
  pinMode(LORA, OUTPUT);

  WiFi.softAP(ssid, password);
  IPAddress IP = WiFi.softAPIP();
  Serial.print("AP IP address: ");
  Serial.println(IP);

  ws.onEvent(onWebSocketEvent);
  server.addHandler(&ws);

  server.begin();
  Serial.println("Web server setup complete");

  setupJSON();



  // Commented out MAX30105 initialization for now
  /*
  Wire.begin(21, 22, 100000L);
  if (!particleSensor.begin(Wire)) {
    Serial.println(F("MAX30105 was not found. Please check wiring/power."));
    while (1);
  }

  byte ledBrightness = 60;
  byte sampleAverage = 4;
  byte ledMode = 2;
  byte sampleRate = 100;
  int pulseWidth = 411;
  int adcRange = 4096;

  particleSensor.setup(ledBrightness, sampleAverage, ledMode, sampleRate, pulseWidth, adcRange);
  */
}

int count = 0;

void loop() {
  readSensors();
  sendWsMessage();

  delay(100); // Send data every second
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
  bufferLength = 2;
  
  // Simulated sensor readings
  for (int i = 0; i < 6; i++) {
    float newECGValue = analogRead(36);
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
    client->text("Hello from ESP32 Server");
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
  serializeJson(doc, json);
  digitalWrite(LORA, HIGH);
  Serial.println(json);
  digitalWrite(LORA, LOW);
}