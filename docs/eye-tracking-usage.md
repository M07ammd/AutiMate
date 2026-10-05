# AI Behavioral Analysis Project - Usage Guide

This project consists of an AI engine that tracks facial emotions and attention/distraction levels using MediaPipe. It includes a visual testing script (`main.py`) and a backend API (`server.py`) for integration with Flutter.

## 1. Prerequisites

- **Python 3.10 or higher** must be installed.
- **Webcam**: A functional webcam is required for the AI tracking to work.

## 2. Initial Setup

1. Open a terminal in the project folder: `c:\Users\reems\Desktop\mohamed model`.
2. Activate the virtual environment (I have already created it for you):
   ```powershell
   .\venv\Scripts\activate
   ```
3. Install the required libraries:
   ```powershell
   pip install -r requirements.txt
   ```

## 3. How to Run the Project

### Option A: Visual Testing Mode (Recommended for testing)
This mode opens a camera window and shows real-time tracking data on your screen.

1. Run the command:
   ```powershell
   python main.py
   ```
2. **Calibration (Crucial):**
   - Look directly at the screen with a neutral expression and press **`n`**. This calibrates your "Natural" state and sets the center for distraction detection.
   - For better emotion accuracy, calibrate other emotions:
     - Press **`h`** and smile for 5 seconds (Happy).
     - Press **`s`** and look sad for 5 seconds (Sad).
     - Press **`a`** and look angry for 5 seconds (Angry).
3. **Usage:**
   - **Start Session**: Press **`Enter`** to start recording a session. A "SESSION ACTIVE" indicator and a timer will appear.
   - **End Session**: Press **`Space`** to end the session.
   - **Report**: When a session ends, a detailed report will be printed to your terminal, including:
     - **Session Duration** (in seconds).
     - **Start & End Time** (timestamps).
     - **Total Frame Count** (samples).
     - **Distraction Percentage**.
     - **Emotion Distribution** (percentage of time spent in each emotion).
   - Press **`q`** to exit.

### Option B: Backend API Mode (For Flutter Integration)
This mode runs the AI engine in the background and provides an API for other apps.

1. Run the command:
   ```powershell
   python server.py
   ```
2. The server will start at `http://localhost:8000`.
3. You can check the state by visiting `http://localhost:8000/state` in your browser.

## 4. Flutter Integration

If you are using this with the Flutter app:
1. Ensure the server is running (Option B).
2. Copy `ai_service.dart` to your Flutter project's `lib/services/` folder.
3. Copy `parents_dashboard.dart` to your Flutter project's `lib/screens/` folder.
4. Follow the detailed steps in `walkthrough.md` for adding dependencies to `pubspec.yaml`.
