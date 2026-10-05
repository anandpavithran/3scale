
#!/usr/bin/env python3	
import json
from http.server import HTTPServer, BaseHTTPRequestHandler

class APIHandler(BaseHTTPRequestHandler):
    def _send_response(self, status, payload):
        self.send_response(status)
        self.send_header("Content-Type", "application/json")
        self.send_header("Access-Control-Allow-Origin", "*")
        self.end_headers()
        self.wfile.write(json.dumps(payload).encode("utf-8"))

    def do_GET(self):
        if self.path == "/" or self.path == "/healthz":
            response = {
                "status": "UP",
                "service": "account-backend",
                "version": "1.0.0"
            }
            self._send_response(200, response)
        elif self.path == "/api/v1/accounts":
            response = {
                "accounts": [
                    {"id": "ACC-1001", "name": "Checking Account", "balance": 1420.50},
                    {"id": "ACC-1002", "name": "Corporate Reserve", "balance": 89400.00}
                ]
            }
            self._send_response(200, response)
        else:
            response = {"error": "Endpoint not found"}
            self._send_response(404, response)

def run(server_class=HTTPServer, handler_class=APIHandler, port=8080):
    server_address = ("", port)
    httpd = server_class(server_address, handler_class)
    print(f"Backend microservice running on port {port}...")
    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        pass
    httpd.server_close()

if __name__ == "__main__":
    run()
