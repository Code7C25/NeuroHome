/*
* NEUROHOME FINAL v6 - PIN 18 + MOVIMIENTO SUAVE
*/
// Comentario que indica la versión y características del proyecto

// Inclusión de librerías necesarias
#include <WiFi.h>              // Para conexión WiFi del ESP32
#include <PubSubClient.h>      // Para comunicación MQTT
#include <ESP32Servo.h>        // Para control de servomotores en ESP32
#include <DHT.h>               // Para sensor de temperatura y humedad
#include <Wire.h>              // Para comunicación I2C
#include <LiquidCrystal_I2C.h> // Para control de LCD I2C

// Configuración de credenciales de red
const char *ssid = "pr";              // Nombre de la red WiFi
const char *password = "kaku1234";    // Contraseña del WiFi
const char* mqtt_server = "broker.hivemq.com"; // Servidor MQTT público

// --- CAMBIO DE PIN AQUÍ ---
#define PIN_SERVO_PORTON 13    // Pin para el servomotor del portón
#define PIN_SERVO_PUERTA 18    // Pin para el servomotor de la puerta (cambiado al 18)
// --------------------------

// Definición de pines para otros componentes
#define PIN_BUZZER 14          // Pin para el buzzer
#define PIN_SENSOR_IR 27       // Pin para sensor infrarrojo
#define PIN_DHT 4              // Pin para sensor DHT11
#define PIN_RGB_R 15           // Pin RED del LED RGB
#define PIN_RGB_G 2            // Pin GREEN del LED RGB  
#define PIN_RGB_B 16           // Pin BLUE del LED RGB

// Declaración de objetos para los componentes
WiFiClient espClient;          // Cliente WiFi para MQTT
PubSubClient client(espClient); // Cliente MQTT
DHT dht(PIN_DHT, DHT11);       // Sensor DHT11
LiquidCrystal_I2C lcd(0x27, 16, 2); // LCD I2C dirección 0x27, 16x2 caracteres
Servo servoPorton;             // Objeto servo para el portón
Servo servoPuerta;             // Objeto servo para la puerta

void setup() {
  Serial.begin(115200);        // Inicia comunicación serial a 115200 baudios
  
  Wire.begin(21, 22);          // Inicia I2C en pines 21 (SDA) y 22 (SCL)
  lcd.init(); lcd.backlight(); // Inicializa LCD y enciende retroiluminación
  lcd.print("Sistema Listo");  // Muestra mensaje inicial en LCD

  // Asignar timers para evitar conflictos entre servos
  ESP32PWM::allocateTimer(0);  // Asigna timer 0 para servos
  ESP32PWM::allocateTimer(1);  // Asigna timer 1 para servos
  
  // Configuración del servo del portón
  servoPorton.setPeriodHertz(50);          // Frecuencia PWM estándar para servos
  servoPorton.attach(PIN_SERVO_PORTON, 500, 2400); // Asocia al pin con rango de pulsos
  
  // Configuración del servo de la puerta
  servoPuerta.setPeriodHertz(50);          // Misma frecuencia
  servoPuerta.attach(PIN_SERVO_PUERTA, 500, 2400); // Asocia al pin 18

  // Posición inicial suave de los servos
  servoPorton.write(0);        // Mueve portón a posición 0 grados (cerrado)
  delay(500);                  // Espera para evitar consumo eléctrico simultáneo
  servoPuerta.write(0);        // Mueve puerta a posición 0 grados (cerrada)

  // Configuración de pines de salida/entrada
  pinMode(PIN_BUZZER, OUTPUT);           // Buzzer como salida
  pinMode(PIN_SENSOR_IR, INPUT);         // Sensor IR como entrada
  pinMode(PIN_RGB_R, OUTPUT);            // LED RGB RED como salida
  pinMode(PIN_RGB_G, OUTPUT);            // LED RGB GREEN como salida  
  pinMode(PIN_RGB_B, OUTPUT);            // LED RGB BLUE como salida
  
  // Apaga todos los LEDs RGB inicialmente
  digitalWrite(PIN_RGB_R, LOW); 
  digitalWrite(PIN_RGB_G, LOW); 
  digitalWrite(PIN_RGB_B, LOW);

  dht.begin();                 // Inicializa sensor DHT
  setup_wifi();                // Conecta a WiFi
  client.setServer(mqtt_server, 1883); // Configura servidor MQTT
  client.setCallback(callback); // Asigna función para mensajes MQTT entrantes
}

