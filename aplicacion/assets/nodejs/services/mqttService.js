const mqtt = require('mqtt');

const BROKER_URL = 'mqtt://broker.hivemq.com'; 

// Memoria temporal para los sensores
let ultimosDatos = { 
  temperature: 0, 
  humidity: 0, 
  mainDoor: false, 
  lastUpdate: new Date() 
};

const client = mqtt.connect(BROKER_URL);

client.on('connect', () => {
  console.log(`🔌 Backend conectado a MQTT Broker: ${BROKER_URL}`);
  // Suscribirse para escuchar a la ESP32
  client.subscribe('casa/sensores/clima'); 
});

client.on('message', (topic, message) => {
  if (topic === 'casa/sensores/clima') {
    try {
      const datos = JSON.parse(message.toString());
      
      // Guardar en memoria
      ultimosDatos.temperature = datos.temperature;
      ultimosDatos.humidity = datos.humidity;
      ultimosDatos.lastUpdate = new Date();
      
      console.log('🌡️ Clima actualizado:', ultimosDatos);
    } catch (e) {
      console.error('Error procesando datos del sensor:', e);
    }
  }
});

const sendCommand = (topic, message) => {
  if (client.connected) {
    client.publish(topic, message);
    console.log(`📤 Comando enviado: ${topic} -> ${message}`);
    return true;
  }
  return false;
};

// Función para que el controlador pida los datos
const getSensores = () => ultimosDatos;

module.exports = { client, sendCommand, getSensores };