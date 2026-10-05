from flask import Flask, jsonify
from flask_cors import CORS

from blueprints.survey_bp import survey_bp
from blueprints.chatbot_bp import chatbot_bp

app = Flask(__name__, static_folder="static")
CORS(app)

# Register Blueprints
app.register_blueprint(survey_bp)
app.register_blueprint(chatbot_bp)

@app.route('/')
def home():
    return jsonify({"status": "ok", "service": "Autimate Modular AI API"})

@app.route('/health', methods=['GET'])
@app.route('/api/health', methods=['GET'])
def health():
    return jsonify({"status": "ok", "service": "Autimate Modular AI API"})

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
