from flask import Flask
from waitress import serve
import os

app = Flask(__name__)

@app.route('/')
def hello_world():
    return 'Hello, World!'

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 3000))
    serve(app, host = '0.0.0.0', port = port)