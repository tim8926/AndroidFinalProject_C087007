import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'login_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PrivacyToDoList',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black, // 배경색 검은색
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black, // AppBar 배경색 검은색
          foregroundColor: Colors.white, // AppBar 텍스트 흰색
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white), // 큰 본문 텍스트
          bodyMedium: TextStyle(color: Colors.white), // 기본 본문 텍스트
          bodySmall: TextStyle(color: Colors.white), // 작은 본문 텍스트
        ),
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey, // 입력 필드 배경색
          border: OutlineInputBorder(),
          labelStyle: TextStyle(color: Colors.white), // 라벨 텍스트 흰색
        ),
      ),
      home: const LoginPage(),
    );
  }
}
