import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/network/api_client.dart';
import '../auth/data/auth_api.dart';
import '../onboarding/onboarding_intro_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthApi _authApi = AuthApi();

  @override
  void initState() {
    super.initState();

    _bootstrap();
  }

  Future<void> _bootstrap() async {
    try {
      await ApiClient.dio.get('/health');

      await _authApi.login(identifier: 'test@talkto.app', password: 'test1234');
    } catch (e) {
      debugPrint('auto login failed: $e');
    }

    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const OnboardingIntroScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset('assets/images/talkto_logo.svg', width: 190),

              const SizedBox(height: 24),

              const Text(
                '일상의 통화를\n우리 가족만의 하나의 이야기로',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF7C8273),
                  fontSize: 16.5,
                  fontWeight: FontWeight.w400,
                  height: 28 / 16.5,
                ),
              ),

              const SizedBox(height: 18),

              SvgPicture.asset('assets/images/soundwave_logo.svg', width: 150),
            ],
          ),
        ),
      ),
    );
  }
}
