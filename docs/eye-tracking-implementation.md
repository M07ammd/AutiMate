# Goal Description

Convert the `ai_engine.py` and `server.py` from a local-webcam dependent system into a stateless/API-driven Microservice. This will allow the Node.js backend (or Flutter app) to send image frames over the network to the Python AI engine for analysis, making it suitable for cloud deployment.

## User Review Required

> [!WARNING]
> By removing the local camera capture (`cv2.VideoCapture`), you will no longer be able to test the AI model simply by running the python script and looking into your computer's webcam. 
> To test it, you will need a client (like your Flutter app or a simple Node.js script) to capture your webcam and send the frames as Base64 encoded strings to the `/analyze_frame` API.
> Does this work for you?

## Proposed Changes

### AI Microservice Component

#### [MODIFY] [ai_engine.py](file:///c:/Users/reems/Desktop/mohamed%20model%20-%20Copy/ai_engine.py)
- **Remove local camera**: Remove `cv2.VideoCapture(0)` and the background thread `_process_loop`.
- **Add `process_frame_base64(b64_string)`**: A new method that accepts a Base64 encoded image string, decodes it into a `cv2` image, and runs the MediaPipe face landmarker.
- **Update State Management**: Instead of checking elapsed time in a `while` loop, the frame processing logic will execute exactly when a frame is received. Calibration logic will count the number of received frames instead of pure seconds (e.g., assuming 1 frame/sec or relying on timestamps passed by the client).
- **Return Instant Results**: The method will return the parsed emotions and distraction status directly to the caller.

#### [MODIFY] [server.py](file:///c:/Users/reems/Desktop/mohamed%20model%20-%20Copy/server.py)
- **Add Pydantic Model**: Create a `FrameRequest` model to accept `{"image": "base64_string..."}`.
- **Add Endpoint `POST /analyze_frame`**: This endpoint will receive the image from the Node.js server (or Flutter), pass it to `tracker.process_frame_base64()`, and return the current emotion and distraction status as JSON.
- **Cleanup**: Remove `tracker.stop()` from the shutdown event since there's no background thread to stop anymore.

## Verification Plan

### Automated Tests
- I will create a small temporary Python client script (`test_client.py`) that reads a local image file, encodes it to Base64, and sends it to the `/analyze_frame` endpoint to verify the API correctly decodes and analyzes the image.

### Manual Verification
- You will be able to run `python server.py`, and the server will start successfully without attempting to open the physical camera.
- You can integrate this with your Node.js or Flutter app by sending HTTP POST requests with base64 images to `http://<server-ip>:8000/analyze_frame`.
