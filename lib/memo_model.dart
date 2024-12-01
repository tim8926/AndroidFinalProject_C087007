class Folder {
  String name;
  List<Memo> memos;

  Folder({required this.name, required this.memos});
}

class Memo {
  String title;
  String content;

  Memo({required this.title, required this.content});
}
