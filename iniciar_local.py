#!/usr/bin/env python3
"""Servidor de loopback simples para executar o Nexora ERP sem abrir HTML como texto."""
from http.server import ThreadingHTTPServer, SimpleHTTPRequestHandler
from pathlib import Path
import threading, webbrowser

ROOT = Path(__file__).resolve().parent

class NexoraHandler(SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=str(ROOT), **kwargs)
    def log_message(self, fmt, *args):
        print('[Nexora] ' + (fmt % args))
    def list_directory(self, path):
        self.send_error(403, 'Listagem de diretório desativada.')
        return None
    def do_GET(self):
        if self.path in ('/', '/?'):
            self.send_response(302)
            self.send_header('Location', '/index.html')
            self.end_headers()
            return
        super().do_GET()
    def end_headers(self):
        self.send_header('X-Content-Type-Options', 'nosniff')
        self.send_header('Cache-Control', 'no-store, max-age=0')
        super().end_headers()

if __name__ == '__main__':
    server = ThreadingHTTPServer(('127.0.0.1', 0), NexoraHandler)
    host, port = server.server_address
    url = f'http://{host}:{port}/index.html'
    print('=' * 58)
    print(' NEXORA ERP 1.3.3 - SERVIDOR LOCAL')
    print('=' * 58)
    print(f'Abra no navegador: {url}')
    print('Mantenha esta janela aberta durante o uso. Ctrl+C encerra.')
    threading.Timer(0.7, lambda: webbrowser.open(url)).start()
    try:
        server.serve_forever(poll_interval=0.5)
    except KeyboardInterrupt:
        print('\nEncerrando o Nexora ERP...')
    finally:
        server.server_close()
