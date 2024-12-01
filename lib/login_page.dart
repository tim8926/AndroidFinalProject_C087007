import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_page.dart';
import 'signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String? errorMessage;

  Future<void> _login() async {
    setState(() {
      _isLoading = true; // 로딩 시작
    });

    final prefs = await SharedPreferences.getInstance();
    final String? usersJson = prefs.getString('users');
    final Map<String, String> users = usersJson != null
        ? Map<String, String>.from(jsonDecode(usersJson))
        : {};

    final String enteredId = _idController.text;
    final String enteredPassword = _passwordController.text;

    await Future.delayed(const Duration(seconds: 1)); // 애니메이션 효과를 위해 딜레이 추가

    if (users.containsKey(enteredId) && users[enteredId] == enteredPassword) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(userId: enteredId),
        ),
      ).then((_) {
        _clearFields();
      });
    } else {
      setState(() {
        errorMessage = "아이디 혹은 비밀번호가 틀렸습니다.";
      });
    }

    setState(() {
      _isLoading = false; // 로딩 종료
    });
  }

  void _clearFields() {
    _idController.clear();
    _passwordController.clear();
    setState(() {
      errorMessage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // 밝은 배경
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 앱 이름 문구
              const Align(
                alignment: Alignment.centerLeft, // 왼쪽 정렬
                child: Text(
                "🔒Privacy",
                style: TextStyle(
                  color: Colors.black, // 텍스트 색상
                  fontSize: 30, // 텍스트 크기
                  fontWeight: FontWeight.bold, // 텍스트 굵기
                ),
              ),
            ),
            const SizedBox(height: 20), // 간격 조정

            const Align(
              alignment: Alignment.centerLeft, // 왼쪽 정렬
              child: Text(
                "ToDoList",
                style: TextStyle(
                  color: Colors.black, // 텍스트 색상
                  fontSize: 50, // 텍스트 크기
                  fontWeight: FontWeight.bold, // 텍스트 굵기
                ),
              ),
            ),
            const SizedBox(height: 120), // 간격 추가 
              // ID 입력 필드
              TextField(
                controller: _idController,
                decoration: InputDecoration(
                  labelText: "ID",
                  labelStyle: const TextStyle(color: Colors.black),
                  filled: true,
                  fillColor: const Color.fromRGBO(245, 245, 245, 1.0), // 부드러운 배경
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: Colors.blue, width: 2),
                  ),
                ),
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 16),

              // 비밀번호 입력 필드
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                  labelStyle: const TextStyle(color: Colors.black),
                  filled: true,
                  fillColor: const Color.fromRGBO(245, 245, 245, 1.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(color: Colors.blue, width: 2),
                  ),
                ),
                style: const TextStyle(color: Colors.black),
              ),
              const SizedBox(height: 20),

              // 로그인 버튼
              _isLoading
                  ? const CircularProgressIndicator(color: Colors.blue)
                  : ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        "로그인",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
              const SizedBox(height: 15),

              const Text(
                "계정이 없으신가요?",
                style: TextStyle(
                  color: Color.fromARGB(255, 101, 101, 101),
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 0),

              // 회원가입 버튼
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignupPage()),
                  );
                },
                child: const Text(
                  "회원가입",
                  style: TextStyle(
                    color: Colors.blue, // 파란색 텍스트로 강조
                    fontSize: 14,
                  ),
                ),
              ),

              // 에러 메시지
              if (errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                    errorMessage!,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 14,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
