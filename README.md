# 🚧 ViaNova-Ai

**ViaNova-Ai**
🚀 Flutter • Python • AI/ML • FastAPI-ready Backend

An End-to-End AI-powered application combining a Python backend, a web frontend, and a cross-platform Flutter mobile app.

![Python](https://img.shields.io/badge/PYTHON-3.11+-3776AB?style=for-the-badge&logo=python&logoColor=white)
![Flutter](https://img.shields.io/badge/FLUTTER-Dart-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![AI](https://img.shields.io/badge/AI-Deep%20Learning-FF6F00?style=for-the-badge)

---

## 📖 Overview

Manual, disconnected workflows for mobile, web, and AI-driven backend systems are often slow to build and hard to maintain.

**ViaNova-Ai** brings these together into a single, end-to-end system — a Python-powered backend for AI/ML logic, a web frontend, and a cross-platform Flutter mobile application, all working seamlessly together.

The application provides a modern **Flutter mobile experience** connected to a **Python backend**, allowing users to interact with AI-powered features directly from their device.

---

## ✨ Features

- 📍 Location Detection (Geolocation & Geocoding)
- 🖼️ Image Upload & Media Picker
- 🗣️ Text-to-Speech Support
- 🔗 URL Launching
- 📤 Content Sharing
- 💾 Local Data Persistence
- 🧠 AI/ML-Powered Backend
- 📱 Cross-Platform App (Android, iOS, Windows, macOS, Linux, Web)
- ⚡ Fast, Responsive UI
- ☁️ Ready for Cloud Deployment

---

## 🏗️ System Architecture

```
User Input
      │
      ▼
Flutter Mobile App (mobile_app)
      │
      ▼
Python Backend API (backend)
      │
      ▼
AI / ML Models
      │
      ▼
Processed Results
      │
      ▼
Response to App
```

---

## 🛠️ Technology Stack

### Programming Languages
- Python
- Dart

### Mobile Framework
- Flutter

### AI / Machine Learning
- Deep Learning models (RNN / LSTM / GRU)
- Jupyter Notebooks for experimentation

### Backend
- Python

### Location & Media
- geolocator
- geocoding
- image_picker
- path_provider

### Utilities
- flutter_tts
- url_launcher
- share_plus
- shared_preferences

---

## 📂 Project Structure

```
ViaNova-Ai
│
├── backend/
│   ├── main.py
│   ├── requirements.txt
│   └── utils/
│
├── frontend/
│   ├── app files
│   └── requirements.txt
│
├── mobile_app/
│   ├── lib/                  # Dart source code
│   ├── android/               # Android platform config
│   ├── ios/                   # iOS platform config
│   ├── windows/                # Windows platform config
│   ├── macos/                  # macOS platform config
│   ├── linux/                  # Linux platform config
│   ├── web/                    # Web platform config
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

python main.py
```

**Backend URL**
```
http://127.0.0.1:8000
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

### Frontend (Web)
```
cd frontend

pip install -r requirements.txt

# run command depends on your frontend framework
```

---

## 📷 Application Screenshots

**Home Screen**
*Add Home Screenshot*

**Feature Screen**
*Add Feature Screenshot*

**Results Screen**
*Add Results Screenshot*

---

## 🌍 Deployment

**Backend**
Railway

**Mobile App**
Google Play / App Store

**Frontend**
Streamlit Community Cloud / Vercel

---

## 🔮 Future Improvements

- Real-Time Detection
- Push Notifications
- GPS Integration
- PDF Report Generation
- User Authentication
- Cloud Storage
- Offline Mode
- Multi-language Support
- Interactive Maps
- Real-Time Monitoring

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

🚀 **ViaNova-Ai — Building Smarter, Connected Experiences**

Made with ❤️ using Python & Flutter
