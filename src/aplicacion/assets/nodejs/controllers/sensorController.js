const { getSensores } = require('../services/mqttService');

exports.getData = (req, res) => {
  const data = getSensores();
  res.json({
    ok: true,
    data: data
  });
};