#!/usr/bin/env python3
"""STL Viewer Server — serves the 3D preview page and STL files."""

import http.server
import os
import sys
import mimetypes

PROJECT_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

class STLViewerHandler(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=PROJECT_ROOT, **kwargs)

    def do_GET(self):
        # Redirect root to the viewer page
        if self.path == '/' or self.path == '/index.html':
            self.path = '/web/index.html'
        return super().do_GET()

    def log_message(self, format, *args):
        # Cleaner log output
        print(f"  {args[0]}", flush=True)

if __name__ == '__main__':
    port = int(sys.argv[1]) if len(sys.argv) > 1 else 8080

    # Ensure mimetypes for STL
    mimetypes.add_type('model/stl', '.stl')
    mimetypes.add_type('application/octet-stream', '.stl')

    server = http.server.HTTPServer(('0.0.0.0', port), STLViewerHandler)
    print(f"""
╔══════════════════════════════════════════════╗
║  🧊 therapy-cable-inline-box-for-physio     ║
║  STL Viewer Server                          ║
╠══════════════════════════════════════════════╣
║  Local:  http://localhost:{port}              ║
╚══════════════════════════════════════════════╝
""")
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        print("\nServer stopped.")
        server.server_close()
