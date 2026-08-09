import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'detection_screen.dart';
import 'history_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';
import 'onboarding_screen.dart';
import 'app_strings.dart';
import 'app_colors.dart';

void main() {
  runApp(const ViaNovaApp());
}

class ViaNovaApp extends StatelessWidget {
  const ViaNovaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ViaNova AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.bgDark,
        textTheme: GoogleFonts.poppinsTextTheme().apply(
          bodyColor: AppColors.textPrimary,
          displayColor: AppColors.textPrimary,
        ),
        colorScheme: ColorScheme.dark(
          primary: AppColors.primary,
          secondary: AppColors.secondary,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

// ---------- SPLASH SCREEN ----------
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () async {
      final prefs = await SharedPreferences.getInstance();
      final onboarded = prefs.getBool('onboarded') ?? false;
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => onboarded ? const HomeScreen() : const OnboardingScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0A0E1A), Color(0xFF141B2D), Color(0xFF1A2138)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.secondary],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.4),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: const Icon(Icons.route_rounded, size: 60, color: Colors.white),
              ),
              const SizedBox(height: 28),
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [AppColors.primary, AppColors.secondary],
                ).createShader(bounds),
                child: Text(
                  'ViaNova AI',
                  style: GoogleFonts.poppins(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'AI-Powered Road Damage Detection',
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 50),
              const SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                  strokeWidth: 2.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---------- HOME SCREEN ----------
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String>(
      valueListenable: currentLanguage,
      builder: (context, lang, _) {
        return Scaffold(
          backgroundColor: AppColors.bgDark,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(22.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(AppStrings.get("welcome"),
                              style: GoogleFonts.poppins(color: AppColors.textSecondary, fontSize: 15)),
                          Text(AppStrings.get("appName"),
                              style: GoogleFonts.poppins(
                                  color: AppColors.textPrimary, fontSize: 26, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.language, color: AppColors.primary),
                        color: AppColors.bgCard,
                        onSelected: (val) => currentLanguage.value = val,
                        itemBuilder: (context) => [
                          const PopupMenuItem(value: "en", child: Text("English", style: TextStyle(color: Colors.white))),
                          const PopupMenuItem(value: "ur", child: Text("اردو", style: TextStyle(color: Colors.white))),
                          const PopupMenuItem(value: "pa", child: Text("پنجابی", style: TextStyle(color: Colors.white))),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [AppColors.secondary, AppColors.primary]),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(AppStrings.get("totalScans"),
                                style: GoogleFonts.poppins(color: Colors.white70, fontSize: 13)),
                            const SizedBox(height: 4),
                            Text('0',
                                style: GoogleFonts.poppins(
                                    color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const Icon(Icons.insights_rounded, color: Colors.white, size: 42),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  Text(AppStrings.get("quickActions"),
                      style: GoogleFonts.poppins(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 14),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.1,
                      children: [
                        _menuCard(
                          context,
                          Icons.camera_alt_rounded,
                          AppStrings.get("cameraDetection"),
                          AppColors.primary,
                          () => Navigator.push(context,
                              MaterialPageRoute(builder: (_) => const DetectionScreen(source: ImageSource.camera))),
                        ),
                        _menuCard(
                          context,
                          Icons.photo_library_rounded,
                          AppStrings.get("galleryDetection"),
                          AppColors.secondary,
                          () => Navigator.push(context,
                              MaterialPageRoute(builder: (_) => const DetectionScreen(source: ImageSource.gallery))),
                        ),
                        _menuCard(
                          context,
                          Icons.history_rounded,
                          AppStrings.get("detectionHistory"),
                          AppColors.warning,
                          () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HistoryScreen())),
                        ),
                        _menuCard(
                          context,
                          Icons.person_rounded,
                          AppStrings.get("profile"),
                          AppColors.success,
                          () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen())),
                        ),
                        _menuCard(
                          context,
                          Icons.settings_rounded,
                          "Settings",
                          AppColors.secondary,
                          () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen())),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _menuCard(BuildContext context, IconData icon, String title, Color color, VoidCallback? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white.withOpacity(0.06)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: color.withOpacity(0.15), shape: BoxShape.circle),
              child: Icon(icon, color: color, size: 30),
            ),
            const SizedBox(height: 14),
            Text(title,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(color: AppColors.textPrimary, fontSize: 13.5, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}