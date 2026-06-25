import 'package:flutter/material.dart';

import 'screens/splash_screen.dart';

void main() {
  runApp(const TalkToApp());
}

class TalkToApp extends StatelessWidget {
  const TalkToApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TalkTo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Pretendard',
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
