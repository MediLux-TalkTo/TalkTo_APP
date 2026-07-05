import 'package:flutter/material.dart';

import 'features/splash/splash_screen.dart';

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
        fontFamily: 'Pretendard Variable',
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
