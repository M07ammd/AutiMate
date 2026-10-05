# AI Engine API Conversion

The AI behavioral analysis module has been successfully converted into a stateless, API-driven Microservice. It no longer relies on the server's local camera.

## What changed?

### `ai_engine.py`
- Removed all `cv2.VideoCapture` and threading loops.
- Replaced the background processor with a new synchronous method: `process_frame_base64(b64_string)`. 
- This method decodes a Base64 image, passes it to the MediaPipe model, updates internal session states, and returns the real-time emotions and distraction analysis.

### `server.py`
- Added a new `POST /analyze_frame` endpoint.
- Clients can now send JSON payloads with a base64 encoded image string (`{"image": "base64..."}`).
- The server responds instantly with the analysis (e.g., `{"emotion": "Happy", "status": "Focused"}`).

### `test_client.py`
- Created a handy python script for you to test the API locally. When you run it, it captures a single picture from your webcam, sends it to the API as a Base64 string, and prints the result.

## Next Steps for your Project
1. **Node.js Integration**: Your Node.js server can now simply make an HTTP POST request to this Python server's `http://localhost:8000/analyze_frame` whenever it receives a frame from the Flutter app.
2. **Flutter Direct Integration**: Alternatively, to save server resources, your Flutter app can send the Base64 frames directly to this Python server via HTTP POST, and then send the final session JSON report to the Node.js database when the game ends.
