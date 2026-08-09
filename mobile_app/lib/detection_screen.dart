import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http_parser/http_parser.dart';
import 'app_strings.dart';
import 'app_colors.dart';
import 'scan_model.dart';
import 'scan_storage.dart';
import 'report_screen.dart';

const String API_URL = "https://vianova-ai-production-69f1.up.railway.app";

class DetectionScreen extends StatefulWidget {
  final ImageSource source;
  const DetectionScreen({super.key, required this.source});

  @override
  State<DetectionScreen> createState() => _DetectionScreenState();
}

class _DetectionScreenState extends State<DetectionScreen> {
  Uint8List? imageBytes;
  bool loading = false;
  Map<String, dynamic>? result;
  String? error;
  final FlutterTts _tts = FlutterTts();
  bool speaking = false;

  // Maps our app language codes to TTS voice locales.
  // Siraiki ("sr") has no dedicated TTS voice on most devices, so it falls
  // back to the closest available voice (Urdu).
  String _ttsLocaleFor(String langCode) {
    switch (langCode) {
      case "ur":
        return "ur-PK";
      case "pa":
        return "pa-IN";
      case "sr":
        return "ur-PK";
      default:
        return "en-US";
    }
  }

  String _severityLabel(String sev, String lang) {
    const map = {
      "High": {"en": "High", "ur": "زیادہ", "pa": "زیادہ", "sr": "زیادہ"},
      "Medium": {"en": "Medium", "ur": "درمیانی", "pa": "درمیانی", "sr": "درمیانی"},
      "Low": {"en": "Low", "ur": "کم", "pa": "گھٹ", "sr": "گھٹ"},
    };
    return map[sev]?[lang] ?? sev;
  }

  String _damageTypeLabel(String type, String lang) {
    const map = {
      "Alligator_Crack": {"en": "Alligator crack", "ur": "مگرمچھ نما دراڑ", "pa": "مگرمچھ ورگی تریڑ", "sr": "مگرمچھ ورگی تریڑ"},
      "Longitudinal_Crack": {"en": "Longitudinal crack", "ur": "طولانی دراڑ", "pa": "لمبائی والی تریڑ", "sr": "لمبائی والی تریڑ"},
      "Pothole": {"en": "Pothole", "ur": "گڑھا", "pa": "کھڈا", "sr": "کھڈا"},
      "Repair_Other": {"en": "Previous repair patch", "ur": "پرانی مرمت کا نشان", "pa": "پہلاں دی مرمت دا نشان", "sr": "پہلاں دی مرمت دا نشان"},
      "Transverse_Crack": {"en": "Transverse crack", "ur": "عرضی دراڑ", "pa": "آڑی تریڑ", "sr": "آڑی تریڑ"},
    };
    return map[type]?[lang] ?? type.replaceAll('_', ' ');
  }

  String _recommendationLabel(String rec, String lang) {
    const map = {
      "Monitor the road periodically.": {
        "en": "Monitor the road periodically.",
        "ur": "سڑک کی وقتاً فوقتاً نگرانی کریں۔",
        "pa": "سڑک دی وقتاً فوقتاً نگرانی کرو۔",
        "sr": "سڑک دی وقتاً فوقتاً نگرانی کرو۔",
      },
      "Schedule maintenance soon.": {
        "en": "Schedule maintenance soon.",
        "ur": "جلد مرمت کا بندوبست کریں۔",
        "pa": "چھیتی مرمت دا بندوبست کرو۔",
        "sr": "چھیتی مرمت دا بندوبست کرو۔",
      },
      "Immediate repair required.": {
        "en": "Immediate repair required.",
        "ur": "فوری مرمت درکار ہے۔",
        "pa": "فوری مرمت لوڑیندی اے۔",
        "sr": "فوری مرمت لوڑیندی اے۔",
      },
    };
    return map[rec]?[lang] ?? rec;
  }

