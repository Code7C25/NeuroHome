const { Sequelize } = require('sequelize');

const DB_HOST = process.env.DB_HOST || 'localhost';
const DB_USER = process.env.DB_USER || 'root';
const DB_PASS = process.env.DB_PASS || '';
const DB_NAME = process.env.DB_NAME || 'domotica';
const DB_PORT = process.env.DB_PORT || 3306;

const sequelize = new Sequelize(DB_NAME, DB_USER, DB_PASS, {
  host: DB_HOST,
  port: DB_PORT,
  dialect: 'mysql',
  logging: false,
  define: {
    timestamps: true,
  },
});

async function connect() {
  try {
    await sequelize.authenticate();
    console.log('DB connected (MySQL) ->', `${DB_USER}@${DB_HOST}:${DB_PORT}/${DB_NAME}`);
    await sequelize.sync(); // sincroniza modelos (en prod usar migraciones)
    return sequelize;
  } catch (err) {
    console.error('DB connection error:', err);
    throw err;
  }
}

module.exports = { sequelize, Sequelize, connect };
