require('dotenv').config();
const express = require('express');
const cors = require('cors');
const morgan = require('morgan');

const authRoutes = require('./routes/auth');
const protectedRoutes = require('./routes/protected');
const testRoutes = require('./routes/test');  // ← AGREGAR ESTA LÍNEA
const { connect } = require('./config/db');

const app = express();

// Middlewares
app.use(cors());
app.use(express.json());
app.use(morgan('dev'));

// Rutas
app.use('/api/auth', authRoutes);
app.use('/api/protected', protectedRoutes);
app.use('/api', testRoutes);  // ← AGREGAR ESTA LÍNEA

// Ruta base opcional
app.get('/', (req, res) => {
  res.json({ ok: true, message: 'NeuroHome backend activo' });
});

// Arranque
(async () => {
  try {
    await connect();
    const PORT = process.env.PORT || 3000;
    app.listen(PORT, () => {
      console.log(`Server listening on http://localhost:${PORT}`);
    });
  } catch (err) {
    console.error('Fallo al iniciar el servidor:', err);
    process.exit(1);
  }
})();