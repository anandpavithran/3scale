import json
import os
from http.server import BaseHTTPRequestHandler, HTTPServer

PORT = int(os.environ.get("PORT", 8080))

class LabRequestHandler(BaseHTTPRequestHandler):
    def _send_headers(self, status=200):
        self.send_response(status)
        self.send_header("Content-Type", "application/json")
        self.send_header("X-Lab-Service", "Python-Backend-v1")
        self.end_headers()

    def do_GET(self):
        if self.path == "/" or self.path == "/info":
            payload = {
                "status": "UP",
                "service": "api-backend",
                "version": "1.0.0",
                "message": "Welcome to Cloud-Native API Administration Lab",
                "runtime": "Python 3.14 Universal Base Image"
            }
            self._send_headers(200)
            self.wfile.write(json.dumps(payload, indent=2).encode("utf-8"))
        elif self.path == "/health":
            payload = {"health": "healthy"}
            self._send_headers(200)
            self.wfile.write(json.dumps(payload).encode("utf-8"))
        else:
            payload = {"error": "Not Found", "requested_path": self.path}
            self._send_headers(404)
            self.wfile.write(json.dumps(payload).encode("utf-8"))

    def log_message(self, format, *args):
        # Structured stdout logging for OpenShift pod logs
        print(f"[API-LOG] {self.address_string()} - {format % args}")

def run():
    server_address = ("0.0.0.0", PORT)
    httpd = HTTPServer(server_address, LabRequestHandler)
    print(f"Starting API Backend service on port {PORT}...")
    httpd.serve_forever()

if __name__ == "__main__":
    run()
