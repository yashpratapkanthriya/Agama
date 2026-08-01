import http.server
import socketserver
import os
import sys

class COOPHandler(http.server.SimpleHTTPRequestHandler):
    def end_headers(self):
        self.send_header("Cross-Origin-Opener-Policy", "same-origin")
        self.send_header("Cross-Origin-Embedder-Policy", "require-corp")
        super().end_headers()

if __name__ == "__main__":
    port = int(sys.argv[1]) if len(sys.argv) > 1 else 8080
    web_dir = os.path.abspath("apps/flutter_client/build/web")
    os.chdir(web_dir)
    with socketserver.TCPServer(("", port), COOPHandler) as httpd:
        print(f"Serving Flutter Web with COOP/COEP at http://localhost:{port}")
        httpd.serve_forever()
