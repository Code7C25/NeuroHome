const express = require('express');
const router = express.Router();
const protectedController = require('../controllers/protectedController');
const { verifyToken } = require('../middlewares/authMiddleware');

router.get('/status', verifyToken, protectedController.status);

module.exports = router;