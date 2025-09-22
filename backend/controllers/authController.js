const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const User = require('../models/user');

exports.register = (req, res) => {
  const { nombre, email, password } = req.body;
  if (!nombre || !email || !password) return res.status(400).json({ message: 'Faltan datos' });

  const salt = bcrypt.genSaltSync(10);
  const hash = bcrypt.hashSync(password, salt);

  User.create(nombre, email, hash, (err, result) => {
    if (err) {
      if (err.code === 'ER_DUP_ENTRY') return res.status(400).json({ message: 'Email ya registrado' });
      return res.status(500).json({ message: 'Error al registrar usuario', error: err });
    }
    res.json({ message: 'Usuario registrado con éxito', userId: result.insertId });
  });
};

exports.login = (req, res) => {
  const { email, password } = req.body;
  if (!email || !password) return res.status(400).json({ message: 'Faltan datos' });

  User.findByEmail(email, (err, results) => {
    if (err) return res.status(500).json({ message: 'Error en la base de datos', error: err });
    if (results.length === 0) return res.status(400).json({ message: 'Usuario no encontrado' });

    const user = results[0];
    const passOk = bcrypt.compareSync(password, user.password_hash);
    if (!passOk) return res.status(400).json({ message: 'Contraseña incorrecta' });

    const token = jwt.sign({ id: user.id, email: user.email }, process.env.JWT_SECRET || 'secret', { expiresIn: '24h' });
    res.json({ message: 'Login exitoso', token });
  });
};
