<?php
// Set response headers
header('Content-Type: application/json; charset=utf-8');

// Parse request URI path without query strings
$requestUri = parse_url($_SERVER['REQUEST_URI'], PHP_URL_PATH);
$method = $_SERVER['REQUEST_METHOD'];

// Root route: General environment and system information
if ($requestUri === '/' && $method === 'GET') {
    http_response_code(200);
    echo json_encode([
        'status' => 'online',
        'runtime' => 'PHP ' . PHP_VERSION,
        'message' => 'Serving from OpenShift PHP S2I',
        'pod_name' => gethostname(),
        'namespace' => getenv('POD_NAMESPACE') ?: 'default',
        'version' => getenv('APP_VERSION') ?: '1.0.0'
    ], JSON_UNESCAPED_SLASHES | JSON_PRETTY_PRINT);
    exit;
}

// Liveness probe endpoint
if ($requestUri === '/healthz' && $method === 'GET') {
    http_response_code(200);
    echo json_encode(['status' => 'alive']);
    exit;
}

// Readiness probe endpoint
if ($requestUri === '/readyz' && $method === 'GET') {
    http_response_code(200);
    echo json_encode(['status' => 'ready']);
    exit;
}

// Fallback 404 handler
http_response_code(404);
echo json_encode(['error' => 'Not Found']);
exit;
