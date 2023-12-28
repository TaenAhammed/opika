import unittest
import http.client
import subprocess
import time
import signal
from app import PORT

class TestMyHandler(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.server_process = subprocess.Popen(['python3', 'app.py'])
        time.sleep(1)  # give the server a second to start up

    @classmethod
    def tearDownClass(cls):
        cls.server_process.send_signal(signal.SIGINT)
        cls.server_process.wait()

    def test_get_root(self):
        conn = http.client.HTTPConnection('localhost', PORT)
        conn.request('GET', '/')
        response = conn.getresponse()
        self.assertEqual(response.status, 200)
        self.assertEqual(response.read(), b'Hello, World!')

if __name__ == '__main__':
    unittest.main()