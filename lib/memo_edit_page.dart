import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MemoEditPage extends StatefulWidget {
  final String userId;
  final String folderName;
  final String memoTitle;

  const MemoEditPage({
    required this.userId,
    required this.folderName,
    required this.memoTitle,
    super.key,
  });

  @override
  State<MemoEditPage> createState() => _MemoEditPageState();
}

class _MemoEditPageState extends State<MemoEditPage> {
  final TextEditingController _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadMemoContent();
  }

  Future<void> _loadMemoContent() async {
    final prefs = await SharedPreferences.getInstance();
    final key = '${widget.userId}_${widget.folderName}_${widget.memoTitle}_content';
    final content = prefs.getString(key) ?? "";
    setState(() {
      _contentController.text = content;
    });
  }

  Future<void> _saveMemoContent() async {
    final prefs = await SharedPreferences.getInstance();
    final key = '${widget.userId}_${widget.folderName}_${widget.memoTitle}_content';
    await prefs.setString(key, _contentController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white, // 앱바 배경색을 하얀색으로 설정
        title: Text(widget.memoTitle, style: const TextStyle(color: Colors.black)), // 제목 텍스트 색상
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.black, // 뒤로가기 버튼 색상을 검은색으로 설정
          onPressed: () {
            Navigator.pop(context); // 뒤로가기 버튼 동작
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            color: const Color.fromRGBO(71, 200, 62, 1), // 저장 아이콘 색상 설정
            onPressed: () async {
              await _saveMemoContent();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("메모가 저장되었습니다."),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.green,
                ),
              );
            },
          ),
        ],
      ),
      backgroundColor: Colors.white, // 페이지 배경색을 하얀색으로 설정
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: _contentController,
          maxLines: null, // 여러 줄 입력 가능
          style: const TextStyle(color: Colors.black, fontSize: 16),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(16),
            hintText: "여기에 텍스트를 입력하세요...",
            hintStyle: const TextStyle(color: Colors.black),
            filled: true,
            fillColor: Colors.white, // 배경색을 앱 배경과 동일하게 설정
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade700), // 테두리 색상
              borderRadius: BorderRadius.circular(10), // 모서리를 둥글게 설정
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.black), // 포커스된 상태의 테두리 색상
              borderRadius: BorderRadius.circular(10),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade700), // 기본 테두리 색상
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }
}
