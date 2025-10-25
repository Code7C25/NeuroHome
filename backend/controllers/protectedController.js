exports.status = (req, res) => {
  const user = req.user || null; // poblado por authMiddleware
  res.json({ ok: true, message: 'Ruta protegida OK', user });
};