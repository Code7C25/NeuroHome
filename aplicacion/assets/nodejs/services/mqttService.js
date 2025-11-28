// services/mqttService.js
const mqtt = require('mqtt');

// Usa un broker público para pruebas o tu IP local si instalas Mosquitto
// Opción A (Público - Más fácil): 'mqtt://broker.hivemq.com'
// Opción B (Local): 'mqtt://localhost'
const BROKER_URL = 'mqtt://broker.hivemq.com'; 

const client = mqtt.connect(BROKER_URL);

client.on('connect', () => {
  console.log(`🔌 Conectado a MQTT Broker: ${BROKER_URL}`);
  // Suscribirse a tópicos de sensores para guardarlos en BD si quieres
  client.subscribe('casa/sensores/#');
});

// Función para enviar comandos
const sendCommand = (topic, message) => {
  if (client.connected) {
    client.publish(topic, message);
    console.log(`📤 MQTT Enviado: ${topic} -> ${message}`);
    return true;
  } else {
    console.error('⚠️ Cliente MQTT no conectado');
    return false;
  }
};

module.exports = { client, sendCommand };