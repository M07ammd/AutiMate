import uuid
import json
import base64
from flask import Blueprint, request, jsonify
from services.chat_service import get_gemini_response, transcribe_audio, text_to_speech, analyze_intent_and_generate_recommendations

chatbot_bp = Blueprint('chatbot', __name__)

@chatbot_bp.route("/api/chat", methods=["POST", "OPTIONS"])
def chat():
    if request.method == "OPTIONS":
        return jsonify({}), 200

    data = request.get_json() or {}
    message = data.get("message", "").strip()
    session_id = data.get("session_id") or str(uuid.uuid4())
    lang = data.get("lang", "en")
    history = data.get("history", [])

    if not message:
        return jsonify({"error": "Empty message"}), 400

    reply = get_gemini_response(message, history, lang)
    return jsonify({"reply": reply, "session_id": session_id})

@chatbot_bp.route("/api/voice", methods=["POST", "OPTIONS"])
def voice():
    if request.method == "OPTIONS":
        return jsonify({}), 200

    audio_file = request.files.get("audio")
    audio_bytes = None

    if audio_file:
        audio_bytes = audio_file.read()
    else:
        data = request.get_json(silent=True) or {}
        audio_b64 = data.get("audio", "")
        if audio_b64:
            audio_bytes = base64.b64decode(audio_b64)

    if not audio_bytes:
        return jsonify({"error": "No audio provided"}), 400

    session_id = request.form.get("session_id") or (request.json.get("session_id") if request.is_json else str(uuid.uuid4()))
    lang = request.form.get("lang", "en")
    history_str = request.form.get("history", "[]")

    try:
        history = json.loads(history_str)
    except:
        history = []

    try:
        transcript = transcribe_audio(audio_bytes, lang)
        reply = get_gemini_response(transcript, history, lang)
        audio_response = text_to_speech(reply, lang)

        return jsonify({
            "transcript": transcript,
            "reply": reply,
            "audio": audio_response,
            "session_id": session_id,
        })
    except Exception as e:
        error_msg = str(e)
        if "insufficient_quota" in error_msg or "rate_limit" in error_msg:
            return jsonify({"error": "Groq quota exceeded."}), 402
        return jsonify({"error": f"Voice processing failed: {error_msg}"}), 500

@chatbot_bp.route("/api/recommend", methods=["POST", "OPTIONS"])
def recommend():
    if request.method == "OPTIONS":
        return jsonify({}), 200
    
    data = request.get_json() or {}
    message = data.get("message", "").strip()
    
    if not message:
        return jsonify({"success": False, "intent": None, "cards": []}), 400
    
    result = analyze_intent_and_generate_recommendations(message)
    status_code = 200 if result.get("success") else 500
    return jsonify(result), status_code

@chatbot_bp.route("/api/reset", methods=["POST"])
def reset():
    return jsonify({"status": "cleared, no memory stored anymore"})
