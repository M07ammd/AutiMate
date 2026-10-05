from flask import Blueprint, request, jsonify
from services.survey_service import predict_autism, model

survey_bp = Blueprint('survey', __name__)

@survey_bp.route('/predict', methods=['POST'])
def predict():
    try:
        data = request.json
        if not data:
            return jsonify({"error": "No JSON data provided"}), 400
            
        result = predict_autism(data)
        return jsonify(result)
    except Exception as e:
        return jsonify({"error": str(e)}), 500
