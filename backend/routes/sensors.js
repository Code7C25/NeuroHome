// routes/sensors.js
const express = require('express');
const router = express.Router();

// Estado actual de los sensores (en memoria por ahora)
let sensorData = {
  temperature: 23.5,
  humidity: 65,
  mainDoor: false, // false = cerrada, true = abierta
  lastUpdate: new Date()
};

// GET /api/sensors/data - Obtener datos de sensores
router.get('/data', (req, res) => {
  res.json({
    success: true,
    data: sensorData,
    timestamp: new Date().toISOString()
  });
});

// POST /api/sensors/update - Arduino envía datos (temp/humedad)
router.post('/update', (req, res) => {
  const { temperature, humidity } = req.body;
  
  if (temperature !== undefined) {
    sensorData.temperature = parseFloat(temperature);
  }
  if (humidity !== undefined) {
    sensorData.humidity = parseFloat(humidity);
  }
  
  sensorData.lastUpdate = new Date();
  
  res.json({
    success: true,
    message: 'Datos actualizados',
    data: sensorData
  });
});

// POST /api/sensors/door - Arduino notifica cambio de puerta
router.post('/door', (req, res) => {
  const { doorOpen } = req.body;
  
  const previousState = sensorData.mainDoor;
  sensorData.mainDoor = Boolean(doorOpen);
  sensorData.lastUpdate = new Date();
  
  // Si la puerta se abrió (antes estaba cerrada)
  if (sensorData.mainDoor && !previousState) {
    console.log('🚨 ALERTA: Puerta principal abierta');
  }
  
  res.json({
    success: true,
    message: `Puerta ${sensorData.mainDoor ? 'abierta' : 'cerrada'}`,
    doorOpen: sensorData.mainDoor
  });
});

module.exports = router;