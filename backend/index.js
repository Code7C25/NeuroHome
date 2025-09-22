const express = require('express');
const dotenv = require('dotenv');
dotenv.config();

const authRoutes = require('./routes/auth');

const app = express();
app.use(express.json());

// Rutas
app.use('/api', authRoutes);

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Servidor corriendo en puerto ${PORT}`));
