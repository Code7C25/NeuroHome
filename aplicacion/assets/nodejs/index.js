require('dotenv').config();
const express = require('express');
const cors = require('cors');
const morgan = require('morgan');

const authRoutes = require('./routes/auth');
const protectedRoutes = require('./routes/protected');
const testRoutes = require('./routes/test');
const sensorRoutes = require('./routes/sensors');  // ← AGREGADO
const { connect } = require('./config/db');

const app = express();

// Middlewares - MEJORADO para producción
app.use(cors({
  origin: '*', // Permite todas las origins (puedes restringirlo después)
  methods: ['GET', 'POST', 'PUT', 'DELETE'],
  credentials: true
}));
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true }));
app.use(morgan('dev'));

// Rutas
app.use('/api/auth', authRoutes);
app.use('/api/protected', protectedRoutes);
app.use('/api', testRoutes);
app.use('/api/sensors', sensorRoutes);  // ← AGREGADO en el lugar correcto

// Ruta base de salud
app.get('/', (req, res) => {
  res.json({ 
    ok: true, 
    message: 'NeuroHome backend activo',
    timestamp: new Date().toISOString(),
    environment: process.env.NODE_ENV || 'development'
  });
});

// Ruta de health check para la nube
app.get('/health', (req, res) => {
  res.status(200).json({ 
    status: 'OK', 
    service: 'NeuroHome Backend',
    timestamp: new Date().toISOString()
  });
});

// Manejo de rutas no encontradas
app.use('*', (req, res) => {
  res.status(404).json({ 
    ok: false, 
    message: 'Ruta no encontrada' 
  });
});

// Manejo global de errores
app.use((err, req, res, next) => {
  console.error('Error no manejado:', err);
  res.status(500).json({ 
    ok: false, 
    message: 'Error interno del servidor',
    error: process.env.NODE_ENV === 'production' ? {} : err.message
  });
});

// Arranque - MODIFICADO para la nube
(async () => {
  try {
    await connect();
    const PORT = process.env.PORT || 3000;
    const HOST = process.env.HOST || '0.0.0.0';  // ← IMPORTANTE para la nube
    
    app.listen(PORT, HOST, () => {
      console.log(`🚀 Server listening on http://${HOST}:${PORT}`);
      console.log(`📊 Environment: ${process.env.NODE_ENV || 'development'}`);
      console.log(`🌐 CORS enabled for all origins`);
    });
  } catch (err) {
    console.error('Fallo al iniciar el servidor:', err);
    process.exit(1);
  }
})();