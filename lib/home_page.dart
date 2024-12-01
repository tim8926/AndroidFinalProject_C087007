import 'package:flutter/material.dart';
import 'folder_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  final String userId; // 사용자 ID 전달

  const HomePage({required this.userId, super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> folders = []; // 폴더 리스트

  @override
  void initState() {
    super.initState();
    _loadFolders();
  }

  // 폴더 데이터 로드
  Future<void> _loadFolders() async {
    final prefs = await SharedPreferences.getInstance();
    final key = '${widget.userId}_folders'; // 사용자별 폴더 키
    final storedFolders = prefs.getStringList(key) ?? [];
    setState(() {
      folders = storedFolders;
    });
  }

  // 폴더 데이터 저장
  Future<void> _saveFolders() async {
    final prefs = await SharedPreferences.getInstance();
    final key = '${widget.userId}_folders';
    await prefs.setStringList(key, folders);
  }

  // 폴더 추가
  void _addFolder() {
    final TextEditingController folderController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900], // 다크 모드 배경
        title: const Text(
          "폴더 추가",
          style: TextStyle(color: Colors.white),
        ),
        content: TextField(
          controller: folderController,
          decoration: const InputDecoration(
            hintText: "폴더 이름",
            hintStyle: TextStyle(color: Colors.grey),
          ),
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (folderController.text.isNotEmpty) {
                setState(() {
                  folders.add(folderController.text); // 폴더 추가
                });
                _saveFolders(); // 저장
                Navigator.pop(context);
              }
            },
            child: const Text("저장", style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("취소", style: TextStyle(color: Colors.grey)),
          ),
        ],
      ),
    );
  }

  // 폴더 삭제
  void _deleteFolder(int index) {
    setState(() {
      folders.removeAt(index); // 리스트에서 삭제
    });
    _saveFolders();
  }

  // 폴더 열기
  void _openFolder(String folderName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FolderPage(
          folderName: folderName,
          userId: widget.userId,
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
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 0),
            // "Folder" 문구와 아이콘을 좌측 상단에 크게 표시
            Row(
              children: const [
                Icon(
                  Icons.folder, 
                  color: Colors.blue, 
                  size: 50, // 아이콘 크기
                ),
                SizedBox(width: 10), // 아이콘과 텍스트 사이 간격
                Text(
                  "Folder", // Folder 문구
                  style: TextStyle(
                    color: Colors.black, // 텍스트 색상
                    fontSize: 40, // 텍스트 크기
                    fontWeight: FontWeight.bold, // 텍스트 굵기
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20), // "Folder"와 폴더 목록 사이 간격

            // 폴더 리스트
            Expanded(
              child: ListView.separated(
                itemCount: folders.length,
                separatorBuilder: (context, index) => const Divider(
                  color: Colors.grey, // 경계선 색상
                  thickness: 1, // 경계선 두께
                  indent: 16, // 왼쪽 여백
                  endIndent: 16, // 오른쪽 여백
                ),
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(
                      Icons.folder, // 파란색 폴더 아이콘
                      color: Colors.blue, // 파란색으로 아이콘 색상 설정
                      size: 30, // 아이콘 크기 조정
                    ),
                    title: Text(
                      folders[index], // 폴더 이름
                      style: const TextStyle(color: Colors.black),
                    ),
                    onTap: () => _openFolder(folders[index]), // 폴더 클릭 시
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteFolder(index), // 폴더 삭제
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      // FloatingActionButton을 우측 하단으로 위치 설정
      floatingActionButton: FloatingActionButton(
        onPressed: _addFolder,
        backgroundColor: Colors.blue,
        child: const Icon(Icons.folder, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat, // 우측 하단으로 설정
    );
  }
}
