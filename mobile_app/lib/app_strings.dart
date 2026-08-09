import 'package:flutter/foundation.dart';

// Global language selector: "en", "ur", "pa", "sr"
final ValueNotifier<String> currentLanguage = ValueNotifier<String>("en");

class AppStrings {
  static const Map<String, Map<String, String>> _strings = {
    "appName": {
      "en": "ViaNova AI",
      "ur": "وایا نووا AI",
      "pa": "وایا نووا AI",
      "sr": "وایا نووا AI",
    },
    "tagline": {
      "en": "AI-Powered Road Damage Detection",
      "ur": "مصنوعی ذہانت سے سڑک کے نقصان کی تشخیص",
      "pa": "مصنوعی ذہانت نال سڑک دے نقصان دی پچھان",
      "sr": "مصنوعی ذہانت نال سڑک دے نقصان دی پچھاݨ",
    },
    "welcome": {
      "en": "Welcome back",
      "ur": "خوش آمدید",
      "pa": "جی آیاں نوں",
      "sr": "جی آیاں نوں",
    },
    "totalScans": {
      "en": "Total Scans",
      "ur": "کل اسکین",
      "pa": "کل سکین",
      "sr": "کل سکین",
    },
    "quickActions": {
      "en": "Quick Actions",
      "ur": "فوری اقدامات",
      "pa": "چھیتی کم",
      "sr": "چھیتی کم",
    },
    "cameraDetection": {
      "en": "Camera Detection",
      "ur": "کیمرہ تشخیص",
      "pa": "کیمرہ پچھان",
      "sr": "کیمرہ پچھاݨ",
    },
    "galleryDetection": {
      "en": "Gallery Detection",
      "ur": "گیلری تشخیص",
      "pa": "گیلری پچھان",
      "sr": "گیلری پچھاݨ",
    },
    "detectionHistory": {
      "en": "Detection History",
      "ur": "تشخیص کی تاریخ",
      "pa": "پچھان دی تریخ",
      "sr": "پچھاݨ دی تاریخ",
    },
    "profile": {
      "en": "Profile",
      "ur": "پروفائل",
      "pa": "پروفائل",
      "sr": "پروفائل",
    },
    "uploadImage": {
      "en": "Upload a road image",
      "ur": "سڑک کی تصویر اپلوڈ کریں",
      "pa": "سڑک دی تصویر اپلوڈ کرو",
      "sr": "سڑک دی تصویر اپلوڈ کرو",
    },
    "analyze": {
      "en": "Analyze Road Damage",
      "ur": "سڑک کے نقصان کا تجزیہ کریں",
      "pa": "سڑک دے نقصان دا تجزیہ کرو",
      "sr": "سڑک دے نقصان دا تجزیہ کرو",
    },
    "damageType": {
      "en": "Damage Type",
      "ur": "نقصان کی قسم",
      "pa": "نقصان دی قسم",
      "sr": "نقصان دی قسم",
    },
    "confidence": {
      "en": "Confidence",
      "ur": "اعتماد",
      "pa": "بھروسہ",
      "sr": "بھروسہ",
    },
    "severity": {
      "en": "Severity",
      "ur": "شدت",
      "pa": "شدت",
      "sr": "شدت",
    },
    "healthScore": {
      "en": "Road Health Score",
      "ur": "سڑک کی صحت اسکور",
      "pa": "سڑک دی صحت سکور",
      "sr": "سڑک دی صحت سکور",
    },
    "recommendation": {
      "en": "Recommendation",
      "ur": "تجویز",
      "pa": "تجویز",
      "sr": "تجویز",
    },
    "analyzing": {
      "en": "Analyzing image...",
      "ur": "تصویر کا تجزیہ ہو رہا ہے...",
      "pa": "تصویر دا تجزیہ ہو رہیا اے...",
      "sr": "تصویر دا تجزیہ تھی رہیا اے...",
    },
    "noScansYet": {
      "en": "No scans yet",
      "ur": "ابھی تک کوئی اسکین نہیں",
      "pa": "ہجے تک کوئی سکین نئیں",
      "sr": "ہاڵے تائیں کوئی سکین کائنی",
    },
    "noScansSubtitle": {
      "en": "Your analyzed roads will appear here",
      "ur": "آپ کی تجزیہ شدہ سڑکیں یہاں نظر آئیں گی",
      "pa": "تہاڈیاں تجزیہ شدہ سڑکاں ایتھے نظر آن گیاں",
      "sr": "تہاڏیاں تجزیہ شدہ سڑکاں ایتھے نظر ایسن",
    },
    "clearHistory": {
      "en": "Clear All",
      "ur": "سب صاف کریں",
      "pa": "سب صاف کرو",
      "sr": "سب صاف کرو",
    },
    "clearHistoryConfirm": {
      "en": "Delete all scan history? This cannot be undone.",
      "ur": "کیا تمام اسکین ہسٹری حذف کر دیں؟ یہ واپس نہیں ہو سکتا۔",
      "pa": "کی سکین ہسٹری مٹا دیئے؟ ایہہ واپس نئیں ہو سکدا۔",
      "sr": "کیا سکین ہسٹری مٹا ڈیوو؟ ایہہ واپس کائنی تھی سگدا۔",
    },
    "cancel": {
      "en": "Cancel",
      "ur": "منسوخ کریں",
      "pa": "منسوخ کرو",
      "sr": "منسوخ کرو",
    },
    "delete": {
      "en": "Delete",
      "ur": "حذف کریں",
      "pa": "مٹاؤ",
      "sr": "مٹاؤ",
    },
    "repairPriority": {
      "en": "Repair Priority",
      "ur": "مرمت کی ترجیح",
      "pa": "مرمت دی ترجیح",
      "sr": "مرمت دی ترجیح",
    },
    "profileTitle": {
      "en": "Profile",
      "ur": "پروفائل",
      "pa": "پروفائل",
      "sr": "پروفائل",
    },
    "appVersion": {
      "en": "App Version",
      "ur": "ایپ ورژن",
      "pa": "ایپ ورژن",
      "sr": "ایپ ورژن",
    },
    "language": {
      "en": "Language",
      "ur": "زبان",
      "pa": "زبان",
      "sr": "زبان",
    },
    "highSeverity": {
      "en": "High Severity",
      "ur": "زیادہ شدت",
      "pa": "زیادہ شدت",
      "sr": "زیادہ شدت",
    },
    "about": {
      "en": "About ViaNova AI",
      "ur": "وایا نووا AI کے بارے میں",
      "pa": "وایا نووا AI بارے",
      "sr": "وایا نووا AI بارے",
    },
    "aboutText": {
      "en": "ViaNova AI uses machine learning to detect and classify road surface damage from photos, helping identify maintenance needs faster.",
      "ur": "وایا نووا AI تصاویر سے سڑک کے نقصان کی شناخت اور درجہ بندی کے لیے مشین لرننگ استعمال کرتا ہے، جس سے مرمت کی ضرورت جلد معلوم ہوتی ہے۔",
      "pa": "وایا نووا AI تصویراں توں سڑک دے نقصان دی پچھان تے درجہ بندی لئی مشین لرننگ استعمال کردا اے۔",
      "sr": "وایا نووا AI تصویراں توں سڑک دے نقصان دی سڃاڻ تے درجہ بندی کرݨ خاطر مشین لرننگ ورتدا اے۔",
    },
  };

  static String get(String key) {
    return _strings[key]?[currentLanguage.value] ?? _strings[key]?["en"] ?? key;
  }
}