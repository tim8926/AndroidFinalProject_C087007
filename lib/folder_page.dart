import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'memo_edit_page.dart';

class FolderPage extends StatefulWidget {
  final String folderName; // 폴더 이름
  final String userId; // 사용자 ID

  const FolderPage({required this.folderName, required this.userId, super.key});

  @override
  State<FolderPage> createState() => _FolderPageState();
}

class _FolderPageState extends State<FolderPage> {
  List<String> memos = []; // 폴더에 포함된 메모 리스트

  @override
  void initState() {
    super.initState();
    _loadMemos(); // 앱 실행 시 메모 데이터를 로드
  }

  // 메모 데이터 로드
  Future<void> _loadMemos() async {
    final prefs = await SharedPreferences.getInstance();
    final key = '${widget.userId}_${widget.folderName}_memos'; // 고유 키 생성
    final storedMemos = prefs.getStringList(key) ?? []; // 저장된 메모 불러오기
    setState(() {
      memos = storedMemos;
    });
  }

  // 메모 데이터 저장
  Future<void> _saveMemos() async {
    final prefs = await SharedPreferences.getInstance();
    final key = '${widget.userId}_${widget.folderName}_memos'; // 고유 키 생성
    await prefs.setStringList(key, memos); // 메모 저장
  }

  // 메모 추가
  void _addMemo() {
    final TextEditingController memoController = TextEditingController(); // 메모 제목 입력 컨트롤러
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white, // 하얀색 배경
        title: const Text(
          "메모 제목 추가",
          style: TextStyle(color: Colors.black),
        ),
        content: TextField(
          controller: memoController,
          decoration: const InputDecoration(
            hintText: "메모 제목",
            hintStyle: TextStyle(color: Colors.black),
          ),
          style: const TextStyle(color: Colors.black),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (memoController.text.isNotEmpty) {
                setState(() {
                  memos.add(memoController.text); // 메모 추가
                });
                _saveMemos(); // 메모 저장
                Navigator.pop(context);
              }
            },
            child: const Text("저장", style: TextStyle(color: Colors.black)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("취소", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // 메모 삭제
  void _deleteMemo(int index) {
    setState(() {
      memos.removeAt(index); // 리스트에서 삭제
    });
    _saveMemos(); // 저장소에 변경사항 반영
  }

  // 메모 열기
  void _openMemo(String memoTitle) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MemoEditPage(
          userId: widget.userId,
          folderName: widget.folderName,
          memoTitle: memoTitle,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.black,
          onPressed: () {
            Navigator.pop(context); // 뒤로가기 버튼
          },
        ),
      ),
      backgroundColor: Colors.white, // 배경을 하얀색으로 설정
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 뒤로가기 버튼 아래에 "Memo"와 메모 이모지를 배치
            Row(
              children: const [
                Icon(
                  Icons.sticky_note_2, // 메모지 아이콘
                  color: Colors.yellow, // 아이콘 색상
                  size: 50, // 아이콘 크기
                ),
                SizedBox(width: 10), // 아이콘과 텍스트 사이 간격
                Text(
                  "Memo", // Memo 문구
                  style: TextStyle(
                    color: Colors.black, // 텍스트 색상
                    fontSize: 40, // 텍스트 크기
                    fontWeight: FontWeight.bold, // 텍스트 굵기
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30), // "Memo"와 메모 목록 사이 간격

            // 메모 리스트
            Expanded(
              child: ListView.separated(
                itemCount: memos.length,
                separatorBuilder: (context, index) => const Divider(
                  color: Colors.grey, // 경계선 색상
                  thickness: 1, // 경계선 두께
                  indent: 16, // 왼쪽 여백
                  endIndent: 16, // 오른쪽 여백
                ),
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(
                      Icons.sticky_note_2, // 메모지 아이콘
                      color: Colors.yellow, // 메모 아이콘 색상
                    ),
                    title: Text(
                      memos[index],
                      style: const TextStyle(color: Colors.black),
                    ),
                    onTap: () => _openMemo(memos[index]), // 메모 제목 클릭 시
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteMemo(index), // 메모 삭제
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addMemo,
        backgroundColor: Colors.yellow,
        child: const Icon(Icons.sticky_note_2, color: Colors.white), // 메모지 아이콘
      ),
    );
  }
}
