const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { createUser, findByUsername, comparePassword } = require('../models/user');

const JWT_SECRET = process.env.JWT_SECRET || 'dev-secret-123';

function makeToken(payload) {
  return jwt.sign(payload, JWT_SECRET, { expiresIn: '8h' });
}

exports.register = async (req, res) => {
  try {
    const { username, password, email, name } = req.body || {};
    if (!username || !password) return res.status(400).json({ ok: false, message: 'Faltan campos' });

    const existing = await findByUsername(username);
    if (existing) return res.status(400).json({ ok: false, message: 'Usuario ya existe' });

    const user = await createUser({ username, password, email, name });
    const token = makeToken({ id: user.id, username: user.username });
    return res.json({ ok: true, token, user: { id: user.id, username: user.username, name: user.name } });
  } catch (err) {
    console.error('register error', err);
    return res.status(500).json({ ok: false, message: 'Error del servidor' });
  }
};

exports.login = async (req, res) => {
  try {
    const { username, password } = req.body || {};
    if (!username || !password) return res.status(400).json({ ok: false, message: 'Faltan credenciales' });

    const user = await findByUsername(username);
    if (!user) return res.status(401).json({ ok: false, message: 'Usuario o contraseña incorrectos' });

    const match = await comparePassword(password, user.password);
    if (!match) return res.status(401).json({ ok: false, message: 'Usuario o contraseña incorrectos' });

    const token = makeToken({ id: user.id, username: user.username });
    return res.json({ ok: true, token, user: { id: user.id, username: user.username, name: user.name } });
  } catch (err) {
    console.error('login error', err);
    return res.status(500).json({ ok: false, message: 'Error del servidor' });
  }
};
