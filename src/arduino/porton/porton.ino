/*
 * PROYECTO: NeuroHome - Portón Paso a Paso
 * MOTOR: 28BYJ-48 con Driver ULN2003
 */

#include <WiFi.h>
#include <PubSubClient.h>
#include <Stepper.h>        // Librería para motores paso a paso
#include <DHT.h>

// --- 1. CONFIGURACIÓN WIFI ---
const char* ssid = "Flia Marani";
const char* password = "casa1234";

// --- 2. CONFIGURACIÓN MQTT ---
const char* mqtt_server = "broker.hivemq.com"; 
const int mqtt_port = 1883;
const char* topic_comando = "casa/porton/comando"; 
const char* topic_estado = "casa/porton/estado";
const char* topic_sensores = "casa/sensores/clima";

// --- 3. CONFIGURACIÓN MOTOR PASO A PASO ---
const int stepsPerRevolution = 2048;  // Pasos por vuelta para el 28BYJ-48
// Pines de control (IN1, IN3, IN2, IN4 - Orden específico para la librería Stepper)
// Prueba este orden nuevo:
Stepper myStepper(stepsPerRevolution, 19, 18, 5, 17);

// --- 4. CONFIGURACIÓN SENSOR ---
#define DHTPIN 4
#define DHTTYPE DHT11

WiFiClient espClient;
PubSubClient client(espClient);
DHT dht(DHTPIN, DHTTYPE);

bool portonAbierto = false; // Para saber el estado actual

void setup() {
  Serial.begin(115200);

  // Velocidad del motor (rpm)
  myStepper.setSpeed(10); // 10 RPM es una velocidad segura para este motor

  dht.begin();
  setup_wifi();
  client.setServer(mqtt_server, mqtt_port);
  client.setCallback(callback);
}

void loop() {
  if (!client.connected()) {
    reconnect();
  }
  client.loop();

  // Leer sensor cada 10 seg
  static unsigned long ultimoTiempo = 0;
  unsigned long tiempoActual = millis();
  if (tiempoActual - ultimoTiempo > 10000) {
    ultimoTiempo = tiempoActual;
    leerYEnviarSensores();
  }
}

// --- CONEXIÓN WIFI ---
void setup_wifi() {
  delay(10);
  Serial.println();
  Serial.print("Conectando a WiFi: ");
  Serial.println(ssid);
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("\nWiFi conectado!");
}

// --- RECEPCIÓN DE MENSAJES ---
void callback(char* topic, byte* payload, unsigned int length) {
  String mensaje = "";
  for (int i = 0; i < length; i++) {
    mensaje += (char)payload[i];
  }
  Serial.print("Mensaje: ");
  Serial.println(mensaje);

  if (String(topic) == topic_comando) {
    if (mensaje == "OPEN") {
      abrirPorton();
    } else if (mensaje == "CLOSE") {
      cerrarPorton();
    }
  }
}

// --- LÓGICA DEL MOTOR ---
void abrirPorton() {
  if (!portonAbierto) {
    Serial.println("Abriendo...");
    client.publish(topic_estado, "ABRIENDO");
    
    // Girar 1 vuelta completa (ajusta 2048 si necesitas más o menos apertura)
    myStepper.step(stepsPerRevolution); 
    
    // Apagar bobinas para que no caliente y ahorre energía
    digitalWrite(19, LOW); digitalWrite(18, LOW); 
    digitalWrite(5, LOW); digitalWrite(17, LOW);

    portonAbierto = true;
    Serial.println("Portón Abierto");
    client.publish(topic_estado, "ABIERTO");
  }
}

void cerrarPorton() {
  if (portonAbierto) {
    Serial.println("Cerrando...");
    client.publish(topic_estado, "CERRANDO");
    
    // Girar en sentido contrario (negativo)
    myStepper.step(-stepsPerRevolution);
    
    // Apagar bobinas
    digitalWrite(19, LOW); digitalWrite(18, LOW); 
    digitalWrite(5, LOW); digitalWrite(17, LOW);

    portonAbierto = false;
    Serial.println("Portón Cerrado");
    client.publish(topic_estado, "CERRADO");
  }
}

void reconnect() {
  while (!client.connected()) {
    Serial.print("Conectando MQTT...");
    String clientId = "ESP32_Porton_" + String(random(0xffff), HEX);
    if (client.connect(clientId.c_str())) {
      Serial.println("¡Conectado!");
      client.subscribe(topic_comando);
    } else {
      delay(5000);
    }
  }
}

void leerYEnviarSensores() {
  float h = dht.readHumidity();
  float t = dht.readTemperature();
  if (!isnan(h) && !isnan(t)) {
    String json = "{\"temperature\": " + String(t) + ", \"humidity\": " + String(h) + "}";
    client.publish(topic_sensores, json.c_str());
  }
}