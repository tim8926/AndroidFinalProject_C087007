import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // JSON 변환에 필요

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? successMessage;
  String? errorMessage;

  Future<void> _register() async {
    final prefs = await SharedPreferences.getInstance();

    // 기존 사용자 데이터를 불러옴
    final String? usersJson = prefs.getString('users');
    Map<String, String> users = usersJson != null
        ? Map<String, String>.from(jsonDecode(usersJson))
        : {};

    if (users.containsKey(_idController.text)) {
      // 이미 존재하는 ID인 경우
      setState(() {
        errorMessage = "이미 존재하는 ID입니다.";
        successMessage = null;
      });
    } else {
      // 새로운 사용자 추가
      users[_idController.text] = _passwordController.text;
      await prefs.setString('users', jsonEncode(users));

      setState(() {
        successMessage = "회원가입이 완료되었습니다! 로그인 화면으로 이동하세요.";
        errorMessage = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white, // AppBar 배경색을 하얀색으로 설정
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.black, // 뒤로가기 버튼 색상 검은색
          onPressed: () {
            Navigator.pop(context); // 뒤로가기 버튼 동작
          },
        ),
        title: null, // 기존 title을 null로 설정하여 "SignUp" 문구를 수동으로 배치
      ),
      backgroundColor: Colors.white, // 전체 화면 배경색을 하얀색으로 설정
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // "SignUp" 문구를 뒤로가기 버튼 바로 아래에 배치
            const Text(
              " SignUp", // SignUp 텍스트
              style: TextStyle(
                color: Colors.black, // 텍스트 색상
                fontSize: 40, // 텍스트 크기
                fontWeight: FontWeight.bold, // 텍스트 굵기
              ),
            ),
            const SizedBox(height: 180), // "SignUp" 문구와 폼 사이의 간격
            const Text(
              "  사용할 아이디를 입력해주세요.",
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
              )
            ),
            const SizedBox(height: 5),
            // ID 입력 필드
            TextField(
              controller: _idController,
              decoration: InputDecoration(
                labelText: "ID",
                labelStyle: const TextStyle(color: Colors.black), // 텍스트 색상
                filled: true,
                fillColor: const Color.fromRGBO(245, 245, 245, 1.0), // 입력창 배경색
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
              style: const TextStyle(color: Colors.black), // 입력 텍스트 색상
            ),
            const SizedBox(height: 16),
            const Text(
              "  사용할 패스워드를 입력해주세요.",
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
              )
            ),
            const SizedBox(height: 5),
            // Password 입력 필드
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Password",
                labelStyle: const TextStyle(color: Colors.black), // 텍스트 색상
                filled: true,
                fillColor: const Color.fromRGBO(245, 245, 245, 1.0), // 입력창 배경색
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
              style: const TextStyle(color: Colors.black), // 입력 텍스트 색상
            ),
            const SizedBox(height: 20),
            // 회원가입 버튼
            Align(
              alignment: Alignment.center,  // 버튼을 수평 중앙으로 배치
              child: ElevatedButton(
                onPressed: _register,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green, // 버튼 배경색
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20, // 버튼 가로 크기만 늘림
                    vertical: 15,  // 버튼 세로 크기
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "회원가입",
                  style: TextStyle(color: Colors.white), // 버튼 텍스트 색상
                ),
              ),
            ),

            if (successMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  successMessage!,
                  style: const TextStyle(color: Colors.green),
                ),
              ),
            if (errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
