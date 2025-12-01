// Incluye la biblioteca necesaria para usar la cámara del ESP32
#include "esp_camera.h"
// Incluye la biblioteca para funcionalidades WiFi del ESP32
#include <WiFi.h>

// ===========================
// Select camera model in board_config.h
// ===========================
// Incluye el archivo de configuración específico del modelo de placa/cámara
#include "board_config.h"

// ===========================
// Enter your WiFi credentials
// ===========================
// Define las credenciales de tu red WiFi
const char *ssid = "pr";          // Nombre de la red WiFi (SSID)
const char *password = "kaku1234"; // Contraseña de la red WiFi

// Declaración de funciones externas que se usarán más adelante
void startCameraServer();  // Inicia el servidor web para la cámara
void setupLedFlash();      // Configura el flash LED si está disponible

void setup() {
  // Inicia la comunicación serial para depuración a 115200 baudios
  Serial.begin(115200);
  // Habilita la salida de mensajes de depuración del sistema por serial
  Serial.setDebugOutput(true);
  Serial.println();  // Imprime una línea en blanco

  // Configura los parámetros de la cámara creando un objeto de tipo 'config'
  camera_config_t config;
  config.ledc_channel = LEDC_CHANNEL_0;  // Canal LEDC para el reloj de la cámara
  config.ledc_timer = LEDC_TIMER_0;      // Timer LEDC a utilizar
  config.pin_d0 = Y2_GPIO_NUM;           // Pin para el bit de dato 0
  config.pin_d1 = Y3_GPIO_NUM;           // Pin para el bit de dato 1
  config.pin_d2 = Y4_GPIO_NUM;           // Pin para el bit de dato 2
  config.pin_d3 = Y5_GPIO_NUM;           // Pin para el bit de dato 3
  config.pin_d4 = Y6_GPIO_NUM;           // Pin para el bit de dato 4
  config.pin_d5 = Y7_GPIO_NUM;           // Pin para el bit de dato 5
  config.pin_d6 = Y8_GPIO_NUM;           // Pin para el bit de dato 6
  config.pin_d7 = Y9_GPIO_NUM;           // Pin para el bit de dato 7
  config.pin_xclk = XCLK_GPIO_NUM;       // Pin para el reloj externo de la cámara
  config.pin_pclk = PCLK_GPIO_NUM;       // Pin para el reloj de píxeles
  config.pin_vsync = VSYNC_GPIO_NUM;     // Pin para señal de sincronización vertical
  config.pin_href = HREF_GPIO_NUM;       // Pin para señal de referencia horizontal
  config.pin_sccb_sda = SIOD_GPIO_NUM;   // Pin para datos del bus SCCB (similar a I2C)
  config.pin_sccb_scl = SIOC_GPIO_NUM;   // Pin para reloj del bus SCCB
  config.pin_pwdn = PWDN_GPIO_NUM;       // Pin para apagar la cámara (power down)
  config.pin_reset = RESET_GPIO_NUM;     // Pin para resetear la cámara
  config.xclk_freq_hz = 20000000;        // Frecuencia del reloj externo (20 MHz)
  config.frame_size = FRAMESIZE_UXGA;    // Tamaño inicial del frame (UXGA: 1600x1200)
  config.pixel_format = PIXFORMAT_JPEG;  // Formato de píxel: JPEG para streaming
  // config.pixel_format = PIXFORMAT_RGB565; // Alternativa para detección de rostros
  
  config.grab_mode = CAMERA_GRAB_WHEN_EMPTY;  // Modo de captura: cuando el buffer está vacío
  config.fb_location = CAMERA_FB_IN_PSRAM;    // Ubicación del frame buffer: en PSRAM
  config.jpeg_quality = 12;                   // Calidad JPEG (0-63, menor = mejor calidad)
  config.fb_count = 1;                        // Número de frame buffers

  // Si hay PSRAM disponible y usamos formato JPEG, mejoramos la configuración
  if (config.pixel_format == PIXFORMAT_JPEG) {
    if (psramFound()) {  // Verifica si hay memoria PSRAM disponible
      config.jpeg_quality = 10;              // Mejor calidad JPEG
      config.fb_count = 2;                   // Dos buffers para mejor rendimiento
      config.grab_mode = CAMERA_GRAB_LATEST; // Siempre captura el frame más reciente
    } else {
      // Sin PSRAM, reducimos la calidad para ahorrar memoria
      config.frame_size = FRAMESIZE_SVGA;    // Tamaño menor (800x600)
      config.fb_location = CAMERA_FB_IN_DRAM; // Usamos DRAM normal
    }
  } else {
    // Configuración óptima para detección de rostros (RGB565)
    config.frame_size = FRAMESIZE_240X240;   // Tamaño pequeño para procesamiento
    #if CONFIG_IDF_TARGET_ESP32S3
    config.fb_count = 2;                     // Para ESP32-S3, usamos 2 buffers
    #endif
  }

  // Configuración específica para el modelo de cámara ESP-EYE
  #if defined(CAMERA_MODEL_ESP_EYE)
  pinMode(13, INPUT_PULLUP);  // Configura pin 13 como entrada con resistencia pull-up
  pinMode(14, INPUT_PULLUP);  // Configura pin 14 como entrada con resistencia pull-up
  #endif

  // Inicializa la cámara con la configuración definida
  esp_err_t err = esp_camera_init(&config);
  if (err != ESP_OK) {  // Si hay error en la inicialización
    Serial.printf("Camera init failed with error 0x%x", err);
    return;  // Sale del setup si la cámara no funciona
  }

  // Obtiene el sensor de la cámara para ajustes adicionales
  sensor_t *s = esp_camera_sensor_get();
  
  // Ajustes específicos para el sensor OV3660
  if (s->id.PID == OV3660_PID) {
    s->set_vflip(s, 1);        // Voltea verticalmente la imagen
    s->set_brightness(s, 1);   // Aumenta un poco el brillo
    s->set_saturation(s, -2);  // Reduce la saturación
  }

  // Para formato JPEG, reduce el tamaño del frame para mayor velocidad inicial
  if (config.pixel_format == PIXFORMAT_JPEG) {
    s->set_framesize(s, FRAMESIZE_QVGA);  // Cambia a QVGA (320x240)
  }

  // Ajustes de espejo y volteo para modelos específicos
  #if defined(CAMERA_MODEL_M5STACK_WIDE) || defined(CAMERA_MODEL_M5STACK_ESP32CAM)
  s->set_vflip(s, 1);    // Voltea verticalmente
  s->set_hmirror(s, 1);  // Espeja horizontalmente
  #endif

  #if defined(CAMERA_MODEL_ESP32S3_EYE)
  s->set_vflip(s, 1);    // Voltea verticalmente
  #endif

  // Configura el flash LED si está definido en los pines
  #if defined(LED_GPIO_NUM)
  setupLedFlash();  // Llama a la función de configuración del flash
  #endif

  // Conecta a la red WiFi
  WiFi.begin(ssid, password);
  WiFi.setSleep(false);  // Desactiva el modo sleep del WiFi para mejor rendimiento
  
  Serial.print("WiFi connecting");
  // Espera hasta que se establezca la conexión WiFi
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);      // Espera 500ms
    Serial.print(".");  // Muestra puntos mientras espera
  }
  Serial.println("");
  Serial.println("WiFi connected");

  // Inicia el servidor web de la cámara
  startCameraServer();
  
  // Muestra la dirección IP para acceder a la cámara
  Serial.print("Camera Ready! Use 'http://");
  Serial.print(WiFi.localIP());  // Muestra la IP local asignada
  Serial.println("' to connect");
}

void loop() {
  // No hace nada - todo el trabajo se hace en el servidor web
  // El delay permite que el procesador descanse
  delay(10000);  // Espera 10 segundos (parece que faltaba el paréntesis de cierre)
}