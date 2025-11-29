const express = require('express');
const router = express.Router();
const sensorController = require('../controllers/sensorController');

// GET /api/sensors/data
// Esta ruta conecta la App con el Controlador.
// El controlador a su vez saca el dato real del servicio MQTT.
router.get('/data', sensorController.getData);

module.exports = router;