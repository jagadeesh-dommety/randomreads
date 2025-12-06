class ReadItem {
  final String id;
  final String title;
  final String content;
  String author = "";
  bool isAiGenerated = true;
  final String topic;
  final int likesCount;
  final int shareCount;
  final int reportCount;
  final DateTime createdAt;

  ReadItem({
    required this.id,
    required this.title,
    required this.content,
    required this.author,
    required this.isAiGenerated,
    required this.topic,
    required this.likesCount,
    required this.shareCount,
    required this.reportCount,
    required this.createdAt,
  });
  
  factory ReadItem.fromJson(Map<String, dynamic> json) {
  return ReadItem(
    id: json['id'],
    title: json['title'],
    content: json['content'],
    author: json['author'],
    isAiGenerated: json['isAiGenerated'],
    topic: json['topic'],
    likesCount: json['likesCount'],
    shareCount: json['shareCount'],
    reportCount: json['reportCount'],
    createdAt: DateTime.parse(json['createdAt']),
  );
}
}
