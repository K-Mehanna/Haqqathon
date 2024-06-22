#include <WiFi.h>
#include <ESPAsyncWebServer.h>
#include <AsyncTCP.h>
#include <ArduinoJson.h>

#define ECG_PIN 23  // ECG sensor pin L0 +
#define ECG_PIN2 22 // ECG sensor pin L0 -

const char *ssid = "ESP32-Access-Point";
const char *password = "123456789";

// Create AsyncWebServer object on port 8080
AsyncWebServer server(8080);
AsyncWebSocket ws("/ws");

JsonDocument doc;

void setupJSON();
float readECG();
float readO2();
float readheartRate();

void onWebSocketEvent(AsyncWebSocket *server, AsyncWebSocketClient *client, AwsEventType type, void *arg, uint8_t *data, size_t len)
{
  if (type == WS_EVT_CONNECT)
  {
    Serial.println("Websocket client connection received");
  }
  else if (type == WS_EVT_DISCONNECT)
  {
    Serial.println("Client disconnected");
  }
  else if (type == WS_EVT_DATA)
  {
    Serial.printf("Data received: %s\n", data);
    // send message to client
    client->text("Hello from ESP32 Server");
  }
}

void sendWsMessage()
{
  // serialize the JSON document to a string
  String json;
  serializeJson(doc, json);
  //Serial.println("Attemmpt" + json);
  ws.textAll(json);
  // ws.textAll("Hello from ESP32 Server");
}

void setup()
{
  Serial.begin(115200);

  pinMode(ECG_PIN, INPUT);
  pinMode(ECG_PIN2, INPUT);

  WiFi.softAP(ssid, password);
  IPAddress IP = WiFi.softAPIP();
  Serial.print("AP IP address: ");
  Serial.println(IP);

  ws.onEvent(onWebSocketEvent);
  server.addHandler(&ws);

  // start server
  server.begin();
  Serial.print("Setup complete");

  setupJSON();
}

void loop()
{
  // Serial.println("Sending message");
  readO2();
  readheartRate();
  readECG();

  sendWsMessage();
  delay(100);
}

void setupJSON()
{
  // doc["patientID"] = "123456";
  JsonObject ecgdata = doc.createNestedObject("ecgdata");

  JsonArray ecgDataArray = ecgdata.createNestedArray("data");
  ecgDataArray.add("0.5");
  ecgDataArray.add("0.7");
  ecgDataArray.add("0.5");
  ecgDataArray.add("0.7");
  ecgDataArray.add("0.5");
  ecgDataArray.add("0.7");
  JsonArray ecgTimeArray = ecgdata.createNestedArray("time");
  ecgTimeArray.add("0.5");
  ecgTimeArray.add("0.7");
  ecgTimeArray.add("0.5");
  ecgTimeArray.add("0.7");
  ecgTimeArray.add("0.5");
  ecgTimeArray.add("0.7");

  // doc["oxygendata"] = String(readO2());
  doc["heartRate"] = String(readheartRate());

  // serialize the JSON document to a string
  String output;
  serializeJson(doc, output);
  Serial.println(output);
}

float readECG()
{
  //Serial.println("Reading ECG");
  float newData;
  for (int i = 0; i < 6; i++)
  {
    //if ((digitalRead(ECG_PIN) == 1) || (digitalRead(ECG_PIN2) == 1))
    //{
      //Serial.println("!");
    //}
    //else
    //{
    //newData = analogRead(36);
    newData = random(0, 100) / 100.0;
    //}
    doc["ecgdata"]["data"][i] = newData;
    doc["ecgdata"]["time"][i] = String(micros());
  }
  return 0.5;
}

float o2 = 0;

float readO2()
{
  //Serial.println("Reading O2");
  o2 += 0.1;
  doc["oxygendata"] = String(o2);
  return o2;
}

float readheartRate()
{
  //Serial.println("Reading Heart Rate");
  // need to schedule these
  doc["heartRate"] = String(60);
  return 60;
}