from flask import Flask, request, jsonify
from waitress import serve
import os


app = Flask(__name__)


@app.route('/')
def greeting():
    return 'Hello from the Python service!'


@app.route('/sort', methods=['POST'])
def sort_data():
    data = request.json['data']
    data.sort()
    return jsonify(data)


if __name__ == '__main__':
    port = int(os.environ.get('PORT', 4000))
    serve(app, host = '0.0.0.0', port = port)