void loop() {
  if (!client.connected()) reconnect(); // Reconecta si se perdió conexión MQTT
  client.loop();              // Procesa mensajes MQTT entrantes
  
  static unsigned long lastTime = 0; // Variable para control de tiempo
  if (millis() - lastTime > 2000) { // Cada 2 segundos
    lastTime = millis();
    leerSensores();           // Lee y publica datos de sensores
  }
}

// --- SONIDO ---
void sonarAlarma(int veces, int duracion) {
  // Reproduce sonido de alarma
  for(int i=0; i<veces; i++) {
    tone(PIN_BUZZER, 2000);   // Genera tono de 2000Hz
    delay(duracion);          // Mantiene el tono
    noTone(PIN_BUZZER);       // Apaga el tono
    delay(100);               // Pausa entre tonos
  }
}

// --- ACCIONES ---
void moverPorton(bool abrir) {
  if (abrir) {
    lcd.setCursor(0,1); lcd.print("Abriendo Porton "); // Mensaje en LCD
    servoPorton.write(90);     // Abre portón (90 grados)
    sonarAlarma(3, 150);       // Sonido corto y rápido
    client.publish("casa/porton/estado", "ABIERTO"); // Publica estado
  } else {
    lcd.setCursor(0,1); lcd.print("Cerrando Porton "); // Mensaje en LCD
    servoPorton.write(0);      // Cierra portón (0 grados)
    sonarAlarma(1, 800);       // Sonido largo
    client.publish("casa/porton/estado", "CERRADO"); // Publica estado
  }
}

void moverPuerta(bool abrir) {
  if (abrir) {
    servoPuerta.write(90);     // Abre puerta (90 grados)
    client.publish("casa/puerta/estado", "ABIERTO"); // Publica estado
  } else {
    servoPuerta.write(0);      // Cierra puerta (0 grados)
    client.publish("casa/puerta/estado", "CERRADO"); // Publica estado
  }
}

void controlLuz(bool on) {
  if (on) {
    // Enciende todos los LEDs RGB (luz blanca)
    digitalWrite(PIN_RGB_R, HIGH); 
    digitalWrite(PIN_RGB_G, HIGH); 
    digitalWrite(PIN_RGB_B, HIGH);
  } else {
    // Apaga todos los LEDs RGB
    digitalWrite(PIN_RGB_R, LOW); 
    digitalWrite(PIN_RGB_G, LOW); 
    digitalWrite(PIN_RGB_B, LOW);
  }
}

void leerSensores() {
  float t = dht.readTemperature(); // Lee temperatura
  float h = dht.readHumidity();    // Lee humedad
  
  if (!isnan(t)) { // Si la lectura es válida
    lcd.setCursor(0,0);
    lcd.print("T:" + String(t,0) + " H:" + String(h,0) + "%"); // Muestra en LCD
    
    // Crea y publica JSON con datos del clima
    String json = "{\"temperature\": " + String(t) + ", \"humidity\": " + String(h) + "}";
    client.publish("casa/sensores/clima", json.c_str());
  }
}

void callback(char* topic, byte* payload, unsigned int length) {
  // Función que se ejecuta cuando llegan mensajes MQTT
  String msg = "";
  for (int i = 0; i < length; i++) msg += (char)payload[i]; // Convierte payload a String
  String t = String(topic); // Convierte topic a String
  
  // Control de portón
  if (t == "casa/porton/comando") {
    if (msg == "OPEN") moverPorton(true); 
    else if (msg == "CLOSE") moverPorton(false);
  }
  // Control de puerta
  else if (t == "casa/puerta/comando") {
    if (msg == "OPEN") moverPuerta(true); 
    else if (msg == "CLOSE") moverPuerta(false);
  }
  // Control de luces
  else if (t == "casa/luces/patio") {
    if (msg == "ON") controlLuz(true); 
    else if (msg == "OFF") controlLuz(false);
  }
}

void setup_wifi() {
  // Conexión a WiFi
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) { delay(500); } // Espera hasta conectar
}

void reconnect() {
  // Reconexión a broker MQTT
  while (!client.connected()) {
    String id = "ESP32_Final_" + String(random(0xffff), HEX); // ID único
    if (client.connect(id.c_str())) {
      // Suscripción a topics MQTT
      client.subscribe("casa/porton/comando");
      client.subscribe("casa/puerta/comando"); 
      client.subscribe("casa/luces/patio");
    } else { delay(5000); } // Espera 5 segundos antes de reintentar
  }
}