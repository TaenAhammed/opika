import http.server
import socketserver
import signal
import sys

PORT = 3000

class MyHandler(http.server.BaseHTTPRequestHandler):
    def do_GET(self):
        if self.path == '/':
            self.send_response(200)
            self.send_header('Content-type', 'text/html')
            self.end_headers()
            self.wfile.write(b'Hello, World!')
        else:
            self.send_response(404)

def run_server():
    with socketserver.TCPServer(("", PORT), MyHandler) as httpd:
        print("serving at port", PORT)
        httpd.serve_forever()

def stop_server(signal, frame):
    print("Stopping server")
    sys.exit(0)

if __name__ == "__main__":
    signal.signal(signal.SIGINT, stop_server)
    run_server()