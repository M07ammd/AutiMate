import os
import re
import json
import base64
import struct
import google.generativeai as genai
from groq import Groq

GEMINI_API_KEY = os.getenv("GEMINI_API_KEY", "")
GROQ_API_KEY = os.getenv("GROQ_API_KEY", "")

genai.configure(api_key=GEMINI_API_KEY)
groq_client = Groq(api_key=GROQ_API_KEY)

SYSTEM_PROMPT = """
You are Autimate, a compassionate and specialized AI assistant designed specifically 
to support individuals with Autism Spectrum Disorder (ASD), their caregivers, 
and family members.

Your core guidelines:
- Use SIMPLE, CLEAR, and SHORT sentences. Avoid complex language.
- Be PATIENT, CALM, and POSITIVE in every response.
- Avoid sarcasm, idioms, or figurative language that may confuse autistic individuals.
- If the user seems distressed, respond with empathy and reassurance first.
- Focus on practical, concrete advice when asked about autism-related topics.
- Topics you specialize in: daily routines, sensory sensitivities, social communication,
  behavioral strategies, caregiver support, emotional regulation, and ASD education.
- Always encourage and validate the user's feelings.
- Keep responses concise — ideally 2 to 4 short sentences unless more detail is needed.

CRITICAL INSTRUCTION FOR LANGUAGE:
- You MUST reply in the exact same language as the user's message.
- If the user writes or speaks in Arabic, you MUST reply entirely in Arabic.
- If the user writes or speaks in English, you MUST reply entirely in English.
- Do not mix languages unless explicitly asked.
"""

def detect_language(text: str) -> str:
    if re.search("[\u0600-\u06FF]", text):
        return "ar"
    return "en"

def get_gemini_response(user_message: str, history: list, lang: str = "en") -> str:
    try:
        model = genai.GenerativeModel(model_name="gemini-2.5-flash", system_instruction=SYSTEM_PROMPT)
        clean_history = []
        expected_role = "user"
        for msg in history:
            if msg.get("role") == expected_role:
                clean_history.append(msg)
                expected_role = "model" if expected_role == "user" else "user"
                
        if clean_history and clean_history[-1].get("role") == "user":
            clean_history.pop()

        chat = model.start_chat(history=clean_history)
        response = chat.send_message(user_message)
        return response.text
    except Exception as e:
        print(f"Gemini Error: {str(e)}")
        if lang == "ar":
            return "عذراً، أواجه مشكلة تقنية حالياً في معالجة طلبك. هل يمكنك المحاولة مرة أخرى لاحقاً؟"
        return "Sorry, I am facing a technical issue right now. Can you try again later?"

def transcribe_audio(audio_bytes: bytes, lang="en") -> str:
    try:
        if not audio_bytes or len(audio_bytes) < 100:
            return "عذراً، لم أتمكن من سماع شيء. يرجى التحدث مرة أخرى."

        transcription = groq_client.audio.transcriptions.create(
            file=("audio.m4a", audio_bytes),
            model="whisper-large-v3",
            prompt="يرجى كتابة النص المسموع بدقة. إذا كان الصوت صامتاً أو مجرد ضجيج، لا تكتب أي شيء.",
            temperature=0,
            response_format="verbose_json"
        )
        
        if isinstance(transcription, dict):
            text = transcription.get("text", "").strip()
            segments = transcription.get("segments", [])
        else:
            text = getattr(transcription, "text", "").strip()
            segments = getattr(transcription, "segments", [])
        
        is_silent = False
        if segments:
            probs = [s.get("no_speech_prob", 0) if isinstance(s, dict) else getattr(s, "no_speech_prob", 0) for s in segments]
            if probs and (sum(probs) / len(probs)) > 0.6:
                is_silent = True

        clean_text = re.sub(r'[^\w\s]', '', text.lower()).strip()
        known_hallucinations = {
            "nancy qanqour", "نانسي قنقر", "amaraorg", "thanks for watching",
            "thank you for watching", "شكرا على المشاهدة", "اشترك في القناة", "شكرا"
        }
        
        if is_silent or not text or clean_text in known_hallucinations:
            return "عذراً، الصوت غير واضح أو يحتوي على ضجيج. هل يمكنك التحدث بوضوح وتكرار ما قلته؟"
            
        return text
    except Exception as e:
        error_msg = str(e).lower()
        if "too short" in error_msg or "minimum audio length" in error_msg:
            return "عذراً، الرسالة الصوتية قصيرة جداً أو تالفة. هل يمكنك تكرارها؟"
        raise Exception(f"Groq Error: {str(e)}")

def text_to_speech(text: str, lang: str = "en") -> str:
    try:
        detected_lang = detect_language(text)
        if detected_lang == "ar":
            model_name = "canopylabs/orpheus-arabic-saudi"
            voice = "abdullah"
        else:
            model_name = "canopylabs/orpheus-v1-english"
            voice = "hannah"

        response = groq_client.audio.speech.create(
            model=model_name,
            voice=voice,
            response_format="wav",
            input=text,
        )

        audio_data = bytearray(response.read())

        if len(audio_data) >= 44 and audio_data[0:4] == b"RIFF":
            audio_data[4:8] = struct.pack('<I', len(audio_data) - 8)
            offset = 12
            while offset < len(audio_data) - 8:
                chunk_id = audio_data[offset:offset+4]
                chunk_size = struct.unpack('<I', audio_data[offset+4:offset+8])[0]
                if chunk_id == b'data':
                    if chunk_size == 0xFFFFFFFF:
                        data_chunk_size = len(audio_data) - offset - 8
                        audio_data[offset+4:offset+8] = struct.pack('<I', data_chunk_size)
                    break
                if chunk_size == 0xFFFFFFFF:
                    break
                offset += 8 + chunk_size

        return base64.b64encode(audio_data).decode("utf-8")
    except Exception as e:
        raise Exception(f"Text-to-speech error: {str(e)}")


