const { sendCommand } = require('../services/mqttService');

exports.controlDevice = (req, res) => {
  const { device, action } = req.body; 
  // device: 'porton' | 'puerta' | 'luz'
  // action: 'OPEN' | 'CLOSE' | 'ON' | 'OFF'

  console.log(`📲 Petición recibida: ${device} -> ${action}`);

  let topic = '';
  let message = action;

  // Mapear dispositivo a Tópico MQTT
  switch (device) {
    case 'porton':
      topic = 'casa/porton/comando';
      break;
    case 'puerta':
      topic = 'casa/puerta/comando'; 
      break;
    case 'luz':
      topic = 'casa/luces/patio';
      break;
    default:
      return res.status(400).json({ ok: false, message: 'Dispositivo no válido' });
  }

  // Enviar por MQTT
  const success = sendCommand(topic, message);

  if (success) {
    res.json({ ok: true, message: `Comando ${action} enviado a ${device}` });
  } else {
    res.status(500).json({ ok: false, message: 'Error al enviar comando MQTT' });
  }
};