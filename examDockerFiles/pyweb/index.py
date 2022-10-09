"""Web Sunucu Sistemi."""
from flask import Flask
app = Flask(__name__)


@app.route("/")
def hello():
    """Web Hello."""
    return "Merhaba Dünya"


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=int("8000"), debug=True)
