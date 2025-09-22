const db = require('../config/db');

const User = {
  create: (nombre, email, password_hash, callback) => {
    const sql = 'INSERT INTO users (nombre, email, password_hash) VALUES (?, ?, ?)';
    db.query(sql, [nombre, email, password_hash], callback);
  },

  findByEmail: (email, callback) => {
    const sql = 'SELECT * FROM users WHERE email = ?';
    db.query(sql, [email], callback);
  }
};

module.exports = User;
