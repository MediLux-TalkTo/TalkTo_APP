import 'package:flutter/material.dart';

class TalkToApp extends StatelessWidget {
  const TalkToApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TalkTo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Pretendard',
        scaffoldBackgroundColor: const Color(0xFFFAFAFA),
        useMaterial3: true,
      ),
      home: const Scaffold(body: Center(child: Text('TalkTo App'))),
    );
  }
}
