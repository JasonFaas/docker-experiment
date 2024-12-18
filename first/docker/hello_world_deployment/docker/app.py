from flask import Flask
import logging

app = Flask(__name__)

@app.route("/")
def hello_world():
    app.logger.info("Health check endpoint called")
    return "Hello World!", 200

if __name__ == "__main__":
    logging.basicConfig(level=logging.INFO)
    app.run(host="0.0.0.0", port=5000)

