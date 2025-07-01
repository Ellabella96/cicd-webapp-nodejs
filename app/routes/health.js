const express = require('express');
const router = express.Router();

let startTime = Date.now();

router.get('/', (req, res) => {
  const uptime = Date.now() - startTime;
  const healthCheck = {
    status: 'healthy',
    timestamp: new Date().toISOString(),
    uptime: uptime,
    service: 'cicd-webapp-nodejs',
    version: process.env.npm_package_version || '1.0.0'
  };

  res.status(200).json(healthCheck);
});

router.get('/ready', (req, res) => {
  // Add readiness checks here (database, external services, etc.)
  res.status(200).json({ status: 'ready' });
});

router.get('/live', (req, res) => {
  // Add liveness checks here
  res.status(200).json({ status: 'alive' });
});

module.exports = router;
