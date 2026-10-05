import json
from http.server import HTTPServer, BaseHTTPRequestHandler


class APIHandler(BaseHTTPRequestHandler):

    def _send_response(self, status_code, payload):
        body = json.dumps(payload).encode("utf-8")
        self.send_response(status_code)
        self.send_header("Content-Type", "application/json")
        self.send_header("Content-Length", str(len(body)))
        self.send_header("Access-Control-Allow-Origin", "*")
        self.end_headers()
        self.wfile.write(body)

    def do_GET(self):
        clean_path = self.path.split("?")[0]

        if clean_path in ("/", "/healthz"):
            response = {
                "status": "UP",
                "service": "account-backend",
                "version": "1.0.0"
            }
            self._send_response(200, response)

        elif clean_path == "/api/v1/accounts":
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
    server_address = ("0.0.0.0", port)
    httpd = server_class(server_address, handler_class)
    print(f"Backend microservice running on port {port}...")
    try:
        httpd.serve_forever()
    except KeyboardInterrupt:
        pass
    finally:
        httpd.server_close()


if __name__ == "__main__":
    run()
