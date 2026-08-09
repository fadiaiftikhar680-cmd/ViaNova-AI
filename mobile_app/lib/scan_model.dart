import 'dart:convert';

class ScanResult {
  final String damageType;
  final double confidence;
  final String severity;
  final int healthScore;
  final String recommendation;
  final String repairPriority;
  final DateTime timestamp;

  ScanResult({
    required this.damageType,
    required this.confidence,
    required this.severity,
    required this.healthScore,
    required this.recommendation,
    required this.repairPriority,
    required this.timestamp,
  });

  factory ScanResult.fromApi(Map<String, dynamic> json) {
    final severity = json['severity'] ?? 'Low';
    String priority;
    switch (severity) {
      case 'High':
        priority = 'Immediate';
        break;
      case 'Medium':
        priority = 'Within 2 Weeks';
        break;
      default:
        priority = 'Routine Monitoring';
    }

    return ScanResult(
      damageType: json['damage_type'] ?? 'Unknown',
      confidence: (json['confidence'] ?? 0).toDouble(),
      severity: severity,
      healthScore: json['road_health_score'] ?? 0,
      recommendation: json['recommendation'] ?? '',
      repairPriority: priority,
      timestamp: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'damageType': damageType,
        'confidence': confidence,
        'severity': severity,
        'healthScore': healthScore,
        'recommendation': recommendation,
        'repairPriority': repairPriority,
        'timestamp': timestamp.toIso8601String(),
      };

  factory ScanResult.fromJson(Map<String, dynamic> json) => ScanResult(
        damageType: json['damageType'],
        confidence: json['confidence'],
        severity: json['severity'],
        healthScore: json['healthScore'],
        recommendation: json['recommendation'],
        repairPriority: json['repairPriority'],
        timestamp: DateTime.parse(json['timestamp']),
      );

  static String encodeList(List<ScanResult> scans) =>
      jsonEncode(scans.map((s) => s.toJson()).toList());

  static List<ScanResult> decodeList(String data) =>
      (jsonDecode(data) as List).map((e) => ScanResult.fromJson(e)).toList();
}