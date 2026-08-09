# 🚧 ViaNova-Ai

**ViaNova-Ai** 🚀 Flutter • Python • AI/ML • FastAPI-ready Backend

An End-to-End AI-powered Road Damage Detection System capable of detecting potholes, cracks, and road surface damage using a custom-trained EfficientNetB0 deep learning model.

![Python](https://img.shields.io/badge/PYTHON-3.11+-3776AB?style=for-the-badge&logo=python&logoColor=white&labelColor=333333)
![Flutter](https://img.shields.io/badge/FLUTTER-DART-02569B?style=for-the-badge&logo=flutter&logoColor=white&labelColor=333333)
![AI](https://img.shields.io/badge/AI-DEEP%20LEARNING-FF6F00?style=for-the-badge&labelColor=333333)

---

## 📖 Overview

Road damage inspection is traditionally performed manually, making it slow, expensive, and prone to human error.

This project presents an **AI-powered Road Damage Detection System** that automatically detects and classifies road damage using a deep learning model built on **EfficientNetB0**.

The application provides a modern **Streamlit Dashboard** and a **Flutter Mobile App**, both connected to a **FastAPI Backend**, allowing users to upload road images and instantly receive detection results.

---

## ✨ Features

- 🛣️ Road Damage Detection
- 🕳️ Pothole Detection
- 🧱 Crack Detection (Alligator, Longitudinal, Transverse)
- 📊 Confidence Scores
- 🩺 Road Health Score
- ⚠️ Risk Level Assessment
- 🛠️ Maintenance Recommendations
- 📁 Single & Batch Image Prediction
- 🗣️ Voice Output — the app speaks the detection result aloud (Text-to-Speech) after analyzing the uploaded image
- 🌐 Multi-Language Support — Urdu, English, Saraiki, and Punjabi
- 📍 Location Detection — captures and tags the road location using device GPS (geolocation & geocoding)
- ⚡ FastAPI REST API
- 🎨 Modern Streamlit Dashboard
- 📱 Cross-Platform Mobile App (Flutter)
- 💻 Responsive UI
- ☁️ Ready for Railway Deployment

---

## 🗣️ Voice Output

After the model detects road damage in an uploaded image, the mobile app reads the result out loud using **Text-to-Speech (flutter_tts)** — including the damage type, severity, and recommendation — so users get both a visual and spoken result.

---

## 🌐 Language Support

The mobile app supports **4 languages**, allowing users to interact with the app and receive spoken/text results in their preferred language:

- 🇬🇧 English
- 🇵🇰 Urdu
- Punjabi
- Saraiki

---

## 📍 Location Detection

The app captures the device's current location at the time of detection using **geolocation and geocoding**, allowing each detected road damage entry to be tagged with the location it was found — laying the groundwork for future map-based and GPS-integrated features.

---

## 🎯 Damage Classes

| Class                | Description                                     |
|------------------------|--------------------------------------------------|
| Pothole                | Pothole damage                                  |
| Alligator_Crack          | Alligator (interconnected) cracking             |
| Longitudinal_Crack        | Crack running along the road direction          |
| Transverse_Crack            | Crack running across the road                   |
| Repair_Other                  | Previously repaired surface / other anomalies |

---

## 🏗️ System Architecture

```
Road Image
      │
      ▼
Streamlit Frontend / Flutter Mobile App
      │
      ▼
FastAPI REST API
      │
      ▼
EfficientNetB0 Detection Model
      │
      ▼
Prediction Results
      │
      ▼
Damage Type + Confidence + Severity + Health Score
```

---

## 🛠️ Technology Stack

### Programming Languages
- Python
- Dart
- C++
- HTML / CSS / JavaScript

### Deep Learning
- TensorFlow
- Keras
- EfficientNetB0

### Backend
- FastAPI
- Uvicorn
- Docker

### Frontend (Web)
- Streamlit
- Plotly
- Pandas

### Mobile App
- Flutter
- Dart (core application logic)
- C++ (Windows & Linux desktop runners)
- HTML / CSS / JavaScript (Flutter Web build output)

### Computer Vision
- Image Classification
- Convolutional Neural Networks (CNN)
- Image Preprocessing (Pillow, NumPy)

### Data Processing
- NumPy
- Pandas

---

## 📂 Project Structure

```
ViaNova-Ai
│
├── backend/
│   ├── app/
│   │   ├── main.py
│   │   ├── model_loader.py
│   │   ├── predict.py
│   │   └── schemas.py
│   ├── models/
│   │   └── roadguardian_model.keras
│   ├── requirements.txt
│   └── Dockerfile
│
├── frontend/
│   ├── app.py
│   └── requirements.txt
│
├── mobile_app/
│   ├── lib/                  # Dart source code
│   ├── android/               # Android platform config
│   ├── ios/                   # iOS platform config
│   ├── windows/                # Windows platform config (C++)
│   ├── macos/                  # macOS platform config
│   ├── linux/                  # Linux platform config (C++)
│   ├── web/                    # Web platform config (HTML/CSS/JS)
│   └── test/                   # Tests
│
├── notebooks/
│
├── docs/
│
├── README.md
└── .gitignore
```

---

## 🚀 Installation

### Clone Repository
```
git clone https://github.com/YOUR_USERNAME/ViaNova-Ai.git

cd ViaNova-Ai
```

### Backend
```
cd backend

pip install -r requirements.txt

uvicorn app.main:app --reload
```

**Backend URL**
```
http://127.0.0.1:8000
```

**Swagger API**
```
http://127.0.0.1:8000/docs
```

### Frontend
```
cd frontend

pip install -r requirements.txt

streamlit run app.py
```

**Frontend URL**
```
http://localhost:8501
```

### Mobile App (Flutter)
```
cd mobile_app

flutter pub get

flutter run
```

**Android Build Requirement:** JDK 17 is required for Gradle builds.
Set it in `mobile_app/android/gradle.properties`:
```
org.gradle.java.home=<path-to-jdk-17>
```

---

## API Endpoints

**Home**
```
GET /
```

**Health Check**
```
GET /health
```

**Prediction**
```
POST /predict
```

**Batch Prediction**
```
POST /predict-batch
```

**Returns**
- Damage Type
- Confidence Score
- Severity Level
- Road Health Score
- Risk Level
- Recommendation

---

## 🌍 Deployment

**Backend**
Railway

**Frontend**
Streamlit Community Cloud

**Mobile App**
Google Play / App Store

---

## 🔮 Future Improvements

- Video Damage Detection
- Live Camera Detection
- PDF Report Generation
- User Authentication
- Cloud Storage
- Damage Severity Analysis
- Interactive Maps
- Real-Time Monitoring
- Additional Regional Language Support

---

## 👩‍💻 Developer

**Fadia Iftikhar**

Bachelor of Artificial Intelligence

The Islamia University of Bahawalpur

Machine Learning Engineer Apprentice

---

## ⭐ Show Your Support

If you like this project, please give it a ⭐ on GitHub.

It motivates future development and helps others discover the project.

---

## 📜 License

This project is licensed under the MIT License.

---

🚀 **AI for Safer Roads**

Made with ❤️ using Python, TensorFlow, FastAPI, Streamlit & Flutter
