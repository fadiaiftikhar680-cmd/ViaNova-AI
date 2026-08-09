import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'app_colors.dart';
import 'app_strings.dart';

class ReportScreen extends StatefulWidget {
  final String damageType;
  final double confidence;
  final String severity;
  final int healthScore;
  final String recommendation;

  const ReportScreen({
    super.key,
    required this.damageType,
    required this.confidence,
    required this.severity,
    required this.healthScore,
    required this.recommendation,
  });

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  bool loadingLocation = true;
  String? locationError;
  double? lat;
  double? lng;
  String city = "Unknown";
  String district = "Unknown";
  String road = "Unnamed Road";

  final DateTime reportDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _fetchLocation();
  }

  Future<void> _fetchLocation() async {
    setState(() {
      loadingLocation = true;
      locationError = null;
    });
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          locationError = "Location services are disabled. Please enable GPS.";
          loadingLocation = false;
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            locationError = "Location permission denied.";
            loadingLocation = false;
          });
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        setState(() {
          locationError = "Location permission permanently denied. Enable it from app settings.";
          loadingLocation = false;
        });
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      );

      String resolvedCity = "Unknown";
      String resolvedDistrict = "Unknown";
      String resolvedRoad = "Unnamed Road";
      try {
        final placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
        if (placemarks.isNotEmpty) {
          final p = placemarks.first;
          resolvedCity = p.locality?.isNotEmpty == true ? p.locality! : (p.subAdministrativeArea ?? "Unknown");
          resolvedDistrict = p.subAdministrativeArea?.isNotEmpty == true ? p.subAdministrativeArea! : resolvedCity;
          resolvedRoad = p.street?.isNotEmpty == true ? p.street! : "Unnamed Road";
        }
      } catch (_) {
        // Reverse geocoding can fail (no internet / no plugin support on some platforms) — GPS coords still shown.
      }

      setState(() {
        lat = position.latitude;
        lng = position.longitude;
        city = resolvedCity;
        district = resolvedDistrict;
        road = resolvedRoad;
        loadingLocation = false;
      });
    } catch (e) {
      setState(() {
        locationError = "Could not get location. Check GPS and try again.";
        loadingLocation = false;
      });
    }
  }

  // Simple rule-based authority lookup by district — extend this map as needed.
  Map<String, String> get authority {
    final name = "Municipal Corporation, $district";
    final email = district == "Unknown"
        ? "info@localauthority.gov.pk"
        : "info@${district.toLowerCase().replaceAll(' ', '')}.gov.pk";
    return {"name": name, "email": email};
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

  String _buildReportText() {
    final auth = authority;
    return '''
ROAD DAMAGE REPORT

Damage Type: ${widget.damageType.replaceAll('_', ' ')}
Confidence: ${widget.confidence.toStringAsFixed(1)}%
Severity: ${widget.severity}
Road Health Score: ${widget.healthScore}/100

Recommendation: ${widget.recommendation}

Location:
City: $city
District: $district
Road: $road
${lat != null ? "GPS: $lat, $lng" : "GPS: Not available"}

Responsible Authority: ${auth['name']}
Contact: ${auth['email']}

Date: ${DateFormat('MMM d, yyyy - h:mm a').format(reportDate)}

Generated via ViaNova AI
''';
  }

  Future<void> _shareReport() async {
    await Share.share(_buildReportText(), subject: "Road Damage Report");
  }

  Future<void> _sendComplaint() async {
    final auth = authority;
    final uri = Uri(
      scheme: 'mailto',
      path: auth['email'],
      query: 'subject=${Uri.encodeComponent("Road Damage Report - $district")}&body=${Uri.encodeComponent(_buildReportText())}',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No email app found on this device.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = authority;
    return Scaffold(
      backgroundColor: AppColors.bgDark,
      appBar: AppBar(
        backgroundColor: AppColors.bgDark,
        elevation: 0,
        title: Text("Damage Report", style: GoogleFonts.poppins(color: AppColors.textPrimary)),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Damage summary card ---
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: AppColors.bgCard, borderRadius: BorderRadius.circular(18)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(widget.damageType.replaceAll('_', ' '),
                            style: GoogleFonts.poppins(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.bold)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                              color: severityColor(widget.severity).withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
                          child: Text(widget.severity,
                              style: TextStyle(color: severityColor(widget.severity), fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    _row("Confidence", "${widget.confidence.toStringAsFixed(1)}%"),
                    _row("Road Health Score", "${widget.healthScore}/100"),
                    const Divider(color: Colors.white12, height: 26),
                    Text("Recommendation", style: GoogleFonts.poppins(color: AppColors.textSecondary, fontSize: 12)),
                    const SizedBox(height: 4),
                    Text(widget.recommendation, style: GoogleFonts.poppins(color: AppColors.textPrimary, fontSize: 14)),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // --- Location card ---
              Text("Location", style: GoogleFonts.poppins(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(color: AppColors.bgCard, borderRadius: BorderRadius.circular(16)),
                child: loadingLocation
                    ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          children: [
                            SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: AppColors.primary, strokeWidth: 2)),
                            SizedBox(width: 12),
                            Text("Detecting location...", style: TextStyle(color: AppColors.textSecondary)),
                          ],
                        ),
                      )
                    : locationError != null
                        ? Row(
                            children: [
                              Expanded(child: Text(locationError!, style: const TextStyle(color: AppColors.danger, fontSize: 13))),
                              TextButton(onPressed: _fetchLocation, child: const Text("Retry")),
                            ],
                          )
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _row("City", city),
                              _row("District", district),
                              _row("Road", road),
                              if (lat != null) _row("GPS", "${lat!.toStringAsFixed(5)}, ${lng!.toStringAsFixed(5)}"),
                            ],
                          ),
              ),
              const SizedBox(height: 18),

              // --- Authority card ---
              Text("Responsible Authority", style: GoogleFonts.poppins(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(color: AppColors.bgCard, borderRadius: BorderRadius.circular(16)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.account_balance_rounded, color: AppColors.primary, size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(auth['name']!,
                              style: GoogleFonts.poppins(color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(auth['email']!, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                  ],
                ),
              ),
              const SizedBox(height: 26),

              // --- Action buttons ---
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _shareReport,
                      icon: const Icon(Icons.share_rounded, color: AppColors.primary, size: 18),
                      label: Text("Share Report", style: GoogleFonts.poppins(color: AppColors.primary, fontSize: 13)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.primary),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _sendComplaint,
                      icon: const Icon(Icons.mail_rounded, size: 18),
                      label: Text("Send Complaint", style: GoogleFonts.poppins(fontSize: 13)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
          Flexible(
            child: Text(value,
                textAlign: TextAlign.right,
                style: const TextStyle(color: AppColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}
