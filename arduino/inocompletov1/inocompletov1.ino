/*
 * PROYECTO: NEUROHOME FINAL
 * PLACA: ESP32 DevKit V1 (Negra)
 */

#include <WiFi.h>
#include <PubSubClient.h>
#include <ESP32Servo.h>
#include <DHT.h>
#include <Wire.h>
#include <LiquidCrystal_I2C.h>

// --- 1. CREDENCIALES WIFI ---
const char* ssid = "Flia Marani";          // <--- ¡PON TU WIFI!
const char* password = "casa1234";  // <--- ¡PON TU CLAVE!
const char* mqtt_server = "broker.hivemq.com"; 

// --- 2. PINES ---
#define PIN_SDA 21
#define PIN_SCL 22
#define PIN_SERVO_PORTON 13
#define PIN_SERVO_PUERTA 12
#define PIN_BUZZER 14
#define PIN_SENSOR_IR 27
#define PIN_DHT 4
// RGB
#define PIN_RGB_R 15
#define PIN_RGB_G 2
#define PIN_RGB_B 16

#define DHTTYPE DHT11

// --- 3. OBJETOS ---
WiFiClient espClient;
PubSubClient client(espClient);
DHT dht(PIN_DHT, DHTTYPE);
LiquidCrystal_I2C lcd(0x27, 16, 2); 
Servo servoPorton;
Servo servoPuerta;

void setup() {
  Serial.begin(115200);

  // LCD
  Wire.begin(PIN_SDA, PIN_SCL);
  lcd.init();
  lcd.backlight();
  lcd.setCursor(0,0);
  lcd.print("NeuroHome v2.0");

  // Servos
  servoPorton.attach(PIN_SERVO_PORTON);
  servoPuerta.attach(PIN_SERVO_PUERTA);
  servoPorton.write(0); // Cerrado al inicio
  servoPuerta.write(0);

  // Pines
  pinMode(PIN_BUZZER, OUTPUT);
  pinMode(PIN_SENSOR_IR, INPUT);
  pinMode(PIN_RGB_R, OUTPUT);
  pinMode(PIN_RGB_G, OUTPUT);
  pinMode(PIN_RGB_B, OUTPUT);
  apagarRGB();

  dht.begin();
  setup_wifi();
  client.setServer(mqtt_server, 1883);
  client.setCallback(callback);
  
  delay(2000);
  lcd.clear();
}

void loop() {
  if (!client.connected()) reconnect();
  client.loop();

  // Actualizar sensores cada 2 segundos
  static unsigned long lastTime = 0;
  if (millis() - lastTime > 2000) {
    lastTime = millis();
    leerSensores();
  }
}

// --- ACCIONES ---

void moverPorton(bool abrir) {
  if (abrir) {
    lcd.setCursor(0,1); lcd.print("Porton: Abriendo");
    
    // Secuencia Pip Pip Pip
    for(int i=0; i<3; i++) {
      digitalWrite(PIN_BUZZER, HIGH); delay(100);
      digitalWrite(PIN_BUZZER, LOW); delay(100);
    }
    
    servoPorton.write(90); 
    client.publish("casa/porton/estado", "ABIERTO");
  } else {
    lcd.setCursor(0,1); lcd.print("Porton: Cerrando");
    
    // Pip largo
    digitalWrite(PIN_BUZZER, HIGH); delay(500);
    digitalWrite(PIN_BUZZER, LOW);
    
    servoPorton.write(0); 
    client.publish("casa/porton/estado", "CERRADO");
  }
  delay(1000); lcd.setCursor(0,1); lcd.print("                ");
}

void moverPuerta(bool abrir) {
  if (abrir) {
    servoPuerta.write(90);
    client.publish("casa/puerta/estado", "ABIERTO");
  } else {
    servoPuerta.write(0);
    client.publish("casa/puerta/estado", "CERRADO");
  }
}

void controlLuz(bool on) {
  if (on) {
    // Blanco (Todos prendidos)
    digitalWrite(PIN_RGB_R, HIGH);
    digitalWrite(PIN_RGB_G, HIGH);
    digitalWrite(PIN_RGB_B, HIGH);
    Serial.println("Luz ON");
  } else {
    apagarRGB();
    Serial.println("Luz OFF");
  }
}

void apagarRGB() {
  digitalWrite(PIN_RGB_R, LOW);
  digitalWrite(PIN_RGB_G, LOW);
  digitalWrite(PIN_RGB_B, LOW);
}

void leerSensores() {
  // 1. Clima
  float t = dht.readTemperature();
  float h = dht.readHumidity();
  
  if (!isnan(t)) {
    lcd.setCursor(0,0);
    lcd.print("T:" + String(t,0) + "C H:" + String(h,0) + "%");
    
    String json = "{\"temperature\": " + String(t) + ", \"humidity\": " + String(h) + "}";
    client.publish("casa/sensores/clima", json.c_str());
  }

  // 2. Sensor IR (Puerta Física)
  // LOW = Detecta obstáculo (Puerta cerrada)
  // HIGH = No detecta nada (Puerta abierta)
  int ir = digitalRead(PIN_SENSOR_IR);
  
  lcd.setCursor(13,0); // Esquina superior derecha
  if (ir == LOW) {
    lcd.print("CER"); // Puerta Cerrada
  } else {
    lcd.print("ABE"); // Puerta Abierta
  }
}

// --- MQTT ---
void callback(char* topic, byte* payload, unsigned int length) {
  String msg = "";
  for (int i = 0; i < length; i++) msg += (char)payload[i];
  String t = String(topic);

  Serial.println(t + " -> " + msg);

  if (t == "casa/porton/comando") {
    if (msg == "OPEN") moverPorton(true);
    else if (msg == "CLOSE") moverPorton(false);
  }
  else if (t == "casa/puerta/comando") {
    if (msg == "OPEN") moverPuerta(true);
    else if (msg == "CLOSE") moverPuerta(false);
  }
  else if (t == "casa/luces/patio") {
    if (msg == "ON") controlLuz(true);
    else if (msg == "OFF") controlLuz(false);
  }
}

void setup_wifi() {
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500); Serial.print(".");
  }
  Serial.println("WiFi OK");
}

void reconnect() {
  while (!client.connected()) {
    String id = "ESP32_Final_" + String(random(0xffff), HEX);
    if (client.connect(id.c_str())) {
      client.subscribe("casa/porton/comando");
      client.subscribe("casa/puerta/comando");
      client.subscribe("casa/luces/patio");
    } else {
      delay(5000);
    }
  }
}