  String _consequenceLabel(String severity, String lang) {
    // Extra explanatory sentence about real-world risk, shown based on severity.
    const map = {
      "High": {
        "en": "This damage is severe. If vehicles like cars or trucks keep passing over it, it will widen and deepen quickly, and could cause tyre damage or accidents.",
        "ur": "یہ نقصان شدید ہے۔ اگر گاڑیاں اور ٹرک اسی طرح اس پر سے گزرتے رہے تو یہ جلد اور گہرا اور چوڑا ہو جائے گا، اور ٹائر خراب ہونے یا حادثے کا خطرہ بھی ہے۔",
        "pa": "ایہہ نقصان شدید اے۔ جے گڈیاں تے ٹرک ایویں ای ایس اُتوں لنگدے رہے تاں ایہہ چھیتی ہور ڈونگھا تے چوڑا ہو ویسی، تے ٹائر خراب ہون یا حادثے دا خطرہ وی اے۔",
        "sr": "ایہہ نقصان شدید اے۔ جے گڈیاں تے ٹرک ایویں ای ایس اُتوں لنگدے رہے تاں ایہہ چھیتی ہور ڈونگھا تے چوڑا ہو ویسی، تے ٹائر خراب ہون یا حادثے دا خطرہ وی اے۔",
      },
      "Medium": {
        "en": "This is a moderate level of damage. If left unattended and vehicles keep driving over it, it can get worse over time and eventually turn into a bigger pothole or crack.",
        "ur": "یہ درمیانے درجے کا نقصان ہے۔ اگر اسے نظر انداز کیا گیا اور گاڑیاں اسی طرح گزرتی رہیں تو وقت کے ساتھ یہ اور بڑھ سکتا ہے اور بڑا گڑھا یا دراڑ بن سکتا ہے۔",
        "pa": "ایہہ درمیانے درجے دا نقصان اے۔ جے نظر انداز کیتا گیا تے گڈیاں ایویں لنگدیاں رہیاں تاں ایہہ ہور ودھ سکدا اے تے وڈا کھڈا یا تریڑ بن سکدا اے۔",
        "sr": "ایہہ درمیانے درجے دا نقصان اے۔ جے نظر انداز کیتا گیا تے گڈیاں ایویں لنگدیاں رہیاں تاں ایہہ ہور ودھ سکدا اے تے وڈا کھڈا یا تریڑ بن سکدا اے۔",
      },
      "Low": {
        "en": "This damage is currently minor and not urgent, but it should still be monitored so it doesn't worsen with regular traffic over time.",
        "ur": "یہ نقصان فی الحال معمولی ہے اور فوری خطرہ نہیں، لیکن اس پر نظر رکھنی چاہیے تاکہ روزانہ کی آمد و رفت سے یہ وقت کے ساتھ نہ بڑھے۔",
        "pa": "ایہہ نقصان ہاڵے معمولی اے تے فوری خطرہ کائنی، پر ایس تے نظر رکھو تاں جو روز دی آمد و رفت نال ایہہ نہ ودھے۔",
        "sr": "ایہہ نقصان ہاڵے معمولی اے تے فوری خطرہ کائنی، پر ایس تے نظر رکھو تاں جو روز دی آمد و رفت نال ایہہ نہ ودھے۔",
      },
    };
    return map[severity]?[lang] ?? "";
  }

