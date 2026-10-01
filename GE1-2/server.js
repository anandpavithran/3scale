const http = require('http');
const os = require('os');

const PORT = process.env.PORT || 8080;
const HOST = '0.0.0.0';

const server = http.createServer((req, res) => {
  const url = req.url;

  // Set default JSON response headers
  res.setHeader('Content-Type', 'application/json');

  if (url === '/' && req.method === 'GET') {
    res.writeHead(200);
    return res.end(JSON.stringify({
      status: 'online',
      runtime: `Node.js ${process.version}`,
      message: 'Serving from OpenShift Node.js S2I',
      pod_name: os.hostname(),
      namespace: process.env.POD_NAMESPACE || 'default',
      version: process.env.npm_package_version || '1.0.0'
    }));
  }

  // Liveness probe endpoint
  if (url === '/healthz' && req.method === 'GET') {
    res.writeHead(200);
    return res.end(JSON.stringify({ status: 'alive' }));
  }

  // Readiness probe endpoint
  if (url === '/readyz' && req.method === 'GET') {
    res.writeHead(200);
    return res.end(JSON.stringify({ status: 'ready' }));
  }

  // 404 handler
  res.writeHead(404);
  res.end(JSON.stringify({ error: 'Not Found' }));
});

// Graceful shutdown handling for container termination signals
const shutdown = (signal) => {
  console.log(`Received ${signal}. Shutting down gracefully...`);
  server.close(() => {
    console.log('HTTP server closed.');
    process.exit(0);
  });

  // Force shutdown if connections do not close in time
  setTimeout(() => {
    console.error('Forcing shutdown.');
    process.exit(1);
  }, 10000).unref();
};

process.on('SIGTERM', () => shutdown('SIGTERM'));
process.on('SIGINT', () => shutdown('SIGINT'));

server.listen(PORT, HOST, () => {
  console.log(`Server listening on http://${HOST}:${PORT}`);
});
