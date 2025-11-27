// routes/test.js
const express = require('express');
const router = express.Router();
const { sequelize } = require('../config/db');

// GET /api/test - Prueba básica del backend
router.get('/test', (req, res) => {
  res.json({ 
    message: '✅ Backend funcionando correctamente',
    timestamp: new Date().toISOString(),
    status: 'OK'
  });
});

// GET /api/test-db - Prueba de conexión a la base de datos
router.get('/test-db', async (req, res) => {
  try {
    // Probar conexión a la base de datos
    await sequelize.authenticate();
    
    // Contar usuarios en la tabla (usando tu modelo Sequelize)
    const User = require('../models/user').User;
    const userCount = await User.count();
    
    res.json({ 
      success: true, 
      message: '✅ Base de datos conectada correctamente',
      count: userCount,
      database: 'MySQL con Sequelize'
    });
  } catch (error) {
    console.error('Error en test-db:', error);
    res.status(500).json({ 
      success: false, 
      error: error.message 
    });
  }
});

module.exports = router;