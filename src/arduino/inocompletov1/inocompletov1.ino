/*
 * NEUROHOME FINAL v6 - PIN 18 + MOVIMIENTO SUAVE
 */

#include <WiFi.h>
#include <PubSubClient.h>
#include <ESP32Servo.h> 
#include <DHT.h>
#include <Wire.h>
#include <LiquidCrystal_I2C.h>

const char* ssid = "Flia Marani";          
const char* password = "casa1234";  
const char* mqtt_server = "broker.hivemq.com"; 

// --- CAMBIO DE PIN AQUÍ ---
#define PIN_SERVO_PORTON 13
#define PIN_SERVO_PUERTA 18  // <--- AHORA EN EL 18
// --------------------------

#define PIN_BUZZER 14
#define PIN_SENSOR_IR 27
#define PIN_DHT 4
#define PIN_RGB_R 15
#define PIN_RGB_G 2
#define PIN_RGB_B 16

WiFiClient espClient;
PubSubClient client(espClient);
DHT dht(PIN_DHT, DHT11);
LiquidCrystal_I2C lcd(0x27, 16, 2); 
Servo servoPorton;
Servo servoPuerta;

void setup() {
  Serial.begin(115200);
  Wire.begin(21, 22);
  lcd.init(); lcd.backlight();
  lcd.print("Sistema Listo");

  // Asignar timers para evitar conflictos
  ESP32PWM::allocateTimer(0);
  ESP32PWM::allocateTimer(1);
  
  servoPorton.setPeriodHertz(50);
  servoPorton.attach(PIN_SERVO_PORTON, 500, 2400);
  
  servoPuerta.setPeriodHertz(50);
  servoPuerta.attach(PIN_SERVO_PUERTA, 500, 2400); // Pin 18
  
  // Posición inicial suave
  servoPorton.write(0);
  delay(500); // Esperar para no consumir todo de golpe
  servoPuerta.write(0);

  pinMode(PIN_BUZZER, OUTPUT);
  pinMode(PIN_SENSOR_IR, INPUT);
  pinMode(PIN_RGB_R, OUTPUT); pinMode(PIN_RGB_G, OUTPUT); pinMode(PIN_RGB_B, OUTPUT);
  digitalWrite(PIN_RGB_R, LOW); digitalWrite(PIN_RGB_G, LOW); digitalWrite(PIN_RGB_B, LOW);

  dht.begin();
  setup_wifi();
  client.setServer(mqtt_server, 1883);
  client.setCallback(callback);
}

void loop() {
  if (!client.connected()) reconnect();
  client.loop();
  
  static unsigned long lastTime = 0;
  if (millis() - lastTime > 2000) {
    lastTime = millis();
    leerSensores();
  }
}

// --- SONIDO ---
void sonarAlarma(int veces, int duracion) {
  for(int i=0; i<veces; i++) {
    tone(PIN_BUZZER, 2000); 
    delay(duracion);
    noTone(PIN_BUZZER);     
    delay(100);             
  }
}

// --- ACCIONES ---
void moverPorton(bool abrir) {
  if (abrir) {
    lcd.setCursor(0,1); lcd.print("Abriendo Porton ");
    servoPorton.write(90); 
    sonarAlarma(3, 150); 
    client.publish("casa/porton/estado", "ABIERTO");
  } else {
    lcd.setCursor(0,1); lcd.print("Cerrando Porton ");
    servoPorton.write(0);
    sonarAlarma(1, 800);
    client.publish("casa/porton/estado", "CERRADO");
  }
}

void moverPuerta(bool abrir) {
  if (abrir) {
    // Puerta Principal
    servoPuerta.write(90);
    client.publish("casa/puerta/estado", "ABIERTO");
  } else {
    servoPuerta.write(0);
    client.publish("casa/puerta/estado", "CERRADO");
  }
}

void controlLuz(bool on) {
  if (on) {
    digitalWrite(PIN_RGB_R, HIGH); digitalWrite(PIN_RGB_G, HIGH); digitalWrite(PIN_RGB_B, HIGH);
  } else {
    digitalWrite(PIN_RGB_R, LOW); digitalWrite(PIN_RGB_G, LOW); digitalWrite(PIN_RGB_B, LOW);
  }
}

void leerSensores() {
  float t = dht.readTemperature();
  float h = dht.readHumidity();
  if (!isnan(t)) {
    lcd.setCursor(0,0);
    lcd.print("T:" + String(t,0) + " H:" + String(h,0) + "%");
    String json = "{\"temperature\": " + String(t) + ", \"humidity\": " + String(h) + "}";
    client.publish("casa/sensores/clima", json.c_str());
  }
}

void callback(char* topic, byte* payload, unsigned int length) {
  String msg = "";
  for (int i = 0; i < length; i++) msg += (char)payload[i];
  String t = String(topic);

  if (t == "casa/porton/comando") {
    if (msg == "OPEN") moverPorton(true); else if (msg == "CLOSE") moverPorton(false);
  }
  else if (t == "casa/puerta/comando") {
    if (msg == "OPEN") moverPuerta(true); else if (msg == "CLOSE") moverPuerta(false);
  }
  else if (t == "casa/luces/patio") {
    if (msg == "ON") controlLuz(true); else if (msg == "OFF") controlLuz(false);
  }
}

void setup_wifi() {
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) { delay(500); }
}

void reconnect() {
  while (!client.connected()) {
    String id = "ESP32_Final_" + String(random(0xffff), HEX);
    if (client.connect(id.c_str())) {
      client.subscribe("casa/porton/comando");
      client.subscribe("casa/puerta/comando");
      client.subscribe("casa/luces/patio");
    } else { delay(5000); }
  }
}