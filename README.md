# 🚀 ViaNova-Ai

**AI-Powered Multi-Platform Application**
📱 Flutter • 🐍 Python • 🧠 AI/ML • 🌐 Web

An end-to-end AI-powered application combining a Python backend, a web frontend, and a cross-platform Flutter mobile app.

---

## 📖 Overview

ViaNova-Ai is a multi-part project that brings together a machine learning-powered backend, a web interface, and a native mobile experience built with Flutter — designed to work seamlessly across Android, iOS, Windows, macOS, Linux, and Web.

---

## ✨ Features

- 📍 Location-based services (geolocation & geocoding)
- 🖼️ Image upload & media picking
- 🗣️ Text-to-speech support
- 🔗 URL launching & content sharing
- 💾 Local data persistence
- 🧠 AI/ML-powered backend (sentiment analysis & related models)
- 📱 Cross-platform mobile app (Android, iOS, Windows, macOS, Linux, Web)

---

## 🏗️ System Architecture

```
User (Mobile / Web)
        │
        ▼
  Flutter Frontend (mobile_app)
        │
        ▼
   Python Backend (backend)
        │
        ▼
   AI/ML Models (notebooks)
        │
        ▼
     Results / Response
```

---

## 🛠️ Technology Stack

| Layer              | Technology                              |
|---------------------|------------------------------------------|
| Mobile App          | Flutter (Dart)                          |
| Backend             | Python                                  |
| ML/AI Experiments   | Jupyter Notebooks (RNN / LSTM / GRU)    |
| Build System        | Gradle (Android), Xcode (iOS)           |
| Local Storage       | shared_preferences                      |
| Location Services   | geolocator, geocoding                   |
| Media Handling      | image_picker, path_provider             |
| Other               | flutter_tts, url_launcher, share_plus   |

---

## 📂 Project Structure

```
ViaNova-Ai/
│
├── backend/                 # Python backend (APIs, ML/AI logic)
│
├── frontend/                 # Web frontend
│
├── mobile_app/                # Flutter mobile application (vianova_app)
│   ├── lib/                    # Dart source code
│   ├── android/                 # Android platform config
│   ├── ios/                     # iOS platform config
│   ├── windows/                 # Windows platform config
│   ├── macos/                   # macOS platform config
│   ├── linux/                   # Linux platform config
│   ├── web/                     # Web platform config
│   └── test/                    # Tests
│
├── notebooks/                # Jupyter notebooks (ML/data experiments)
│
├── docs/                      # Project documentation
│
├── README.md
└── .gitignore
```

---

## 🚀 Installation

### Clone Repository
```bash
git clone https://github.com/YOUR_USERNAME/ViaNova-Ai.git
cd ViaNova-Ai
```

### Backend
```bash
cd backend
pip install -r requirements.txt
python main.py
```

### Mobile App (Flutter)
```bash
cd mobile_app
flutter pub get
flutter run
```

**Android Build Requirement:** JDK 17 is required for Gradle builds. Set it in `mobile_app/android/gradle.properties`:
```
org.gradle.java.home=<path-to-jdk-17>
```

### Frontend (Web)
```bash
cd frontend
# add install/run commands specific to your frontend framework
```

---

## 📷 Application Screenshots

*(Add screenshots here)*

---

## 🌍 Deployment

| Component | Platform |
|-----------|----------|
| Backend   | *(e.g. Railway / Render / AWS)* |
| Mobile App | Google Play / App Store |
| Frontend  | *(e.g. Vercel / Netlify)* |

---

## 🔮 Future Improvements

- Real-time detection/analysis
- Push notifications
- Cloud storage integration
- Offline mode support
- User authentication
- Multi-language support

---

## 👩‍💻 Developer

*(Add your name, degree, and institution here)*

---

## ⭐ Show Your Support

If you like this project, please give it a ⭐ on GitHub — it motivates future development.

---

## 📜 License

This project is licensed under the MIT License.

---

**Made with ❤️ using Python & Flutter**