  Future<void> _speakResult() async {
    if (result == null) return;
    final lang = currentLanguage.value;
    await _tts.stop();
    await _tts.setLanguage(_ttsLocaleFor(lang));
    await _tts.setPitch(1.0);
    await _tts.setSpeechRate(0.62);

    final damageType = _damageTypeLabel("${result!['damage_type']}", lang);
    final confidence = "${result!['confidence']}";
    final severityRaw = "${result!['severity']}";
    final severity = _severityLabel(severityRaw, lang);
    final healthScore = "${result!['road_health_score']}";
    final recommendation = _recommendationLabel("${result!['recommendation']}", lang);
    final consequence = _consequenceLabel(severityRaw, lang);

    String sentence;
    switch (lang) {
      case "ur":
        sentence =
            "نقصان کی قسم $damageType ہے، اعتماد $confidence فیصد ہے۔ شدت $severity ہے۔ سڑک کی صحت کا اسکور $healthScore بٹا سو ہے۔ $consequence تجویز یہ ہے کہ: $recommendation";
        break;
      case "pa":
      case "sr":
        sentence =
            "نقصان دی قسم $damageType اے، بھروسہ $confidence فیصد اے۔ شدت $severity اے۔ سڑک دی صحت سکور $healthScore بٹا سو اے۔ $consequence تجویز ایہہ اے کہ: $recommendation";
        break;
      default:
        sentence =
            "Damage type is $damageType, with $confidence percent confidence. Severity is $severity. Road health score is $healthScore out of 100. $consequence Recommendation: $recommendation";
    }

    setState(() => speaking = true);
    await _tts.speak(sentence);
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: widget.source, imageQuality: 85);
    if (picked != null) {
      final bytes = await picked.readAsBytes();
      setState(() {
        imageBytes = bytes;
        result = null;
        error = null;
      });
    }
  }

  Future<void> analyzeImage() async {
    if (imageBytes == null) return;
    setState(() {
      loading = true;
      error = null;
    });

    try {
      final uri = Uri.parse("$API_URL/predict");
      final request = http.MultipartRequest("POST", uri);
      request.files.add(http.MultipartFile.fromBytes(
        "file",
        imageBytes!,
        filename: "image.jpg",
        contentType: MediaType("image", "jpeg"),
      ));

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        setState(() {
          result = decoded;
          loading = false;
        });
        // Save this scan to local history so it shows up on the History screen
        await ScanStorage.saveScan(ScanResult.fromApi(decoded));
        // Speak the result aloud in the currently selected app language
        _speakResult();
      } else {
        setState(() {
          error = "Server error: ${response.statusCode}";
          loading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = "Connection error. Check your internet.";
        loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => pickImage());
    _tts.setCompletionHandler(() {
      if (mounted) setState(() => speaking = false);
    });
    _tts.setCancelHandler(() {
      if (mounted) setState(() => speaking = false);
    });
  }

  Color severityColor(String sev) {
    switch (sev) {
      case "High":
        return AppColors.danger;
      case "Medium":
        return AppColors.warning;
      default:
        return AppColors.success;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDark,
      appBar: AppBar(
        backgroundColor: AppColors.bgDark,
        elevation: 0,
        title: Text(AppStrings.get("analyze"), style: const TextStyle(color: AppColors.textPrimary)),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              if (imageBytes != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.memory(imageBytes!, height: 240, width: double.infinity, fit: BoxFit.cover),
                )
              else
                Container(
                  height: 240,
                  decoration: BoxDecoration(
                    color: AppColors.bgCard,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Center(child: Icon(Icons.image, color: AppColors.textSecondary, size: 60)),
                ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: pickImage,
                      icon: const Icon(Icons.refresh, color: AppColors.primary),
                      label: const Text("Change", style: TextStyle(color: AppColors.primary)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.primary),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: imageBytes == null || loading ? null : analyzeImage,
                      icon: const Icon(Icons.search),
                      label: Text(AppStrings.get("analyze"), style: const TextStyle(fontSize: 13)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              if (loading)
                Column(
                  children: [
                    const CircularProgressIndicator(color: AppColors.primary),
                    const SizedBox(height: 12),
                    Text(AppStrings.get("analyzing"), style: const TextStyle(color: AppColors.textSecondary)),
                  ],
                ),
              if (error != null)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.danger.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(error!, style: const TextStyle(color: AppColors.danger)),
                ),
              if (result != null)
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.bgCard,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _resultRow(AppStrings.get("damageType"), _damageTypeLabel("${result!['damage_type']}", currentLanguage.value)),
                          _resultRow(AppStrings.get("confidence"), "${result!['confidence']}%"),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(AppStrings.get("severity"), style: const TextStyle(color: AppColors.textSecondary)),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  color: severityColor(result!['severity']).withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  _severityLabel("${result!['severity']}", currentLanguage.value),
                                  style: TextStyle(color: severityColor(result!['severity']), fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          _resultRow(AppStrings.get("healthScore"), "${result!['road_health_score']}/100"),
                          const Divider(color: Colors.white12, height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(AppStrings.get("recommendation"), style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                              GestureDetector(
                                onTap: speaking
                                    ? () async {
                                        await _tts.stop();
                                        setState(() => speaking = false);
                                      }
                                    : _speakResult,
                                child: Row(
                                  children: [
                                    Icon(
                                      speaking ? Icons.stop_circle_rounded : Icons.volume_up_rounded,
                                      color: AppColors.primary,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      speaking ? "Stop" : "Listen",
                                      style: const TextStyle(color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            _recommendationLabel("${result!['recommendation']}", currentLanguage.value),
                            style: const TextStyle(color: AppColors.textPrimary, fontSize: 15),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ReportScreen(
                                      damageType: "${result!['damage_type']}",
                                      confidence: (result!['confidence'] as num).toDouble(),
                                      severity: "${result!['severity']}",
                                      healthScore: (result!['road_health_score'] as num).toInt(),
                                      recommendation: "${result!['recommendation']}",
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.description_rounded, size: 18),
                              label: const Text("Generate Report", style: TextStyle(fontSize: 13)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.secondary,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _resultRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textSecondary)),
          Text(value, style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}